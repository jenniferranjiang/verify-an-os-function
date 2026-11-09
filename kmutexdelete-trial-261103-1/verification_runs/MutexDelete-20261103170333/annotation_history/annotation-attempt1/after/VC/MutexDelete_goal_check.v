From KMutexDeleteProof.VC Require Import MutexDelete_goal MutexDelete_proof_auto MutexDelete_proof_manual.

Module VC_Correctness : VC_Correct.
  Include MutexDelete_proof_auto.
  Include MutexDelete_proof_manual.
End VC_Correctness.
