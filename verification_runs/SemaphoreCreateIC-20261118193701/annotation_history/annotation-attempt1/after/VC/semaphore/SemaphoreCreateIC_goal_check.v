From CRTOS_Verify.VC.semaphore Require Import SemaphoreCreateIC_goal SemaphoreCreateIC_proof_auto SemaphoreCreateIC_proof_manual.

Module VC_Correctness : VC_Correct.
  Include SemaphoreCreateIC_proof_auto.
  Include SemaphoreCreateIC_proof_manual.
End VC_Correctness.
