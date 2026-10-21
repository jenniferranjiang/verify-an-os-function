/*
* Copyright (c) 2020 AIIT XUOS Lab
* XiUOS is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*        http://license.coscl.org.cn/MulanPSL2
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
* See the Mulan PSL v2 for more details.
*/
/**
* @file:    assign_fifo.c
* @brief:   ready table and timeslice functions definitions of fifo scheduler algorithm
* @version: 1.0
* @author:  AIIT XUOS Lab
* @date:    2020/3/15
*
*/
/*
 * 从 CRTOS kernel/thread/assign_fifo.c 迁移。
 * 使用 vrtos 类型和已验证的 NULL_PARAM_CHECK_1 适配；原算法保持。
 * Init/Insert 原本就是直接函数调用，没有函数指针分派需要替换。
 * TimesliceUpdate 仅保留源码，暂不设计或验证其 Spec。
 */
/*
* Copyright (c) 2020 AIIT XUOS Lab
* XiUOS is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*        http://license.coscl.org.cn/MulanPSL2
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
* See the Mulan PSL v2 for more details.
*/
/**
* @file:    xs_klist.h
* @brief:   function declaration and structure defintion of linklist
* @version: 1.0
* @author:  AIIT XUOS Lab
* @date:    2020/3/2
*
*/
/*
* Copyright (c) 2020 AIIT XUOS Lab
* XiUOS is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*        http://license.coscl.org.cn/MulanPSL2
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
* See the Mulan PSL v2 for more details.
*/
/**
* @file:    xs_base.h
* @brief:   basic data type defintions 
* @version: 1.0
* @author:  AIIT XUOS Lab
* @date:    2020/3/10
*
*/
/*  import  board special configuration */
/*  Automatically generated file; DO NOT EDIT. */
/*  XiZi_IIoT Project Configuration */
// #define ARCH_CPU_64BIT
// #define ARCH_RISCV64
/*  kd233 feature */
/*  config default board resources */
/*  config board app name */
/*  config board service table */
/*  config board peripheral */
/*  Hardware feature */
/*  Kernel feature */
/*  separate compile(choose none for compile once) */
/*  Memory Management */
/*  Using small memory allocator */
/*  Task feature */
/*  Inter-Task communication */
/*  Kernel Console */
/*  Kernel Hook */
/*  Command shell */
/*  Set shell user control */
/*  Set shell config param */
/*  Kernel data structure Manage */
/*  Kernel components init */
/*  hash table config */
/*  Kernel Lib */
/*  C++ features */
/*  File system */
/*  Tool feature */
/*  OTA function */
/*  APP_Framework */
/*  Framework */
/*  Security */
/*  Applications */
/*  config stack size and priority of main task */
/*  test app */
/*  connection app */
/*  control app */
/*  knowing app */
/*  sensor app */
/*  app lib */
/*  lib using cJSON */
/*  lib using queue */
/*  lib using LVGL */
/*  lvgl image display parameter settings */
/*  lib using embedded_database */
/*  lib using LoRaWan */
/*  lib using MQTT */
/*  lib using JerryScript */
/*  lib using SQLite */
/*  lib using PikaPython */
typedef signed char int8;
typedef signed short int16;
typedef signed int int32;
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef signed long long int64;
typedef unsigned long long uint64;
typedef int x_bool;
typedef long x_base;
typedef unsigned long x_ubase;
typedef x_base x_err_t;
typedef uint32 x_time_t;
typedef uint32 x_ticks_t;
typedef x_base x_flag_t;
typedef x_ubase x_size_t;
typedef x_ubase x_dev_t;
typedef x_base x_OffPos;
/* the type of components*/
/* the type of error */
// void KPrintf(const char *fmt, ...);
typedef struct SysDoubleLinklistNode
{
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
/*
 * 双向链表类型及验证接口集中维护于此。下列通用和调度专用规格均从
 * 既有验证头文件/切片迁移。就绪桶只保存 task/sched_link 的纯地址等式，
 * 不查询 descriptor map；DLL 只接管节点，六个调度标量留在 task_inv。
 * 任务登记由全局调度不变量提供，插入接口显式保留 owner 非空事实。
 * remove_sched_self 是额外携带调用者字段 frame 的兼容接口，不表示稳定
 * 节点谓词拥有标量；新调度调用优先使用纯节点的 remove_self。
 * xs_klist.h 继续提供原有列表宏及单链表声明，并转导入本头文件。
 */
/*@ Import Coq Require Import CRTOS_Verify.lib.dll */
/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosRules */
/*@ Import Coq Require Import CRTOS_Verify.libai.DoubleLinkListSpec */
/*@ Import Coq Require Import CRTOS_Verify.libai.NodeSelfLinked */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskSchedMember */
/*@ Import Coq Require Import CRTOS_Verify.lib.OsAssignReadyVector */
/*@ Import Coq Require Import CRTOS_Verify.libai.RRR_ReadyInsert */
/*@ Import Coq Import DLL */
/*@ Extern Coq addr := Z */
/*@ Extern Coq
      (DL_Node :: * => *)
      (option :: * => *)
      (TaskDescriptorAbs :: *)
      (TaskSchedMemberAbs :: *)
 */
/*@ Extern Coq
      (Build_DL_Node : {A} -> A -> Z -> DL_Node A)
      (store_dll :
        {A} -> (Z -> A -> Assertion) ->
        Z -> list(DL_Node A) -> Assertion)
      (nil : {A} -> list A)
      (cons : {A} -> A -> list A -> list A)
      (app : {A} -> list A -> list A -> list A)
      (occupy_dll_node : Z -> Assertion)
      (store_node_self_linked : Z -> Assertion)
      (dll_insert_anchor :
        {A} -> Z -> list(DL_Node A) -> Z -> Prop)
      (dll_insert_before_dispatch :
        {A} -> Z -> list(DL_Node A) -> Z -> DL_Node A ->
        list(DL_Node A))
      (dll_insert_after_dispatch :
        {A} -> Z -> list(DL_Node A) -> Z -> DL_Node A ->
        list(DL_Node A))
      (store_task_sched_member :
        Z -> TaskSchedMemberAbs -> Assertion)
      (sched_link_of : Z -> Z)
      (ready_task_node : Z -> DL_Node Z)
      (store_priority_ready_bucket : Z -> list(DL_Node Z) -> Assertion)
      (store_ready_dll_tail_view :
        Z -> list(DL_Node Z) -> Z -> Assertion)
 */
void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require
      undef_data_at(&(linklist_head->node_prev)) *
      undef_data_at(&(linklist_head->node_next))
    Ensure
      linklist_head != 0 && store_node_self_linked(linklist_head)
 */;
void DoubleLinkListInsertNodeBefore(
  DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ rrr_ready_insert_before
    With (head: Z) (prefix: list(DL_Node Z))
         (current_task current_link task_ptr: Z) (suffix: list(DL_Node Z))
         (nodes: list(DL_Node Z)) (ready_table_guard: Z)
    Require ready_table_guard != 0 &&
            task_ptr != 0 &&
            linklist == current_link &&
            linklist_node != 0 &&
            linklist_node == sched_link_of(task_ptr) &&
            nodes == app(prefix,
              cons(Build_DL_Node(current_task, current_link), suffix)) &&
            store_priority_ready_bucket(head, nodes) *
            occupy_dll_node(linklist_node)
    Ensure task_ptr != 0 && ready_table_guard != 0 &&
           store_priority_ready_bucket(
             head,
             app(prefix,
               cons(Build_DL_Node(task_ptr, linklist_node),
                 cons(Build_DL_Node(current_task, current_link), suffix))))
 */
;
/*
  Legacy local insertion contract derived from an older crtosverify version.
  Current reviewed Xizi Specs are polymorphic and differ from this interface.
  Keep this historical caller dependency explicit; the startup Stage-1 audit
  records the carrier/predicate migration needed to use the reviewed cases.
*/
void DoubleLinkListInsertNodeBefore(DoubleLinklistType *linklist,
                                    DoubleLinklistType *linklist_node)
/*@ dispatch_case
    With {A} (storeA: Z -> A -> Assertion)
             (head: Z) (nodes: list(DL_Node A)) (inserted_data: A)
    Require dll_insert_anchor(head, nodes, linklist) &&
            linklist_node != 0 &&
            store_dll(storeA, head, nodes) *
            storeA(linklist_node, inserted_data) *
            occupy_dll_node(linklist_node)
    Ensure store_dll(
             storeA, head,
             dll_insert_before_dispatch(
               head, nodes, linklist,
               Build_DL_Node(inserted_data, linklist_node)))
*/;
void DoubleLinkListInsertNodeAfter(
  DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ rrr_ready_insert_after
    With (head: Z) (nodes: list(DL_Node Z))
         (task_ptr ready_table_guard: Z)
    Require ready_table_guard != 0 &&
            task_ptr != 0 &&
            linklist_node != 0 &&
            linklist_node == sched_link_of(task_ptr) &&
            store_ready_dll_tail_view(head, nodes, linklist) *
            occupy_dll_node(linklist_node)
    Ensure task_ptr != 0 && ready_table_guard != 0 &&
           store_priority_ready_bucket(
             head,
             app(nodes, cons(Build_DL_Node(task_ptr, linklist_node), nil)))
 */
;
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist,
                                   DoubleLinklistType *linklist_node)
/*@ dispatch_case
    With {A} (storeA: addr -> A -> Assertion)
             (nodes: list(DL_Node A)) (a: A) (head: addr)
    Require dll_insert_anchor(head, nodes, linklist) &&
            linklist_node != 0 &&
            store_dll(storeA, head, nodes) *
            storeA(linklist_node, a) *
            occupy_dll_node(linklist_node)
    Ensure store_dll(
             storeA, head,
             dll_insert_after_dispatch(
               head, nodes, linklist,
               Build_DL_Node(a, linklist_node)))
*/;
/* Ready-vector specialization of the verified member-removal contract. */
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_ready_member
    With (task head : Z)
         (prefix suffix : list(DL_Node Z))
    Require
      linklist_node == sched_link_of(task) &&
      store_priority_ready_bucket(
        head,
        app(prefix, cons(ready_task_node(task), suffix)))
    Ensure
      linklist_node == sched_link_of(task) &&
      store_priority_ready_bucket(head, app(prefix, suffix)) *
      store_node_self_linked(linklist_node)
 */
;
/* Self-linked behavior; verified separately from the original helper body. */
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_sched_self
    With (task : Z) (sched : TaskSchedMemberAbs)
    Require
      linklist_node == sched_link_of(task) &&
      linklist_node != 0 &&
      store_task_sched_member(sched_link_of(task), sched) *
      store_node_self_linked(sched_link_of(task))
    Ensure
      store_task_sched_member(sched_link_of(task), sched) *
      store_node_self_linked(sched_link_of(task))
 */
;
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_self
    With (node : Z)
    Require
      linklist_node == node &&
      node != 0 &&
      store_node_self_linked(node)
    Ensure
      store_node_self_linked(node)
 */;
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_member
    With {A} (storeA: addr -> A -> Assertion)
             (head: addr)  (a: A)
             (prefix: list(DL_Node A))
             (suffix: list(DL_Node A))
    Require store_dll(storeA, head,
              app(prefix, cons(Build_DL_Node(a, linklist_node), suffix)))
    Ensure store_dll(storeA, head, app(prefix, suffix)) *
           storeA(linklist_node, a) *
           store_node_self_linked(linklist_node)
*/
;
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_from_head
    With {A} (storeA: addr -> A -> Assertion)
             (head: addr) (a: A)
             (suffix: list(DL_Node A))
    Require linklist_node != 0 && 
            store_dll(storeA, head,
              cons(Build_DL_Node(a, linklist_node), suffix))
    Ensure store_dll(storeA, head, suffix) *
           storeA(linklist_node, a) *
           store_node_self_linked(linklist_node)
*/
;
/* Ready-vector specialization of the verified payload-preserving contract. */
int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist)
/*@ ready_dll
    With (nodes : list(DL_Node Z))
    Require
      store_priority_ready_bucket(linklist, nodes)
    Ensure
      ((__return == 1 && nodes == nil) ||
       (__return == 0 && nodes != nil)) &&
      store_priority_ready_bucket(linklist, nodes)
 */
;
/* Exact, payload-preserving semantic contract of double_link.c. */
int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist)
/*@ dll
    With {A} (storeA : Z -> A -> Assertion)
             (nodes : list(DL_Node A))
    Require
      store_dll(storeA, linklist, nodes)
    Ensure
      ((__return == 1 && nodes == nil) ||
       (__return == 0 && nodes != nil)) &&
      store_dll(storeA, linklist, nodes)
 */
;
struct SysDoubleLinklistNode *DoubleLinkListGetHead(const DoubleLinklistType *linklist);
struct SysDoubleLinklistNode *DoubleLinkListGetNext(const DoubleLinklistType *linklist,
        const struct SysDoubleLinklistNode *linklist_node);
unsigned int DoubleLinkListLenGet(const DoubleLinklistType *linklist);
// #include <libc.h>
// Single List 
typedef struct SingleLinklistNode
{
    struct SingleLinklistNode *node_next;
} SysSingleLinklistType;
void InitSingleLinkList(SysSingleLinklistType *linklist);
void AppendSingleLinkList(SysSingleLinklistType *linklist, SysSingleLinklistType *linklist_node);
void SingleLinkListNodeInsert(SysSingleLinklistType *linklist, SysSingleLinklistType *linklist_node);
unsigned int SingleLinkListGetLen(const SysSingleLinklistType *linklist);
SysSingleLinklistType *SingleLinkListRmNode(SysSingleLinklistType *linklist, SysSingleLinklistType *linklist_node);
SysSingleLinklistType *SingleLinkListGetFirstNode(SysSingleLinklistType *linklist);
SysSingleLinklistType *SingleLinkListGetTailNode(SysSingleLinklistType *linklist);
SysSingleLinklistType *SingleLinkListGetNextNode(SysSingleLinklistType *linklist_node);
int IsSingleLinkListEmpty(SysSingleLinklistType *linklist);
struct IdNode
{
    uint16 id;
    DoubleLinklistType link;
};
struct IdManager
{
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    DoubleLinklistType *htable;
};
/*@ Import Coq Require Import CRTOS_Verify.lib.idnode */
/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosRules */
/*@ Import Coq Import IDNode */
/*@ Extern Coq (unit :: *) */
/*@ Extern Coq (tt : unit) */
/*@ Extern Coq (true: bool)
               (false: bool) */
/*@ Extern Coq Record IdNodeAbs {
  idnode_id: Z;
  idnode_addr: addr;
} */
/*@ Extern Coq
  (Build_IdNodeAbs: Z -> addr -> IdNodeAbs)
*/
/*@ Extern Coq Record StableIdmanager {
  idmax: Z;
  hoffset: Z;
  id_map: addr;
  htable: addr;
} */
/*@ Extern Coq Record VarIdmanager {
  idlist: list(Z);
  idbuckets: list(list(IdNodeAbs));
} */
/*@ Extern Coq
  (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
  (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager)
  (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop)
  (idmanager_first_free_id : StableIdmanager -> VarIdmanager -> option Z)
  (idmanager_query : VarIdmanager -> Z -> bool)
  (idbuckets_ok :
    Z -> Z -> list(Z) -> list(list(IdNodeAbs)) -> Prop)
  (store_idnode_insert_ready : addr -> Assertion)
  (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion)
  (store_idmanager_allocated_unlinked :
    StableIdmanager -> VarIdmanager -> addr -> Z -> Assertion)
  (store_idnode_unlinked: addr -> IdNodeAbs -> Assertion)
  (store_idnodes: addr -> list IdNodeAbs -> Assertion)
*/
int AllocId(struct IdManager *manager)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require store_idmanager(sidm, idm, manager)
    Ensure (idmanager_first_free_id(sidm, idm) == Some(__return) &&
            __return < 65536 &&
            store_idmanager_allocated_unlinked(sidm, idm, manager, __return))
           ||
           (idmanager_first_free_id(sidm, idm) == None &&
            __return == -1 &&
            store_idmanager(sidm, idm, manager))
*/;
void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager) (id: Z)
    Require store_idmanager_allocated_unlinked(sidm, idm, manager, id) *
            store_idnode_unlinked(&(idnode->link), Build_IdNodeAbs(id, idnode))
    Ensure store_idmanager(sidm,
             idmanager_link(sidm, idmanager_add(idm, id), id, idnode), manager)
*/;
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require store_idmanager(sidm, idm, manager) *
            store_idnode_insert_ready(idnode)
    Ensure (__return == -1 &&
            idmanager_first_free_id(sidm, idm) == None &&
            store_idmanager(sidm, idm, manager) *
            store_idnode_insert_ready(idnode))
           ||
           (idmanager_min_free_id(sidm, idm, __return) &&
            store_idmanager(sidm,
              idmanager_link(sidm, idmanager_add(idm, __return), __return, idnode),
              manager))
*/
;
/*@ Extern Coq
  (store_idmanager_found :
    StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
*/
struct IdNode *GetObj(struct IdManager *manager, uint16 id)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require 0 <= id && id < sidm.idmax && store_idmanager(sidm, idm, manager)
    Ensure (__return == 0 &&
            idmanager_query(idm, id) == false &&
            store_idmanager(sidm, idm, manager))
           ||
           (__return != 0 &&
            idmanager_query(idm, id) == true &&
            store_idmanager_found(sidm, idm, manager, __return, id))
*/
;
struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require 0 <= id && id < 65536 && store_idmanager(sidm, idm, manager)
    Ensure (manager == 0 &&
            __return == 0 &&
            store_idmanager(sidm, idm, manager))
           ||
           (manager != 0 &&
            __return == 0 &&
            idmanager_query(idm, id) == false &&
            store_idmanager(sidm, idm, manager))
           ||
           (manager != 0 &&
            __return != 0 &&
            idmanager_query(idm, id) == true &&
            store_idmanager_found(sidm, idm, manager, __return, id))
*/
;
/*@ Extern Coq
  (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager)
  (store_idmanager_remove_ready :
    StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
  (store_idmanager_removeobj_post :
    StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
  (UCharArray::full : Z -> Z -> list Z -> Assertion)
*/
void RemoveObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager) (id: Z)
    Require store_idmanager_remove_ready(sidm, idm, manager, idnode, id)
    Ensure store_idmanager_removeobj_post(sidm, idm, manager, idnode, id)
*/
;
void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ known_node
    With (sidm: StableIdmanager) (idm: VarIdmanager) (idnode: addr)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            idmanager_query(
              idmanager_link(sidm, idmanager_add(idm, id), id, idnode), id)
              == true &&
            store_idmanager(sidm,
              idmanager_link(sidm, idmanager_add(idm, id), id, idnode),
              manager)
    Ensure idnode != 0 &&
           &(idnode->link) != 0 &&
           store_idmanager(sidm,
             idmanager_remove(sidm,
               idmanager_link(sidm, idmanager_add(idm, id), id, idnode), id),
             manager) *
           (idnode->id == 65535) *
           store_node_self_linked(&(idnode->link))
*/
/*@ current_node
    With (sidm: StableIdmanager) (idm: VarIdmanager) (idnode: addr)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            store_idmanager_remove_ready(sidm, idm, manager, idnode, id)
    Ensure idnode != 0 &&
           &(idnode->link) != 0 &&
           store_idmanager_removeobj_post(sidm, idm, manager, idnode, id)
*/
;
/*@ Extern Coq
  (store_idnode : addr -> IdNodeAbs -> Assertion)
*/
typedef unsigned long size_t;
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskPure */
/*@ Import Coq Require Import CRTOS_Verify.lib.StructFieldOffsetAxiom */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskStackSetup */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskStackSetupProofAux */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskParseInfo */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskDescriptor */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskSchedMember */
/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosInv */
/*@ Import Coq Require Import CRTOS_Verify.libai.AssignReadyPending */
/*@ Extern Coq (TaskStatus :: *) */
/*@ Extern Coq
               (TSK_INIT : TaskStatus) (TSK_READY : TaskStatus)
               (TSK_RUNNING : TaskStatus) (TSK_SUSPEND : TaskStatus)
               (TSK_CLOSE : TaskStatus) (TSK_INVALID : TaskStatus)
               (decode_task_status : Z -> TaskStatus)
               (task_status_matches : TaskStatus -> Z -> Prop)
               (store_task_status : Z -> TaskStatus -> Assertion) */
/*@ Extern Coq (StableGlobalState :: *)
               (VarGlobalState :: *)
               (TaskStable :: *)
               (TaskState :: *)
               (AssignStable :: *)
               (DelayState :: *)
               (TaskDescriptorAbs :: *)
               (TaskSchedMemberAbs :: *)
               (TaskBaseInfoAbs :: *)
               (OsAssignReadyVectorAbs :: *)
               (VarAssignAbs :: *) */
/*@ Extern Coq
      (InsideCritical :
        StableGlobalState -> VarGlobalState -> Assertion)
      (OutsideCritical :
        StableGlobalState -> VarGlobalState -> Assertion)
      (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
      (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
      (os_inv :
        StableGlobalState -> VarGlobalState -> Assertion)
 */
/*
 * Stage-1 nested 接口对应当前非 SMP、RISC-V 配置下已关闭中断的调用者。
 * k210/interrupt.c 的 DisableLocalInterrupt 保存 mstatus 并清除 bit 3；
 * EnableLocalInterrupt 恢复保存值。因此 nested 返回值必须满足 MIE=0，
 * nested 解锁也必须检查该保存值，不能对任意 lock 承诺继续持锁。
 * 这些是新增的待审核 primitive Specs；汇编和锁计数器仍在既有临界区
 * primitive 的验证边界内，本次没有声称已经验证其 C/汇编实现。
 * ordinary/stable 使用原始 CriticalSTS 的进入/退出规则；nested 规格保持原文。
 */
x_base CriticalAreaLock(void)
/*@ ordinary
    With (sg : StableGlobalState) (st1 : VarGlobalState)
    Require
      OutsideCritical(sg, st1)
    Ensure
      exists st_lock,
        Crtos_RTrans(st1, st_lock) &&
        InsideCritical(sg, st_lock) *
        os_inv(sg, st_lock)
 */
/*@ nested
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require InsideCritical(sg, st)
    Ensure (__return & 8) == 0 && InsideCritical(sg, st)
 */
;
void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require
      Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) *
      os_inv(sg, st2)
    Ensure
      OutsideCritical(sg, st2)
 */
/*@ nested
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require (lock & 8) == 0 && InsideCritical(sg, st)
    Ensure InsideCritical(sg, st)
 */
;
struct TaskDescriptor;
struct Delay
{
 struct TaskDescriptor *task;
 x_ticks_t ticks;
 uint8 status;
 DoubleLinklistType link;
};
typedef struct Delay *DelayType;
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSetDelay */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSetDelayState */
/*@ Import Coq Import DLL */
/*@ Extern Coq (DL_Node :: * => *)
               (option :: * => *)
*/
/*@ Extern Coq Record TaskDelayAbs {
      tdTaskPtr: Z;
      tdTicks: Z;
      tdStatus: Z;
    }
*/
/* QCP 的 Record 声明只登记此切片需要的逻辑投影；不改变 Rocq record。 */
/*@ Extern Coq Record TaskSchedMemberAbs {
      tsmStat: TaskStatus;
      tsmAdvanceCnt: Z;
      tsmCurPrio: Z;
      tsmOriginTimeslice: Z;
      tsmRestTimeslice: Z;
      tsmBitmapColumn: Z;
    }
*/
/*@ Extern Coq Record TaskBaseInfoAbs {
      tbName: list(Z);
      tbFuncEntry: Z;
      tbFuncParam: Z;
      tbOriginPrio: Z;
      tbStackDepth: Z;
      tbStackStart: Z;
    }
*/
/*@ Extern Coq Record OsAssignReadyVectorAbs {
      orvBuckets: list(list(DL_Node Z));
      orvReadyGroup: Z;
      orvHighestPrio: Z;
    }
*/
/*@ Extern Coq Record VarAssignAbs {
      assignReadyVector: OsAssignReadyVectorAbs;
      assignRunningTask: Z;
      assignCurrentPriority: Z;
    }
*/
/*@ Extern Coq Record TaskStable {
      task_stable_ids: StableIdmanager;
      task_idmanager_ptr: Z;
      task_list_head: Z;
    }
*/
/*@ Extern Coq Record TaskState {
      task_desc_map: Z -> option TaskDescriptorAbs;
      task_idmanager_abs: VarIdmanager;
      task_ptr_list: list(Z);
      sched_owned_tasks: list(Z);
    }
*/
/*@ Extern Coq Record AssignStable {
      assign_ptr: Z;
    }
*/
/*@ Extern Coq Record DelayState {
      delay_inactive_map: Z -> option TaskDelayAbs;
      delay_active_nodes: list(DL_Node TaskDelayAbs);
    }
*/
/*@ Extern Coq Record StableGlobalState {
      os_task_stable: TaskStable;
      os_assign_stable: AssignStable;
      os_tick_ptr: Z;
      delay_head_ptr: Z;
    }
*/
/*@ Extern Coq Record VarGlobalState {
      os_tasks: TaskState;
      os_delays: DelayState;
      os_assign: VarAssignAbs;
      os_tick: Z;
    }
*/
/*@ Extern Coq Record TaskDescriptorAbs {
      tdBaseInfo: TaskBaseInfoAbs;
      tdSchedMember: TaskSchedMemberAbs;
      tdStackPoint: Z;
      tdDelay: Z;
      tdEventIdTrigger: Z;
      tdEventMode: Z;
      tdExstatus: Z;
      tdDone: Z;
    }
*/
/*@ Extern Coq
      (NOMEMORY : Z)
      (KOK : Z)
      (Some : {A} -> A -> option A)
      (os_global_context : StableGlobalState -> Prop)
      (task_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (task_fields : StableGlobalState -> VarGlobalState -> Assertion)
      (assign_ready_vector_addr : StableGlobalState -> Z)
      (assign_ready_published : VarGlobalState -> Prop)
      (assign_ready_pending : StableGlobalState -> VarGlobalState -> Assertion)
      (replace_global_ready_vector :
        OsAssignReadyVectorAbs -> VarGlobalState -> VarGlobalState)
      (replace_task_desc_map :
        (Z -> option TaskDescriptorAbs) -> VarGlobalState -> VarGlobalState)
      (delay_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (tick_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (task_delay_pointer_addr : Z -> Z)
      (task_delay_head_addr : Z)
      (ktask_set_delay_success : Z -> Z -> Prop)
      (ktask_set_delay_step :
        Z -> Z -> TaskDescriptorAbs -> VarGlobalState -> Z ->
        VarGlobalState -> Prop)
      (store_delay_info : Z -> TaskDelayAbs -> Assertion)
      (store_task_delay_opt :
        Z -> Z -> list(DL_Node TaskDelayAbs) -> Assertion)
      (store_delay_unlinked_info :
        Z -> TaskDelayAbs -> Assertion)
      (store_delay_dll_focus :
        Z -> list(DL_Node TaskDelayAbs) -> DL_Node TaskDelayAbs ->
        list(DL_Node TaskDelayAbs) -> Assertion)
      (store_delay_dll_frame :
        Z -> list(DL_Node TaskDelayAbs) -> DL_Node TaskDelayAbs ->
        list(DL_Node TaskDelayAbs) -> Assertion)
      (store_delay_dll_head_frame :
        Z -> list(DL_Node TaskDelayAbs) -> Z -> Assertion)
      (store_delay_dll_next_frame :
        Z -> list(DL_Node TaskDelayAbs) -> DL_Node TaskDelayAbs ->
        list(DL_Node TaskDelayAbs) -> Z -> Assertion)
      (store_delay_scan :
        Z -> Z -> list(DL_Node TaskDelayAbs) ->
        list(DL_Node TaskDelayAbs) -> Assertion)
      (delay_prefix_scanned :
        Z -> list(DL_Node TaskDelayAbs) -> Prop)
      (delay_nodes_wf : list(DL_Node TaskDelayAbs) -> Prop)
      (mkTaskDelayAbs : Z -> Z -> Z -> TaskDelayAbs)
      (delay_remove_old :
        Z -> list(DL_Node TaskDelayAbs) ->
        list(DL_Node TaskDelayAbs))
      (delay_insert_by_ticks :
        DL_Node TaskDelayAbs -> list(DL_Node TaskDelayAbs) ->
        list(DL_Node TaskDelayAbs))
      (TASK_DELAY_INACTIVE_VALUE : Z)
      (TASK_DELAY_ACTIVE_VALUE : Z)
      (heartbeat_ticks_addr : Z)
*/
x_err_t KTaskSetDelay(struct TaskDescriptor *task, x_ticks_t ticks)
/*@ inside_global <= local_resources
    With (sg : StableGlobalState) (st_before : VarGlobalState)
         (desc_before : TaskDescriptorAbs)
    Require task != 0 &&
            st_before.os_tasks.task_desc_map(task) == Some(desc_before) &&
            os_global_context(sg) &&
            task_fields(sg, st_before) *
            delay_inv(sg, st_before) *
            tick_inv(sg, st_before)
    Ensure exists st_after,
             ktask_set_delay_step(
               task, ticks, desc_before,
               st_before, __return, st_after) &&
             task_fields(sg, st_after) *
             delay_inv(sg, st_after) *
             tick_inv(sg, st_after)
 */
/*@ local_resources
    With (delay_nodes : list(DL_Node TaskDelayAbs))
         (os_tick delay_before : Z)
    Require task != 0 &&
            delay_nodes_wf(delay_nodes) &&
            store_dll(
              store_delay_info, task_delay_head_addr, delay_nodes) *
            store_uint(heartbeat_ticks_addr, os_tick) *
            store_task_delay_opt(task, delay_before, delay_nodes)
    Ensure store_uint(heartbeat_ticks_addr, os_tick) *
           (
             (__return == -NOMEMORY &&
              delay_before == 0 &&
              delay_nodes_wf(delay_nodes) &&
              store_dll(
                store_delay_info, task_delay_head_addr, delay_nodes) *
              store_task_delay_opt(task, delay_before, delay_nodes))
             ||
             (__return == KOK &&
              exists delay_after delay_nodes_after,
                delay_after != 0 &&
                ktask_set_delay_success(delay_before, delay_after) &&
                delay_nodes_after ==
                  delay_insert_by_ticks(
                    Build_DL_Node(
                      mkTaskDelayAbs(
                        task,
                        unsigned_last_nbits(os_tick + ticks, 32),
                        TASK_DELAY_ACTIVE_VALUE),
                      field_addr(delay_after, struct Delay, link)),
                    delay_remove_old(delay_before, delay_nodes)) &&
                delay_nodes_wf(delay_nodes_after) &&
                store_dll(
                  store_delay_info,
                  task_delay_head_addr,
                  delay_nodes_after) *
                data_at(
                  task_delay_pointer_addr(task), struct Delay *, delay_after))
           )
 */
;
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSchedDelayState */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskUnSetDelayState */
/*@ Extern Coq
      (ktask_unset_delay_step : Z -> VarGlobalState -> VarGlobalState -> Prop)
*/
/*@ Extern Coq (vDelayView :: *) */
/*@ Extern Coq
      (vDelayNull : vDelayView)
      (vDelayInactive : Z -> TaskDelayAbs -> vDelayView)
      (vDelayActive :
        Z -> TaskDelayAbs ->
        list(DL_Node TaskDelayAbs) ->
        list(DL_Node TaskDelayAbs) -> vDelayView)
      (store_ktask_unset_delay_pre :
        Z -> vDelayView -> Assertion)
      (store_ktask_unset_delay_post :
        Z -> vDelayView -> Assertion)
 */
x_err_t KTaskUnSetDelay(struct TaskDescriptor *task)
/*@ inside_global <= delay_unified
    With (sg : StableGlobalState) (st_before : VarGlobalState)
         (desc_before : TaskDescriptorAbs)
    Require task != 0 &&
            st_before.os_tasks.task_desc_map(task) == Some(desc_before) &&
            os_global_context(sg) &&
            task_fields(sg, st_before) *
            delay_inv(sg, st_before)
    Ensure __return == KOK &&
           exists st_after,
             ktask_unset_delay_step(
               desc_before.tdDelay, st_before, st_after) &&
             task_fields(sg, st_after) *
             delay_inv(sg, st_after)
 */
/*@ delay_unified
    With (delay_view : vDelayView)
    Require store_ktask_unset_delay_pre(task, delay_view)
    Ensure
      __return == KOK &&
      store_ktask_unset_delay_post(task, delay_view)
 */
;
void CheckTaskDelay(void);
struct TaskBaseInfo {
    char name[32]; ///< task name
    void *func_entry; ///< task function entry
    void *func_param; ///< task parameter
    uint8 origin_prio; ///< task init priority
    uint32 stack_depth; ///< task stack size
    void *stack_start; ///< task stack start address
};
typedef struct TaskBaseInfo TaskBaseInfoType;
struct TaskDyncSchedMember {
    uint8 stat; ///< task stat
    uint8 advance_cnt; ///< total time slice advance process count
    uint8 cur_prio; ///< task current priority
    x_ubase origin_timeslice; ///< task init timeslice
    x_ubase rest_timeslice; ///< task remaining timeslice
    DoubleLinklistType sched_link; ///< task sched list
    uint32 bitmap_column;
    DelayType delay;
};
typedef struct TaskDyncSchedMember TaskDyncSchedMembeType;
struct KTaskDone;
struct TaskDescriptor
{
    void *stack_point; ///< stack point
    TaskDyncSchedMembeType task_dync_sched_member; ///< task dynamic sched member
    TaskBaseInfoType task_base_info; ///< task base information
    uint32 event_id_trigger; ///< event ops (event trigger )
    uint32 event_mode; ///<  event mode (AND/OR/AUTOCLEAN)
    x_err_t exstatus; ///< exception status
    DoubleLinklistType link; ///< manage list
    struct IdNode id; ///< task id
    struct KTaskDone *Done;
};
typedef struct TaskDescriptor *KTaskDescriptorType;
struct OsAssignReadyVector {
    DoubleLinklistType priority_ready_vector[32];
    uint32 priority_ready_group;
    x_ubase highest_prio;
};
struct KTaskDone
{
    int32 (*init)(KTaskDescriptorType task,
                        const char *name,
                        void (*entry)(void *parameter),
                        void *parameter,
                        uint32 stack_depth,
                        uint8 priority);
    x_err_t (*start)(KTaskDescriptorType task);
    x_err_t (*Delete)(KTaskDescriptorType task);
    x_err_t (*delay)(KTaskDescriptorType task, x_ticks_t ticks);
    x_err_t (*mdelay)(KTaskDescriptorType task,uint32 ms);
    x_err_t (*prioset)(KTaskDescriptorType task, uint8 prio);
    x_err_t (*suspend)(KTaskDescriptorType task);
    x_err_t (*wake)(KTaskDescriptorType task);
};
int32 KTaskCreate(const char *name,
                             void (*entry)(void *parameter),
                             void *parameter,
                             uint32 stack_depth,
                             uint8 priority);
void KTaskQuit(void);
void KUpdateExstatus(x_err_t no);
int *KObtainExstatus(void);
KTaskDescriptorType GetKTaskDescriptor(void);
KTaskDescriptorType KTaskSearch(char *name);
x_err_t StartupKTask(int32 id);
x_err_t KTaskDelete(int32 id);
x_err_t YieldOsAssign(void);
x_err_t DelayKTask(x_ticks_t tick);
x_err_t MdelayKTask(uint32 ms);
// KTaskPrioSet is bugged, dont use this
x_err_t KTaskPrioSet(int32 id, uint8 prio);
x_err_t KTaskCoreCombine(int32 id, uint8 coreid);
x_err_t KTaskCoreUnCombine(int32 id);
x_err_t SuspendKTask(int32 id);
x_err_t KTaskWakeup(int32 id);
void KTaskTimeout(void *parameter);
void InitIdleKTask(void);
void IdleKTaskExec(void);
KTaskDescriptorType GetIdleKTaskDescripter(void);
void KTaskOsAssign(void);
void KTaskOsAssignRemoveKTask(struct TaskDescriptor *task);
void RoundRobinRemainTaskTimesliceInit(struct TaskDescriptor *task);
void RoundRobinRemainReadyVectorInsert(struct TaskDescriptor *task, struct OsAssignReadyVector* ready_table);
void RoundRobinRemainTaskTimesliceUpdate(struct TaskDescriptor *task);
x_err_t LinklistSuspend(DoubleLinklistType *list,struct TaskDescriptor *task,uint8 flag);
x_err_t LinklistResume(DoubleLinklistType *list);
x_err_t LinklistResumeAll(DoubleLinklistType *list);
void HwSendIpi(int ipi_vector, unsigned int cpu_mask);
void KTaskIdDelete(int32 id);
struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id);
/*@ Extern Coq (TaskBaseInfoAbs :: *) */
/*@ Extern Coq (StackRegisterContextAbs :: *) */
/*@ Extern Coq (store_string_n : Z -> Z -> list Z -> Assertion)
               (store_task_base_info : Z -> TaskBaseInfoAbs -> Assertion)
               (store_ktask_stack :
                  Z -> Z -> list Z ->
                  StackRegisterContextAbs -> Assertion)
               (store_stack_register_context_slots :
                  Z -> StackRegisterContextAbs -> Assertion)
               (ktask_context_regs_setup :
                  Z -> Z -> Z -> Z -> Z -> StackRegisterContextAbs)
               (UCharArray::full : Z -> Z -> list Z -> Assertion)
               (UIntArray::full : Z -> Z -> list Z -> Assertion)
               (CHAR_SHARP : Z)
               (OxFADEFACE : Z)
               (SAVED_MSTATUS : Z)
               (REG_COUNT : Z)
               (REG_LENGTH : Z)
               (unsigned_last_nbits : Z -> Z -> Z)
               (ktask_stack_aligned_top : Z -> Z -> Z -> Z)
               (ktask_stack_context_addr : Z -> Z -> Z -> Z)
               (ktask_stack_setup_layout_ok : Z -> Z -> Z -> Prop)
               (ktask_stack_context_layout_ok : Prop)
               (aligned_reglen : Z -> Prop)
               (ktask_xubase_value : Z -> Prop)
               (kss_raw_top : TaskBaseInfoAbs -> Z)
               (kss_aligned_top : TaskBaseInfoAbs -> Z)
               (kss_context_addr : TaskBaseInfoAbs -> Z) */
struct StackRegisterContext
{
    x_ubase epc;
    x_ubase ra;
    x_ubase mstatus;
    x_ubase gp;
    x_ubase tp;
    x_ubase t0;
    x_ubase t1;
    x_ubase t2;
    x_ubase s0_fp;
    x_ubase s1;
    x_ubase a0;
    x_ubase a1;
    x_ubase a2;
    x_ubase a3;
    x_ubase a4;
    x_ubase a5;
    x_ubase a6;
    x_ubase a7;
    x_ubase s2;
    x_ubase s3;
    x_ubase s4;
    x_ubase s5;
    x_ubase s6;
    x_ubase s7;
    x_ubase s8;
    x_ubase s9;
    x_ubase s10;
    x_ubase s11;
    x_ubase t3;
    x_ubase t4;
    x_ubase t5;
    x_ubase t6;
};
uint8 KTaskStackSetup(struct TaskDescriptor *task)
/*@ With info
    Require task != 0 &&
            ktask_xubase_value(&KTaskQuit) &&
            ktask_stack_setup_layout_ok(
              info.tbStackStart, info.tbStackDepth, REG_LENGTH) &&
            has_permission(&(task->stack_point)) *
            store_task_base_info(task, info) *
            UCharArray::full(
              info.tbStackStart, info.tbStackDepth,
              repeat_Z(CHAR_SHARP, info.tbStackDepth))
    Ensure __return == 0 &&
            store(&(task->stack_point), kss_context_addr(info)) *
            store_task_base_info(task, info) *
            store_ktask_stack(
              info.tbStackStart, info.tbStackDepth,
              repeat_Z(
                CHAR_SHARP,
                kss_context_addr(info) - info.tbStackStart),
              ktask_context_regs_setup(
                info.tbFuncEntry, info.tbFuncParam, &KTaskQuit,
                SAVED_MSTATUS, OxFADEFACE))
 */
;
inline void NULL_PARAM_CHECK_1(void *p)
/*@
    Require emp
    Ensure p != 0
*/
;
inline void NULL_PARAM_CHECK_2(void (*entry)(void *parameter))
/*@
    Require emp
    Ensure entry != 0
*/
;
/*@ Extern Coq (TaskBaseInfoAbs :: *) */
/*@ Extern Coq (StackRegisterContextAbs :: *) */
/*@ Extern Coq (store_string : Z -> list Z -> Assertion)
               (crtos_valid_string : list Z -> Prop)
               (string_length : list Z -> Z)
               (ktask_xubase_value : Z -> Prop)
               (kss_context_addr : TaskBaseInfoAbs -> Z)
               (mkTaskBaseInfoAbs :
                  list Z -> Z -> Z -> Z -> Z -> Z -> TaskBaseInfoAbs)
               (KOK : Z)
               (NOMEMORY : Z)
               (INVALID : Z)
               (PRIORITY_MAX : Z)
               (NAME_MAX_SIZE : Z)
               (REG_LENGTH : Z)
               (ktask_stack_aligned_top : Z -> Z -> Z -> Z)
               (ktask_stack_context_addr : Z -> Z -> Z -> Z)
               (ktask_stack_setup_layout_ok : Z -> Z -> Z -> Prop)
               (aligned_reglen : Z -> Prop)
               (store_ktask_stack :
                  Z -> Z -> list Z ->
                  StackRegisterContextAbs -> Assertion)
               (ktask_context_regs_setup :
                  Z -> Z -> Z -> Z -> Z -> StackRegisterContextAbs)
               (CHAR_SHARP : Z)
               (OxFADEFACE : Z)
               (SAVED_MSTATUS : Z)
               (store_task_base_info :
                  Z -> TaskBaseInfoAbs -> Assertion)
               (has_permission_ktask_base_info : Z -> Assertion)
               (ktask_init_input_arguments_ok :
                  Z -> Z -> Z -> Z -> Z -> Prop)
               (assert_task_base_info_values :
                  TaskBaseInfoAbs -> list Z ->
                  Z -> Z -> Z -> Z -> Prop)
               (has_permission_ktask_base_info_start0 : Z -> Assertion)
               (ALIGN_SIZE : Z)
               (addr_aligned : Z -> Z -> Prop)
 */
/*
 * Verification-facing replacement for
 * CONTAINER_OF(..., TaskDescriptor, task_dync_sched_member.sched_link).
 * The helper has no memory effect.  Its alignment premise is the local fact
 * required by the centralized 32-bit TaskDescriptor layout axiom.
 */
struct TaskDescriptor *CONTAINER_OF_TASK_SCHED(
    DoubleLinklistType *sched_link_ptr)
/*@ With task_ptr
    Require addr_aligned(task_ptr, ALIGN_SIZE) &&
            sched_link_ptr == sched_link_of(task_ptr) &&
            emp
    Ensure __return == task_ptr &&
           addr_aligned(__return, ALIGN_SIZE) &&
           sched_link_ptr ==
             &(__return->task_dync_sched_member.sched_link)
 */
;
void *KERNEL_MALLOC(uint32 size)
/*@ Require 0 <= size && size <= UINT_MAX
    Ensure (__return == 0) ||
           (0 < __return &&
            __return <= UINT_MAX - size &&
            addr_aligned(__return, ALIGN_SIZE) &&
            CharArray::undef_full(__return, size))
 */
;
void *x_malloc(x_size_t size)
/*@ delay_object
    Require 0 <= size && size <= UINT_MAX
    Ensure (__return == 0) ||
           (0 < __return &&
            __return <= UINT_MAX - size &&
            addr_aligned(__return, ALIGN_SIZE) &&
            CharArray::undef_full(__return, size))
 */
;
void *memset(void *s, int c, size_t n)
/*@ Require 0 <= n && n <= UINT_MAX &&
            0 <= c && c <= 127 &&
            CharArray::undef_full(s, n)
    Ensure __return == s && CharArray::full(s, n, repeat_Z(c, n))
*/
;
/*@ Printing Coq Name crtos_valid_string := Crtos_C_Rules.valid_string */
/*@ Printing Strategy Name crtos_valid_string := Crtos_C_Rules.valid_string */
char *strncpy(char *dest, const char *src, size_t n)
/*@ With src_str
    Require 0 <= n && n <= UINT_MAX &&
            CharArray::undef_full(dest, n) *
            store_string(src, src_str)
    Ensure  __return == dest &&
            crtos_valid_string(sublist(0, n, src_str)) &&
            CharArray::full(dest, n,
              app(sublist(0, n, src_str),
                  repeat_Z(0, n - string_length(sublist(0, n, src_str))))) *
            store_string(src, src_str)
*/
;
static x_err_t _KTaskBaseInfoParse(KTaskDescriptorType task,
                            const char *name,
                            void (*entry)(void *parameter),
                            void *parameter,
                            uint32 stack_depth,
                            uint8 priority)
/*@ With src_name
    Require ktask_init_input_arguments_ok(
              entry, parameter, &KTaskQuit,
              stack_depth, priority) &&
            has_permission(&(task->stack_point)) *
            has_permission_ktask_base_info(task) *
            store_string(name, src_name)
    Ensure ktask_init_input_arguments_ok(
             entry, parameter, &KTaskQuit,
             stack_depth, priority) &&
           task != 0 && name != 0 && entry != 0 &&
           ((__return == -INVALID &&
              priority >= PRIORITY_MAX &&
              has_permission(&(task->stack_point)) *
              has_permission_ktask_base_info(task) *
              store_string(name, src_name)) ||
            (__return == -NOMEMORY &&
              priority < PRIORITY_MAX &&
              has_permission(&(task->stack_point)) *
              has_permission_ktask_base_info_start0(task) *
              store_string(name, src_name)) ||
            (__return == KOK &&
              exists info,
              info.tbStackStart != 0 &&
              priority < PRIORITY_MAX &&
              assert_task_base_info_values(
                info, sublist(0, NAME_MAX_SIZE - 1, src_name),
                entry, parameter, stack_depth, priority) &&
              store(&(task->stack_point), kss_context_addr(info)) *
              store_task_base_info(task, info) *
              store_string(name, src_name) *
              store_ktask_stack(
                info.tbStackStart, info.tbStackDepth,
                repeat_Z(
                  CHAR_SHARP,
                  kss_context_addr(info) - info.tbStackStart),
                ktask_context_regs_setup(
                  info.tbFuncEntry, info.tbFuncParam, &KTaskQuit,
                  SAVED_MSTATUS, OxFADEFACE))))
 */
;
/*@ Extern Coq
    (mkTaskSchedMemberAbs :
        TaskStatus -> Z -> Z -> Z -> Z -> Z -> TaskSchedMemberAbs)
      (has_permission_task_sched_member : Z -> TaskStatus -> Assertion)
*/
// Copied from /home/cheng/osroot/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/assign_roundrobinremain.c
void RoundRobinRemainTaskTimesliceInit(struct TaskDescriptor *task)
/*@ Require
      has_permission(
        &(task->task_dync_sched_member.origin_timeslice)) *
      has_permission(
        &(task->task_dync_sched_member.rest_timeslice))
    Ensure
      task != 0 &&
      store(
        &(task->task_dync_sched_member.origin_timeslice),
        unsigned int, 10) *
      store(
        &(task->task_dync_sched_member.rest_timeslice),
        unsigned int, 10)
 */
;
int32 _InitKTask(KTaskDescriptorType task,
              const char *name,
       void (*entry)(void *parameter),
       void *parameter,
       uint32 stack_depth,
       uint8 priority);
x_err_t _StartupKTask(KTaskDescriptorType task);
x_err_t _DeleteKTask(KTaskDescriptorType task);
x_err_t _DelayKTask(KTaskDescriptorType task, x_ticks_t ticks);
x_err_t _MdelayKTask(KTaskDescriptorType task, uint32 ms);
x_err_t _KTaskPrioSet(KTaskDescriptorType task, uint8 prio);
x_err_t _SuspendKTask(KTaskDescriptorType task);
x_err_t _KTaskWakeup(KTaskDescriptorType task);
DoubleLinklistType xiaoshan_task_head ={&xiaoshan_task_head, &xiaoshan_task_head}; ///< global task manage list
// k_task_id_manager中的ID MAX NUM和桶的大小初始化后固定；
// 抽象状态应为分可变和不可变的部分
// DECLARE_ID_MANAGER(k_task_id_manager, ID_NUM_MAX);
// =================================================>
uint8 __id_map_k_task_id_manager[16];
DoubleLinklistType __htable_k_task_id_manager[16];
struct IdManager k_task_id_manager = {
    .id_max = 128,
    .hoffset = 16,
    .id_map = __id_map_k_task_id_manager,
    .htable = __htable_k_task_id_manager
};
// read-only, not protected by lock
static struct KTaskDone Done = {
    .init = _InitKTask,
    .start = _StartupKTask,
    .Delete = _DeleteKTask,
    .delay = _DelayKTask,
    .mdelay = _MdelayKTask,
    .prioset = _KTaskPrioSet,
    .suspend = _SuspendKTask,
    .wake = _KTaskWakeup
};
DoubleLinklistType xiaoshan_delay_head = {&xiaoshan_delay_head, &xiaoshan_delay_head};
/*@ Import Coq Require Import CRTOS_Verify.libai.RRR_ReadyInsert */
/*@ Import Coq Require Import CRTOS_Verify.libai.ReadyViews */
/*@ Extern Coq
      (task_fields_except_sched : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
      (rrr_ready_bucket_head : Z -> Z -> Z)
      (store_os_assign_ready_vector : Z -> OsAssignReadyVectorAbs -> Assertion)
      (store_ready_dll_tail_frame : Z -> list(DL_Node Z) -> Z -> Assertion)
      (store_ready_dll_head_frame : Z -> list(DL_Node Z) -> Z -> Assertion)
      (store_rrr_vector_except : Z -> Z -> list(DL_Node Z) -> OsAssignReadyVectorAbs -> Assertion)
      (os_assign_ready_vector_replace_bucket : OsAssignReadyVectorAbs -> Z -> list(DL_Node Z) -> OsAssignReadyVectorAbs)
 */
/*@ Import Coq Require Import CRTOS_Verify.libai.TaskOwnedMemoryLemmas */
/*@ Import Coq Require Import CRTOS_Verify.libai.TaskSchedViews */
/*@ Import Coq Require Import CRTOS_Verify.libai.AssignInCritical */
/*@ Extern Coq
      (store_assign_remove_sched_frame : Z -> TaskSchedMemberAbs -> Assertion)
      (task_fields_except_sched : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
      (store_task_sched_except_cur_prio : Z -> TaskSchedMemberAbs -> Assertion)
      (store_task_sched_except_bitmap_column : Z -> TaskSchedMemberAbs -> Assertion)
      (store_task_sched_except_advance_cnt : Z -> TaskSchedMemberAbs -> Assertion)
 */
/*@ Import Coq Require Import CRTOS_Verify.libai.RRR_ReadyInsert */
/*@ Extern Coq (OsAssignReadyVectorAbs :: *) */
/*@ Extern Coq (task_fields_except_sched :
      StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion) */
/*@ Extern Coq
      (os_assign_ready_vector_replace_bucket :
        OsAssignReadyVectorAbs -> Z -> list(DL_Node Z) -> OsAssignReadyVectorAbs)
      (rrr_ready_bucket_head : Z -> Z -> Z)
      (store_rrr_vector_except :
        Z -> Z -> list(DL_Node Z) ->
        OsAssignReadyVectorAbs -> Assertion)
      (store_ready_dll_tail_frame :
        Z -> list(DL_Node Z) -> Z -> Assertion)
      (store_ready_dll_tail_view :
        Z -> list(DL_Node Z) -> Z -> Assertion)
      (store_os_assign_ready_vector :
        Z -> OsAssignReadyVectorAbs -> Assertion)
 */
/*@ include strategies "ready_views.strategies" */
/*@ include strategies "task_sched_view.strategies" */
void FifoTaskTimesliceInit(struct TaskDescriptor *task)
/*@ Require
      has_permission(
        &(task->task_dync_sched_member.origin_timeslice)) *
      has_permission(
        &(task->task_dync_sched_member.rest_timeslice))
    Ensure
      task != 0 &&
      store(
        &(task->task_dync_sched_member.origin_timeslice),
        unsigned int, 0) *
      store(
        &(task->task_dync_sched_member.rest_timeslice),
        unsigned int, 0)
 */
{
    NULL_PARAM_CHECK_1(task);
    task->task_dync_sched_member.origin_timeslice = (0);
 task->task_dync_sched_member.rest_timeslice = (0);
}
/*
 * 使用项目 RRR 尾插调用已有的本地 DLL 接口。
 * 通过 assign_ready_pending 访问全局就绪表，只替换当前优先级桶。
 * 调度标量由 task_inv 保留并归还；位图和最高优先级由外层函数同步。
 * FIFO/RR 不扫描旧任务字段；待插入任务的优先级和基址对齐由 task_inv 提供。
 */
void FifoReadyVectorInsert(struct TaskDescriptor *task, struct OsAssignReadyVector* ready_table)
/*@ With (sg : StableGlobalState)
         (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (before : OsAssignReadyVectorAbs)
    Require
      before == st.os_assign.assignReadyVector &&
      ready_table == assign_ready_vector_addr(sg) &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, st) *
      assign_ready_pending(sg, st) *
      occupy_dll_node(sched_link_of(task))
    Ensure
      task != 0 && ready_table != 0 &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, replace_global_ready_vector(
        os_assign_ready_vector_replace_bucket(
          before, desc.tdSchedMember.tsmCurPrio,
          app(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
              cons(ready_task_node(task), nil))), st)) *
      assign_ready_pending(sg, replace_global_ready_vector(
        os_assign_ready_vector_replace_bucket(
          before, desc.tdSchedMember.tsmCurPrio,
          app(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
              cons(ready_task_node(task), nil))), st))
 */
{
    /* 标量由 task_inv 局部取还；链表仅转移 sched_link。 */
    DoubleLinklistType* tail = (0);
    NULL_PARAM_CHECK_1(task);
    NULL_PARAM_CHECK_1(ready_table);
    /* 策略按桶访问需求打开就绪视图，保留发布关系。 */
    /*@ st.os_tasks.task_desc_map(task) == Some(desc) &&
        task_fields(sg, st)
        which implies
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
        addr_aligned(task, ALIGN_SIZE) &&
        task_fields(sg, st)
     */
    tail = ready_table->priority_ready_vector[task->task_dync_sched_member.cur_prio].node_prev;
 DoubleLinkListInsertNodeAfter(tail, &(task->task_dync_sched_member.sched_link))
        /*@ where (rrr_ready_insert_after)
              head = rrr_ready_bucket_head(
                ready_table@pre, desc.tdSchedMember.tsmCurPrio),
              nodes = Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
              task_ptr = task@pre,
              ready_table_guard = ready_table@pre */;
    /* 只更新全局状态中的目标桶；位图、缓存及其余全局分量保持原值。 */
    /*@ task@pre != 0 &&
        before == st.os_assign.assignReadyVector &&
        ready_table@pre == assign_ready_vector_addr(sg) &&
        st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
        assign_ready_published(st) &&
        task_fields(sg, st) *
        store_os_assign_ready_vector(ready_table@pre,
          os_assign_ready_vector_replace_bucket(
            before, desc.tdSchedMember.tsmCurPrio,
            app(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
                cons(ready_task_node(task@pre), nil))))
        which implies
        task_fields(sg, replace_global_ready_vector(
          os_assign_ready_vector_replace_bucket(
            before, desc.tdSchedMember.tsmCurPrio,
            app(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
                cons(ready_task_node(task@pre), nil))), st)) *
        assign_ready_pending(sg, replace_global_ready_vector(
          os_assign_ready_vector_replace_bucket(
            before, desc.tdSchedMember.tsmCurPrio,
            app(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
                cons(ready_task_node(task@pre), nil))), st))
     */
}
void FifoTaskTimesliceUpdate()
{
    return;
}
