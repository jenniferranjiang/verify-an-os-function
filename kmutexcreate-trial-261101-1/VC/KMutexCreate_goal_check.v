From CRTOS_Verify.VC Require Import KMutexCreate_goal KMutexCreate_proof_auto KMutexCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include KMutexCreate_proof_auto.
  Include KMutexCreate_proof_manual.
End VC_Correctness.
