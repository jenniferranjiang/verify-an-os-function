From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String Coq.micromega.Lia.
Require Import CRTOS_Verify.lib.idnode CRTOS_Verify.sem.SemaphorePure CRTOS_Verify.sem.SemaphoreRep.
Import ListNotations CRTOS_Verify.lib.CrtosRules.Task_C_Rules IDNode DLL.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope sac.

(** 静态数组的逐元素构造。地址 metadata 为来源输入；每个元素的两槽
    从原始静态资源转交给 BSS bucket representation，没有增加任何字节。 *)
Lemma static_bucket_array_build : forall n base start,
  (forall index, start <= index < start + Z.of_nat n ->
     base + index * sizeof("SysDoubleLinklistNode") <> 0) ->
  store_array_rec store_sem_static_bucket_at base start (start + Z.of_nat n) (repeat tt n) |--
  store_idbucket_list base start (repeat [] n).
Proof.
  induction n as [|n IH]; intros base start Haddr.
  - cbn [repeat store_array_rec store_idbucket_list]. entailer!.
  - cbn [repeat store_array_rec store_idbucket_list store_idbucket].
    replace (start + Z.of_nat (S n)) with (start + 1 + Z.of_nat n) by lia.
    sep_apply (IH base (start + 1) ltac:(intros; apply Haddr; lia)).
    Right. unfold store_sem_static_bucket_at, store_uninit_idbucket.
    entailer!. apply Haddr; lia.
Qed.

(** BSS bitmap 的16个零字节精确表示空ID集合。 *)
Lemma static_empty_id_map : id_map_bytes_ok 128 [] (repeat 0 16).
Proof.
  unfold id_map_bytes_ok.
  split; [lia|]. split; [lia|]. split; [reflexivity|].
  split; [unfold idlist_ok; split; constructor|].
  split; [repeat constructor; lia|].
  intros id Hrange. unfold Znth, id_in_ids.
  rewrite nth_repeat. apply Z.bits_0.
Qed.

(** 固定容量128、16桶的初始纯 manager 状态。 *)
Lemma static_empty_buckets : idbuckets_ok 128 16 [] (repeat [] 16).
Proof.
  unfold idbuckets_ok, idnodes_ok, idlist_ok, idnode_ids.
  cbn [repeat idbuckets_index_ok concat map Zlength].
  repeat split; try lia; repeat constructor.
Qed.

(** 从权威静态声明的字段、零数组和有效地址metadata建立整个空模块。
    这是初始化 ownership 的实际构造，不通过加强循环/函数Require来获得地址。 *)
Lemma semaphore_static_initial_build : forall manager registry bitmap table,
  let sg := Build_SemaphoreStable manager registry
    (Build_StableIdmanager 128 16 bitmap table) in
  store_semaphore_static_initial sg |-- store_semaphore sg [].
Proof.
  intros manager registry bitmap table; cbn zeta.
  unfold store_semaphore_static_initial, store_semaphore, store_sem_manager,
    store_sem_registry, semaphore_manager_state, store_idmanager.
  cbn [semaphore_manager_abs semaphore_manager_addr semaphore_registry_addr idmax hoffset id_map htable idlist idbuckets].
  unfold store_array.
  Intros.
  destruct H as [Hregistry Htable].
  sep_apply (static_bucket_array_build 16 table 0 ltac:(intros; apply Htable; lia)).
  unfold store_id_map, store_uchar_array, store_idbuckets.
  Exists (repeat 0 16).
  unfold store_dll. Exists registry registry.
  cbn [dllseg].
  entailer!.
  - change (UCharArray.full bitmap 16 (repeat 0 16) **
      store_idbucket_list table 0 (repeat [] 16) |--
      (“ registry = registry /\ registry = registry ” && emp) **
      (UCharArray.full bitmap 16 (repeat 0 16) **
       store_idbucket_list table 0 (repeat [] 16))).
    entailer!.
  - constructor.
  - exact static_empty_id_map.
  - exact static_empty_buckets.
  - unfold semaphore_valid; repeat split; constructor.
Qed.

Print Assumptions semaphore_static_initial_build.
