From KMutexDeleteProof.VC Require Import KMutexDelete_goal KMutexDelete_proof_auto KMutexDelete_proof_manual.

Module VC_Correctness : VC_Correct.
  Include KMutexDelete_proof_auto.
  Include KMutexDelete_proof_manual.
End VC_Correctness.
