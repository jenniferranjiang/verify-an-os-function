From KMutexDeleteProof.VC Require Import MutexResumeAll_goal MutexResumeAll_proof_auto MutexResumeAll_proof_manual.

Module VC_Correctness : VC_Correct.
  Include MutexResumeAll_proof_auto.
  Include MutexResumeAll_proof_manual.
End VC_Correctness.
