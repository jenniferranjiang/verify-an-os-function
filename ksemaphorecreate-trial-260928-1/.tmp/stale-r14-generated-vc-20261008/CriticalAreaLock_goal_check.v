From CRTOS_Verify.VC Require Import CriticalAreaLock_goal CriticalAreaLock_proof_auto CriticalAreaLock_proof_manual.

Module VC_Correctness : VC_Correct.
  Include CriticalAreaLock_proof_auto.
  Include CriticalAreaLock_proof_manual.
End VC_Correctness.
