From CRTOS_Verify.VC Require Import FindEventById_goal FindEventById_proof_auto FindEventById_proof_manual.

Module VC_Correctness : VC_Correct.
  Include FindEventById_proof_auto.
  Include FindEventById_proof_manual.
End VC_Correctness.
