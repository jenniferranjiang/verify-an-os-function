Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import Coq.Sorting.Permutation.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.CrtosRules CRTOS_Verify.lib.idnode.
Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** IdInsertObj失败时保留的原始字段精确值；padding由外层对象持有。 *)
Definition idnode_private (p : addr) (id prev next : Z) : Assertion :=
 &(p # "IdNode" ->ₛ "id") # UShort |-> id **
 &(p # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr |-> prev **
 &(p # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr |-> next.
(** 私有DLL节点的两个原值；初始化和插入覆盖它们，失败保留精确值。 *)
Definition dll_private (p prev next : addr) : Assertion :=
 &(p # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> prev **
 &(p # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next.
(** QCP当前struct_padding=emp，本次完整32字节ownership需要显式保存这4字节。
    根库同一处理适用，不能与另一份自动padding重复；后续字段写入不修改它们。 *)
Definition sem_padding (p : addr) : Assertion :=
 UCharArray.full (p + 2) 2 [0;0] ** UCharArray.full (p + 14) 2 [0;0].
(** x_malloc成功交出整个32字节未初始化对象；不把未初始化字节假设成某个整数值。 *)
Definition sem_allocated (p : addr) : Assertion :=
 “ p <> 0 /\ addr_aligned p 4 ” && UCharArray.undef_full p 32.
(** memset完成整对象清零后、尚未登记的完整私有对象。失败x_free只消费此形态。
    共2+2+8+2+2+8+8=32字节，没有全局表/等待任务ownership。 *)
Definition sem_zero (p : addr) : Assertion :=
 “ p <> 0 /\ addr_aligned p 4 ” &&
 idnode_private &(p # "Semaphore" ->ₛ "id") 0 0 0 **
 &(p # "Semaphore" ->ₛ "value") # UShort |-> 0 **
 dll_private &(p # "Semaphore" ->ₛ "pend_list") 0 0 **
 dll_private &(p # "Semaphore" ->ₛ "link") 0 0 ** sem_padding p.

(** IdInsertObj成功后，id字段与id.link已交给manager；其余22字节仍归创建者。
    参数保留value和两个独立DLL节点的精确值；padding始终是零。 *)
Definition sem_private_remainder (p value pend_prev pend_next link_prev link_next : Z) : Assertion :=
 &(p # "Semaphore" ->ₛ "value") # UShort |-> value **
 dll_private &(p # "Semaphore" ->ₛ "pend_list") pend_prev pend_next **
 dll_private &(p # "Semaphore" ->ₛ "link") link_prev link_next ** sem_padding p.
(** ID已登记、value尚为零，其余两个DLL节点仍未初始化。 *)
Definition sem_id_registered (p : addr) : Assertion :=
 sem_private_remainder p 0 0 0 0 0.
(** value已赋值且pend_list自环，管理link尚未头插；最后一次DLL插入消费该节点。 *)
Definition sem_ready_to_publish (p value : Z) : Assertion :=
 sem_private_remainder p value &(p # "Semaphore" ->ₛ "pend_list")
   &(p # "Semaphore" ->ₛ "pend_list") 0 0.

(** 等待节点属于任务的sched_link；复用任务模块类型和权威task_desc_map，
    不另建任务视图，也不重复拥有任务标量或Delay。 *)
Definition sched_link_of (task : addr) : addr :=
 &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link").
Definition pure_suspend_sched_link (T : addr -> option TaskDescriptorAbs)
 (link task : addr) : Assertion :=
 EX desc : TaskDescriptorAbs,
 “ T task = Some desc /\ link = sched_link_of task /\
   desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND ” && emp.
Definition semaphore_pending_nodes (pending : list addr) : list (DL_Node addr) :=
 map (fun task => Build_DL_Node task (sched_link_of task)) pending.
Definition semaphore_link_nodes (ptrs : list addr) : list (DL_Node addr) :=
 map (fun p => Build_DL_Node p &(p # "Semaphore" ->ₛ "link")) ptrs.
Definition pure_semaphore_link_member (link p : addr) : Assertion :=
 “ link = &(p # "Semaphore" ->ₛ "link") ” && emp.

(** 对象表是ID和值的唯一权威来源；缺失分支仅令函数全定义，wf排除登记缺失。 *)
Definition semaphore_id_nodes (st : SemaphoreState) : list IdNodeAbs :=
 map (fun p => Build_IdNodeAbs
   (match st.(sem_obj_map) p with Some obj => obj.(sem_id) | None => 0 end)
   &(p # "Semaphore" ->ₛ "id")) st.(sem_ptr_list).
(** 桶顺序由管理链创建顺序过滤；InsertObj与全局链均头插，删除均保持余项顺序。
    空桶的零指针/已初始化自环具体区别由store_idbucket存在分支保留。 *)
Definition semaphore_idmanager (sg : SemaphoreStable) (st : SemaphoreState) : VarIdmanager :=
 let nodes := semaphore_id_nodes st in
 Build_VarIdmanager (map idnode_id nodes)
 (map (fun index => filter (fun node => Z.eqb (node.(idnode_id) mod sg.(sem_idmanager_stable).(hoffset)) index) nodes)
      (map Z.of_nat (seq 0 (Z.to_nat sg.(sem_idmanager_stable).(hoffset))))).
Definition semaphore_world_wf (st : SemaphoreState) : Prop :=
 forall p, In p st.(sem_ptr_list) <-> exists obj, st.(sem_obj_map) p = Some obj.
(** 已登记对象本体只拥有value、padding、pend_list及等待sched_link。
    id与id.link归IDmanager，管理link归全局DLL，三部分不重叠。 *)
Definition store_semaphore (wait : addr -> addr -> Assertion)
 (p : addr) (obj : SemaphoreAbs) : Assertion :=
 “ p <> 0 /\ addr_aligned p 4 ” &&
 &(p # "Semaphore" ->ₛ "value") # UShort |-> obj.(sem_value) **
 store_dll wait &(p # "Semaphore" ->ₛ "pend_list")
   (semaphore_pending_nodes obj.(sem_pending_addrs)) ** sem_padding p.
(** 模块完整内存：manager12字节、bitmap16字节、16个连续8字节桶，
    全局哨兵、全部登记对象与等待链。静态done唯一dispatch已归一直呼，不进入资源模型。 *)
Definition semaphore_inv (wait : addr -> addr -> Assertion)
 (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
 “ semaphore_context sg /\ semaphore_world_wf st ” &&
 store_idmanager sg.(sem_idmanager_stable) (semaphore_idmanager sg st) sg.(sem_idmanager_ptr) **
 store_dll pure_semaphore_link_member sg.(sem_list_head) (semaphore_link_nodes st.(sem_ptr_list)) **
 store_map (store_semaphore wait) st.(sem_obj_map).
(** 只暴露本次slice所需模块；不是宣称整个OS内存已经被重新验证。
    n是实际uint16 KTaskOsAssignLockNest，独立于逻辑锁token，不排除65535。 *)
Definition slice_OS_inv (sg : StableGlobalState) (st : VarGlobalState) (n : Z) : Assertion :=
 semaphore_inv (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
   sg.(os_semaphore_stable) st.(os_semaphores) **
 &("KTaskOsAssignLockNest") # UShort |-> n.

(** 对象注册之前的完整源静态资源：ID数组为零、链哨兵已由初始化器自环。
    无额外初始化token；进入全局协议时转交这些现有链接器所有权。 *)
Definition semaphore_initial_state : SemaphoreState :=
 {| sem_ptr_list := []; sem_obj_map := fun _ => None |}.
Definition store_sem_static_initial (sg : SemaphoreStable) : Assertion :=
 let m := sg.(sem_idmanager_ptr) in let sid := sg.(sem_idmanager_stable) in
 “ semaphore_context sg ” &&
 &(m # "IdManager" ->ₛ "id_max") # UShort |-> 128 **
 &(m # "IdManager" ->ₛ "hoffset") # UShort |-> 16 **
 &(m # "IdManager" ->ₛ "id_map") # Ptr |-> sid.(id_map) **
 &(m # "IdManager" ->ₛ "htable") # Ptr |-> sid.(htable) **
 UCharArray.full sid.(id_map) 16 (repeat 0 16) **
 store_array (fun base index (_ : unit) => store_uninit_idbucket (base + index * sizeof("SysDoubleLinklistNode"))) sid.(htable) 16 (repeat tt 16) **
 dll_private sg.(sem_list_head) sg.(sem_list_head) sg.(sem_list_head).
