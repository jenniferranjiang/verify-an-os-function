From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.common Require Import CalculateTickFromTimeMs_goal.
From CRTOS_Verify.VC.common Require Import CalculateTickFromTimeMs_proof_auto.
Require Import CRTOS_Verify.lib.common.CrtosRules.
Require Import CRTOS_Verify.lib.common.TickConversion.
Local Open Scope sac.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_1_split_goal_1 : CalculateTickFromTimeMs_return_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  try rewrite Z.quot_div_nonneg in * by lia.
  try rewrite Z.rem_mod_nonneg in * by lia.
  assert (Hq : 0 <= (ms_pre * 100) / 1000 <= 429496730).
  { split; [apply Z.div_pos | apply Z.div_le_upper_bound]; lia. }
  pose proof (Z.mod_pos_bound (ms_pre * 100) 1000 ltac:(lia)) as Hr.
  assert (Hqb : unsigned_last_nbits ((ms_pre * 100) / 1000) 32 = (ms_pre * 100) / 1000).
  { apply unsigned_last_nbits_eq. change (0 <= (ms_pre * 100) / 1000 < 4294967296). lia. }
  assert (Hrb : unsigned_last_nbits ((ms_pre * 100) mod 1000) 32 = (ms_pre * 100) mod 1000).
  { apply unsigned_last_nbits_eq. change (0 <= (ms_pre * 100) mod 1000 < 4294967296). lia. }
  rewrite Hqb in *. try rewrite Hrb in *.
  try rewrite (unsigned_last_nbits_eq (((ms_pre * 100) / 1000) + 1) 32 ltac:(change (0 <= (ms_pre * 100) / 1000 + 1 < 4294967296); lia)).
  unfold tick_from_time_ms.
  destruct (Z.eq_dec ((ms_pre * 100) / 1000) 0); try lia.
Qed.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_1 : CalculateTickFromTimeMs_return_wit_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_CalculateTickFromTimeMs_return_wit_1_split_goal_1.
Qed.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_2_split_goal_1 : CalculateTickFromTimeMs_return_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  try rewrite Z.quot_div_nonneg in * by lia.
  try rewrite Z.rem_mod_nonneg in * by lia.
  assert (Hq : 0 <= (ms_pre * 100) / 1000 <= 429496730).
  { split; [apply Z.div_pos | apply Z.div_le_upper_bound]; lia. }
  pose proof (Z.mod_pos_bound (ms_pre * 100) 1000 ltac:(lia)) as Hr.
  assert (Hqb : unsigned_last_nbits ((ms_pre * 100) / 1000) 32 = (ms_pre * 100) / 1000).
  { apply unsigned_last_nbits_eq. change (0 <= (ms_pre * 100) / 1000 < 4294967296). lia. }
  assert (Hrb : unsigned_last_nbits ((ms_pre * 100) mod 1000) 32 = (ms_pre * 100) mod 1000).
  { apply unsigned_last_nbits_eq. change (0 <= (ms_pre * 100) mod 1000 < 4294967296). lia. }
  rewrite Hqb in *. try rewrite Hrb in *.
  try rewrite (unsigned_last_nbits_eq (((ms_pre * 100) / 1000) + 1) 32 ltac:(change (0 <= (ms_pre * 100) / 1000 + 1 < 4294967296); lia)).
  unfold tick_from_time_ms.
  destruct (Z.eq_dec ((ms_pre * 100) / 1000) 0); try lia.
  assert (Hlo : Z.leb 5 ((ms_pre * 100) mod 1000) = true) by (apply Z.leb_le; lia).
  assert (Hhi : Z.leb ((ms_pre * 100) mod 1000) 9 = true) by (apply Z.leb_le; lia).
  rewrite Hlo, Hhi. reflexivity.
Qed.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_2 : CalculateTickFromTimeMs_return_wit_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_CalculateTickFromTimeMs_return_wit_2_split_goal_1.
Qed.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_3_split_goal_1 : CalculateTickFromTimeMs_return_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  try rewrite Z.quot_div_nonneg in * by lia.
  try rewrite Z.rem_mod_nonneg in * by lia.
  assert (Hq : 0 <= (ms_pre * 100) / 1000 <= 429496730).
  { split; [apply Z.div_pos | apply Z.div_le_upper_bound]; lia. }
  pose proof (Z.mod_pos_bound (ms_pre * 100) 1000 ltac:(lia)) as Hr.
  assert (Hqb : unsigned_last_nbits ((ms_pre * 100) / 1000) 32 = (ms_pre * 100) / 1000).
  { apply unsigned_last_nbits_eq. change (0 <= (ms_pre * 100) / 1000 < 4294967296). lia. }
  assert (Hrb : unsigned_last_nbits ((ms_pre * 100) mod 1000) 32 = (ms_pre * 100) mod 1000).
  { apply unsigned_last_nbits_eq. change (0 <= (ms_pre * 100) mod 1000 < 4294967296). lia. }
  rewrite Hqb in *. try rewrite Hrb in *.
  try rewrite (unsigned_last_nbits_eq (((ms_pre * 100) / 1000) + 1) 32 ltac:(change (0 <= (ms_pre * 100) / 1000 + 1 < 4294967296); lia)).
  unfold tick_from_time_ms.
  destruct (Z.eq_dec ((ms_pre * 100) / 1000) 0); try lia.
  assert (Hlo : Z.leb 5 ((ms_pre * 100) mod 1000) = false) by (apply Z.leb_gt; lia).
  rewrite Hlo. reflexivity.
Qed.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_3 : CalculateTickFromTimeMs_return_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_CalculateTickFromTimeMs_return_wit_3_split_goal_1.
Qed.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_4_split_goal_1 : CalculateTickFromTimeMs_return_wit_4_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  try rewrite Z.quot_div_nonneg in * by lia.
  try rewrite Z.rem_mod_nonneg in * by lia.
  assert (Hq : 0 <= (ms_pre * 100) / 1000 <= 429496730).
  { split; [apply Z.div_pos | apply Z.div_le_upper_bound]; lia. }
  pose proof (Z.mod_pos_bound (ms_pre * 100) 1000 ltac:(lia)) as Hr.
  assert (Hqb : unsigned_last_nbits ((ms_pre * 100) / 1000) 32 = (ms_pre * 100) / 1000).
  { apply unsigned_last_nbits_eq. change (0 <= (ms_pre * 100) / 1000 < 4294967296). lia. }
  assert (Hrb : unsigned_last_nbits ((ms_pre * 100) mod 1000) 32 = (ms_pre * 100) mod 1000).
  { apply unsigned_last_nbits_eq. change (0 <= (ms_pre * 100) mod 1000 < 4294967296). lia. }
  rewrite Hqb in *. try rewrite Hrb in *.
  try rewrite (unsigned_last_nbits_eq (((ms_pre * 100) / 1000) + 1) 32 ltac:(change (0 <= (ms_pre * 100) / 1000 + 1 < 4294967296); lia)).
  unfold tick_from_time_ms.
  destruct (Z.eq_dec ((ms_pre * 100) / 1000) 0); try lia.
  assert (Hhi : Z.leb ((ms_pre * 100) mod 1000) 9 = false) by (apply Z.leb_gt; lia).
  rewrite Hhi, Bool.andb_false_r. reflexivity.
Qed.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_4 : CalculateTickFromTimeMs_return_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_CalculateTickFromTimeMs_return_wit_4_split_goal_1.
Qed.

Lemma proof_of_CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial : CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_CalculateTickFromTimeMs_which_implies_wit_1 : CalculateTickFromTimeMs_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of_CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial : CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_CalculateTickFromTimeMs_which_implies_wit_2 : CalculateTickFromTimeMs_which_implies_wit_2.
Proof. Admitted.

