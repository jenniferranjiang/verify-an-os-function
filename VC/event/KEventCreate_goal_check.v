Require Import CRTOS_Verify.VC.event.KEventCreate_goal CRTOS_Verify.VC.event.KEventCreate_proof_auto CRTOS_Verify.VC.event.KEventCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include KEventCreate_proof_auto.
  Include KEventCreate_proof_manual.
End VC_Correctness.
