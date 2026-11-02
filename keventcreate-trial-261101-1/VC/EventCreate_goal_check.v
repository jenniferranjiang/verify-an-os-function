From CRTOS_Verify.VC Require Import EventCreate_goal EventCreate_proof_auto EventCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include EventCreate_proof_auto.
  Include EventCreate_proof_manual.
End VC_Correctness.
