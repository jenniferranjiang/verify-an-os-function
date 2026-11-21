From CRTOS_Verify.VC.dataqueue Require Import PopDataqueue_goal PopDataqueue_proof_auto PopDataqueue_proof_manual.

Module VC_Correctness : VC_Correct.
  Include PopDataqueue_proof_auto.
  Include PopDataqueue_proof_manual.
End VC_Correctness.
