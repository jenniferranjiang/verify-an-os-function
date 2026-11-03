From CRTOS_Verify.VC Require Import MutexCreate_goal MutexCreate_proof_auto MutexCreate_proof_manual.

Module VC_Correctness : VC_Correct.
  Include MutexCreate_proof_auto.
  Include MutexCreate_proof_manual.
End VC_Correctness.
