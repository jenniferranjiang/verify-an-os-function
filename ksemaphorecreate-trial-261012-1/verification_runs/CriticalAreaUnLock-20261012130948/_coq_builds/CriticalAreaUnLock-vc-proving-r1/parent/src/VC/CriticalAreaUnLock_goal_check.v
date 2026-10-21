From CRTOS_Verify.VC Require Import CriticalAreaUnLock_goal CriticalAreaUnLock_proof_auto CriticalAreaUnLock_proof_manual.

Module VC_Correctness : VC_Correct.
  Include CriticalAreaUnLock_proof_auto.
  Include CriticalAreaUnLock_proof_manual.
End VC_Correctness.
