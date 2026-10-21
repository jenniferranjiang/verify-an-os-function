From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import CRTOS_Verify.lib.idnode CRTOS_Verify.lib.CrtosGlobState.
Import ListNotations IDNode.
Local Open Scope Z_scope.
Local Open Scope string_scope.

(** 一个已发布 Semaphore 的可观察内容。addr 是本次生命周期内不变的分配基址，
    id 是登记 ID；pending_addrs 保存等待任务的 TaskDescriptor 基址及链表顺序。
    bitmap、哈希桶、registry link 均由此列表派生，不保存第二份模块状态。 *)
Record SemaphoreObject := Build_SemaphoreObject {
  semaphore_addr : addr;
  semaphore_id : Z;
  semaphore_value : Z;
  semaphore_pending_addrs : list addr
}.
Definition SemaphoreState := list SemaphoreObject.

(** semaphore.c 的固定全局地址及 DECLARE_ID_MANAGER 配置。
    manager_abs 直接复用共享 ID manager 的稳定配置类型。 *)
Record SemaphoreStable := Build_SemaphoreStable {
  semaphore_manager_addr : addr;
  semaphore_registry_addr : addr;
  semaphore_manager_abs : StableIdmanager
}.

(** 各对象的嵌入 id 子对象供公共 IDNode 表示使用；它不拥有内存。 *)
Definition semaphore_id_node (obj : SemaphoreObject) : IdNodeAbs :=
  let p := obj.(semaphore_addr) in
  Build_IdNodeAbs obj.(semaphore_id) (&(p # "Semaphore" ->ₛ "id")).
Definition semaphore_registry_node (obj : SemaphoreObject) : DL_Node unit :=
  let p := obj.(semaphore_addr) in
  Build_DL_Node tt (&(p # "Semaphore" ->ₛ "link")).
Definition semaphore_pending_node (task : addr) : DL_Node unit :=
  Build_DL_Node tt
    (&(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")).

(** registry 头插顺序也决定每个 ID 哈希桶的头插顺序，删除只过滤原顺序。 *)
Definition semaphore_manager_state (sg : SemaphoreStable)
    (objects : SemaphoreState) : VarIdmanager :=
  Build_VarIdmanager (map semaphore_id objects)
    (map (fun k => map semaphore_id_node
      (filter (fun obj => Z.eqb
        (obj.(semaphore_id) mod sg.(semaphore_manager_abs).(hoffset))
        (Z.of_nat k)) objects))
      (seq 0 (Z.to_nat sg.(semaphore_manager_abs).(hoffset)))).

(** 全模块稳定态的范围与唯一性。一个等待任务只能挂一个 semaphore pending 队列；
    已发布 ID 和对象地址分别唯一；对象值遵守 uint16 范围。 *)
Definition semaphore_valid (objects : SemaphoreState) : Prop :=
  NoDup (map semaphore_addr objects) /\
  NoDup (map semaphore_id objects) /\
  NoDup (List.concat (map semaphore_pending_addrs objects)) /\
  Forall (fun obj => obj.(semaphore_addr) <> 0 /\
    0 <= obj.(semaphore_id) < 128 /\
    0 <= obj.(semaphore_value) <= 65535) objects.

(** 成功创建精确头插新对象，值为参数、等待队列为空。 *)
Definition semaphore_publish (p id value : Z) (before : SemaphoreState)
    : SemaphoreState := Build_SemaphoreObject p id value [] :: before.

(** 只允许分配当前首个空闲 ID；此关系不把 malloc 失败混入 ID 分配失败。 *)
Definition semaphore_create_transition (sg : SemaphoreStable)
    (p value result : Z) (before after : SemaphoreState) : Prop :=
  (result = -5 /\ after = before) \/
  (idmanager_min_free_id sg.(semaphore_manager_abs)
      (semaphore_manager_state sg before) result /\
   p <> 0 /\ ~ In p (map semaphore_addr before) /\
   after = semaphore_publish p result value before).

(** 删除时只移走目标对象；ID 节点、registry link 与对象本体 ownership
    在表示层返还给退休对象，pending 必须先经 ResumeAll 清空。 *)
Definition semaphore_remove (id : Z) (before : SemaphoreState) : SemaphoreState :=
  filter (fun obj => negb (Z.eqb obj.(semaphore_id) id)) before.

(** 生命周期的值更新不改变地址、ID 或等待队列；uint16 溢出按 C 转换取模。 *)
Definition semaphore_set_value (value : Z) (obj : SemaphoreObject) : SemaphoreObject :=
  Build_SemaphoreObject obj.(semaphore_addr) obj.(semaphore_id)
    (value mod 65536) obj.(semaphore_pending_addrs).
Definition semaphore_set_pending (tasks : list addr) (obj : SemaphoreObject)
    : SemaphoreObject :=
  Build_SemaphoreObject obj.(semaphore_addr) obj.(semaphore_id)
    obj.(semaphore_value) tasks.
