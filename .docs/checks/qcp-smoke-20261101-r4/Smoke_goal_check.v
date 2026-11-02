From QcpSmoke Require Import Smoke_goal Smoke_proof_auto Smoke_proof_manual.

Module VC_Correctness : VC_Correct.
  Include Smoke_proof_auto.
  Include Smoke_proof_manual.
End VC_Correctness.
