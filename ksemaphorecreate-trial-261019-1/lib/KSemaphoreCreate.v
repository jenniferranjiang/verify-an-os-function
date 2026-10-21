Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Import SetsClass.SetsClass.
Require Export CRTOS_Verify.lib.SemaphoreInv.
Import ListNotations IDNode MonadErr SetsNotation.
Local Open Scope Z_scope.
Local Open Scope sac.

(** 精确C uint16++和条件--；65535进入后归零，退出仍为零。 *)
Definition nest_inc (n : Z) : Z := (n + 1) mod 65536.
Definition nest_dec (n : Z) : Z := if Z.leb 1 n then n - 1 else n.
Definition nest_roundtrip (n : Z) : Z := nest_dec (nest_inc n).

(** 首次取得锁记录当时观察；嵌套沿用外层锁anchor，不复制全局token。 *)
Definition critical_anchor (mode : Z) (anchor acquired : VarGlobalState) : VarGlobalState :=
 if Z.eq_dec mode 0 then acquired else anchor.

(** 发布新Semaphore：对象地址内部追踪身份，对外只返回ID。前态同地址未发布。
    对象初值val，等待队列为空；全局管理链按源码头插。 *)
Definition semaphore_publish (p id val : Z) (before : SemaphoreState) : SemaphoreState :=
 {| sem_ptr_list := p :: before.(sem_ptr_list);
    sem_obj_map := fun q => if Z.eq_dec q p
      then Some {| sem_id := id; sem_value := val; sem_pending_addrs := [] |}
      else before.(sem_obj_map) q |}.
(** 仅替换信号量模块，所有任务、调度、tick、其他IPC和ISR抽象分量保持。 *)
Definition replace_semaphores (sems : SemaphoreState) (st : VarGlobalState) : VarGlobalState :=
 {| os_tasks := st.(os_tasks); os_tick := st.(os_tick); os_delays := st.(os_delays);
    os_assign := st.(os_assign); zombie_queue := st.(zombie_queue);
    os_recycle := st.(os_recycle); os_idle := st.(os_idle); os_semaphores := sems;
    os_mutexes := st.(os_mutexes); os_msgqueues := st.(os_msgqueues);
    os_events := st.(os_events); os_isr := st.(os_isr); os_exstatus := st.(os_exstatus) |}.

(** malloc已经成功后的原子语义；ID耗尽返回-5且不登记。
    成功严格使用bitmap扫描的最小空ID；p由分配器提供，空间新鲜性由ownership保证。
    这里的纯map空cell条件是发布身份约束，不要求caller预先给定p。 *)
Definition semaphore_create_locked_result (sg : StableGlobalState) (val : Z)
 (before : VarGlobalState) (ret : Z) (after : VarGlobalState) : Prop :=
 let ssg := sg.(os_semaphore_stable) in
 let ids := semaphore_idmanager ssg before.(os_semaphores) in
 (ret = -5 /\ idmanager_full ssg.(sem_idmanager_stable) ids /\ after = before) \/
 (exists p, p <> 0 /\ addr_aligned p 4 /\
   before.(os_semaphores).(sem_obj_map) p = None /\
   idmanager_min_free_id ssg.(sem_idmanager_stable) ids ret /\
   after = replace_semaphores (semaphore_publish p ret val before.(os_semaphores)) before).
Definition abs_semaphore_create_locked (sg : StableGlobalState) (val : Z)
 : program VarGlobalState Z :=
 {| nrm := semaphore_create_locked_result sg val;
    err := fun _ => False |}.
(** 外层没有临界区的malloc失败保持观察集合；其他路径按全局atomic_cmd取锁后观察。
    失败不是异常monad err；所有参数uint16值由C类型检查保障。 *)
Definition abs_semaphore_create (sg : StableGlobalState) (val : Z)
 : program (VarGlobalState -> Prop) Z :=
 {| nrm := fun P r Q => (r = -5 /\ Q = P) \/
      (task_atomic_cmd (abs_semaphore_create_locked sg val)).(nrm) P r Q;
    err := fun _ => False |}.
(** 已持临界区时不再引入环境观察、不重复取得全局锁。
    malloc失败保留当前内存；成功分配后执行同一locked语义。 *)
Definition abs_semaphore_create_nested (sg : StableGlobalState) (val : Z)
 : program VarGlobalState Z :=
 {| nrm := fun before r after => (r = -5 /\ after = before) \/
      semaphore_create_locked_result sg val before r after;
    err := fun _ => False |}.
(** 含实际计数的嵌套出口关系。明确区分malloc失败和已进入临界区的ID耗尽，
    防止把65535回绕误写为所有失败都保持计数。 *)
Definition semaphore_create_nested_result (sg : StableGlobalState) (val : Z)
 (before : VarGlobalState) (n ret : Z) (after : VarGlobalState) (n_after : Z) : Prop :=
 (ret = -5 /\ after = before /\ n_after = n) \/
 (semaphore_create_locked_result sg val before ret after /\ n_after = nest_roundtrip n).

(** 设计阶段类型检查：同一safeExec分别连接外层状态集合与嵌套精确状态。 *)
Check (fun sg val st X => safeExec (LastSeen st) (abs_semaphore_create sg val) X).
Check (fun sg val st Y => safeExec (ExactSeen st) (abs_semaphore_create_nested sg val) Y).
