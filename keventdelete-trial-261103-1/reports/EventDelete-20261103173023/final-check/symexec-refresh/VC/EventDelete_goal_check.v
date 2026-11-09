From CRTOS_Verify.VC Require Import EventDelete_goal EventDelete_proof_auto EventDelete_proof_manual.

Module VC_Correctness : VC_Correct.
  Include EventDelete_proof_auto.
  Include EventDelete_proof_manual.
End VC_Correctness.
