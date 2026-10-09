From CRTOS_Verify.VC Require Import AllocId_goal AllocId_proof_auto_verified AllocId_proof_manual.

Module VC_Correctness_Verified : VC_Correct.
  Include AllocId_proof_auto_verified.
  Include AllocId_proof_manual.
End VC_Correctness_Verified.
