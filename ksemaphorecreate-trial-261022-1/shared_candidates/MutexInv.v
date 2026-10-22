Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Sorting.Permutation.
Require Import Coq.Strings.String.
Require Import SetsClass.SetsClass.
Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export TrialShared.CrtosRules.
Require Import TrialShared.dll TrialShared.idnode.

Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

Definition mutex_link_node (mutex : addr) : DL_Node addr :=
  Build_DL_Node mutex (&(mutex # "Mutex" ->ₛ "link")).

Definition mutex_link_nodes (mutexes : list addr) : list (DL_Node addr) :=
  map mutex_link_node mutexes.

(** 汇总实际等待顺序，供总组合建立唯一 sched_link owner；不强加永久优先级排序。 *)
(** cc concat所有mutex的pend_list *)
Definition mutex_waiters (st : MutexState) : list addr :=
  List.concat
    (map (fun mutex =>
      match st.(mutex_obj_map) mutex with
      | Some obj => map getData obj.(mutex_pending)
      | None => nil
      end) st.(mutex_ptr_list)).

(** IdNode 的 [2,4) 两字节 padding：创建时 memset 清零，后续字段写入保留。
    QCP 的 struct_padding 当前为 emp，不能替代这些实际字节权限。
    布局公理集中在 StructFieldOffsetAxiom；不拥有 id 或 DLL 字段。 *)
Definition store_mutex_padding (mutex : addr) : Assertion :=
  CharArray.full (mutex + 2) 2 (repeat_Z 0 2).

(**
  map cell 包含对象主体和完整 pend_list。store_dll 拥有等待节点的两个
  指针槽；外部 store_wait_T 只表达同一 task map 与节点/状态的纯关联，
  六个 sched 标量统一由 task_inv 拥有；
  task 主体、task ID、全局 task link、Delay 对象均不在此重新拥有。
*)
Definition store_mutex (store_wait_T : addr -> addr -> Assertion)
    (mutex : addr) (obj : MutexAbs) : Assertion :=
  “ mutex <> 0 /\ addr_aligned mutex ALIGN_SIZE ” &&
  &(mutex # "Mutex" ->ₛ "val") # UShort |-> obj.(mutex_val) **
  &(mutex # "Mutex" ->ₛ "recursive_cnt") # UChar |-> obj.(mutex_recursive_cnt) **
  &(mutex # "Mutex" ->ₛ "origin_prio") # UChar |-> obj.(mutex_origin_prio) **
  &(mutex # "Mutex" ->ₛ "holder") # Ptr |-> obj.(mutex_holder) **
  store_dll store_wait_T &(mutex # "Mutex" ->ₛ "pend_list") obj.(mutex_pending) **
  store_mutex_padding mutex.

Definition pure_mutex_link_member (link mutex : addr) : Assertion :=
  “ link = &(mutex # "Mutex" ->ₛ "link") ” && emp.

(**
  MutexDoneType 是匿名 typedef；按 Arch32 声明顺序保存四个4字节 Ptr 槽。
  不使用尚未经前端注册的虚构 struct tag。后续接入应确认 typedef 布局和
  本翻译单元独立 static done 地址。只拥有指针值，不提供函数体正确性。
*)
Definition store_mutex_done (p : addr) (done : MutexDoneAbs) : Assertion :=
  p # Ptr |-> done.(mutex_done_create) **
  (p + 4) # Ptr |-> done.(mutex_done_delete) **
  (p + 8) # Ptr |-> done.(mutex_done_obtain) **
  (p + 12) # Ptr |-> done.(mutex_done_abandon).

(**
  已登记 map 与管理链双向覆盖，ID manager 包含恰好相同的嵌入 ID 地址。
  不假定 holder 一定存活，也不添加 val/recursive_cnt/holder 之间尚未
  由生命周期证明支持的关系；持锁指针跨解锁保活另由 OC 协议处理。
*)
Record mutex_world_wf (st : MutexState) : Prop := {
  mutex_wf_map_list :
    (forall mutex, In mutex st.(mutex_ptr_list) <->
      exists obj, st.(mutex_obj_map) mutex = Some obj);
  mutex_wf_id_nodes :
    Permutation
      (map idnode_addr (List.concat st.(mutex_idmanager_abs).(idbuckets)))
      (map (fun mutex => &(mutex # "Mutex" ->ₛ "id")) st.(mutex_ptr_list))
}.

(**
  已发布对象的稳定资源组合。创建的分步登记、Delete 中先唤醒再加锁、
  摘链后锁外 x_free 都须通过具体局部 Spec 转移资源；本谓词不假称覆盖
  这些中间阶段，也未接入现有 CriticalSTS 的全生命周期不变量。
*)
Definition mutex_inv (store_wait_T : addr -> addr -> Assertion)
    (sg : MutexStable) (st : MutexState) : Assertion :=
  “ mutex_context sg /\ mutex_world_wf st ” &&
  store_idmanager sg.(mutex_idmanager_stable) st.(mutex_idmanager_abs)
    sg.(mutex_idmanager_ptr) **
  store_dll pure_mutex_link_member sg.(mutex_list_head)
    (mutex_link_nodes st.(mutex_ptr_list)) **
  store_map (store_mutex store_wait_T) st.(mutex_obj_map) **
  store_mutex_done sg.(mutex_done_ptr) sg.(mutex_done_abs).

(** 提取单个对象后的剩余 frame，保留 ID manager、全局链、表和其他对象。 *)
Definition mutex_inv_except (store_wait_T : addr -> addr -> Assertion)
    (sg : MutexStable) (st : MutexState) (mutex : addr) : Assertion :=
  “ mutex_context sg /\ mutex_world_wf st ” &&
  store_idmanager sg.(mutex_idmanager_stable) st.(mutex_idmanager_abs)
    sg.(mutex_idmanager_ptr) **
  store_dll pure_mutex_link_member sg.(mutex_list_head)
    (mutex_link_nodes st.(mutex_ptr_list)) **
  store_map_missing_i (store_mutex store_wait_T) st.(mutex_obj_map) mutex **
  store_mutex_done sg.(mutex_done_ptr) sg.(mutex_done_abs).

Lemma mutex_inv_open : forall store_wait_T sg st mutex obj,
  st.(mutex_obj_map) mutex = Some obj ->
  mutex_inv store_wait_T sg st |--
  mutex_inv_except store_wait_T sg st mutex **
  store_mutex store_wait_T mutex obj.
Proof.
  intros store_wait_T sg st mutex obj Hlookup.
  unfold mutex_inv, mutex_inv_except.
  Intros.
  sep_apply (store_map_split (store_mutex store_wait_T) mutex obj
    st.(mutex_obj_map) Hlookup).
  entailer!.
Qed.

Lemma mutex_inv_close : forall store_wait_T sg st mutex obj,
  st.(mutex_obj_map) mutex = Some obj ->
  mutex_inv_except store_wait_T sg st mutex **
  store_mutex store_wait_T mutex obj |-- mutex_inv store_wait_T sg st.
Proof.
  intros store_wait_T sg st mutex obj Hlookup.
  unfold mutex_inv, mutex_inv_except.
  Intros.
  sep_apply (store_map_merge (store_mutex store_wait_T) mutex obj
    st.(mutex_obj_map) Hlookup).
  entailer!.
Qed.
