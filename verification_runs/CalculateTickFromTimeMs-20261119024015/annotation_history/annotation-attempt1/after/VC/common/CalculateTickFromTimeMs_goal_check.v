From CRTOS_Verify.VC.common Require Import CalculateTickFromTimeMs_goal CalculateTickFromTimeMs_proof_auto CalculateTickFromTimeMs_proof_manual.

Module VC_Correctness : VC_Correct.
  Include CalculateTickFromTimeMs_proof_auto.
  Include CalculateTickFromTimeMs_proof_manual.
End VC_Correctness.
