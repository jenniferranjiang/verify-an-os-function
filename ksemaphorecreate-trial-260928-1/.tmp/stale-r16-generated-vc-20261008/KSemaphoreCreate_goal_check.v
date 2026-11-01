From CRTOS_Verify.VC Require Import KSemaphoreCreate_goal KSemaphoreCreate_proof_auto KSemaphoreCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include KSemaphoreCreate_proof_auto.
  Include KSemaphoreCreate_proof_manual.
End VC_Correctness.
