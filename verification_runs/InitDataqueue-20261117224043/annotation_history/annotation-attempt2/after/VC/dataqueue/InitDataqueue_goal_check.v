From CRTOS_Verify.VC.dataqueue Require Import InitDataqueue_goal InitDataqueue_proof_auto InitDataqueue_proof_manual.

Module VC_Correctness : VC_Correct.
  Include InitDataqueue_proof_auto.
  Include InitDataqueue_proof_manual.
End VC_Correctness.
