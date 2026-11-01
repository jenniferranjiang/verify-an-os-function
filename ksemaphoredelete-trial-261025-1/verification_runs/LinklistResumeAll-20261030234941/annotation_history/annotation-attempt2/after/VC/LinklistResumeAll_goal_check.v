From CRTOS_Verify.VC Require Import LinklistResumeAll_goal LinklistResumeAll_proof_auto LinklistResumeAll_proof_manual.

Module VC_Correctness : VC_Correct.
  Include LinklistResumeAll_proof_auto.
  Include LinklistResumeAll_proof_manual.
End VC_Correctness.
