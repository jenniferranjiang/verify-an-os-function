From CRTOS_Verify.VC.semaphore Require Import KSemaphoreCreateIC_goal KSemaphoreCreateIC_proof_auto KSemaphoreCreateIC_proof_manual.

Module VC_Correctness : VC_Correct.
  Include KSemaphoreCreateIC_proof_auto.
  Include KSemaphoreCreateIC_proof_manual.
End VC_Correctness.
