Require Import CRTOS_Verify.VC.mutex.MutexCreate_goal CRTOS_Verify.VC.mutex.MutexCreate_proof_auto CRTOS_Verify.VC.mutex.MutexCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include MutexCreate_proof_auto.
  Include MutexCreate_proof_manual.
End VC_Correctness.
