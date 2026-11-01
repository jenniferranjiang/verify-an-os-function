From CRTOS_Verify.VC Require Import IdInsertObj_goal IdInsertObj_proof_auto IdInsertObj_proof_manual.

Module VC_Correctness : VC_Correct.
  Include IdInsertObj_proof_auto.
  Include IdInsertObj_proof_manual.
End VC_Correctness.
