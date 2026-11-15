Require Import CRTOS_Verify.VC.mutex.KMutexCreate_goal CRTOS_Verify.VC.mutex.KMutexCreate_proof_auto CRTOS_Verify.VC.mutex.KMutexCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include KMutexCreate_proof_auto.
  Include KMutexCreate_proof_manual.
End VC_Correctness.
