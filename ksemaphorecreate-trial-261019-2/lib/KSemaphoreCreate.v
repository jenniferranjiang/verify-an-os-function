Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import CRTOS_Verify.lib.idnode.
Require Export CRTOS_Verify.lib.CrtosInv.
From MonadLib.MonadErr Require Import MonadErrBasic.
Require Import SetsClass.SetsClass.
Import SetsNotation ListNotations IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sets.

(** 发布新对象时只替换信号量模块；其他所有全局纯状态精确保留。
    新对象插在管理链表头，ID桶顺序由同一列表派生。 *)
Definition semaphore_publish (before : VarGlobalState)
    (p : addr) (id value : Z) : VarGlobalState :=
  {| os_tasks := before.(os_tasks);
     os_tick := before.(os_tick);
     os_delays := before.(os_delays);
     os_assign := before.(os_assign);
     zombie_queue := before.(zombie_queue);
     os_recycle := before.(os_recycle);
     os_idle := before.(os_idle);
     os_semaphores := {| sem_objects :=
       {| sem_address := p; sem_identifier := id;
          sem_contents := {| sem_value := value; sem_pending := [] |} |}
       :: before.(os_semaphores).(sem_objects) |};
     os_mutexes := before.(os_mutexes);
     os_msgqueues := before.(os_msgqueues);
     os_events := before.(os_events);
     os_isr := before.(os_isr);
     os_exstatus := before.(os_exstatus) |}.

(** malloc 已成功且清零后的锁内原子操作。ID耗尽保持模块状态并返回-5；
    成功取得最小空闲ID、新对象value等于uint16形参、pend_list为空。
    fresh地址是malloc与既存对象分离的抽象结果，非用户前置条件。 *)
Definition abs_semaphore_create_locked (sg : StableGlobalState) (value : Z)
    : program VarGlobalState Z :=
  {| MonadErr.nrm := fun before result after =>
       (result = -5 /\ after = before /\
          idmanager_full sg.(os_semaphore_stable).(sem_idmanager_stable)
            (sem_idmanager_abs before.(os_semaphores))) \/
       (exists p, p <> 0 /\ addr_aligned p 4 /\
          ~ In p (sem_ptr_list before.(os_semaphores)) /\
          idmanager_min_free_id sg.(os_semaphore_stable).(sem_idmanager_stable)
            (sem_idmanager_abs before.(os_semaphores)) result /\
          after = semaphore_publish before p result value);
     MonadErr.err := fun _ => False |}.

(** 初始PRIMASK=1时没有环境推进（含已经持token的nested调用）。
    malloc NULL提前返回；其他路径执行上面的精确锁内effect。 *)
Definition abs_semaphore_create_masked (sg : StableGlobalState) (value : Z)
    : program VarGlobalState Z :=
  {| MonadErr.nrm := fun before result after =>
       (result = -5 /\ after = before) \/
       (abs_semaphore_create_locked sg value).(MonadErr.nrm) before result after;
     MonadErr.err := fun _ => False |}.

(** IRQ开启的调用采用共享RTrans原子提升。malloc NULL没有凭空加一次
    临界区，保留输入状态集合；分配成功后才观察lock时刻状态。 *)
Definition abs_semaphore_create (sg : StableGlobalState) (value : Z)
    : program (VarGlobalState -> Prop) Z :=
  {| MonadErr.nrm := fun before result after =>
       (result = -5 /\ after == before) \/
       (task_atomic_cmd (abs_semaphore_create_locked sg value)).(MonadErr.nrm)
          before result after;
     MonadErr.err := fun _ => False |}.

(** 源码中的uint16++再条件--：65535回绕到0并保持0；其余值回到原值。
    malloc失败路径未执行此操作。 *)
Definition semaphore_create_nest_after (n : Z) : Z :=
  critical_nest_dec (critical_nest_inc n).

(** 将真实计数变化与分配失败/锁内返回原因关联，不能任意混合两条路径。 *)
Definition semaphore_create_nest_result (sg : StableGlobalState) (value : Z)
    (before : VarGlobalState) (n result : Z) (after : VarGlobalState) (m : Z) : Prop :=
  (result = -5 /\ after = before /\ m = n) \/
  ((abs_semaphore_create_locked sg value).(MonadErr.nrm) before result after /\
    m = critical_nest_roundtrip n).
