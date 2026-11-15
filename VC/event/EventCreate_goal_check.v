Require Import CRTOS_Verify.VC.event.EventCreate_goal CRTOS_Verify.VC.event.EventCreate_proof_auto CRTOS_Verify.VC.event.EventCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include EventCreate_proof_auto.
  Include EventCreate_proof_manual.
End VC_Correctness.
