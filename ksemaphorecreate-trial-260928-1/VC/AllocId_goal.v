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
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Import CrtosOS_C_Rules.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Local Open Scope sac.

(*----- Function AllocId -----*)

Definition AllocId_safety_wit_1 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((( &( "index" ) )) # Int  |->_)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (store_semaphore_id_manager stable before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_2 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((( &( "scan_end" ) )) # Int  |->_)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (store_semaphore_id_manager stable before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_3 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((( &( "id" ) )) # Int  |->_)
  **  ((( &( "scan_end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (store_semaphore_id_manager stable before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_4 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((( &( "entry" ) )) # UChar  |->_)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "scan_end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (store_semaphore_id_manager stable before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_5 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "scan_end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (store_semaphore_id_manager stable before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_6 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre = 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "scan_end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (store_semaphore_id_manager stable before )
|--
  “ False ”
.

Definition AllocId_safety_wit_7 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (PreH1 : (semaphore_bitmap_ok stable before bytes )) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "scan_end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
|--
  “ ((((semaphore_id_limit (stable)) + 7 ) <> (INT_MIN)) \/ (8 <> (-1))) ” 
  &&  “ (8 <> 0) ”
.

Definition AllocId_safety_wit_8 := 
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (PreH1 : (semaphore_bitmap_ok stable before bytes )) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "scan_end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
|--
  “ (((semaphore_id_limit (stable)) + 7 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= ((semaphore_id_limit (stable)) + 7 )) ”
) \/
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (PreH1 : (semaphore_bitmap_ok stable before bytes )) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "scan_end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
|--
  “ (((semaphore_id_limit (stable)) + 7 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= ((semaphore_id_limit (stable)) + 7 )) ”
).

Definition AllocId_safety_wit_8_split_goal_1 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (PreH1 : (semaphore_bitmap_ok stable before bytes )) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "scan_end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
|--
  “ (((semaphore_id_limit (stable)) + 7 ) <= INT_MAX) ”
.

Definition AllocId_safety_wit_8_split_goal_2 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (PreH1 : (semaphore_bitmap_ok stable before bytes )) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "scan_end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
|--
  “ ((INT_MIN) <= ((semaphore_id_limit (stable)) + 7 )) ”
.

Definition AllocId_safety_wit_9 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (PreH1 : (semaphore_bitmap_ok stable before bytes )) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "scan_end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
|--
  “ (7 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 7) ”
.

Definition AllocId_safety_wit_10 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (PreH1 : (semaphore_bitmap_ok stable before bytes )) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "scan_end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
|--
  “ (8 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 8) ”
.

Definition AllocId_safety_wit_11 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (PreH1 : (semaphore_bitmap_ok stable before bytes )) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "scan_end" ) )) # Int  |-> (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_12 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index < scan_end)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index)) (PreH6 : (index <= scan_end)) (PreH7 : (semaphore_alloc_index_inv stable before index )) (PreH8 : (semaphore_bitmap_ok stable before bytes )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (manager_pre <> 0)) (PreH11 : (manager_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
|--
  “ (255 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 255) ”
.

Definition AllocId_safety_wit_13 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : ((Znth index bytes 0) = 255)) (PreH2 : (index < scan_end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= scan_end)) (PreH8 : (semaphore_alloc_index_inv stable before index )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (manager_pre <> 0)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
|--
  “ ((index + 1 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (index + 1 )) ”
.

Definition AllocId_safety_wit_14 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index <> scan_end)) (PreH2 : (index >= scan_end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= scan_end)) (PreH8 : (semaphore_alloc_index_inv stable before index )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (manager_pre <> 0)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
|--
  “ False ”
.

Definition AllocId_safety_wit_15 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index = scan_end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < scan_end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH7 : (0 <= index)) (PreH8 : (index <= scan_end)) (PreH9 : (semaphore_alloc_index_inv stable before index )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (semaphore_bitmap_ok stable before bytes )) (PreH12 : (manager_pre <> 0)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
|--
  “ False ”
.

Definition AllocId_safety_wit_16 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index = scan_end)) (PreH2 : (index >= scan_end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= scan_end)) (PreH8 : (semaphore_alloc_index_inv stable before index )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (manager_pre <> 0)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
|--
  “ (1 <> (INT_MIN)) ”
.

Definition AllocId_safety_wit_17 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index = scan_end)) (PreH2 : (index >= scan_end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= scan_end)) (PreH8 : (semaphore_alloc_index_inv stable before index )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (manager_pre <> 0)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition AllocId_safety_wit_18 := 
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index <> scan_end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < scan_end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH7 : (0 <= index)) (PreH8 : (index <= scan_end)) (PreH9 : (semaphore_alloc_index_inv stable before index )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (semaphore_bitmap_ok stable before bytes )) (PreH12 : (manager_pre <> 0)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
|--
  “ ((index * 8 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (index * 8 )) ”
) \/
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index <> scan_end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < scan_end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH7 : (0 <= index)) (PreH8 : (index <= scan_end)) (PreH9 : (semaphore_alloc_index_inv stable before index )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (semaphore_bitmap_ok stable before bytes )) (PreH12 : (manager_pre <> 0)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
|--
  “ ((index * 8 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (index * 8 )) ”
).

Definition AllocId_safety_wit_18_split_goal_1 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index <> scan_end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < scan_end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH7 : (0 <= index)) (PreH8 : (index <= scan_end)) (PreH9 : (semaphore_alloc_index_inv stable before index )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (semaphore_bitmap_ok stable before bytes )) (PreH12 : (manager_pre <> 0)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
|--
  “ ((index * 8 ) <= INT_MAX) ”
.

Definition AllocId_safety_wit_18_split_goal_2 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index <> scan_end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < scan_end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH7 : (0 <= index)) (PreH8 : (index <= scan_end)) (PreH9 : (semaphore_alloc_index_inv stable before index )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (semaphore_bitmap_ok stable before bytes )) (PreH12 : (manager_pre <> 0)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
|--
  “ ((INT_MIN) <= (index * 8 )) ”
.

Definition AllocId_safety_wit_19 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index <> scan_end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < scan_end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH7 : (0 <= index)) (PreH8 : (index <= scan_end)) (PreH9 : (semaphore_alloc_index_inv stable before index )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (semaphore_bitmap_ok stable before bytes )) (PreH12 : (manager_pre <> 0)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
  **  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
|--
  “ (8 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 8) ”
.

Definition AllocId_safety_wit_20 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index_2)) (PreH5 : (index_2 < scan_end_2)) (PreH6 : (semaphore_alloc_index_inv stable before index_2 )) (PreH7 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH8 : (semaphore_bitmap_ok stable before bytes )) (PreH9 : (index <> scan_end)) (PreH10 : ((Znth index bytes 0) <> 255)) (PreH11 : (index < scan_end)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH15 : (0 <= index)) (PreH16 : (index <= scan_end)) (PreH17 : (semaphore_alloc_index_inv stable before index )) (PreH18 : (semaphore_bitmap_ok stable before bytes )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (manager_pre <> 0)) (PreH21 : (manager_pre <> 0)) (PreH22 : (SemaphoreStableContext stable )) (PreH23 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition AllocId_safety_wit_21 := 
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index_2)) (PreH5 : (index_2 < scan_end_2)) (PreH6 : (semaphore_alloc_index_inv stable before index_2 )) (PreH7 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH8 : (semaphore_bitmap_ok stable before bytes )) (PreH9 : (index <> scan_end)) (PreH10 : ((Znth index bytes 0) <> 255)) (PreH11 : (index < scan_end)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH15 : (0 <= index)) (PreH16 : (index <= scan_end)) (PreH17 : (semaphore_alloc_index_inv stable before index )) (PreH18 : (semaphore_bitmap_ok stable before bytes )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (manager_pre <> 0)) (PreH21 : (manager_pre <> 0)) (PreH22 : (SemaphoreStableContext stable )) (PreH23 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH24 : ((Z.land entry 1) <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ ((id + 1 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (id + 1 )) ”
) \/
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index_2)) (PreH5 : (index_2 < scan_end_2)) (PreH6 : (semaphore_alloc_index_inv stable before index_2 )) (PreH7 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH8 : (semaphore_bitmap_ok stable before bytes )) (PreH9 : (index <> scan_end)) (PreH10 : ((Znth index bytes 0) <> 255)) (PreH11 : (index < scan_end)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH15 : (0 <= index)) (PreH16 : (index <= scan_end)) (PreH17 : (semaphore_alloc_index_inv stable before index )) (PreH18 : (semaphore_bitmap_ok stable before bytes )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (manager_pre <> 0)) (PreH21 : (manager_pre <> 0)) (PreH22 : (SemaphoreStableContext stable )) (PreH23 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH24 : ((Z.land entry 1) <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ ((id + 1 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (id + 1 )) ”
).

Definition AllocId_safety_wit_21_split_goal_1 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index_2)) (PreH5 : (index_2 < scan_end_2)) (PreH6 : (semaphore_alloc_index_inv stable before index_2 )) (PreH7 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH8 : (semaphore_bitmap_ok stable before bytes )) (PreH9 : (index <> scan_end)) (PreH10 : ((Znth index bytes 0) <> 255)) (PreH11 : (index < scan_end)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH15 : (0 <= index)) (PreH16 : (index <= scan_end)) (PreH17 : (semaphore_alloc_index_inv stable before index )) (PreH18 : (semaphore_bitmap_ok stable before bytes )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (manager_pre <> 0)) (PreH21 : (manager_pre <> 0)) (PreH22 : (SemaphoreStableContext stable )) (PreH23 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH24 : ((Z.land entry 1) <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ ((id + 1 ) <= INT_MAX) ”
.

Definition AllocId_safety_wit_21_split_goal_2 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index_2)) (PreH5 : (index_2 < scan_end_2)) (PreH6 : (semaphore_alloc_index_inv stable before index_2 )) (PreH7 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH8 : (semaphore_bitmap_ok stable before bytes )) (PreH9 : (index <> scan_end)) (PreH10 : ((Znth index bytes 0) <> 255)) (PreH11 : (index < scan_end)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH15 : (0 <= index)) (PreH16 : (index <= scan_end)) (PreH17 : (semaphore_alloc_index_inv stable before index )) (PreH18 : (semaphore_bitmap_ok stable before bytes )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (manager_pre <> 0)) (PreH21 : (manager_pre <> 0)) (PreH22 : (SemaphoreStableContext stable )) (PreH23 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH24 : ((Z.land entry 1) <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ ((INT_MIN) <= (id + 1 )) ”
.

Definition AllocId_safety_wit_22 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index_2)) (PreH5 : (index_2 < scan_end_2)) (PreH6 : (semaphore_alloc_index_inv stable before index_2 )) (PreH7 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH8 : (semaphore_bitmap_ok stable before bytes )) (PreH9 : (index <> scan_end)) (PreH10 : ((Znth index bytes 0) <> 255)) (PreH11 : (index < scan_end)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH15 : (0 <= index)) (PreH16 : (index <= scan_end)) (PreH17 : (semaphore_alloc_index_inv stable before index )) (PreH18 : (semaphore_bitmap_ok stable before bytes )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (manager_pre <> 0)) (PreH21 : (manager_pre <> 0)) (PreH22 : (SemaphoreStableContext stable )) (PreH23 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH24 : ((Z.land entry 1) <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> (id + 1 ))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ (1 <= 7) ” 
  &&  “ (0 <= 1) ”
.

Definition AllocId_safety_wit_23 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index_2)) (PreH5 : (index_2 < scan_end_2)) (PreH6 : (semaphore_alloc_index_inv stable before index_2 )) (PreH7 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH8 : (semaphore_bitmap_ok stable before bytes )) (PreH9 : (index <> scan_end)) (PreH10 : ((Znth index bytes 0) <> 255)) (PreH11 : (index < scan_end)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH15 : (0 <= index)) (PreH16 : (index <= scan_end)) (PreH17 : (semaphore_alloc_index_inv stable before index )) (PreH18 : (semaphore_bitmap_ok stable before bytes )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (manager_pre <> 0)) (PreH21 : (manager_pre <> 0)) (PreH22 : (SemaphoreStableContext stable )) (PreH23 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH24 : ((Z.land entry 1) <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> (id + 1 ))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition AllocId_safety_wit_24 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id >= (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition AllocId_safety_wit_25 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id >= (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition AllocId_safety_wit_26 := 
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id < (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ ((signed_last_nbits ((1 * (2^(id % ( 8 ) )) )) (32)) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (signed_last_nbits ((1 * (2^(id % ( 8 ) )) )) (32))) ” 
  &&  “ ((id % ( 8 ) ) <= 31) ” 
  &&  “ (0 <= (id % ( 8 ) )) ”
) \/
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id < (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ ((signed_last_nbits ((1 * (2^(id % ( 8 ) )) )) (32)) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (signed_last_nbits ((1 * (2^(id % ( 8 ) )) )) (32))) ” 
  &&  “ ((id % ( 8 ) ) <= 31) ” 
  &&  “ (0 <= (id % ( 8 ) )) ”
).

Definition AllocId_safety_wit_26_split_goal_1 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id < (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ ((signed_last_nbits ((1 * (2^(id % ( 8 ) )) )) (32)) <= INT_MAX) ”
.

Definition AllocId_safety_wit_26_split_goal_2 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id < (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ ((INT_MIN) <= (signed_last_nbits ((1 * (2^(id % ( 8 ) )) )) (32))) ”
.

Definition AllocId_safety_wit_26_split_goal_3 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id < (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ ((id % ( 8 ) ) <= 31) ”
.

Definition AllocId_safety_wit_26_split_goal_4 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id < (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ (0 <= (id % ( 8 ) )) ”
.

Definition AllocId_safety_wit_27 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id < (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ ((id <> (INT_MIN)) \/ (8 <> (-1))) ” 
  &&  “ (8 <> 0) ”
.

Definition AllocId_safety_wit_28 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id < (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition AllocId_safety_wit_29 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id < (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "scan_end" ) )) # Int  |-> scan_end_2)
  **  ((( &( "index" ) )) # Int  |-> index_2)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ (8 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 8) ”
.

Definition AllocId_entail_wit_1 := 
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (PreH1 : (semaphore_bitmap_ok stable before bytes )) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ ((((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= 0) ” 
  &&  “ (0 <= (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (semaphore_alloc_index_inv stable before 0 ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
) \/
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (PreH1 : (semaphore_bitmap_ok stable before bytes )) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  TT && emp 
|--
  “ (semaphore_alloc_index_inv stable before 0 ) ” 
  &&  “ (0 <= (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ”
  &&  emp
).

Definition AllocId_entail_wit_1_split_goal_1 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (PreH1 : (semaphore_bitmap_ok stable before bytes )) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (semaphore_alloc_index_inv stable before 0 )
.

Definition AllocId_entail_wit_1_split_goal_2 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (PreH1 : (semaphore_bitmap_ok stable before bytes )) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (0 <= (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))
.

Definition AllocId_entail_wit_2 := 
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : ((Znth index bytes 0) = 255)) (PreH2 : (index < scan_end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= scan_end)) (PreH8 : (semaphore_alloc_index_inv stable before index )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (manager_pre <> 0)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= (index + 1 )) ” 
  &&  “ ((index + 1 ) <= scan_end) ” 
  &&  “ (semaphore_alloc_index_inv stable before (index + 1 ) ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
) \/
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : ((Znth index bytes 0) = 255)) (PreH2 : (index < scan_end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= scan_end)) (PreH8 : (semaphore_alloc_index_inv stable before index )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (manager_pre <> 0)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  TT && emp 
|--
  “ (semaphore_alloc_index_inv stable before (index + 1 ) ) ”
  &&  emp
).

Definition AllocId_entail_wit_2_split_goal_1 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : ((Znth index bytes 0) = 255)) (PreH2 : (index < scan_end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= scan_end)) (PreH8 : (semaphore_alloc_index_inv stable before index )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (manager_pre <> 0)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (semaphore_alloc_index_inv stable before (index + 1 ) )
.

Definition AllocId_entail_wit_3 := 
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index <> scan_end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < scan_end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH7 : (0 <= index)) (PreH8 : (index <= scan_end)) (PreH9 : (semaphore_alloc_index_inv stable before index )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (semaphore_bitmap_ok stable before bytes )) (PreH12 : (manager_pre <> 0)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index < scan_end) ” 
  &&  “ (semaphore_alloc_index_inv stable before index ) ” 
  &&  “ (semaphore_alloc_entry_inv stable before index (index * 8 ) (Znth index bytes 0) ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (index <> scan_end) ” 
  &&  “ ((Znth index bytes 0) <> 255) ” 
  &&  “ (index < scan_end) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index <= scan_end) ” 
  &&  “ (semaphore_alloc_index_inv stable before index ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
) \/
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index <> scan_end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < scan_end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH7 : (0 <= index)) (PreH8 : (index <= scan_end)) (PreH9 : (semaphore_alloc_index_inv stable before index )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (semaphore_bitmap_ok stable before bytes )) (PreH12 : (manager_pre <> 0)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  TT && emp 
|--
  “ (semaphore_alloc_entry_inv stable before index (index * 8 ) (Znth index bytes 0) ) ”
  &&  emp
).

Definition AllocId_entail_wit_3_split_goal_1 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index <> scan_end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < scan_end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH7 : (0 <= index)) (PreH8 : (index <= scan_end)) (PreH9 : (semaphore_alloc_index_inv stable before index )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (semaphore_bitmap_ok stable before bytes )) (PreH12 : (manager_pre <> 0)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (semaphore_alloc_entry_inv stable before index (index * 8 ) (Znth index bytes 0) )
.

Definition AllocId_entail_wit_4 := 
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index_2)) (PreH5 : (index_2 < scan_end_2)) (PreH6 : (semaphore_alloc_index_inv stable before index_2 )) (PreH7 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH8 : (semaphore_bitmap_ok stable before bytes )) (PreH9 : (index <> scan_end)) (PreH10 : ((Znth index bytes 0) <> 255)) (PreH11 : (index < scan_end)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH15 : (0 <= index)) (PreH16 : (index <= scan_end)) (PreH17 : (semaphore_alloc_index_inv stable before index )) (PreH18 : (semaphore_bitmap_ok stable before bytes )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (manager_pre <> 0)) (PreH21 : (manager_pre <> 0)) (PreH22 : (SemaphoreStableContext stable )) (PreH23 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH24 : ((Z.land entry 1) <> 0)) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index_2) ” 
  &&  “ (index_2 < scan_end_2) ” 
  &&  “ (semaphore_alloc_index_inv stable before index_2 ) ” 
  &&  “ (semaphore_alloc_entry_inv stable before index_2 (id + 1 ) (unsigned_last_nbits ((Z.shiftr entry 1)) (8)) ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (index <> scan_end) ” 
  &&  “ ((Znth index bytes 0) <> 255) ” 
  &&  “ (index < scan_end) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index <= scan_end) ” 
  &&  “ (semaphore_alloc_index_inv stable before index ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
) \/
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index_2)) (PreH5 : (index_2 < scan_end_2)) (PreH6 : (semaphore_alloc_index_inv stable before index_2 )) (PreH7 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH8 : (semaphore_bitmap_ok stable before bytes )) (PreH9 : (index <> scan_end)) (PreH10 : ((Znth index bytes 0) <> 255)) (PreH11 : (index < scan_end)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH15 : (0 <= index)) (PreH16 : (index <= scan_end)) (PreH17 : (semaphore_alloc_index_inv stable before index )) (PreH18 : (semaphore_bitmap_ok stable before bytes )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (manager_pre <> 0)) (PreH21 : (manager_pre <> 0)) (PreH22 : (SemaphoreStableContext stable )) (PreH23 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH24 : ((Z.land entry 1) <> 0)) ,
  TT && emp 
|--
  “ (semaphore_alloc_entry_inv stable before index_2 (id + 1 ) (unsigned_last_nbits ((Z.shiftr entry 1)) (8)) ) ”
  &&  emp
).

Definition AllocId_entail_wit_4_split_goal_1 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index_2)) (PreH5 : (index_2 < scan_end_2)) (PreH6 : (semaphore_alloc_index_inv stable before index_2 )) (PreH7 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH8 : (semaphore_bitmap_ok stable before bytes )) (PreH9 : (index <> scan_end)) (PreH10 : ((Znth index bytes 0) <> 255)) (PreH11 : (index < scan_end)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH15 : (0 <= index)) (PreH16 : (index <= scan_end)) (PreH17 : (semaphore_alloc_index_inv stable before index )) (PreH18 : (semaphore_bitmap_ok stable before bytes )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (manager_pre <> 0)) (PreH21 : (manager_pre <> 0)) (PreH22 : (SemaphoreStableContext stable )) (PreH23 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH24 : ((Z.land entry 1) <> 0)) ,
  (semaphore_alloc_entry_inv stable before index_2 (id + 1 ) (unsigned_last_nbits ((Z.shiftr entry 1)) (8)) )
.

Definition AllocId_return_wit_1 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id < (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) (replace_Znth (index_2) ((Z.lor (unsigned_last_nbits ((Znth index_2 bytes 0)) (8)) (unsigned_last_nbits ((Z.shiftl 1 (id % ( 8 ) ))) (8)))) (bytes)) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  (“ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (0 <= id) ” 
  &&  “ ((semaphore_first_free (stable) (before)) = (Some (id))) ”
  &&  (store_sem_manager_id_allocated stable before id ))
  ||
  (“ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (id = (-1)) ” 
  &&  “ ((semaphore_first_free (stable) (before)) = None) ”
  &&  (store_semaphore_id_manager stable before ))
.

Definition AllocId_return_wit_2 := 
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id >= (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ ((-1) = (-1)) ” 
  &&  “ ((semaphore_first_free (stable) (before)) = None) ”
  &&  (store_semaphore_id_manager stable before )
) \/
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id >= (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ ((semaphore_first_free (stable) (before)) = None) ”
  &&  (store_semaphore_id_manager stable before )
).

Definition AllocId_return_wit_2_split_goal_1 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id >= (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ ((semaphore_first_free (stable) (before)) = None) ”
.

Definition AllocId_return_wit_2_split_goal_spatial := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id >= (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  (store_semaphore_id_manager stable before )
.

Definition AllocId_return_wit_3 := 
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index = scan_end)) (PreH2 : (index >= scan_end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= scan_end)) (PreH8 : (semaphore_alloc_index_inv stable before index )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (manager_pre <> 0)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ ((-1) = (-1)) ” 
  &&  “ ((semaphore_first_free (stable) (before)) = None) ”
  &&  (store_semaphore_id_manager stable before )
) \/
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index = scan_end)) (PreH2 : (index >= scan_end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= scan_end)) (PreH8 : (semaphore_alloc_index_inv stable before index )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (manager_pre <> 0)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ ((semaphore_first_free (stable) (before)) = None) ”
  &&  (store_semaphore_id_manager stable before )
).

Definition AllocId_return_wit_3_split_goal_1 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index = scan_end)) (PreH2 : (index >= scan_end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= scan_end)) (PreH8 : (semaphore_alloc_index_inv stable before index )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (manager_pre <> 0)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ ((semaphore_first_free (stable) (before)) = None) ”
.

Definition AllocId_return_wit_3_split_goal_spatial := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index = scan_end)) (PreH2 : (index >= scan_end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= scan_end)) (PreH8 : (semaphore_alloc_index_inv stable before index )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (manager_pre <> 0)) (PreH12 : (manager_pre <> 0)) (PreH13 : (SemaphoreStableContext stable )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  (store_semaphore_id_manager stable before )
.

Definition AllocId_partial_solve_wit_1_pure := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "scan_end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (store_semaphore_id_manager stable before )
|--
  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (SemaphoreStableContext stable ) ”
.

Definition AllocId_partial_solve_wit_1_aux := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (store_semaphore_id_manager stable before )
|--
  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ”
  &&  (store_semaphore_id_manager stable before )
.

Definition AllocId_partial_solve_wit_1 := AllocId_partial_solve_wit_1_pure -> AllocId_partial_solve_wit_1_aux.

Definition AllocId_partial_solve_wit_2 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index < scan_end)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index)) (PreH6 : (index <= scan_end)) (PreH7 : (semaphore_alloc_index_inv stable before index )) (PreH8 : (semaphore_bitmap_ok stable before bytes )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (manager_pre <> 0)) (PreH11 : (manager_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ (index < scan_end) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index <= scan_end) ” 
  &&  “ (semaphore_alloc_index_inv stable before index ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ”
  &&  ((((semaphore_bitmap_addr (stable)) + (index * sizeof(UCHAR)))) # UChar  |-> (Znth index bytes 0))
  **  (UCharArray.missing_i (semaphore_bitmap_addr (stable)) index 0 (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
.

Definition AllocId_partial_solve_wit_3 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (PreH1 : (index <> scan_end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < scan_end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH7 : (0 <= index)) (PreH8 : (index <= scan_end)) (PreH9 : (semaphore_alloc_index_inv stable before index )) (PreH10 : (semaphore_bitmap_ok stable before bytes )) (PreH11 : (semaphore_bitmap_ok stable before bytes )) (PreH12 : (manager_pre <> 0)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ (index <> scan_end) ” 
  &&  “ ((Znth index bytes 0) <> 255) ” 
  &&  “ (index < scan_end) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index <= scan_end) ” 
  &&  “ (semaphore_alloc_index_inv stable before index ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ”
  &&  ((((semaphore_bitmap_addr (stable)) + (index * sizeof(UCHAR)))) # UChar  |-> (Znth index bytes 0))
  **  (UCharArray.missing_i (semaphore_bitmap_addr (stable)) index 0 (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
.

Definition AllocId_partial_solve_wit_4 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id < (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
|--
  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index_2) ” 
  &&  “ (index_2 < scan_end_2) ” 
  &&  “ (semaphore_alloc_index_inv stable before index_2 ) ” 
  &&  “ (semaphore_alloc_entry_inv stable before index_2 id entry ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (index <> scan_end) ” 
  &&  “ ((Znth index bytes 0) <> 255) ” 
  &&  “ (index < scan_end) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index <= scan_end) ” 
  &&  “ (semaphore_alloc_index_inv stable before index ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ ((Z.land entry 1) = 0) ”
  &&  ((((semaphore_bitmap_addr (stable)) + (index_2 * sizeof(UCHAR)))) # UChar  |-> (Znth index_2 bytes 0))
  **  (UCharArray.missing_i (semaphore_bitmap_addr (stable)) index_2 0 (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
.

Definition AllocId_partial_solve_wit_5 := 
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (bytes: (@list Z)) (index: Z) (scan_end: Z) (id: Z) (entry: Z) (index_2: Z) (scan_end_2: Z) (PreH1 : (id < (semaphore_id_limit (stable)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index_2)) (PreH6 : (index_2 < scan_end_2)) (PreH7 : (semaphore_alloc_index_inv stable before index_2 )) (PreH8 : (semaphore_alloc_entry_inv stable before index_2 id entry )) (PreH9 : (semaphore_bitmap_ok stable before bytes )) (PreH10 : (index <> scan_end)) (PreH11 : ((Znth index bytes 0) <> 255)) (PreH12 : (index < scan_end)) (PreH13 : (manager_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ))) (PreH16 : (0 <= index)) (PreH17 : (index <= scan_end)) (PreH18 : (semaphore_alloc_index_inv stable before index )) (PreH19 : (semaphore_bitmap_ok stable before bytes )) (PreH20 : (semaphore_bitmap_ok stable before bytes )) (PreH21 : (manager_pre <> 0)) (PreH22 : (manager_pre <> 0)) (PreH23 : (SemaphoreStableContext stable )) (PreH24 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH25 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
|--
  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (scan_end_2 = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index_2) ” 
  &&  “ (index_2 < scan_end_2) ” 
  &&  “ (semaphore_alloc_index_inv stable before index_2 ) ” 
  &&  “ (semaphore_alloc_entry_inv stable before index_2 id entry ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (index <> scan_end) ” 
  &&  “ ((Znth index bytes 0) <> 255) ” 
  &&  “ (index < scan_end) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (scan_end = (((semaphore_id_limit (stable)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index <= scan_end) ” 
  &&  “ (semaphore_alloc_index_inv stable before index ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (semaphore_bitmap_ok stable before bytes ) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ ((Z.land entry 1) = 0) ”
  &&  ((((semaphore_bitmap_addr (stable)) + (index_2 * sizeof(UCHAR)))) # UChar  |->_)
  **  (UCharArray.missing_i (semaphore_bitmap_addr (stable)) index_2 0 (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_buckets stable before )
.

Definition AllocId_which_implies_wit_1 := 
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH2 : (SemaphoreStableContext stable )) ,
  (store_semaphore_id_manager stable before )
|--
  EX (bytes: (@list Z)) ,
  “ (semaphore_bitmap_ok stable before bytes ) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
) \/
(
forall (manager_pre: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH2 : (SemaphoreStableContext stable )) ,
  (store_semaphore_id_manager stable before )
|--
  EX (bytes: (@list Z)) ,
  “ (semaphore_bitmap_ok stable before bytes ) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (UCharArray.full (semaphore_bitmap_addr (stable)) (((semaphore_id_limit (stable)) + 7 ) ÷ 8 ) bytes )
  **  (store_semaphore_buckets stable before )
).

Module Type VC_Correct.


Axiom proof_of_AllocId_safety_wit_1 : AllocId_safety_wit_1.
Axiom proof_of_AllocId_safety_wit_2 : AllocId_safety_wit_2.
Axiom proof_of_AllocId_safety_wit_3 : AllocId_safety_wit_3.
Axiom proof_of_AllocId_safety_wit_4 : AllocId_safety_wit_4.
Axiom proof_of_AllocId_safety_wit_5 : AllocId_safety_wit_5.
Axiom proof_of_AllocId_safety_wit_6 : AllocId_safety_wit_6.
Axiom proof_of_AllocId_safety_wit_7 : AllocId_safety_wit_7.
Axiom proof_of_AllocId_safety_wit_8 : AllocId_safety_wit_8.
Axiom proof_of_AllocId_safety_wit_9 : AllocId_safety_wit_9.
Axiom proof_of_AllocId_safety_wit_10 : AllocId_safety_wit_10.
Axiom proof_of_AllocId_safety_wit_11 : AllocId_safety_wit_11.
Axiom proof_of_AllocId_safety_wit_12 : AllocId_safety_wit_12.
Axiom proof_of_AllocId_safety_wit_13 : AllocId_safety_wit_13.
Axiom proof_of_AllocId_safety_wit_14 : AllocId_safety_wit_14.
Axiom proof_of_AllocId_safety_wit_15 : AllocId_safety_wit_15.
Axiom proof_of_AllocId_safety_wit_16 : AllocId_safety_wit_16.
Axiom proof_of_AllocId_safety_wit_17 : AllocId_safety_wit_17.
Axiom proof_of_AllocId_safety_wit_18 : AllocId_safety_wit_18.
Axiom proof_of_AllocId_safety_wit_19 : AllocId_safety_wit_19.
Axiom proof_of_AllocId_safety_wit_20 : AllocId_safety_wit_20.
Axiom proof_of_AllocId_safety_wit_21 : AllocId_safety_wit_21.
Axiom proof_of_AllocId_safety_wit_22 : AllocId_safety_wit_22.
Axiom proof_of_AllocId_safety_wit_23 : AllocId_safety_wit_23.
Axiom proof_of_AllocId_safety_wit_24 : AllocId_safety_wit_24.
Axiom proof_of_AllocId_safety_wit_25 : AllocId_safety_wit_25.
Axiom proof_of_AllocId_safety_wit_26 : AllocId_safety_wit_26.
Axiom proof_of_AllocId_safety_wit_27 : AllocId_safety_wit_27.
Axiom proof_of_AllocId_safety_wit_28 : AllocId_safety_wit_28.
Axiom proof_of_AllocId_safety_wit_29 : AllocId_safety_wit_29.
Axiom proof_of_AllocId_entail_wit_1 : AllocId_entail_wit_1.
Axiom proof_of_AllocId_entail_wit_2 : AllocId_entail_wit_2.
Axiom proof_of_AllocId_entail_wit_3 : AllocId_entail_wit_3.
Axiom proof_of_AllocId_entail_wit_4 : AllocId_entail_wit_4.
Axiom proof_of_AllocId_return_wit_1 : AllocId_return_wit_1.
Axiom proof_of_AllocId_return_wit_2 : AllocId_return_wit_2.
Axiom proof_of_AllocId_return_wit_3 : AllocId_return_wit_3.
Axiom proof_of_AllocId_partial_solve_wit_1_pure : AllocId_partial_solve_wit_1_pure.
Axiom proof_of_AllocId_partial_solve_wit_1 : AllocId_partial_solve_wit_1.
Axiom proof_of_AllocId_partial_solve_wit_2 : AllocId_partial_solve_wit_2.
Axiom proof_of_AllocId_partial_solve_wit_3 : AllocId_partial_solve_wit_3.
Axiom proof_of_AllocId_partial_solve_wit_4 : AllocId_partial_solve_wit_4.
Axiom proof_of_AllocId_partial_solve_wit_5 : AllocId_partial_solve_wit_5.
Axiom proof_of_AllocId_which_implies_wit_1 : AllocId_which_implies_wit_1.

End VC_Correct.
