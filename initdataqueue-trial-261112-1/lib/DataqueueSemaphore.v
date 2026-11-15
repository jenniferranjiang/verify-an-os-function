Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require CRTOS_Verify.lib.semaphore.KSemaphoreCreate.
Require CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Require Export CRTOS_Verify.lib.semaphore.SemaphoreOps.
Require Export InitDataqueueTrial.lib.CrtosInv.
From MonadLib.MonadErr Require Import MonadErrBasic.
Import ListNotations MonadErr Monad MonadNotation.
Local Open Scope Z_scope.
Local Open Scope monad.

(** 原Semaphore纯创建command直接引用根库，借助project_core保守提升；
    不复制SemaphoreInv、TaskInv或它们的证明文件。queue资源在同一carrier
    作为frame保留，IC真实body仍需后续独立证明。 *)
Definition dq_semaphore_create_ic (sg : StableGlobalState) (val : Z)
    : program VarGlobalState Z :=
  lift_core (choice (ret (-5))
    (CRTOS_Verify.lib.semaphore.KSemaphoreCreate.abs_semaphore_create_locked sg val)).
Definition dq_semaphore_create_effect sg val before result after : Prop :=
  nrm (dq_semaphore_create_ic sg val) before result after.

(** 本轮rollback只删除无等待者对象，负ID及uint16查询语义不变。
    queue map不强制sem永久存在，具体原对象由checked观察确认。 *)
Definition dq_sem_delete_empty (id : Z) (st : VarGlobalState) : Prop :=
  id < 0 \/ forall sem, In sem st.(os_semaphores) ->
    sem.(semaphore_id) = semaphore_query_id id ->
    sem.(semaphore_pending_addrs) = nil.

(** 直接引用原core删除关系，empty保证resched=false；lift_core保持新增
    queue分量，其余原模块字段按根纯效果保持。原helper合同的状态域仍为
    CoreVarGlobalState，调用时从本轮os_inv拆出原core资源再frame归还。 *)
Definition dq_semaphore_delete_ic (id : Z) : program VarGlobalState unit :=
  lift_core
    {| nrm := fun before _ after =>
         (id < 0 /\ after = before) \/
         (0 <= id /\ exists p,
           CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_locked_effect
             id p false before after);
       err := fun _ => False |}.
Definition dq_semaphore_delete_effect id before after : Prop :=
  nrm (dq_semaphore_delete_ic id) before tt after.
