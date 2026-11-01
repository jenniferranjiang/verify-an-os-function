From CRTOS_Verify.VC Require Import InitDoubleLinkList_goal InitDoubleLinkList_proof_auto InitDoubleLinkList_proof_manual.

Module VC_Correctness : VC_Correct.
  Include InitDoubleLinkList_proof_auto.
  Include InitDoubleLinkList_proof_manual.
End VC_Correctness.
