Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import Coq.Sorting.Permutation Coq.Sorting.Sorted Coq.micromega.Lia.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.CrtosRules.
Require Export CRTOS_Verify.lib.dll CRTOS_Verify.lib.idnode.
Require Export CRTOS_Verify.lib.AssignState.
Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.

(**
  [store_priority_ready_bucket head bucket] 拥有一个优先级桶的哨兵和每个
  [sched_link] 节点的 [node_prev/node_next] 两个指针槽。

  参数 [head] 是桶哨兵地址，[bucket] 同时记录节点地址和外围任务基址。
  DLL 的 payload 只保存嵌入节点与外围任务的纯地址等式，并用 [emp]
  明确表示它不拥有额外内存；它不查询 descriptor map，也不要求 owner
  地址非零。任务登记、READY 状态和优先级的一致性由全局调度不变量提供。
  读取任务的调度标量时，必须凭全局查询事实从 [task_inv] 局部借出
  对应 descriptor cell，不能由本桶取得字段访问权限。
*)
Definition store_priority_ready_bucket
    (head : addr)
    (bucket : list (DL_Node addr)) : Assertion :=
  store_dll
    (fun slink task => “ slink = sched_link_of task ” && emp)
    head bucket.

(**
  [store_priority_ready_vector_rec base index buckets] 仿照
  [lib/idnode.v] 中 [store_idbucket_list] 的数组递归方式，拥有连续的就绪
  桶哨兵。

  参数：

  - [base]：[priority_ready_vector[0]] 的地址；
  - [index]：当前桶相对 [base] 的逻辑下标；
  - [buckets]：从当前下标开始的抽象桶后缀。

  每个数组元素地址按
  [base + index * sizeof("SysDoubleLinklistNode")] 计算。该谓词只拥有
  数组中由 [buckets] 覆盖的链表，不拥有结构体后面的两个标量字段。
*)
Fixpoint store_priority_ready_vector_rec
    (base : addr)
    (index : Z)
    (buckets : list (list (DL_Node addr))) : Assertion :=
  match buckets with
  | nil => emp
  | bucket :: rest =>
      store_priority_ready_bucket
        (base + index * sizeof("SysDoubleLinklistNode")) bucket **
      store_priority_ready_vector_rec base (index + 1) rest
  end.

(**
  [store_priority_ready_vector ready_vector buckets] 拥有 C
  结构体中的完整 32 元素 [priority_ready_vector] 数组。

  [ready_vector] 是外层 [struct OsAssignReadyVector] 的地址；
  [buckets] 是按优先级 0 到 31 排列、同时保存 owner 任务基址与
  节点地址的抽象桶。长度条件放在
  纯断言中，防止较短列表只描述数组前缀却被误当作完整数组所有权。
*)
Definition store_priority_ready_vector
    (ready_vector : addr)
    (buckets : list (list (DL_Node addr))) : Assertion :=
  “ Zlength buckets = PRIORITY_MAX ” &&
  store_priority_ready_vector_rec
    (priority_ready_vector_base ready_vector) 0 buckets.

(**
  [store_os_assign_ready_vector ready_vector state] 是整个
  [struct OsAssignReadyVector] 的原始空间解释。

  它拥有：

  - 32 个 [priority_ready_vector] 哨兵及其中全部调度节点的 next/prev 槽；
  - [priority_ready_group] 的 32 位无符号整数单元；
  - [highest_prio] 的可写单元。当前 32 位 QCP 模型按项目既有约定用
    [UInt] 表示 [x_ubase]。

  本谓词刻意不内嵌 [os_assign_ready_vector_ok]，从而能表达插入或删除
  过程中的中间状态。公共稳定状态由 [assign_inv] 中的全局纯良构性
  与本原始空间谓词共同解释。

  节点 payload 仅记录 [sched_link = sched_link_of task]，不查询
  descriptor map，也不拥有外围任务字段。六个调度标量在所有任务状态下
  始终由 [task_inv] 中的 descriptor cell 拥有；本空间谓词与任务 map
  无关，因此更新任务状态或其他标量不会改变就绪表内存的解释。
  节点对应任务已发布以及桶元数据的一致性，属于 [assign_inv] 保存的
  全局纯关系，不能从本原始空间谓词单独推出。
*)
Definition store_os_assign_ready_vector
    (ready_vector : addr)
    (state : OsAssignReadyVectorAbs) : Assertion :=
  store_priority_ready_vector
    ready_vector state.(orvBuckets) **
  &(ready_vector # "OsAssignReadyVector" ->ₛ "priority_ready_group")
    # UInt |-> state.(orvReadyGroup) **
  &(ready_vector # "OsAssignReadyVector" ->ₛ "highest_prio")
    # UInt |-> state.(orvHighestPrio).

(** Assign 本体尾部 [273,276) 的三字节只归 assign_inv 所有，不在外围重复。 *)
Definition store_assign_padding (p : addr) : Assertion :=
  CharArray.undef_full (p + 273) 3.

(** 静态 [PriorityReadyVectorDone] 表三个函数指针槽的唯一线性所有权。 *)
Definition store_priority_ready_vector_done
    (table : addr)
    (done : PriorityReadyVectorDoneAbs) : Assertion :=
  &(table # "PriorityReadyVectorDone" ->ₛ "init")
    # Ptr |-> done.(prvdInit) **
  &(table # "PriorityReadyVectorDone" ->ₛ "insert")
    # Ptr |-> done.(prvdInsert) **
  &(table # "PriorityReadyVectorDone" ->ₛ "remove")
    # Ptr |-> done.(prvdRemove).

(**
  [assign_inv sg st] 拥有非 SMP Assign 的就绪容器、running-task、
  callback-table 指针和 current-priority 字段，并在内部保存
  [assign_world_wf]，统一保证就绪元数据与任务登记的一致性。
  [store_os_assign_ready_vector] 仅描述就绪容器自身的内存与节点地址关系；
  就绪容器拥有 READY task 的 sched_link，六个标量始终由 task_inv 拥有。
  独立函数表由本不变量拥有一次，表内三槽与 ready_vector_done 指针槽分离。
  current-priority 的范围直接由 UChar points-to 保证。
*)
Definition assign_inv
    (sg : StableGlobalState)
    (st : VarGlobalState) : Assertion :=
  let assign := sg.(os_assign_stable).(assign_ptr) in
  let state := st.(os_assign) in
  “ assign_world_wf st.(os_tasks).(task_desc_map) state ” &&
  store_os_assign_ready_vector
    (&(assign # "Assign" ->ₛ "os_assign_ready_vector"))
    state.(assignReadyVector) **
  &(assign # "Assign" ->ₛ "os_running_task")
    # Ptr |-> state.(assignRunningTask) **
  &(assign # "Assign" ->ₛ "ready_vector_done")
    # Ptr |-> sg.(os_assign_stable).(ready_vector_done_ptr) **
  &(assign # "Assign" ->ₛ "current_priority")
    # UChar |-> state.(assignCurrentPriority) **
  store_priority_ready_vector_done
    sg.(os_assign_stable).(ready_vector_done_ptr)
    sg.(os_assign_stable).(ready_vector_done_abs) **
  store_assign_padding assign.

