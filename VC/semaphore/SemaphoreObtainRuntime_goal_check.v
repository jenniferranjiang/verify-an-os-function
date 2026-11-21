From CRTOS_Verify.VC.semaphore Require Import SemaphoreObtainRuntime_goal SemaphoreObtainRuntime_proof_auto SemaphoreObtainRuntime_proof_manual.

Module VC_Correctness : VC_Correct.
  Include SemaphoreObtainRuntime_proof_auto.
  Include SemaphoreObtainRuntime_proof_manual.
End VC_Correctness.
