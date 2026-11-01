From CRTOS_Verify.VC Require Import InsertObj_goal InsertObj_proof_auto InsertObj_proof_manual.

Module VC_Correctness : VC_Correct.
  Include InsertObj_proof_auto.
  Include InsertObj_proof_manual.
End VC_Correctness.
