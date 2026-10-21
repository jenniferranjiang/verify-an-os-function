Require Import Coq.ZArith.ZArith Coq.micromega.Lia.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Export TrialShared.CrtosRules.
Local Open Scope Z_scope.
Local Open Scope sac.

(**
  全局 __exstatus 是独立 Int 槽，显式限定为 32 位有符号整数范围。
  KUpdateExstatus 写入 [-10,0]，但 KObtainExstatus / libc 的 errno 接口
  还会暴露可写 int 指针，不能把整个全局状态限制为负内核错误码。
  KObtainExstatus 返回可写地址需要后续借用/归还接口，不能凭此复制该槽。
*)
Definition exstatus_inv (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ INT_MIN <= st.(os_exstatus) <= INT_MAX ” &&
  sg.(os_exstatus_slot) # Int |-> st.(os_exstatus).

(** 状态码范围是显式契约；外借 KObtainExstatus 返回的写权限时必须恢复它。 *)
Lemma exstatus_inv_range : forall sg st,
  exstatus_inv sg st |-- “ INT_MIN <= st.(os_exstatus) <= INT_MAX ”.
Proof. intros; unfold exstatus_inv; entailer!. Qed.

Lemma exstatus_update_range : forall status : Z,
  0 <= status < 11 -> INT_MIN <= -status <= INT_MAX.
Proof.
  intros status Hstatus.
  change (-2147483648 <= -status <= 2147483647).
  lia.
Qed.
