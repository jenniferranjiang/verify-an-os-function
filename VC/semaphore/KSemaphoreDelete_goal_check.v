Require Import CRTOS_Verify.VC.semaphore.KSemaphoreDelete_goal CRTOS_Verify.VC.semaphore.KSemaphoreDelete_proof_auto CRTOS_Verify.VC.semaphore.KSemaphoreDelete_proof_manual.

Module VC_Correctness : VC_Correct.
  Include KSemaphoreDelete_proof_auto.
  Include KSemaphoreDelete_proof_manual.
End VC_Correctness.
