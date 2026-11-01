Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.CrtosConfig CRTOS_Verify.lib.dll_abs CRTOS_Verify.lib.idnode_abs.
Require Export CRTOS_Verify.lib.StructFieldOffsetAxiom.
Import KTaskCNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.

(** 对应一个 Mutex：地址和发布期 ID、可用值、8位递归计数、原优先级、
    holder 指针值及 pend_list 的任务地址顺序。holder 仅为引用，不拥有任务。
    不强加“计数为零等价于无持有者”：C 的 uint8 递归计数可回绕。 *)
Record MutexAbs := {
  mutex_addr : addr;
  mutex_id : Z;
  mutex_value : Z;
  mutex_recursive_count : Z;
  mutex_original_priority : Z;
  mutex_holder : addr;
  mutex_pending_addrs : list addr
}.
Definition MutexState := list MutexAbs.

(** k_mutex_id_manager 的固定地址/容量/数组与 k_mutex_list 哨兵。
    done 的不可变分派已解析为直接调用，不为它另建运行时所有权。 *)
Record MutexStable := {
  mutex_manager_ptr : addr;
  mutex_manager_stable : StableIdmanager;
  mutex_list_head : addr
}.
Definition mutex_context (sg : MutexStable) : Prop :=
  sg.(mutex_manager_ptr) = &("k_mutex_id_manager") /\
  sg.(mutex_manager_stable).(idmax) = 128 /\
  sg.(mutex_manager_stable).(hoffset) = 16 /\
  sg.(mutex_manager_stable).(id_map) = &("__id_map_k_mutex_id_manager") /\
  sg.(mutex_manager_stable).(htable) = &("__htable_k_mutex_id_manager") /\
  sg.(mutex_list_head) = &("k_mutex_list").
Definition mutex_idnode (m : MutexAbs) : IdNodeAbs :=
  let p := m.(mutex_addr) in
  Build_IdNodeAbs m.(mutex_id) (&(p # "Mutex" ->ₛ "id")).

(** 管理链与 ID 哈希桶都头插；从唯一对象序列派生位图 ID 集合和每桶顺序，
    不再把一份独立 VarIdmanager 放入模块状态。 *)
Definition mutex_manager (st : MutexState) : VarIdmanager :=
  Build_VarIdmanager (map mutex_id st)
    (map (fun i => map mutex_idnode
       (filter (fun m => Z.eqb (m.(mutex_id) mod 16) (Z.of_nat i)) st))
     (seq 0 16)).
Definition mutex_waiters (st : MutexState) : list addr :=
  List.concat (map mutex_pending_addrs st).

(** 成功创建时 C 设置 val=1、holder=NULL、origin_prio=255、recursive_cnt=0，
    并初始化空等待链；此纯值不提供任何内存权限。 *)
Definition mutex_created (p id : Z) : MutexAbs :=
  {| mutex_addr := p; mutex_id := id; mutex_value := 1;
     mutex_recursive_count := 0; mutex_original_priority := 255;
     mutex_holder := 0; mutex_pending_addrs := nil |}.
Definition mutex_publish (p id : Z) (st : MutexState) : MutexState :=
  mutex_created p id :: st.
(** BSS 清零 bitmap 和懒桶，全局管理链静态自环，对应空模块。 *)
Definition mutex_initial : MutexState := nil.
