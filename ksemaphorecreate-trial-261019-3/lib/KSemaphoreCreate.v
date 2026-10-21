Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Export TrialShared.CrtosInv.
From MonadLib.MonadErr Require Export MonadErrBasic monadesafe_lib.
Import ListNotations IDNode MonadErr.
Local Open Scope Z_scope.

(** 锁内操作精确描述容量满失败，或选取最小空闲ID并发布初始化对象。
    分配地址仅存在量化；新对象须尚未发布，其真实freshness由分离ownership保证。
    内存权限和私有对象转移由C contract处理，此纯关系不拥有资源。 *)
Definition abs_semaphore_create_locked (sg : StableGlobalState) (val : Z)
    : program VarGlobalState Z :=
  {| nrm := fun before result after =>
       let sidm := sg.(os_semaphore_stable).(semaphore_manager_stable) in
       let idm := semaphore_manager before.(os_semaphores) in
       (result = -5 /\ idmanager_full sidm idm /\ after = before) \/
       (exists p,
         p <> 0 /\ addr_aligned p 4 /\
         ~ In p (map semaphore_addr before.(os_semaphores)) /\
         idmanager_min_free_id sidm idm result /\
         after = replace_semaphores
           (semaphore_publish p result val before.(os_semaphores)) before);
     err := fun _ => False |}.

(** malloc失败在进入临界区前返回，不引入虚构原子观察；其余路径执行一次
    原子操作。-ENOMEMORY= -5，内部分配ID失败为-1而外层转换为-5。 *)
Definition abs_semaphore_create (sg : StableGlobalState) (val : Z)
    : program (VarGlobalState -> Prop) Z :=
  choice (MonadErr.ret (-5))
    (task_atomic_cmd (abs_semaphore_create_locked sg val)).

(** 编译检查使用的协议类型连接；不是C实现证明或待证公理。 *)
Check @safeExec.
Check LastSeen.
Check abs_semaphore_create.
Check SemaphoreRaw.
Check SemaphoreZero.
Check CriticalNest.
