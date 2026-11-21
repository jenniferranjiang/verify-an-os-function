From CRTOS_Verify.VC.semaphore Require Import KSemaphoreDeleteIC_goal KSemaphoreDeleteIC_proof_auto KSemaphoreDeleteIC_proof_manual.

Module VC_Correctness : VC_Correct.
  Include KSemaphoreDeleteIC_proof_auto.
  Include KSemaphoreDeleteIC_proof_manual.
End VC_Correctness.
