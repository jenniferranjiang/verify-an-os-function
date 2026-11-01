From CRTOS_Verify.VC Require Import AllocId_goal AllocId_proof_auto AllocId_proof_manual.

Module VC_Correctness : VC_Correct.
  Include AllocId_proof_auto.
  Include AllocId_proof_manual.
End VC_Correctness.
