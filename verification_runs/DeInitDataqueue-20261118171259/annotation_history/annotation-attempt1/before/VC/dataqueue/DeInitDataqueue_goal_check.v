From CRTOS_Verify.VC.dataqueue Require Import DeInitDataqueue_goal DeInitDataqueue_proof_auto DeInitDataqueue_proof_manual.

Module VC_Correctness : VC_Correct.
  Include DeInitDataqueue_proof_auto.
  Include DeInitDataqueue_proof_manual.
End VC_Correctness.
