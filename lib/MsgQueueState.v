Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.CrtosConfig.
Require Export CRTOS_Verify.lib.dll_abs CRTOS_Verify.lib.idnode_abs.
Require Export CRTOS_Verify.lib.StructFieldOffsetAxiom.
Import KTaskCNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.

(**
  对应 struct MsgQueue 的实际字段和两个等待 DLL。
  mqIndex 保留 int16 的有符号值，三个容量字段保留 uint16 截断后的值。
  msg_buf 长度由 each_len*max_msgs 导出，字节内容只在空间谓词中存在量化。
  当前为所有权草案，尚无逻辑消息序列；后续收发功能 Spec 应以消息内容
  关联占用槽，而不把整个分配区的逐字节快照放入全局抽象状态。
*)
Record MsgQueueAbs : Type := {
  mqBuffer : addr;
  mqIndex : Z;
  mqNumMsgs : Z;
  mqEachLen : Z;
  mqMaxMsgs : Z;
  mqDone : addr;
  mqSendWaitNodes : list (DL_Node addr);
  mqRecvWaitNodes : list (DL_Node addr)
}.

(** msgqueue.c::Done 六槽回调表的值快照，不自动提供函数调用 Spec。 *)
Record MsgQueueDoneAbs : Type := {
  mqdInit : addr;
  mqdUrgentSend : addr;
  mqdSend : addr;
  mqdRecv : addr;
  mqdReinit : addr;
  mqdDelete : addr
}.

(** 各地址分别属于独立 ID manager、全局 DLL 和本翻译单元静态 Done。 *)
Record MsgQueueStable : Type := {
  msgqueue_idmanager_ptr : addr;
  msgqueue_stable_ids : StableIdmanager;
  msgqueue_list_head : addr;
  msgqueue_done_ptr : addr;
  msgqueue_done_abs : MsgQueueDoneAbs
}.

Record MsgQueueState : Type := {
  msgqueue_objects : addr -> option MsgQueueAbs;
  msgqueue_ptrs : list addr;
  msgqueue_ids : VarIdmanager
}.

(**
  绑定本模块全局根；static Done 不与其他翻译单元的同名对象混为一体。
  具体函数地址及静态表地址的链接关系在后续 Spec 接入时建立。
*)
Definition msgqueue_context (sg : MsgQueueStable) : Prop :=
  sg.(msgqueue_idmanager_ptr) = &("k_mq_id_manager") /\
  sg.(msgqueue_list_head) = &("k_mq_list") /\
  sg.(msgqueue_stable_ids).(idmax) = ID_MAX_NUM /\
  sg.(msgqueue_stable_ids).(hoffset) = BUCKET_NUM /\
  sg.(msgqueue_stable_ids).(id_map) = &("__id_map_k_mq_id_manager") /\
  sg.(msgqueue_stable_ids).(htable) = &("__htable_k_mq_id_manager").

