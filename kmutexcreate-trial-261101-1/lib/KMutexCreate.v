Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Export KMutexCreateTrial.lib.CrtosInv.
From MonadLib.MonadErr Require Export MonadErrBasic monadesafe_lib.
Import ListNotations IDNode MonadErr.
Local Open Scope Z_scope.

(** 锁内创建：ID API 失败仅保证返回失败且模块不变，原复用规格不保证容量满；
    成功选最小空闲 ID，头插完整初始对象，保持所有其他 OS 分量。
    fresh 地址由 malloc 的分离所有权支持，这个纯关系不代替内存权限。 *)
Definition abs_mutex_create_locked (sg : StableGlobalState)
    : program VarGlobalState Z :=
  {| nrm := fun before result after =>
       let sidm := sg.(os_mutex_stable).(mutex_manager_stable) in
       let idm := mutex_manager before.(os_mutexes) in
       (result = -5 /\ after = before) \/
       (exists p,
         p <> 0 /\ addr_aligned p 4 /\
         ~ In p (map mutex_addr before.(os_mutexes)) /\
         idmanager_min_free_id sidm idm result /\
         after = replace_mutexes (mutex_publish p result before.(os_mutexes)) before);
     err := fun _ => False |}.

(** malloc 失败发生在锁外，返回 -ENOMEMORY=-5；其余路径执行一次原子创建。
    不使用“失败必满”或保证分配成功的额外前提。 *)
Definition abs_mutex_create (sg : StableGlobalState)
    : program (VarGlobalState -> Prop) Z :=
  choice (MonadErr.ret (-5))
    (task_atomic_cmd (abs_mutex_create_locked sg)).

Check @safeExec.
Check LastSeen.
Check abs_mutex_create.
Check MutexRaw.
Check MutexZero.
