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
  Event 模型对应验证副本 xs_event.h 的两个普通 uint32 字段。
  evOptions/evEvents 保留实际 32 位值；evWaitNodes 保存 pend_list 的真实
  顺序及任务基址。原始 C 的 3/29 位自动截断不在本模型中，Spec 接入前
  必须另证合法输入/写入保持性或建立位域与普通字段的对应关系。
*)
Record EventAbs : Type := {
  evOptions : Z;
  evEvents : Z;
  evWaitNodes : list (DL_Node addr)
}.

(** event.c 的 static done 四个函数指针值；只记录值，不赋予调用权限。 *)
Record EventDoneAbs : Type := {
  evdCreate : addr;
  evdDelete : addr;
  evdTrigger : addr;
  evdProcess : addr
}.

(** 稳定地址分别指向独立 k_event_id_manager、k_event_list 和 event.c::done。 *)
Record EventStable : Type := {
  event_idmanager_ptr : addr;
  event_stable_ids : StableIdmanager;
  event_list_head : addr;
  event_done_ptr : addr;
  event_done_abs : EventDoneAbs
}.

(** 已完整发布对象的唯一 map；ID 值由 event_ids 保存，不复制 ID 字段。 *)
Record EventState : Type := {
  event_objects : addr -> option EventAbs;
  event_ptrs : list addr;
  event_ids : VarIdmanager
}.

(**
  绑定本模块公开根和独立 ID 存储；static done 地址保持 TU 局部参数，
  不与其他文件同名 done/Done 合并。回调值的具体链接关系待各函数 Spec 接入。
*)
Definition event_context (sg : EventStable) : Prop :=
  sg.(event_idmanager_ptr) = &("k_event_id_manager") /\
  sg.(event_list_head) = &("k_event_list") /\
  sg.(event_stable_ids).(idmax) = ID_MAX_NUM /\
  sg.(event_stable_ids).(hoffset) = BUCKET_NUM /\
  sg.(event_stable_ids).(id_map) = &("__id_map_k_event_id_manager") /\
  sg.(event_stable_ids).(htable) = &("__htable_k_event_id_manager").

