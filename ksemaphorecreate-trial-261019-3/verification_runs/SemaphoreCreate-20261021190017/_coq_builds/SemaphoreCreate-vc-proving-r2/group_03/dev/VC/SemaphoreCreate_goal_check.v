From CRTOS_Verify.VC Require Import SemaphoreCreate_goal SemaphoreCreate_proof_auto SemaphoreCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include SemaphoreCreate_proof_auto.
  Include SemaphoreCreate_proof_manual.
End VC_Correctness.
