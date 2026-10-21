Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Strings.String.
Require Import Coq.Lists.List.
Require Import Coq.Classes.RelationClasses.
Require Import Coq.Classes.Morphisms.
Require Import Coq.micromega.Psatz.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass. 
Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.

From SimpleC.SL Require Import ConAssertion CriticalSTS.
Require Export CRTOS_Verify.lib.dll_abs.
Require Import CRTOS_Verify.lib.CrtosRules.

Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.

Module DLL.

Definition dllseg {A: Type} (storeA: addr -> A -> Assertion) (x px y py: addr) (l: list (DL_Node A)): Assertion :=
  (fix dllseg x px y py l :=
     match l with
     | nil     => “ x = y /\ px = py ” && emp
     | a :: l0 => EX z: addr,
                    “ x = a.(ptr) ” &&
                    storeA x a.(data) **
                    &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px ** 
                    &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
                    dllseg z x y py l0
     end) x px y py l.
     
Definition dllseg_shift {A: Type} (storeA: addr -> A -> Assertion) (px py: addr) (l: list (DL_Node A)): Assertion :=
  (fix dllseg_shift px py l :=
     match l with
     | nil     => “ px = py ” && emp
     | a :: l0 => EX x: addr,
                    “ x = a.(ptr) ” &&
                    storeA x a.(data) **
                    &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px ** 
                    &(px # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> x **
                    dllseg_shift x py l0
     end) px py l.

Definition dllseg_shift_rev {A: Type} (storeA: addr -> A -> Assertion) (x y : addr) (l: list (DL_Node A)): Assertion :=
  (fix dllseg_shift_rev x y l :=
    match l with
    | nil     => “ x = y ” && emp
    | a :: l0 => EX z: addr,
                    “ x = a.(ptr) ” &&
                    storeA x a.(data) **
                    &(z # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> x ** 
                    &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
                    dllseg_shift_rev z y l0
    end) x y l.

Definition dll_nodes_nonzero {A: Type} (l: list (DL_Node A)): Prop :=
  Forall (fun node => node.(ptr) <> 0) l.

Definition store_dll {A: Type} (storeA: addr -> A -> Assertion) (x: addr) (l: list (DL_Node A)): Assertion :=
  EX h pt: addr,
    “ x <> 0 /\ pt <> 0 /\ h <> 0 /\ dll_nodes_nonzero l ” &&
    &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
    &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> h **
    dllseg storeA h x x pt l.

Lemma store_dll_head_prev_next_nonzero:
  forall {A: Type} (storeA: addr -> A -> Assertion) (x: addr) (l: list (DL_Node A)),
    store_dll storeA x l |--
    EX h pt: addr,
      “ pt <> 0 /\ h <> 0 ” &&
      &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
      &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> h **
      dllseg storeA h x x pt l.
Proof.
  intros A storeA x l.
  unfold store_dll.
  Intros h pt.
  Exists h pt.
  entailer!.
Qed.

Lemma store_dll_nonzero:
  forall {A: Type} (storeA: addr -> A -> Assertion) (x: addr) (l: list (DL_Node A)),
    store_dll storeA x l |--
    EX h pt: addr,
      “ x <> 0 /\ pt <> 0 /\ h <> 0 /\ dll_nodes_nonzero l ” &&
      &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
      &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> h **
      dllseg storeA h x x pt l.
Proof.
  intros A storeA x l.
  unfold store_dll.
  Intros h pt.
  Exists h pt.
  entailer!.
Qed.

Definition occupy_dll_node (x: addr): Assertion :=
  (EX __, &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> __) ** 
  (EX __, &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> __).

Theorem dllseg_concat:
  forall
    {A : Type} (storeA : addr -> A -> Assertion)
    (x px y py z pz: addr) (l1 l2: list (DL_Node A)),
  dllseg storeA x px y py l1 ** dllseg storeA y py z pz l2 |--
  dllseg storeA x px z pz (l1 ++ l2).
Proof.
  intros.
  revert x px y py z pz l2. 
  induction l1 ; intros.
  + simpl.
    entailer!.
    destruct H. subst. reflexivity.
  + simpl.
    Intros x0.
    Exists x0. entailer!.
Qed.

Theorem dllseg_split:
  forall 
    {A : Type} (storeA : addr -> A -> Assertion)
    (x px z pz: addr) (l1 l2: list (DL_Node A)),
  dllseg storeA x px z pz (l1 ++ l2) |--
  EX y py,dllseg storeA x px y py l1 ** dllseg storeA y py z pz l2.
Proof.
  intros.
  revert x px.
  induction l1 ; intros.
  + simpl.
    Exists x px.
    entailer!.
  + simpl.
    Intros z0.
    sep_apply IHl1.
    Intros y y0.
    Exists y y0 z0.
    entailer!.
Qed.

Theorem dllseg_shift_split:
  forall 
    {A : Type} (storeA : addr -> A -> Assertion)
    (px pz: addr) (l1 l2: list (DL_Node A)),
  dllseg_shift storeA px pz (l1 ++ l2) |--
  EX py ,dllseg_shift storeA px py l1 ** dllseg_shift storeA py pz l2.
Proof.
  intros.
  revert px.
  induction l1;intros.
  + simpl.
    Exists px;entailer!.
  + simpl.
    Intros x.
    sep_apply IHl1.
    Intros py.
    Exists py x.
    entailer!. 
Qed.

Theorem dllseg_shift_concat: 
forall 
    {A : Type} (storeA : addr -> A -> Assertion)
    (px py pz: addr) (l1 l2: list (DL_Node A)),
    dllseg_shift storeA px py l1 ** dllseg_shift storeA py pz l2
    |--
    dllseg_shift storeA px pz (l1 ++ l2).
Proof.
  intros.
  revert px.
  induction l1;intros.
  + simpl.
    entailer!;destruct H;subst;reflexivity.
  + simpl.
    Intros x.
    Exists x.
    sep_apply (IHl1).
    entailer!.
Qed.


Theorem dllseg_shift_rev_split:
forall 
    {A : Type} (storeA : addr -> A -> Assertion)
    (x z: addr) (l1 l2: list (DL_Node A)),
  dllseg_shift_rev storeA x z (l1 ++ l2) |--
  EX y,dllseg_shift_rev storeA x y l1 ** dllseg_shift_rev storeA y z l2.
Proof.
  intros.
  revert x.
  induction l1;intros.
  + Exists x;simpl.
    entailer!.
  + simpl.
    Intros z0.
    sep_apply (IHl1 z0).
    Intros y;Exists y z0.
    entailer!.
Qed.

Theorem dllseg_shift_rev_concat: 
forall 
    {A : Type} (storeA : addr -> A -> Assertion)
    (x y z: addr) (l1 l2: list (DL_Node A)),
    dllseg_shift_rev storeA x y l1 ** dllseg_shift_rev storeA y z l2 |--
    dllseg_shift_rev storeA x z (l1 ++ l2).
Proof.
  intros.
  revert x.
  induction l1;intros.
  + simpl.
    entailer!.
    subst;reflexivity.
  + simpl.
    Intros z0.
    Exists z0.
    entailer!.
Qed.



Lemma dllseg_to_dllseg_shift:
forall {A: Type} (storeA: addr -> A -> Assertion) (x px y py: addr) (l: list (DL_Node A)),
  dllseg storeA x px y py l **
  &(px # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> x 
  |--
  &(py # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> y **
  dllseg_shift storeA px py l.
Proof.
  intros.
  revert x px.
  induction l;intros.
  + simpl;entailer!;destruct H;subst;reflexivity.
  + simpl.
    Intros z.
    subst.
    sep_apply (IHl z a.(ptr)).
    Exists a.(ptr).
    entailer!.
Qed.

Lemma dllseg_to_dllseg_shift_rev:
forall {A: Type} (storeA: addr -> A -> Assertion) (x px y py: addr) (l: list (DL_Node A)),
  dllseg storeA x px y py l **
  &(y # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> py
  |--
  dllseg_shift_rev storeA x y l **
  &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px.
Proof.
  intros.
  revert x px.
  induction l;intros.
  + simpl.
    entailer!.
    destruct H.
    subst.
    reflexivity.
  + simpl.
    Intros z.
    subst.
    sep_apply (IHl).
    Exists z.
    entailer!.
Qed.

Lemma dllseg_shift_to_dllseg:
forall {A: Type} (storeA: addr -> A -> Assertion) (px py y: addr) (l: list (DL_Node A)),
  &(py # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> y **
  dllseg_shift storeA px py l
  |--
  EX x,
  dllseg storeA x px y py l **
  &(px # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> x 
.
Proof.
  intros.
  revert px.
  induction l;intros;simpl.
  + Exists y.
    entailer!.
    subst;reflexivity.
  + Intros x.
    sep_apply IHl.
    Intros z;Exists x z.
    entailer!.
Qed.

Lemma dllseg_shift_rev_to_dllseg:
forall {A: Type} (storeA: addr -> A -> Assertion) (x px y: addr) (l: list (DL_Node A)),
  dllseg_shift_rev storeA x y l **
  &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px
  |--
  EX py,
  dllseg storeA x px y py l **
  &(y # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> py.
Proof.
  intros.
  revert x px.
  induction l;intros;simpl.
  + Exists px.
    entailer!.
    subst;reflexivity.
  + Intros z.
    sep_apply (IHl z x).
    Intros py.
    Exists py z.
    entailer!.
Qed.

Lemma dllseg_shift_to_dllseg_shift_rev:
forall {A: Type} (storeA: addr -> A -> Assertion) (px y py: addr) (l: list (DL_Node A)),
  dllseg_shift storeA px py l **
  &(py # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> y **
  &(y # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> py 
  |--
  EX x,
  dllseg_shift_rev storeA x y l **
  &(px # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> x **
  &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px.
Proof.
  intros.
  revert px.
  induction l;intros;simpl.
  + entailer!.
    Exists y;subst;entailer!;reflexivity.
  + Intros x.
    sep_apply IHl.
    Intros x0.
    Exists x x0.
    entailer!.
Qed.

Lemma store_dll_shift_unfold: 
forall {A: Type} (storeA: addr -> A -> Assertion)(x: addr) (l: list (DL_Node A)),
  store_dll storeA x l |--
  EX px: addr,
  &(px # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> x **
  &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
  dllseg_shift storeA x px l .
Proof.
  intros.
  unfold store_dll.
  Intros h pt.
  sep_apply (dllseg_to_dllseg_shift storeA h x x pt l).
  Exists pt.
  entailer!.
Qed.

Lemma store_dll_shift_rev_unfold:
forall {A: Type} (storeA: addr -> A -> Assertion)(x: addr) (l: list (DL_Node A)),
  store_dll storeA x l |--
  EX xn: addr ,
  &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> xn **
  &(xn # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> x **
  dllseg_shift_rev storeA xn x l.
Proof.
  intros.
  unfold store_dll.
  Intros h pt.
  sep_apply (dllseg_to_dllseg_shift_rev storeA h x x pt l).
  Exists h.
  entailer!.
Qed.

Lemma dllseg_head_insert:
  forall (A: Type) (storeA: Z -> A -> Assertion) 
         (py y z x pt: Z) (a: A) (l: list (DL_Node A)),
    dllseg storeA z y x pt l **
    storeA y a **
    &(y # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> py **
    &(y # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z |--
    dllseg storeA y py x pt ((Build_DL_Node a y) :: l).
Proof.
    intros.
    simpl.
    Exists z.
    entailer!.
Qed.

Lemma dllseg_neq:
  forall {A : Type} (storeA : addr -> A -> Assertion)
  (x px y py: addr) (l: list (DL_Node A)),
  x <> y ->
  dllseg storeA x px y py l |--
  EX z a l0,
    “ l = a :: l0 ” &&
    “ x = a.(ptr) ” &&
    storeA x a.(data) **
    &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px ** 
    &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
    dllseg storeA z x y py l0.
Proof.
  intros.
  destruct l; simpl.
  + entailer!.
  + Intros z0.
    Exists z0 d l.
    entailer!.
Qed.

Lemma dllseg_head_split:
  forall (A: Type) (storeA: Z -> A -> Assertion) 
         (y py x pt: Z) (a: A) (l: list (DL_Node A)),
    dllseg storeA y py x pt ((Build_DL_Node a y) :: l) |--
    EX z,
    dllseg storeA z y x pt l **
    storeA y a **
    &(y # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> py **
    &(y # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z.
Proof.
    intros.
    simpl.
    Intros z.
    Exists z.
    entailer!.
Qed.

Theorem dllseg_shift_transfrom_a:
forall 
    {A : Type} (storeA : addr -> A -> Assertion)(z y: addr)(a: A),
    storeA y a **
    &( y # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> z ** 
    &( z # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> y |--
    dllseg_shift storeA z y ((Build_DL_Node a y) :: nil).
Proof.
    pre_process.
    intros.
    csimpl.
    simpl.
    Exists y.
    entailer!.
Qed.

Theorem dllseg_shift_contact_a:
forall 
    {A : Type} (storeA : addr -> A -> Assertion)
    (x z y: addr)(a: A)(l: list (DL_Node A)),
    dllseg_shift storeA x z l **
    storeA y a **
    &( y # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> z ** 
    &( z # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> y |--
  dllseg_shift storeA x y (l ++ ((Build_DL_Node a y) :: nil)).
Proof.
    pre_process.
    intros.
    csimpl.
    simpl.
    induction l.
    +
    csimpl.
    simpl.
    Exists y.
    entailer!.
    rewrite H.
    entailer!.
    +
    pose proof dllseg_shift_transfrom_a storeA z y a.
    revert H.
    csimpl.
    intros.
    sep_apply H.
    pose proof dllseg_shift_concat storeA x z y (a0 :: l) (Build_DL_Node a y :: nil).
    sep_apply H0.
    entailer!.
Qed.

Theorem dllseg_shift_rev_contact_a:
forall 
    {A : Type} (storeA : addr -> A -> Assertion)
    (x z y: addr)(a: A)(l: list (DL_Node A)),
    dllseg_shift_rev storeA z x l **
    storeA y a **
    &( y # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z ** 
    &( z # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> y |--
  dllseg_shift_rev storeA y x ((Build_DL_Node a y) :: l).
Proof.
    pre_process.
    intros.
    csimpl.
    simpl.
    induction l.
    +
    csimpl.
    simpl.
    Exists z.
    entailer!.
    +
    Exists z.
    entailer!.
Qed.

End DLL.
