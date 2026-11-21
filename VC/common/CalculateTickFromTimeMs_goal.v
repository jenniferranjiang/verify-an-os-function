From SimpleC.Verification Require Import VCPrelude.
Require Import CRTOS_Verify.lib.common.CrtosRules.
Require Import CRTOS_Verify.lib.common.TickConversion.
Local Open Scope sac.

(*----- Function CalculateTickFromTimeMs -----*)

Definition CalculateTickFromTimeMs_safety_wit_1 :=
forall (ms_pre: Z),
  ((( &( "tmp" ) )) # UInt  |->_)
  **  ((( &( "ms" ) )) # UInt  |-> ms_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition CalculateTickFromTimeMs_safety_wit_2 :=
forall (ms_pre: Z),
  ((( &( "ticks" ) )) # UInt  |->_)
  **  ((( &( "tmp" ) )) # UInt  |-> 0)
  **  ((( &( "ms" ) )) # UInt  |-> ms_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition CalculateTickFromTimeMs_safety_wit_3 :=
forall (ms_pre: Z),
  ((( &( "ticks" ) )) # UInt  |-> 0)
  **  ((( &( "tmp" ) )) # UInt  |-> 0)
  **  ((( &( "ms" ) )) # UInt  |-> ms_pre)
|--
  “ (1000 <> 0) ”
.

Definition CalculateTickFromTimeMs_safety_wit_4 :=
forall (ms_pre: Z),
  ((( &( "ticks" ) )) # UInt  |-> 0)
  **  ((( &( "tmp" ) )) # UInt  |-> 0)
  **  ((( &( "ms" ) )) # UInt  |-> ms_pre)
|--
  “ (100 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 100) ”
.

Definition CalculateTickFromTimeMs_safety_wit_5 :=
forall (ms_pre: Z),
  ((( &( "ticks" ) )) # UInt  |-> 0)
  **  ((( &( "tmp" ) )) # UInt  |-> 0)
  **  ((( &( "ms" ) )) # UInt  |-> ms_pre)
|--
  “ (1000 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1000) ”
.

Definition CalculateTickFromTimeMs_safety_wit_6 :=
forall (ms_pre: Z) (PreH1 : (0 <= ms_pre)) (PreH2 : (ms_pre <= UINT_MAX)),
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
  **  ((( &( "ticks" ) )) # UInt  |-> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))
  **  ((( &( "tmp" ) )) # UInt  |-> 0)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition CalculateTickFromTimeMs_safety_wit_7 :=
forall (ms_pre: Z) (PreH1 : (0 = (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH2 : (0 <= ms_pre)) (PreH3 : (ms_pre <= UINT_MAX)),
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
  **  ((( &( "ticks" ) )) # UInt  |-> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))
  **  ((( &( "tmp" ) )) # UInt  |-> 0)
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition CalculateTickFromTimeMs_safety_wit_8 :=
forall (ms_pre: Z) (PreH1 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH2 : (0 <= ms_pre)) (PreH3 : (ms_pre <= UINT_MAX)),
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
  **  ((( &( "ticks" ) )) # UInt  |-> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))
  **  ((( &( "tmp" ) )) # UInt  |-> 0)
|--
  “ (1000 <> 0) ”
.

Definition CalculateTickFromTimeMs_safety_wit_9 :=
forall (ms_pre: Z) (PreH1 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH2 : (0 <= ms_pre)) (PreH3 : (ms_pre <= UINT_MAX)),
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
  **  ((( &( "ticks" ) )) # UInt  |-> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))
  **  ((( &( "tmp" ) )) # UInt  |-> 0)
|--
  “ (100 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 100) ”
.

Definition CalculateTickFromTimeMs_safety_wit_10 :=
forall (ms_pre: Z) (PreH1 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH2 : (0 <= ms_pre)) (PreH3 : (ms_pre <= UINT_MAX)),
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
  **  ((( &( "ticks" ) )) # UInt  |-> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))
  **  ((( &( "tmp" ) )) # UInt  |-> 0)
|--
  “ (1000 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1000) ”
.

Definition CalculateTickFromTimeMs_safety_wit_11 :=
forall (ms_pre: Z) (PreH1 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH2 : (0 <= ms_pre)) (PreH3 : (ms_pre <= UINT_MAX)),
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
  **  ((( &( "ticks" ) )) # UInt  |-> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))
  **  ((( &( "tmp" ) )) # UInt  |-> (unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)))
|--
  “ (5 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 5) ”
.

Definition CalculateTickFromTimeMs_safety_wit_12 :=
forall (ms_pre: Z) (PreH1 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) >= 5)) (PreH2 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH3 : (0 <= ms_pre)) (PreH4 : (ms_pre <= UINT_MAX)),
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
  **  ((( &( "ticks" ) )) # UInt  |-> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))
  **  ((( &( "tmp" ) )) # UInt  |-> (unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)))
|--
  “ (9 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 9) ”
.

Definition CalculateTickFromTimeMs_safety_wit_13 :=
forall (ms_pre: Z) (PreH1 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) <= 9)) (PreH2 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) >= 5)) (PreH3 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH4 : (0 <= ms_pre)) (PreH5 : (ms_pre <= UINT_MAX)),
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
  **  ((( &( "ticks" ) )) # UInt  |-> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))
  **  ((( &( "tmp" ) )) # UInt  |-> (unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)))
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition CalculateTickFromTimeMs_return_wit_1 :=
(
forall (ms_pre: Z) (PreH1 : (0 = (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH2 : (0 <= ms_pre)) (PreH3 : (ms_pre <= UINT_MAX)),
  TT && emp 
|--
  “ (1 = (tick_from_time_ms (ms_pre))) ”
  &&  emp
) \/
(
forall (ms_pre: Z) (PreH1 : (0 = (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH2 : (0 <= ms_pre)) (PreH3 : (ms_pre <= UINT_MAX)),
  TT && emp 
|--
  “ (1 = (tick_from_time_ms (ms_pre))) ”
  &&  emp
).

Definition CalculateTickFromTimeMs_return_wit_1_split_goal_1 :=
forall (ms_pre: Z) (PreH1 : (0 = (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH2 : (0 <= ms_pre)) (PreH3 : (ms_pre <= UINT_MAX)),
  (1 = (tick_from_time_ms (ms_pre)))
.

Definition CalculateTickFromTimeMs_return_wit_2 :=
(
forall (ms_pre: Z) (PreH1 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) <= 9)) (PreH2 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) >= 5)) (PreH3 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH4 : (0 <= ms_pre)) (PreH5 : (ms_pre <= UINT_MAX)),
  TT && emp 
|--
  “ ((unsigned_last_nbits (((unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)) + 1 )) (32)) = (tick_from_time_ms (ms_pre))) ”
  &&  emp
) \/
(
forall (ms_pre: Z) (PreH1 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) <= 9)) (PreH2 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) >= 5)) (PreH3 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH4 : (0 <= ms_pre)) (PreH5 : (ms_pre <= UINT_MAX)),
  TT && emp 
|--
  “ ((unsigned_last_nbits (((unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)) + 1 )) (32)) = (tick_from_time_ms (ms_pre))) ”
  &&  emp
).

Definition CalculateTickFromTimeMs_return_wit_2_split_goal_1 :=
forall (ms_pre: Z) (PreH1 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) <= 9)) (PreH2 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) >= 5)) (PreH3 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH4 : (0 <= ms_pre)) (PreH5 : (ms_pre <= UINT_MAX)),
  ((unsigned_last_nbits (((unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)) + 1 )) (32)) = (tick_from_time_ms (ms_pre)))
.

Definition CalculateTickFromTimeMs_return_wit_3 :=
(
forall (ms_pre: Z) (PreH1 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) < 5)) (PreH2 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH3 : (0 <= ms_pre)) (PreH4 : (ms_pre <= UINT_MAX)),
  TT && emp 
|--
  “ ((unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)) = (tick_from_time_ms (ms_pre))) ”
  &&  emp
) \/
(
forall (ms_pre: Z) (PreH1 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) < 5)) (PreH2 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH3 : (0 <= ms_pre)) (PreH4 : (ms_pre <= UINT_MAX)),
  TT && emp 
|--
  “ ((unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)) = (tick_from_time_ms (ms_pre))) ”
  &&  emp
).

Definition CalculateTickFromTimeMs_return_wit_3_split_goal_1 :=
forall (ms_pre: Z) (PreH1 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) < 5)) (PreH2 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH3 : (0 <= ms_pre)) (PreH4 : (ms_pre <= UINT_MAX)),
  ((unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)) = (tick_from_time_ms (ms_pre)))
.

Definition CalculateTickFromTimeMs_return_wit_4 :=
(
forall (ms_pre: Z) (PreH1 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) > 9)) (PreH2 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) >= 5)) (PreH3 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH4 : (0 <= ms_pre)) (PreH5 : (ms_pre <= UINT_MAX)),
  TT && emp 
|--
  “ ((unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)) = (tick_from_time_ms (ms_pre))) ”
  &&  emp
) \/
(
forall (ms_pre: Z) (PreH1 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) > 9)) (PreH2 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) >= 5)) (PreH3 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH4 : (0 <= ms_pre)) (PreH5 : (ms_pre <= UINT_MAX)),
  TT && emp 
|--
  “ ((unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)) = (tick_from_time_ms (ms_pre))) ”
  &&  emp
).

Definition CalculateTickFromTimeMs_return_wit_4_split_goal_1 :=
forall (ms_pre: Z) (PreH1 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) > 9)) (PreH2 : ((unsigned_last_nbits (((ms_pre * 100 ) % ( 1000 ) )) (32)) >= 5)) (PreH3 : (0 <> (unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)))) (PreH4 : (0 <= ms_pre)) (PreH5 : (ms_pre <= UINT_MAX)),
  ((unsigned_last_nbits (((ms_pre * 100 ) ÷ 1000 )) (32)) = (tick_from_time_ms (ms_pre)))
.

Definition CalculateTickFromTimeMs_partial_solve_wit_1 :=
  TT && emp 
|--
  TT && emp 
.

Definition CalculateTickFromTimeMs_partial_solve_wit_2 :=
forall (ms_pre: Z) (PreH1 : (0 <= ms_pre)) (PreH2 : (ms_pre <= UINT_MAX)),
  (store_uinteger (Z.to_nat (4)) 4 ( &( "ms" ) ) ms_pre )
|--
  “ (0 <= ms_pre) ”
  &&  “ (ms_pre <= UINT_MAX) ”
  &&  (store_uinteger (Z.to_nat (4)) 4 ( &( "ms" ) ) ms_pre )
.

Definition CalculateTickFromTimeMs_which_implies_wit_1 :=
(
forall (ms_pre: Z),
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
|--
  “ (0 <= ms_pre) ”
  &&  “ (ms_pre <= UINT_MAX) ”
  &&  (store_uinteger (Z.to_nat (4)) 4 ( &( "ms" ) ) ms_pre )
) \/
(
forall (ms_pre: Z) (PreH1 : (ms_pre <= UINT_MAX)) (PreH2 : (ms_pre >= 0)),
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
|--
  (store_uinteger (Z.to_nat (4)) 4 ( &( "ms" ) ) ms_pre )
).

Definition CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial :=
forall (ms_pre: Z) (PreH1 : (ms_pre <= UINT_MAX)) (PreH2 : (ms_pre >= 0)),
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
|--
  (store_uinteger (Z.to_nat (4)) 4 ( &( "ms" ) ) ms_pre )
.

Definition CalculateTickFromTimeMs_which_implies_wit_2 :=
(
forall (ms_pre: Z),
  (store_uinteger (Z.to_nat (4)) 4 ( &( "ms" ) ) ms_pre )
|--
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
) \/
(
forall (ms_pre: Z),
  (store_uinteger (Z.to_nat (4)) 4 ( &( "ms" ) ) ms_pre )
|--
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
).

Definition CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial :=
forall (ms_pre: Z),
  (store_uinteger (Z.to_nat (4)) 4 ( &( "ms" ) ) ms_pre )
|--
  ((( &( "ms" ) )) # UInt  |-> ms_pre)
.

Module Type VC_Correct.


Axiom proof_of_CalculateTickFromTimeMs_safety_wit_1 : CalculateTickFromTimeMs_safety_wit_1.
Axiom proof_of_CalculateTickFromTimeMs_safety_wit_2 : CalculateTickFromTimeMs_safety_wit_2.
Axiom proof_of_CalculateTickFromTimeMs_safety_wit_3 : CalculateTickFromTimeMs_safety_wit_3.
Axiom proof_of_CalculateTickFromTimeMs_safety_wit_4 : CalculateTickFromTimeMs_safety_wit_4.
Axiom proof_of_CalculateTickFromTimeMs_safety_wit_5 : CalculateTickFromTimeMs_safety_wit_5.
Axiom proof_of_CalculateTickFromTimeMs_safety_wit_6 : CalculateTickFromTimeMs_safety_wit_6.
Axiom proof_of_CalculateTickFromTimeMs_safety_wit_7 : CalculateTickFromTimeMs_safety_wit_7.
Axiom proof_of_CalculateTickFromTimeMs_safety_wit_8 : CalculateTickFromTimeMs_safety_wit_8.
Axiom proof_of_CalculateTickFromTimeMs_safety_wit_9 : CalculateTickFromTimeMs_safety_wit_9.
Axiom proof_of_CalculateTickFromTimeMs_safety_wit_10 : CalculateTickFromTimeMs_safety_wit_10.
Axiom proof_of_CalculateTickFromTimeMs_safety_wit_11 : CalculateTickFromTimeMs_safety_wit_11.
Axiom proof_of_CalculateTickFromTimeMs_safety_wit_12 : CalculateTickFromTimeMs_safety_wit_12.
Axiom proof_of_CalculateTickFromTimeMs_safety_wit_13 : CalculateTickFromTimeMs_safety_wit_13.
Axiom proof_of_CalculateTickFromTimeMs_return_wit_1 : CalculateTickFromTimeMs_return_wit_1.
Axiom proof_of_CalculateTickFromTimeMs_return_wit_2 : CalculateTickFromTimeMs_return_wit_2.
Axiom proof_of_CalculateTickFromTimeMs_return_wit_3 : CalculateTickFromTimeMs_return_wit_3.
Axiom proof_of_CalculateTickFromTimeMs_return_wit_4 : CalculateTickFromTimeMs_return_wit_4.
Axiom proof_of_CalculateTickFromTimeMs_partial_solve_wit_1 : CalculateTickFromTimeMs_partial_solve_wit_1.
Axiom proof_of_CalculateTickFromTimeMs_partial_solve_wit_2 : CalculateTickFromTimeMs_partial_solve_wit_2.
Axiom proof_of_CalculateTickFromTimeMs_which_implies_wit_1 : CalculateTickFromTimeMs_which_implies_wit_1.
Axiom proof_of_CalculateTickFromTimeMs_which_implies_wit_2 : CalculateTickFromTimeMs_which_implies_wit_2.

End VC_Correct.
