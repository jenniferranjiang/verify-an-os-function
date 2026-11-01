From CRTOS_Verify.VC Require Import SemaphoreDelete_goal SemaphoreDelete_proof_auto SemaphoreDelete_proof_manual.

Module VC_Correctness : VC_Correct.
  Include SemaphoreDelete_proof_auto.
  Include SemaphoreDelete_proof_manual.
End VC_Correctness.
