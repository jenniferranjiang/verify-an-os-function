Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.CrtosConfig CRTOS_Verify.lib.dll_abs CRTOS_Verify.lib.idnode_abs.
Require Export CRTOS_Verify.lib.StructFieldOffsetAxiom.
Import KTaskCNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.

(** 一个 Semaphore 的地址、ID、计数和等待任务地址顺序；ID 在发布期固定。
    等待节点地址由同一任务的 sched_link 派生，不复制任务描述符。 *)
Record SemaphoreAbs := {
  semaphore_addr : addr;
  semaphore_id : Z;
  semaphore_value : Z;
  semaphore_pending_addrs : list addr
}.
Definition SemaphoreState := list SemaphoreAbs.
(** 管理链的顺序就是对象序列；ID bitmap 和哈希桶均由该序列派生。 *)
Record SemaphoreStable := {
  semaphore_manager_ptr : addr;
  semaphore_manager_stable : StableIdmanager;
  semaphore_list_head : addr
}.
Definition semaphore_context (sg : SemaphoreStable) : Prop :=
  sg.(semaphore_manager_ptr) = &("k_sem_id_manager") /\
  sg.(semaphore_manager_stable).(idmax) = 128 /\
  sg.(semaphore_manager_stable).(hoffset) = 16 /\
  sg.(semaphore_manager_stable).(id_map) = &("__id_map_k_sem_id_manager") /\
  sg.(semaphore_manager_stable).(htable) = &("__htable_k_sem_id_manager") /\
  sg.(semaphore_list_head) = &("k_sem_list").
Definition semaphore_idnode (s : SemaphoreAbs) : IdNodeAbs :=
  let p := s.(semaphore_addr) in
  Build_IdNodeAbs s.(semaphore_id) (&(p # "Semaphore" ->ₛ "id")).
(** 两种插入均为头插，故每个 ID 桶恰是管理链按 hash 过滤的子序列。 *)
Definition semaphore_manager (st : SemaphoreState) : VarIdmanager :=
  Build_VarIdmanager (map semaphore_id st)
    (map (fun i => map semaphore_idnode
       (filter (fun s => Z.eqb (s.(semaphore_id) mod 16) (Z.of_nat i)) st))
     (seq 0 16)).
Definition semaphore_waiters (st : SemaphoreState) : list addr :=
  List.concat (map semaphore_pending_addrs st).
Definition semaphore_created (p id val : Z) : SemaphoreAbs :=
  {| semaphore_addr := p; semaphore_id := id;
     semaphore_value := val; semaphore_pending_addrs := nil |}.
(** BSS bitmap/桶全零，k_sem_list静态自环，对应空对象集合。 *)
Definition semaphore_initial : SemaphoreState := nil.

(** 当前arm-none-eabi ILP32布局的可类型检查陈述，供前端布局元数据核对。
    此处没有公理或证明，且任何证明不以此当作已证结论；ABI编译检查给出C侧证据。 *)
Definition SemaphoreLayout : Prop :=
  sizeof("Semaphore") = 32 /\ sizeof("IdNode") = 12 /\
  sizeof("SysDoubleLinklistNode") = 8 /\
  forall p : addr,
    &(p # "Semaphore" ->ₛ "id") = p /\
    &(p # "Semaphore" ->ₛ "id" .ₛ "id") = p /\
    &(p # "Semaphore" ->ₛ "id" .ₛ "link") = p+4 /\
    &(p # "Semaphore" ->ₛ "value") = p+12 /\
    &(p # "Semaphore" ->ₛ "pend_list") = p+16 /\
    &(p # "Semaphore" ->ₛ "link") = p+24.

(** 头插发布的纯状态更新；旧对象和它们的等待顺序逐项保留。 *)
Definition semaphore_publish (p id val : Z) (st : SemaphoreState) : SemaphoreState :=
  semaphore_created p id val :: st.
