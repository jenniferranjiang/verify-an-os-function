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
/*@ include strategies "node_self_linked.strategies" */
/*@ Extern Coq
      (dll_nodes_nonzero : {A} -> list(DL_Node A) -> Prop)
      (dllseg_shift :
        {A} -> (Z -> A -> Assertion) -> Z -> Z ->
        list(DL_Node A) -> Assertion)
      (dllseg_shift_rev :
        {A} -> (Z -> A -> Assertion) -> Z -> Z ->
        list(DL_Node A) -> Assertion)
 */
/*
 * 直接验证 m_double_linklist.h 的既有多态成员删除接口；C 语句逐字对应原 double_link.c。
 * prefix/suffix 的 payload 保持抽象，仅暴露删除操作写入的四个指针槽。
 */
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_member */
{
    /*@ store_dll(storeA, head,
          app(prefix, cons(Build_DL_Node(a, linklist_node), suffix)))
        which implies
        exists previous next,
          head != 0 && linklist_node != 0 &&
          previous != 0 && next != 0 &&
          dll_nodes_nonzero(app(prefix, suffix)) &&
          dllseg_shift(storeA, head, previous, prefix) *
          store_ptr(field_addr(previous, struct SysDoubleLinklistNode, node_next), linklist_node) *
          (linklist_node->node_prev == previous) *
          (linklist_node->node_next == next) *
          store_ptr(field_addr(next, struct SysDoubleLinklistNode, node_prev), linklist_node) *
          dllseg_shift_rev(storeA, next, head, suffix) *
          storeA(linklist_node, a)
     */
    /*@ Given previous next */
    linklist_node->node_next->node_prev = linklist_node->node_prev;
    linklist_node->node_prev->node_next = linklist_node->node_next;
    linklist_node->node_next = linklist_node;
    linklist_node->node_prev = linklist_node;
    /*@ head != 0 &&
        dll_nodes_nonzero(app(prefix, suffix)) &&
        dllseg_shift(storeA, head, previous, prefix) *
        store_ptr(field_addr(previous, struct SysDoubleLinklistNode, node_next), next) *
        store_ptr(field_addr(next, struct SysDoubleLinklistNode, node_prev), previous) *
        dllseg_shift_rev(storeA, next, head, suffix)
        which implies
        store_dll(storeA, head, app(prefix, suffix))
     */
}
