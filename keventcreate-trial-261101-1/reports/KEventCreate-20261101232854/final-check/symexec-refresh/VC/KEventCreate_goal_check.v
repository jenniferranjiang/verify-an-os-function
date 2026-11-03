From CRTOS_Verify.VC Require Import KEventCreate_goal KEventCreate_proof_auto KEventCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include KEventCreate_proof_auto.
  Include KEventCreate_proof_manual.
End VC_Correctness.
