From CRTOS_Verify.VC Require Import InsertObj_goal InsertObj_proof_auto_verified InsertObj_proof_manual.

Module VC_Correctness_Verified : VC_Correct.
  Include InsertObj_proof_auto_verified.
  Include InsertObj_proof_manual.
End VC_Correctness_Verified.
