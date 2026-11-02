Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Strings.String.
Require Import Coq.Strings.Ascii.
Require Import Coq.Lists.List.
Require Import Coq.Classes.RelationClasses.
Require Import Coq.Classes.Morphisms.
Require Import Coq.micromega.Psatz.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass. Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Import naive_C_Rules.
Local Open Scope sac.

(*----- Function increment -----*)

Definition increment_safety_wit_1 := 
forall (x_pre: Z) (PreH1 : (0 <= x_pre)) (PreH2 : (x_pre < 100)) ,
  ((( &( "x" ) )) # Int  |-> x_pre)
|--
  “ ((x_pre + 1 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (x_pre + 1 )) ”
.

Definition increment_safety_wit_2 := 
forall (x_pre: Z) (PreH1 : (0 <= x_pre)) (PreH2 : (x_pre < 100)) ,
  ((( &( "x" ) )) # Int  |-> x_pre)
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition increment_return_wit_1 := 
forall (x_pre: Z) (PreH1 : (0 <= x_pre)) (PreH2 : (x_pre < 100)) ,
  TT && emp 
|--
  “ ((x_pre + 1 ) = (x_pre + 1 )) ”
  &&  emp
.

Module Type VC_Correct.


Axiom proof_of_increment_safety_wit_1 : increment_safety_wit_1.
Axiom proof_of_increment_safety_wit_2 : increment_safety_wit_2.
Axiom proof_of_increment_return_wit_1 : increment_return_wit_1.

End VC_Correct.
