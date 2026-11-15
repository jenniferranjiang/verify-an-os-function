(** Trial adaptation of lib/task/TaskStatusMemory.v; baseline SHA256 bda16faef54155629c40d76a353c3b17fb40e236db46afac745d4118566e9de1.
    必要修改：将依赖改为扩展后同一 OS state / STS 实例，原全局文件保持只读。 *)
From Coq Require Import ZArith Lia.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_InitDataqueue.CrtosRules.
Require Export CRTOS_Verify.lib.task.TaskStatus.

Local Open Scope Z_scope.
Local Open Scope sac.

(** 状态属于语义层，原始字节只在此存在量中保存。非法编码同样可读。 *)
Definition store_task_status (p : addr) (status : TaskStatus) : Assertion :=
  EX raw : Z, “ decode_task_status raw = status ” && p # UChar |-> raw.

Lemma store_task_status_fold : forall p raw,
  p # UChar |-> raw |-- store_task_status p (decode_task_status raw).
Proof. intros; unfold store_task_status; Exists raw; entailer!. Qed.

Lemma store_task_status_valid : forall p status,
  store_task_status p status |-- “ valid_object p (sizeof(CHAR)) 1 ”.
Proof.
  intros; unfold store_task_status; Intros raw.
  prop_apply (valid_store_uchar p raw); Intros. entailer!.
Qed.

Lemma store_task_status_permission : forall p status,
  store_task_status p status |-- p # UChar |->_ .
Proof.
  intros; unfold store_task_status; Intros raw.
  sep_apply store_uchar_undef_store_uchar; entailer!.
Qed.
