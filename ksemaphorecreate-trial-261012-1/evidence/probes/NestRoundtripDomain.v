Require Import Coq.ZArith.ZArith Coq.micromega.Lia.
Local Open Scope Z_scope.

(** 直接对应 CriticalAreaLock 的 uint16++ 与 CriticalAreaUnLock 的
    非零递减。只判断算术保持条件，不假定实际板级可达状态，也不修改入口合同。 *)
Lemma critical_counter_roundtrip_exact_domain : forall n,
  0 <= n <= 65535 ->
  (Z.max 0 (((n + 1) mod 65536) - 1) = n <-> n < 65535).
Proof.
  intros n Hrange.
  destruct (Z.eq_dec n 65535) as [-> | Hneq].
  - change (0 = 65535 <-> 65535 < 65535); lia.
  - rewrite Z.mod_small by lia.
    replace (n + 1 - 1) with n by lia.
    rewrite Z.max_r by lia.
    split; lia.
Qed.

Print Assumptions critical_counter_roundtrip_exact_domain.
