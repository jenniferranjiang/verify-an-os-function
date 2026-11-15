Require Import CRTOS_Verify.VC.semaphore.KSemaphoreCreate_goal CRTOS_Verify.VC.semaphore.KSemaphoreCreate_proof_auto CRTOS_Verify.VC.semaphore.KSemaphoreCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include KSemaphoreCreate_proof_auto.
  Include KSemaphoreCreate_proof_manual.
End VC_Correctness.
