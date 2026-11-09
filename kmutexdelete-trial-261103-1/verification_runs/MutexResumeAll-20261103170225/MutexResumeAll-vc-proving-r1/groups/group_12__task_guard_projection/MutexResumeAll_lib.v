From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
From Coq Require Import Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KMutexDelete.
Local Open Scope string.
Local Open Scope sac.

(** 等待哨兵next的借出/归还资源：wand不能被当成可复制的纯事实。 *)
Definition mutex_resume_next_restore (sg : StableGlobalState) (st : VarGlobalState)
    (head next : addr) : Assertion :=
  (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) -* os_inv sg st.

(** 写exstatus后恢复新的task-map索引全局资源；构造此wand必须证明关联保持。 *)
Definition mutex_resume_exstatus_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task value : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* os_inv sg st.

(** 任务ID只读字段，原值归还后重新得到完整os_inv，供Wakeup调用。 *)
Definition mutex_resume_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task id : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 剩余队列完成后的整体结果仍是原drain临界区的批量效果。
    复用已审阅逐步关系，不另定义一套执行链；初始化/保持均是显式VC义务。 *)
Definition mutex_resume_remaining_effect (p : addr) (waiting : list addr)
    (before : VarGlobalState) (remaining : list addr) (current : VarGlobalState) : Prop :=
  forall final,
    mutex_resume_all_steps p remaining current final ->
    mutex_resume_all_effect p waiting before final.
