From CRTOS_Verify.VC Require Import IdInsertObj_goal IdInsertObj_proof_auto_verified IdInsertObj_proof_manual.

Module VC_Correctness_Verified : VC_Correct.
  Include IdInsertObj_proof_auto_verified.
  Include IdInsertObj_proof_manual.
End VC_Correctness_Verified.
