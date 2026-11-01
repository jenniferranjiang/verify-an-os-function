Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import SetsClass.SetsClass.
Import SetsNotation.

Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Require Import CRTOS_Verify.sem.CrtosOSPure.

Lemma review_irq_enter_transition :
  forall handler handlers stable world,
    crtos_os_protocol_transition
      (Build_CrtosOSProtocolState handlers stable world,
       crtos_os_no_tokens)
      (Build_CrtosOSProtocolState (handler :: handlers) stable world,
       crtos_os_depth_token (List.length handlers)).
Proof.
  intros handler handlers stable world.
  unfold crtos_os_protocol_transition.
  exists crtos_os_no_tokens,
    (crtos_os_depth_token (List.length handlers)), crtos_os_no_tokens.
  assert (Hnone_left : forall tokens,
      crtos_os_token_disjoint crtos_os_no_tokens tokens).
  { unfold crtos_os_token_disjoint, crtos_os_no_tokens. tauto. }
  assert (Hnone_right : forall tokens,
      crtos_os_token_disjoint tokens crtos_os_no_tokens).
  { unfold crtos_os_token_disjoint, crtos_os_no_tokens. tauto. }
  assert (Hunion_right : forall tokens,
      crtos_os_token_equiv tokens
        (crtos_os_token_union tokens crtos_os_no_tokens)).
  { intros tokens token. unfold crtos_os_token_union, crtos_os_no_tokens.
    tauto. }
  refine (conj (crtos_os_enter_core handler handlers stable world)
    (conj (Hnone_left crtos_os_no_tokens)
      (conj (Hnone_right (crtos_os_depth_token (List.length handlers)))
        (conj (Hnone_right _)
          (conj (Hnone_right _)
            (conj (Hunion_right crtos_os_no_tokens)
              (Hunion_right
                (crtos_os_depth_token (List.length handlers))))))))).
Qed.

Lemma review_irq_exit_transition :
  forall handler handlers stable before after,
    CrtosOSGTrans stable before after ->
    crtos_os_protocol_transition
      (Build_CrtosOSProtocolState (handler :: handlers) stable before,
       crtos_os_depth_token (List.length handlers))
      (Build_CrtosOSProtocolState handlers stable after,
       crtos_os_no_tokens).
Proof.
  intros handler handlers stable before after Hworld.
  unfold crtos_os_protocol_transition.
  exists (crtos_os_depth_token (List.length handlers)),
    crtos_os_no_tokens, crtos_os_no_tokens.
  assert (Hnone_left : forall tokens,
      crtos_os_token_disjoint crtos_os_no_tokens tokens).
  { unfold crtos_os_token_disjoint, crtos_os_no_tokens. tauto. }
  assert (Hnone_right : forall tokens,
      crtos_os_token_disjoint tokens crtos_os_no_tokens).
  { unfold crtos_os_token_disjoint, crtos_os_no_tokens. tauto. }
  assert (Hunion_right : forall tokens,
      crtos_os_token_equiv tokens
        (crtos_os_token_union tokens crtos_os_no_tokens)).
  { intros tokens token. unfold crtos_os_token_union, crtos_os_no_tokens.
    tauto. }
  refine (conj (crtos_os_exit_core handler handlers stable before after Hworld)
    (conj (Hnone_right (crtos_os_depth_token (List.length handlers)))
      (conj (Hnone_left crtos_os_no_tokens)
        (conj (Hnone_right _)
          (conj (Hnone_right _)
            (conj (Hunion_right
              (crtos_os_depth_token (List.length handlers)))
              (Hunion_right crtos_os_no_tokens))))))).
Qed.
