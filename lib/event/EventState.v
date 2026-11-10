Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.common.CrtosConfig CRTOS_Verify.lib.common.dll_abs CRTOS_Verify.lib.id.idnode_abs.
Require Export CRTOS_Verify.lib.common.StructFieldOffsetAxiom.
Import KTaskCNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.

(** Event 的地址、发布期 ID、3位 options、29位 events 及等待者基址顺序。
    options 不是调用者原输入，而是 C 位域赋值后保存的低3位；events 可变。 *)
Record EventAbs := {
  event_addr : addr;
  event_id : Z;
  event_options : Z;
  event_events : Z;
  event_pending_addrs : list addr
}.
Definition EventState := list EventAbs.

(** 固定的 k_event_id_manager、bitmap、桶数组和 k_event_list 哨兵地址。
    静态 done 的分派在切片中已解析，不另持有运行时函数表资源。 *)
Record EventStable := {
  event_manager_ptr : addr;
  event_manager_stable : StableIdmanager;
  event_list_head : addr
}.
Definition event_context (sg : EventStable) : Prop :=
  sg.(event_manager_ptr) = &("k_event_id_manager") /\
  sg.(event_manager_stable).(idmax) = 128 /\
  sg.(event_manager_stable).(hoffset) = 16 /\
  sg.(event_manager_stable).(id_map) = &("__id_map_k_event_id_manager") /\
  sg.(event_manager_stable).(htable) = &("__htable_k_event_id_manager") /\
  sg.(event_list_head) = &("k_event_list").
Definition event_idnode (e : EventAbs) : IdNodeAbs :=
  let p := e.(event_addr) in
  Build_IdNodeAbs e.(event_id) (&(p # "Event" ->ₛ "id")).

(** 管理链与 ID 桶均头插，故从单一对象序列派生 ID 集合及各桶顺序。
    bitmap 与懒桶形态交给已有 ID 模块，不增加第二份可变 manager 状态。 *)
Definition event_manager (st : EventState) : VarIdmanager :=
  Build_VarIdmanager (map event_id st)
    (map (fun i => map event_idnode
      (filter (fun e => Z.eqb (e.(event_id) mod 16) (Z.of_nat i)) st))
      (seq 0 16)).
Definition event_waiters (st : EventState) : list addr :=
  List.concat (map event_pending_addrs st).

(** Create 不拒绝任何 uint32 options：赋值到3位位域得到 options mod8。
    memset 建立 events=0，等待哨兵初始化为空。 *)
Definition event_created (p id options : Z) : EventAbs :=
  {| event_addr := p; event_id := id; event_options := options mod 8;
     event_events := 0; event_pending_addrs := nil |}.
Definition event_publish (p id options : Z) (st : EventState) : EventState :=
  event_created p id options :: st.
(** BSS bitmap/桶清零，k_event_list 静态自环，对应空对象序列。 *)
Definition event_initial : EventState := nil.
