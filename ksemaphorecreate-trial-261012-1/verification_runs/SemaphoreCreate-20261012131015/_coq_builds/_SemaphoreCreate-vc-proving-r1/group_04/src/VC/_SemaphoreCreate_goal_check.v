From CRTOS_Verify.VC Require Import _SemaphoreCreate_goal _SemaphoreCreate_proof_auto _SemaphoreCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include _SemaphoreCreate_proof_auto.
  Include _SemaphoreCreate_proof_manual.
End VC_Correctness.
