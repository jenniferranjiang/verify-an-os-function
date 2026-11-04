From CRTOS_Verify.VC Require Import KEventDelete_goal KEventDelete_proof_auto KEventDelete_proof_manual.

Module VC_Correctness : VC_Correct.
  Include KEventDelete_proof_auto.
  Include KEventDelete_proof_manual.
End VC_Correctness.
