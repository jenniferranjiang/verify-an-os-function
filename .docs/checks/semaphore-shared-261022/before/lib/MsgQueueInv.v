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
Definition store_msgqueue_padding (p : addr) : Assertion :=
  UCharArray.full (p + 2) 2 [0; 0].

(**
  独立候选谓词，当前不接入 store_msgqueue/msgqueue_inv；待消息队列模块验证时细化。
  外部缓冲区拥有 each_len*max_msgs 个字节，即 _InitMsgQueue 的分配请求范围；
  创建证明仍须建立 C 乘法安全及该区域的取得，不能由 Z 乘法代替溢出证明。
  bytes 仅为空间见证：允许未初始化/未指定值的字节，不声称整个块清零或可读。
  该谓词保留完整释放权限，但不保留跨操作的消息值；功能证明须再关联逻辑消息，
  尤其 send 只写 size 字节，而 recv 按 min(size,each_len) 读，不记录发送长度。
*)
Definition store_msgqueue_buffer (a : MsgQueueAbs) : Assertion :=
  “ a.(mqBuffer) <> 0 ” &&
  EX bytes : list (option Z),
    UCharArray.mixed_full a.(mqBuffer)
      (a.(mqEachLen) * a.(mqMaxMsgs)) bytes.

(**
  以下是供后续函数证明显式使用的候选安全域，未放入 msgqueue_inv：
  uint16 相乘在当前 C 整数提升后还需有符号 int 溢出证明；index 的 int16
  写回、urgent -- 与容量截断也需要输入条件和保持性证明，不能仅凭类型得出。
*)
Definition msgqueue_arithmetic_safe (a : MsgQueueAbs) : Prop :=
  0 < a.(mqMaxMsgs) <= 32767 /\
  0 <= a.(mqIndex) < a.(mqMaxMsgs) /\
  0 <= a.(mqNumMsgs) <= a.(mqMaxMsgs) /\
  0 <= a.(mqEachLen) * a.(mqMaxMsgs) <= INT_MAX.

(** 命名结构体函数表按实际字段存储，布局对应由 StructFieldOffsetAxiom 的 ABI 公理给出。 *)
Definition store_msgqueue_done (p : addr) (d : MsgQueueDoneAbs) : Assertion :=
  &(p # "MsgQueueDone" ->ₛ "init") # Ptr |-> d.(mqdInit) **
  &(p # "MsgQueueDone" ->ₛ "urgensend") # Ptr |-> d.(mqdUrgentSend) **
  &(p # "MsgQueueDone" ->ₛ "send") # Ptr |-> d.(mqdSend) **
  &(p # "MsgQueueDone" ->ₛ "recv") # Ptr |-> d.(mqdRecv) **
  &(p # "MsgQueueDone" ->ₛ "reinit") # Ptr |-> d.(mqdReinit) **
  &(p # "MsgQueueDone" ->ₛ "Delete") # Ptr |-> d.(mqdDelete).

Definition pure_msgqueue_link (link object : addr) : Assertion :=
  “ link = &(object # "MsgQueue" ->ₛ "link") ” && emp.

Definition msgqueue_link_nodes (objects : list addr) : list (DL_Node addr) :=
  map (fun p => Build_DL_Node p (&(p # "MsgQueue" ->ₛ "link"))) objects.

(**
  两条等待 DLL 各拥有哨兵及 sched_link，payload 仅纯关联同一权威 task map、
  节点和等待状态；所有任务六个 sched 标量始终由 task_inv 统一拥有。
  map cell 另拥有主体字段和 padding，排除 ID/global link、任务主体、Delay。
  msg_buf 仅拥有指针字段；所指缓冲区暂不纳入，留待消息队列模块验证时补充。
*)
Definition store_msgqueue (store_wait_T : addr -> addr -> Assertion)
    (p : addr) (a : MsgQueueAbs) : Assertion :=
  “ addr_aligned p ALIGN_SIZE ” &&
  &(p # "MsgQueue" ->ₛ "msg_buf") # Ptr |-> a.(mqBuffer) **
  &(p # "MsgQueue" ->ₛ "index") # Short |-> a.(mqIndex) **
  &(p # "MsgQueue" ->ₛ "num_msgs") # UShort |-> a.(mqNumMsgs) **
  &(p # "MsgQueue" ->ₛ "each_len") # UShort |-> a.(mqEachLen) **
  &(p # "MsgQueue" ->ₛ "max_msgs") # UShort |-> a.(mqMaxMsgs) **
  &(p # "MsgQueue" ->ₛ "Done") # Ptr |-> a.(mqDone) **
  store_dll store_wait_T (&(p # "MsgQueue" ->ₛ "send_pend_list")) a.(mqSendWaitNodes) **
  store_dll store_wait_T (&(p # "MsgQueue" ->ₛ "recv_pend_list")) a.(mqRecvWaitNodes) **
  store_msgqueue_padding p.

(** 登记对象的双向覆盖和 ID 地址多重集对应；已发布对象引用模块唯一 Done。 *)
Record msgqueue_world_wf (sg : MsgQueueStable) (st : MsgQueueState) : Prop := {
  msgqueue_wf_map_list :
    (forall p, In p st.(msgqueue_ptrs) <->
      exists a, st.(msgqueue_objects) p = Some a);
  msgqueue_wf_id_nodes :
    Permutation
      (map idnode_addr (List.concat st.(msgqueue_ids).(idbuckets)))
      (map (fun p => &(p # "MsgQueue" ->ₛ "id")) st.(msgqueue_ptrs));
  msgqueue_wf_done :
    (forall p a, st.(msgqueue_objects) p = Some a -> a.(mqDone) = sg.(msgqueue_done_ptr))
}.

Definition msgqueue_send_waiters (st : MsgQueueState) : list addr :=
  flat_map (fun p => match st.(msgqueue_objects) p with
    | Some a => map (@getData addr) a.(mqSendWaitNodes)
    | None => []
    end) st.(msgqueue_ptrs).

Definition msgqueue_recv_waiters (st : MsgQueueState) : list addr :=
  flat_map (fun p => match st.(msgqueue_objects) p with
    | Some a => map (@getData addr) a.(mqRecvWaitNodes)
    | None => []
    end) st.(msgqueue_ptrs).

(** 顺序只用于枚举归属，不声称不同 DLL 之间存在 C 执行次序。 *)
Definition msgqueue_waiters (st : MsgQueueState) : list addr :=
  msgqueue_send_waiters st ++ msgqueue_recv_waiters st.

(**
  稳定发布态所有权模型，不覆盖 KCreateMsgQueue 分步发布窗口，也不修复
  _InitMsgQueue 分配失败后未移除 ID 的源码路径；后续需真实资源转交证明。
*)
Definition msgqueue_inv (store_wait_T : addr -> addr -> Assertion)
    (sg : MsgQueueStable) (st : MsgQueueState) : Assertion :=
  “ msgqueue_world_wf sg st ” &&
  store_idmanager sg.(msgqueue_stable_ids) st.(msgqueue_ids) sg.(msgqueue_idmanager_ptr) **
  store_dll pure_msgqueue_link sg.(msgqueue_list_head) (msgqueue_link_nodes st.(msgqueue_ptrs)) **
  store_msgqueue_done sg.(msgqueue_done_ptr) sg.(msgqueue_done_abs) **
  store_map (store_msgqueue store_wait_T) st.(msgqueue_objects).

Definition msgqueue_cell_frame (store_wait_T : addr -> addr -> Assertion)
    (sg : MsgQueueStable) (st : MsgQueueState) (p : addr) : Assertion :=
  “ msgqueue_world_wf sg st ” &&
  store_idmanager sg.(msgqueue_stable_ids) st.(msgqueue_ids) sg.(msgqueue_idmanager_ptr) **
  store_dll pure_msgqueue_link sg.(msgqueue_list_head) (msgqueue_link_nodes st.(msgqueue_ptrs)) **
  store_msgqueue_done sg.(msgqueue_done_ptr) sg.(msgqueue_done_abs) **
  store_map_missing_i (store_msgqueue store_wait_T) st.(msgqueue_objects) p.

Lemma msgqueue_inv_open : forall store_wait_T sg st p a,
  st.(msgqueue_objects) p = Some a ->
  msgqueue_inv store_wait_T sg st |--
  msgqueue_cell_frame store_wait_T sg st p ** store_msgqueue store_wait_T p a.
Proof.
  intros store_wait_T sg st p a Hlookup.
  unfold msgqueue_inv, msgqueue_cell_frame.
  Intros.
  sep_apply (store_map_split (store_msgqueue store_wait_T) p a
    st.(msgqueue_objects) Hlookup).
  entailer!.
Qed.

Lemma msgqueue_inv_close : forall store_wait_T sg st p a,
  st.(msgqueue_objects) p = Some a ->
  msgqueue_cell_frame store_wait_T sg st p ** store_msgqueue store_wait_T p a |--
  msgqueue_inv store_wait_T sg st.
Proof.
  intros store_wait_T sg st p a Hlookup.
  unfold msgqueue_inv, msgqueue_cell_frame.
  Intros.
  sep_apply (store_map_merge (store_msgqueue store_wait_T) p a
    st.(msgqueue_objects) Hlookup).
  entailer!.
Qed.
