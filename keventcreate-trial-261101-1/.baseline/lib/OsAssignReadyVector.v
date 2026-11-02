Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.AssignInv.

Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.

(** 就绪容器的完整定义与 assign_inv 同属 CrtosInv；这里保留局部桶补集
    和初始化写权限，不重定义稳定不变量或其状态条件。 *)

(**
  [store_priority_ready_vector_except ready_vector index bucket buckets]
  描述除第 [index] 个桶以外的其余 31 个桶，作用类似
  [lib/idnode.v] 的 [store_idbuckets_except]。保留桶只保存其节点权限及
  节点与任务的纯地址对应，不依赖 descriptor map。

  参数 [bucket] 必须正是 [buckets] 在 [index] 处的元素。该局部视图用于
  将目标桶单独交给双向链表插入、删除或遍历规格，同时原样保留其他桶的
  所有权；它不会盲目展开整个 32 元素数组。
*)
Definition store_priority_ready_vector_except
    (ready_vector : addr)
    (index : Z)
    (bucket : list (DL_Node addr))
    (buckets : list (list (DL_Node addr))) : Assertion :=
  EX prefix suffix : list (list (DL_Node addr)),
    “ Zlength buckets = PRIORITY_MAX /\
      buckets = prefix ++ bucket :: suffix /\
      Zlength prefix = index ” &&
    store_priority_ready_vector_rec
      (priority_ready_vector_base ready_vector) 0 prefix **
    store_priority_ready_vector_rec
      (priority_ready_vector_base ready_vector)
      (index + 1) suffix.

(**
  [has_permission_priority_ready_bucket head] 拥有一个尚待初始化的数组
  哨兵中的两个可写指针槽。它不读取旧指针值，也不拥有任何任务节点。
  这是调用 [InitDoubleLinkList] 前单个
  [priority_ready_vector[index]] 元素所需的最小空间资源。
*)
Definition has_permission_priority_ready_bucket (head : addr) : Assertion :=
  &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |->_ **
  &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |->_.

(**
  [has_permission_priority_ready_vector_rec base index count] 递归拥有
  [count] 个连续、尚待初始化的就绪桶哨兵。与已初始化的存储谓词分开
  定义，是因为 [OsAssignReadyVectorInit] 在读取前会覆盖所有头指针。
*)
Fixpoint has_permission_priority_ready_vector_rec
    (base : addr)
    (index : Z)
    (count : nat) : Assertion :=
  match count with
  | O => emp
  | S count' =>
      has_permission_priority_ready_bucket
        (base + index * sizeof("SysDoubleLinklistNode")) **
      has_permission_priority_ready_vector_rec base (index + 1) count'
  end.

(**
  [has_permission_os_assign_ready_vector ready_vector] 拥有初始化整个
  [struct OsAssignReadyVector] 所需的写权限：32 个数组哨兵的 64 个指针
  槽，以及 [priority_ready_group]、[highest_prio] 两个标量槽。它不对
  初始化前的位模式作出任何承诺。
*)
Definition has_permission_os_assign_ready_vector
    (ready_vector : addr) : Assertion :=
  has_permission_priority_ready_vector_rec
    (priority_ready_vector_base ready_vector) 0
    (Z.to_nat PRIORITY_MAX) **
  &(ready_vector # "OsAssignReadyVector" ->ₛ "priority_ready_group")
    # UInt |->_ **
  &(ready_vector # "OsAssignReadyVector" ->ₛ "highest_prio")
    # UInt |->_.
