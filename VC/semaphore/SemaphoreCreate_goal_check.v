Require Import CRTOS_Verify.VC.semaphore.SemaphoreCreate_goal CRTOS_Verify.VC.semaphore.SemaphoreCreate_proof_auto CRTOS_Verify.VC.semaphore.SemaphoreCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include SemaphoreCreate_proof_auto.
  Include SemaphoreCreate_proof_manual.
End VC_Correctness.
