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
  Mutex 稳定登记阶段的模型，依据 xs_mutex.h / mutex.c。
  holder 是单个指针值，不拥有所指任务；解引用前必须从同一核心 task map
  取得存活及字段权限。当前优先级调整代码被注释，本模型不假定优先级继承。
  recursive_cnt 为 uint8，C 的增减存在截断/回绕，不能假定非零或无限计数。
*)
Record MutexAbs : Type := {
  mutex_val : Z;
  mutex_recursive_cnt : Z;
  mutex_origin_prio : Z;
  mutex_holder : addr;
  mutex_pending : list (DL_Node addr)
}.

(** 本模块独立 static done 的四个回调值；仅记录地址，不提供回调 Spec。 *)
Record MutexDoneAbs : Type := {
  mutex_done_create : addr;
  mutex_done_delete : addr;
  mutex_done_obtain : addr;
  mutex_done_abandon : addr
}.

(** 独立 ID manager、管理链哨兵及静态回调表的稳定地址；无任务状态副本。 *)
Record MutexStable : Type := {
  mutex_idmanager_ptr : addr;
  mutex_idmanager_stable : StableIdmanager;
  mutex_list_head : addr;
  mutex_done_ptr : addr;
  mutex_done_abs : MutexDoneAbs
}.

(** 已登记 Mutex 对象的纯 map、真实管理链顺序和 ID manager 状态。 *)
Record MutexState : Type := {
  mutex_idmanager_abs : VarIdmanager;
  mutex_ptr_list : list addr;
  mutex_obj_map : addr -> option MutexAbs
}.

(** 绑定具名全局、当前128 ID/16桶配置与四个回调值。 *)
Definition mutex_context (sg : MutexStable) : Prop :=
  sg.(mutex_idmanager_ptr) = &("k_mutex_id_manager") /\
  sg.(mutex_list_head) = &("k_mutex_list") /\
  sg.(mutex_idmanager_stable).(idmax) = ID_MAX_NUM /\
  sg.(mutex_idmanager_stable).(hoffset) = BUCKET_NUM /\
  sg.(mutex_idmanager_stable).(id_map) = &("__id_map_k_mutex_id_manager") /\
  sg.(mutex_idmanager_stable).(htable) = &("__htable_k_mutex_id_manager") /\
  sg.(mutex_done_abs).(mutex_done_create) = &("_MutexCreate") /\
  sg.(mutex_done_abs).(mutex_done_delete) = &("_MutexDelete") /\
  sg.(mutex_done_abs).(mutex_done_obtain) = &("_MutexObtain") /\
  sg.(mutex_done_abs).(mutex_done_abandon) = &("_MutexAbandon").

