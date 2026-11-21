From CRTOS_Verify.VC.semaphore Require Import SemaphoreDeleteIC_goal SemaphoreDeleteIC_proof_auto SemaphoreDeleteIC_proof_manual.

Module VC_Correctness : VC_Correct.
  Include SemaphoreDeleteIC_proof_auto.
  Include SemaphoreDeleteIC_proof_manual.
End VC_Correctness.
