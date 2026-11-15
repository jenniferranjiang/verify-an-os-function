Require Import CRTOS_Verify.VC.semaphore.LinklistResumeAll_goal CRTOS_Verify.VC.semaphore.LinklistResumeAll_proof_auto CRTOS_Verify.VC.semaphore.LinklistResumeAll_proof_manual.

Module VC_Correctness : VC_Correct.
  Include LinklistResumeAll_proof_auto.
  Include LinklistResumeAll_proof_manual.
End VC_Correctness.
