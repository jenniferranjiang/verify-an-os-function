From Coq Require Import ZArith Lia String.
From SimpleC.SL Require Import CNotation SeparationLogic.
Require Import CRTOS_Verify.lib.CrtosRules.
Import CRTOS_Verify.lib.CrtosRules.Task_C_Rules.
Local Open Scope Z_scope.
Local Open Scope string_scope.

(** 本probe只检查官方现有定义，不建立新layout公理或新对象表示。 *)
Lemma arm32_pointer_validity_permits_zero : isvalidptr 0.
Proof. unfold isvalidptr. vm_compute. repeat split; congruence. Qed.

(** 非零基址与范围才能以整数算术推出真实已知偏移的非零。 *)
Lemma concrete_subobject_nonzero : forall p offset,
  0 < p -> 0 <= offset -> p + offset <> 0.
Proof. intros; lia. Qed.

(** 以下两个Fail只证实它们不是可定义归约等式；不是全逻辑不可证明性结论。 *)
Fail Definition sys_dll_size_is_definitionally_eight :
  sizeof("SysDoubleLinklistNode") = 8 := eq_refl.
Fail Definition idnode_link_is_definitionally_offset_four (p : Z) :
  &(p # "IdNode" ->ₛ "link") = p + 4 := eq_refl.

Print Assumptions arm32_pointer_validity_permits_zero.
Print Assumptions concrete_subobject_nonzero.
