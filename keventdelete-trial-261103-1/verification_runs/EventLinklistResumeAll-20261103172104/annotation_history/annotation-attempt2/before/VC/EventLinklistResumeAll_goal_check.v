From CRTOS_Verify.VC Require Import EventLinklistResumeAll_goal EventLinklistResumeAll_proof_auto EventLinklistResumeAll_proof_manual.

Module VC_Correctness : VC_Correct.
  Include EventLinklistResumeAll_proof_auto.
  Include EventLinklistResumeAll_proof_manual.
End VC_Correctness.
