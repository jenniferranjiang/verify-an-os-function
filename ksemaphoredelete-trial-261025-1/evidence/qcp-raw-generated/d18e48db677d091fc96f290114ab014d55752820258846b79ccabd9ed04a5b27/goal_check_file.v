From CRTOS_Verify.VC Require Import KSemaphoreDelete_goal KSemaphoreDelete_proof_auto KSemaphoreDelete_proof_manual.

Module VC_Correctness : VC_Correct.
  Include KSemaphoreDelete_proof_auto.
  Include KSemaphoreDelete_proof_manual.
End VC_Correctness.
