From CRTOS_Verify.VC.dataqueue Require Import DataqueuePeak_goal DataqueuePeak_proof_auto DataqueuePeak_proof_manual.

Module VC_Correctness : VC_Correct.
  Include DataqueuePeak_proof_auto.
  Include DataqueuePeak_proof_manual.
End VC_Correctness.
