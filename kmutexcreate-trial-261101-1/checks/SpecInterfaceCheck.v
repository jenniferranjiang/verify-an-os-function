(** 本文件仅检查 annotated C 所引用接口的 Rocq 类型，不含 C 证明。 *)
Require Import Coq.ZArith.ZArith Coq.Lists.List.
From SimpleC.SL Require Import Mem.
Require Import CRTOS_Verify.lib.KMutexCreate.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KTaskWakeup.
From MonadLib.MonadErr Require Import MonadErrBasic monadesafe_lib.
Import DLL IDNode.
Check (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (os_inv : StableGlobalState -> VarGlobalState -> Assertion).
Check (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop).
Check (abs_mutex_create : StableGlobalState -> program (VarGlobalState -> Prop) Z).
Check (MutexRaw : addr -> Assertion).
Check (addr_aligned : Z -> Z -> Prop).
Check (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion).
Check (store_idnode_insert_ready : addr -> Assertion).
Check (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop).
Check (idmanager_add : VarIdmanager -> Z -> VarIdmanager).
Check (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager).
Check (CharArray.undef_full : Z -> Z -> Assertion).
Check (CharArray.full : Z -> Z -> list Z -> Assertion).
Check (@repeat_Z : forall A : Type, A -> Z -> list A).
Check (store_node_self_linked : addr -> Assertion).
Check (@store_dll : forall A : Type, (addr -> A -> Assertion) -> addr -> list (DL_Node A) -> Assertion).
Check (occupy_dll_node : addr -> Assertion).
Check (@Build_DL_Node : forall A : Type, A -> addr -> DL_Node A).
Check (@dll_insert_anchor : forall A : Type, addr -> list (DL_Node A) -> addr -> Prop).
Check (@dll_insert_after_dispatch : forall A : Type, addr -> list (DL_Node A) -> addr -> DL_Node A -> list (DL_Node A)).
Check (sched_link_of : addr -> addr).
Check (store_ready_dll_tail_view : addr -> list (DL_Node Z) -> addr -> Assertion).
Check (store_priority_ready_bucket : addr -> list (DL_Node Z) -> Assertion).
Check (@safeExec : forall S A : Type, (S -> Prop) -> program S A -> (A -> S -> Prop) -> Prop).
Check (@MonadErr.ret : forall S A : Type, A -> program S A).

Check (@nil : forall A : Type, list A).
Check (@cons : forall A : Type, A -> list A -> list A).
Check (@app : forall A : Type, list A -> list A -> list A).
