Require Import CRTOS_Verify.VC.semaphore.SemaphoreDelete_goal CRTOS_Verify.VC.semaphore.SemaphoreDelete_proof_auto CRTOS_Verify.VC.semaphore.SemaphoreDelete_proof_manual.

Module VC_Correctness : VC_Correct.
  Include SemaphoreDelete_proof_auto.
  Include SemaphoreDelete_proof_manual.
End VC_Correctness.
