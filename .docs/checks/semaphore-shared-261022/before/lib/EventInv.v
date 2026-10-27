Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
Require Import Coq.Sorting.Permutation.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.CrtosRules.
Require Import CRTOS_Verify.lib.dll CRTOS_Verify.lib.idnode.

Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope list_scope.
Local Open Scope sac.

(** IdNode 的 [2,4) 两字节 padding：创建时 memset 清零，后续字段写入保留。
    QCP 的 struct_padding 当前为 emp，不能替代这些实际字节权限。
    布局公理集中在 StructFieldOffsetAxiom；不拥有 id 或 DLL 字段。 *)
Definition store_event_padding (p : addr) : Assertion :=
  UCharArray.full (p + 2) 2 [0; 0].

(**
  EventDoneType 是匿名 typedef。在当前 32 位模型中以四个连续 Ptr 槽
  表示其物理布局，顺序与 C 声明一致；接入时须建立匿名类型布局对应。
  该表属于模块，仅存一份，不能为每个 Event cell 复制。
*)
Definition store_event_done (p : addr) (d : EventDoneAbs) : Assertion :=
  p # Ptr |-> d.(evdCreate) **
  (p + 4) # Ptr |-> d.(evdDelete) **
  (p + 8) # Ptr |-> d.(evdTrigger) **
  (p + 12) # Ptr |-> d.(evdProcess).

(** DLL 拥有 link 槽；该 payload 只表达 container-of 关系。 *)
Definition pure_event_link (link object : addr) : Assertion :=
  “ link = &(object # "Event" ->ₛ "link") ” && emp.

Definition event_link_nodes (objects : list addr) : list (DL_Node addr) :=
  map (fun p => Build_DL_Node p (&(p # "Event" ->ₛ "link"))) objects.

(**
  显式等待 payload 参数由总不变式提供：只查询唯一 task map 并约束
  节点和状态，不拥有六个 sched 标量；标量统一归 task_inv。本 DLL
  只拥有 sched_link。cell 不拥有任务主体或 Delay。
*)
Definition store_event (store_wait_T : addr -> addr -> Assertion)
    (p : addr) (a : EventAbs) : Assertion :=
  “ addr_aligned p ALIGN_SIZE ” &&
  &(p # "Event" ->ₛ "options") # UInt |-> a.(evOptions) **
  &(p # "Event" ->ₛ "events") # UInt |-> a.(evEvents) **
  store_dll store_wait_T (&(p # "Event" ->ₛ "pend_list")) a.(evWaitNodes) **
  store_event_padding p.

(** 双向覆盖 map 与管理链，ID 节点地址多重集与嵌入 id 完整对应。 *)
Record event_world_wf (st : EventState) : Prop := {
  event_wf_map_list :
    (forall p, In p st.(event_ptrs) <->
      exists a, st.(event_objects) p = Some a);
  event_wf_id_nodes :
    Permutation
      (map idnode_addr (List.concat st.(event_ids).(idbuckets)))
      (map (fun p => &(p # "Event" ->ₛ "id")) st.(event_ptrs))
}.

(** 由权威对象 map 汇总等待者，供总不变式检查 sched_link 完整且唯一。 *)
Definition event_waiters (st : EventState) : list addr :=
  flat_map (fun p => match st.(event_objects) p with
    | Some a => map (@getData addr) a.(evWaitNodes)
    | None => []
    end) st.(event_ptrs).

(**
  这是完整发布状态的模块空间模型，不是创建、删除或锁外调用的完整协议。
  布局使用集中管理的 ABI 公理；等待顺序不永久假设按当前优先级排序。
*)
Definition event_inv (store_wait_T : addr -> addr -> Assertion)
    (sg : EventStable) (st : EventState) : Assertion :=
  “ event_world_wf st ” &&
  store_idmanager sg.(event_stable_ids) st.(event_ids) sg.(event_idmanager_ptr) **
  store_dll pure_event_link sg.(event_list_head) (event_link_nodes st.(event_ptrs)) **
  store_event_done sg.(event_done_ptr) sg.(event_done_abs) **
  store_map (store_event store_wait_T) st.(event_objects).

(** 聚焦一个 map cell 时原样保存 ID manager、管理链、回调表、纯关系和其余对象。 *)
Definition event_cell_frame (store_wait_T : addr -> addr -> Assertion)
    (sg : EventStable) (st : EventState) (p : addr) : Assertion :=
  “ event_world_wf st ” &&
  store_idmanager sg.(event_stable_ids) st.(event_ids) sg.(event_idmanager_ptr) **
  store_dll pure_event_link sg.(event_list_head) (event_link_nodes st.(event_ptrs)) **
  store_event_done sg.(event_done_ptr) sg.(event_done_abs) **
  store_map_missing_i (store_event store_wait_T) st.(event_objects) p.

Lemma event_inv_open : forall store_wait_T sg st p a,
  st.(event_objects) p = Some a ->
  event_inv store_wait_T sg st |--
  event_cell_frame store_wait_T sg st p ** store_event store_wait_T p a.
Proof.
  intros store_wait_T sg st p a Hlookup.
  unfold event_inv, event_cell_frame.
  Intros.
  sep_apply (store_map_split (store_event store_wait_T) p a
    st.(event_objects) Hlookup).
  entailer!.
Qed.

Lemma event_inv_close : forall store_wait_T sg st p a,
  st.(event_objects) p = Some a ->
  event_cell_frame store_wait_T sg st p ** store_event store_wait_T p a |--
  event_inv store_wait_T sg st.
Proof.
  intros store_wait_T sg st p a Hlookup.
  unfold event_inv, event_cell_frame.
  Intros.
  sep_apply (store_map_merge (store_event store_wait_T) p a
    st.(event_objects) Hlookup).
  entailer!.
Qed.
