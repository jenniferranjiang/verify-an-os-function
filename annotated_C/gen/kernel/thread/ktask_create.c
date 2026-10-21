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
// #include <libc.h>
typedef struct SysDoubleLinklistNode
{
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
// Single List 
typedef struct SingleLinklistNode
{
    struct SingleLinklistNode *node_next;
} SysSingleLinklistType;
void InitDoubleLinkList(DoubleLinklistType *linklist_head);
void DoubleLinkListInsertNodeBefore(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node);
int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist);
struct SysDoubleLinklistNode *DoubleLinkListGetHead(const DoubleLinklistType *linklist);
struct SysDoubleLinklistNode *DoubleLinkListGetNext(const DoubleLinklistType *linklist,
        const struct SysDoubleLinklistNode *linklist_node);
unsigned int DoubleLinkListLenGet(const DoubleLinklistType *linklist);
void InitSingleLinkList(SysSingleLinklistType *linklist);
void AppendSingleLinkList(SysSingleLinklistType *linklist, SysSingleLinklistType *linklist_node);
void SingleLinkListNodeInsert(SysSingleLinklistType *linklist, SysSingleLinklistType *linklist_node);
unsigned int SingleLinkListGetLen(const SysSingleLinklistType *linklist);
SysSingleLinklistType *SingleLinkListRmNode(SysSingleLinklistType *linklist, SysSingleLinklistType *linklist_node);
SysSingleLinklistType *SingleLinkListGetFirstNode(SysSingleLinklistType *linklist);
SysSingleLinklistType *SingleLinkListGetTailNode(SysSingleLinklistType *linklist);
SysSingleLinklistType *SingleLinkListGetNextNode(SysSingleLinklistType *linklist_node);
int IsSingleLinkListEmpty(SysSingleLinklistType *linklist);
typedef struct SysDoubleLinklistNode DoubleLinklistType;
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
/*@ Import Coq Require Import CRTOS_Verify.lib.dll */
/*@ Import Coq Require Import CRTOS_Verify.lib.idnode */
/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosRules */
/*@ Import Coq Require Import CRTOS_Verify.lib.mynode */
/*@ Import Coq Import DLL */
/*@ Import Coq Import IDNode */
/*@ Import Coq Import MyNode */
/*@ Extern Coq addr := Z */
/*@ Extern Coq (DL_Node :: * => *) */
/*@ Extern Coq (unit :: *) */
/*@ Extern Coq (tt : unit) */
/*@ Extern Coq (true: bool)
               (false: bool) */
/*@ Extern Coq
  (Build_DL_Node: {A} -> A -> Z -> DL_Node A)
  (store_dll: {A} -> (Z -> A -> Assertion) -> Z ->
                     list(DL_Node A) -> Assertion)
  (nil: {A} -> list A)
  (cons: {A} -> A -> list A -> list A)
  (app: {A} -> list A -> list A -> list A)
*/
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
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require store_idmanager(sm, m, manager)
    Ensure (idmanager_first_free_id(sm, m) == Some(__return) &&
            __return < 65536 &&
            store_idmanager_allocated_unlinked(sm, m, manager, __return))
           ||
           (idmanager_first_free_id(sm, m) == None &&
            __return == -1 &&
            store_idmanager(sm, m, manager))
*/;
void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm: StableIdmanager) (m: VarIdmanager) (id: Z)
    Require store_idmanager_allocated_unlinked(sm, m, manager, id) *
            store_idnode_unlinked(&(idnode->link), Build_IdNodeAbs(id, idnode))
    Ensure store_idmanager(sm,
             idmanager_link(sm, idmanager_add(m, id), id, idnode), manager)
*/;
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require store_idmanager(sm, m, manager) *
            store_idnode_insert_ready(idnode)
    Ensure (__return == -1 &&
            idmanager_first_free_id(sm, m) == None &&
            store_idmanager(sm, m, manager) *
            store_idnode_insert_ready(idnode))
           ||
           (idmanager_min_free_id(sm, m, __return) &&
            store_idmanager(sm,
              idmanager_link(sm, idmanager_add(m, __return), __return, idnode),
              manager))
*/
;
/*@ Extern Coq
  (store_idmanager_found :
    StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
*/
struct IdNode *GetObj(struct IdManager *manager, uint16 id)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require 0 <= id && id < sm.idmax && store_idmanager(sm, m, manager)
    Ensure (__return == 0 &&
            idmanager_query(m, id) == false &&
            store_idmanager(sm, m, manager))
           ||
           (__return != 0 &&
            idmanager_query(m, id) == true &&
            store_idmanager_found(sm, m, manager, __return, id))
*/
;
struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require 0 <= id && id < 65536 && store_idmanager(sm, m, manager)
    Ensure (manager == 0 &&
            __return == 0 &&
            store_idmanager(sm, m, manager))
           ||
           (manager != 0 &&
            __return == 0 &&
            idmanager_query(m, id) == false &&
            store_idmanager(sm, m, manager))
           ||
           (manager != 0 &&
            __return != 0 &&
            idmanager_query(m, id) == true &&
            store_idmanager_found(sm, m, manager, __return, id))
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
/*@ With (sm: StableIdmanager) (m: VarIdmanager) (id: Z)
    Require store_idmanager_remove_ready(sm, m, manager, idnode, id)
    Ensure store_idmanager_removeobj_post(sm, m, manager, idnode, id)
*/
;
void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ known_node
    With (sm: StableIdmanager) (m: VarIdmanager) (idnode: addr)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            idmanager_query(
              idmanager_link(sm, idmanager_add(m, id), id, idnode), id)
              == true &&
            store_idmanager(sm,
              idmanager_link(sm, idmanager_add(m, id), id, idnode),
              manager)
    Ensure idnode != 0 &&
           &(idnode->link) != 0 &&
           store_idmanager(sm,
             idmanager_remove(sm,
               idmanager_link(sm, idmanager_add(m, id), id, idnode), id),
             manager) *
           (idnode->id == 65535) *
           (idnode->link.node_prev == &(idnode->link)) *
           (idnode->link.node_next == &(idnode->link))
*/
;
/*@ Extern Coq
  (store_idnode : addr -> IdNodeAbs -> Assertion)
  (occupy_dll_node : addr -> Assertion)
  (store_dll_node_self : addr -> Assertion)
*/
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist,
                                   DoubleLinklistType *linklist_node)
/*@ With {A} (storeA: addr -> A -> Assertion)
             (nodes: list(DL_Node A)) (a: A) (head: addr)
    Require linklist == head &&
            linklist_node != 0 &&
            store_dll(storeA, linklist, nodes) *
            storeA(linklist_node, a) *
            occupy_dll_node(linklist_node)
    Ensure linklist == head &&
           store_dll(storeA, linklist,
             cons(Build_DL_Node(a, linklist_node), nodes))
*/;
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ With {A} (storeA: addr -> A -> Assertion)
             (head: addr)  (a: A)
             (prefix: list(DL_Node A))
             (suffix: list(DL_Node A))
    Require store_dll(storeA, head,
              app(prefix, cons(Build_DL_Node(a, linklist_node), suffix)))
    Ensure store_dll(storeA, head, app(prefix, suffix)) *
           storeA(linklist_node, a) *
           (linklist_node->node_next == linklist_node) *
           (linklist_node->node_prev == linklist_node)
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
           store_dll_node_self(linklist_node)
*/
;
/* the type of error */
typedef signed char int8;
typedef signed short int16;
typedef signed int int32;
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef signed long long int64;
typedef unsigned long long uint64;
typedef int x_bool;
typedef int x_base;
typedef unsigned long x_ubase;
typedef x_base x_err_t;
typedef uint32 x_time_t;
typedef uint32 x_ticks_t;
typedef unsigned long size_t;
/*@ Import Coq Require Import CRTOS_Verify.lib.TaskSetStatus */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskStackSetup */
/*@ Import Coq Require Import CRTOS_Verify.lib.TaskStackSetupProofAux */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskParseInfo */
/*@ Import Coq Require Import CRTOS_Verify.lib.TaskDescriptor */
/*@ Import Coq Require Import CRTOS_Verify.lib.TaskSchedMember */
/*@ Extern Coq (TaskSchedMemberAbs :: *)
               (DL_Node :: * => *) */
/*@ Extern Coq
      (nil : {A} -> list A)
      (store_task_sched_member :
        Z -> TaskSchedMemberAbs -> Assertion)
      (store_dll :
        {A} -> (Z -> A -> Assertion) ->
        Z -> list (DL_Node A) -> Assertion)
 */
void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require
      undef_data_at(&(linklist_head->node_prev)) *
      undef_data_at(&(linklist_head->node_next))
    Ensure
      store_dll(
        store_task_sched_member, linklist_head, nil)
 */;
struct TaskDescriptor;
struct Delay
{
 struct TaskDescriptor *task;
 x_ticks_t ticks;
 uint8 status;
 DoubleLinklistType link;
};
typedef struct Delay *DelayType;
x_err_t KTaskSetDelay(struct TaskDescriptor *task, x_ticks_t ticks);
x_err_t KTaskUnSetDelay(struct TaskDescriptor *task);
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
               (store_ktask_stack_memset : Z -> Z -> Assertion)
               (store_stack_register_context_slots :
                  Z -> StackRegisterContextAbs -> Assertion)
               (ktask_stack_context_region :
                  Z -> Z -> Z -> StackRegisterContextAbs)
               (UIntArray::full : Z -> Z -> list Z -> Assertion)
               (repeat_z : Z -> Z -> list Z)
               (OxFADEFACE : Z)
               (REG_COUNT : Z)
               (REG_LENGTH : Z)
               (unsigned_last_nbits : Z -> Z -> Z)
               (ktask_stack_aligned_top : Z -> Z -> Z -> Z)
               (ktask_stack_context_addr : Z -> Z -> Z -> Z)
               (ktask_stack_setup_layout_ok : Z -> Z -> Z -> Prop)
               (ktask_stack_context_layout_ok : Prop)
               (aligned_reglen : Z -> Prop)
               (ktask_xubase_value : Z -> Prop)
               (tbName : TaskBaseInfoAbs -> list Z)
               (tbFuncEntry : TaskBaseInfoAbs -> Z)
               (tbFuncParam : TaskBaseInfoAbs -> Z)
               (tbOriginPrio : TaskBaseInfoAbs -> Z)
               (tbStackDepth : TaskBaseInfoAbs -> Z)
               (tbStackStart : TaskBaseInfoAbs -> Z)
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
              tbStackStart(info), tbStackDepth(info), REG_LENGTH) &&
            has_permission(&(task->stack_point)) *
            store_task_base_info(task, info) *
            store_ktask_stack_memset(tbStackStart(info), tbStackDepth(info))
    Ensure __return == 0 && exists context_addr aligned_top,
            aligned_top == ktask_stack_aligned_top(
                tbStackStart(info), tbStackDepth(info), REG_LENGTH) &&
            context_addr == ktask_stack_context_addr(
                tbStackStart(info), tbStackDepth(info), REG_LENGTH) &&
            ktask_stack_setup_layout_ok(
                tbStackStart(info), tbStackDepth(info), REG_LENGTH) &&
            aligned_reglen(context_addr) && aligned_reglen(aligned_top) &&
            store(&(task->stack_point), context_addr) *
            store_task_base_info(task, info) *
            store_ktask_stack_memset(
                tbStackStart(info), context_addr - tbStackStart(info)) *
            store_stack_register_context_slots(
                context_addr,
                ktask_stack_context_region(
                tbFuncEntry(info), tbFuncParam(info), &KTaskQuit)) *
            store_ktask_stack_memset(
                aligned_top,
                tbStackStart(info) + tbStackDepth(info) - aligned_top)
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
               (string_length : list Z -> Z)
               (ktask_xubase_value : Z -> Prop)
               (tbName : TaskBaseInfoAbs -> list Z)
               (tbFuncEntry : TaskBaseInfoAbs -> Z)
               (tbFuncParam : TaskBaseInfoAbs -> Z)
               (tbOriginPrio : TaskBaseInfoAbs -> Z)
               (tbStackDepth : TaskBaseInfoAbs -> Z)
               (tbStackStart : TaskBaseInfoAbs -> Z)
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
               (store_ktask_stack_memset : Z -> Z -> Assertion)
               (store_stack_register_context_slots :
                  Z -> StackRegisterContextAbs -> Assertion)
               (ktask_stack_context_region :
                  Z -> Z -> Z -> StackRegisterContextAbs)
               (store_task_base_info :
                  Z -> TaskBaseInfoAbs -> Assertion)
               (has_permission_ktask_base_info : Z -> Assertion)
               (ktask_init_input_arguments_ok :
                  Z -> Z -> Z -> Z -> Z -> Prop)
               (assert_task_base_info_values :
                  TaskBaseInfoAbs -> list Z ->
                  Z -> Z -> Z -> Z -> Prop)
               (has_permission_ktask_base_info_start0 : Z -> Assertion)
               (aligned_4 : Z -> Prop)
               (ktask_descriptor_field_offset_ok : Z -> Prop)
 */
void *KERNEL_MALLOC(uint32 size)
/*@ Require 0 <= size && size <= UINT_MAX
    Ensure (__return == 0) ||
           (0 < __return &&
            __return <= UINT_MAX - size &&
            aligned_4(__return) &&
            ktask_descriptor_field_offset_ok(__return) &&
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
char *strncpy(char *dest, const char *src, size_t n)
/*@ With src_str
    Require 0 <= n && n <= UINT_MAX &&
            CharArray::undef_full(dest, n) *
            store_string(src, src_str)
    Ensure  __return == dest &&
            store_string_n(dest, n, sublist(0, n, src_str)) *
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
              exists info aligned_top context_addr,
              tbStackStart(info) != 0 &&
              aligned_top == ktask_stack_aligned_top(
                tbStackStart(info), tbStackDepth(info), REG_LENGTH) &&
              context_addr == ktask_stack_context_addr(
                tbStackStart(info), tbStackDepth(info), REG_LENGTH) &&
              priority < PRIORITY_MAX &&
              assert_task_base_info_values(
                info, sublist(0, NAME_MAX_SIZE, src_name),
                entry, parameter, stack_depth, priority) &&
              ktask_stack_setup_layout_ok(
                tbStackStart(info), tbStackDepth(info), REG_LENGTH) &&
              aligned_reglen(context_addr) && aligned_reglen(aligned_top) &&
              store(&(task->stack_point), context_addr) *
              store_task_base_info(task, info) *
              store_string(name, src_name) *
              store_ktask_stack_memset(
                tbStackStart(info), context_addr - tbStackStart(info)) *
              store_stack_register_context_slots(
                context_addr,
                ktask_stack_context_region(
                  tbFuncEntry(info), tbFuncParam(info), &KTaskQuit)) *
              store_ktask_stack_memset(
                aligned_top,
                tbStackStart(info) + tbStackDepth(info) - aligned_top)))
 */
;
/*@ Extern Coq
    (mkTaskSchedMemberAbs :
        Z -> Z -> Z -> Z -> Z -> Z -> TaskSchedMemberAbs)
      (has_permission_task_sched_member : Z -> Z -> Assertion)
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
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskCreate */
/*@ Import Coq Require Import CRTOS_Verify.lib.GlobalInvarants */
/*@ Extern Coq
      (StableGlobalState :: *)
      (CrtosGlobalState :: *)
      (KProtocolPhase :: *)
*/
/*@ Extern Coq
      (TaskInsideCritical : StableGlobalState -> CrtosGlobalState -> Assertion)
      (TaskOutsideCritical : StableGlobalState -> CrtosGlobalState -> Assertion)
      (TaskRTrans : CrtosGlobalState -> CrtosGlobalState -> Prop)
      (TaskGTrans : CrtosGlobalState -> CrtosGlobalState -> Prop)
      (crtos_inv : StableGlobalState -> CrtosGlobalState -> Assertion)
*/
/*@ Extern Coq
      (KS_NORMAL : KProtocolPhase)
      (KS_CREATE_PENDING : KProtocolPhase)
      (KOK : Z)
      (KERROR : Z)
      (PRIORITY_MAX : Z)
      (NAME_MAX_SIZE : Z)
      (TASK_INIT : Z)
      (TASK_STAT_MASK : Z)
      (store_string : Z -> list Z -> Assertion)
      (ktask_init_input_arguments_ok :
        Z -> Z -> Z -> Z -> Z -> Prop)
      (has_permission_ktask_base_info : Z -> Assertion)
      (has_permission_ktask_base_info_start0 : Z -> Assertion)
      (assert_task_base_info_values :
        TaskBaseInfoAbs -> list Z -> Z -> Z -> Z -> Z -> Prop)
      (store_task_descriptor_base_info_init_post :
        Z -> TaskBaseInfoAbs -> Z -> Assertion)
      (has_permission_task_sched_member : Z -> Z -> Assertion)
      (has_permission_task_descriptor : Z -> Z -> Assertion)
      (mkTaskSchedMemberAbs :
        Z -> Z -> Z -> Z -> Z -> Z -> TaskSchedMemberAbs)
      (replace_task_protocol_phase : KProtocolPhase -> CrtosGlobalState -> CrtosGlobalState)
*/
/*@ Extern Coq
      (ID_MAX_NUM : Z)
      (TaskOutsideCritical :
        StableGlobalState -> CrtosGlobalState -> Assertion)
      (ktask_create_nomemory :
        StableGlobalState ->
        CrtosGlobalState -> CrtosGlobalState -> Prop)
      (ktask_create_init_failure :
        StableGlobalState ->
        CrtosGlobalState -> CrtosGlobalState -> Prop)
      (ktask_create_success :
        StableGlobalState ->
        CrtosGlobalState -> CrtosGlobalState ->
        Z -> Z -> Prop)
      (store_created_task_descriptor :
        Z -> Z -> TaskBaseInfoAbs -> TaskSchedMemberAbs ->
        StableGlobalState -> Assertion)
      (store_zeroed_task_descriptor : Z -> Assertion)
      (store_ktask_create_private_zeroed : Z -> Assertion)
      (store_task_descriptor_free_ready : Z -> Z -> Assertion)
      (store_ktask_create_init_frame : Z -> Assertion)
      (store_ktask_create_init_failure_private : Z -> Z -> Z -> Assertion)
      (store_ktask_create_shared_open :
        StableGlobalState -> CrtosGlobalState -> Assertion)
      (unit_empty : Z -> unit -> Assertion)
      (stable_idmanager_abs : StableGlobalState -> StableIdmanager)
      (task_idmanager_abs : CrtosGlobalState -> VarIdmanager)
      (task_link_list : CrtosGlobalState -> list(DL_Node unit))
      (ktask_create_publish_state :
        StableGlobalState -> CrtosGlobalState -> Z -> Z -> CrtosGlobalState)
      (ktask_create_rollback_state :
        StableGlobalState -> CrtosGlobalState -> Z ->
        list(DL_Node unit) -> list(DL_Node unit) -> CrtosGlobalState)
      (store_idnode_insert_ready : Z -> Assertion)
      (occupy_dll_node : Z -> Assertion)
      (aligned_4 : Z -> Prop)
      (ktask_descriptor_field_offset_ok : Z -> Prop)
*/
static void _KTaskDyncMemberInit(KTaskDescriptorType task)
/*@ With origin_prio old_stat
    Require
      store(&(task->task_base_info.origin_prio),
        unsigned char, origin_prio) *
      has_permission_task_sched_member(task, old_stat) *
      has_permission(&(task->exstatus))
    Ensure
      task != 0 &&
      store_dll(store_task_sched_member,
        &(task->task_dync_sched_member.sched_link), nil) *
      store_task_sched_member(&(task->task_dync_sched_member.sched_link),
        mkTaskSchedMemberAbs(
          TASK_INIT | (old_stat & unsigned_last_nbits(~TASK_STAT_MASK, 8)),
          0, origin_prio, 10, 10, 0)) *
      store(&(task->task_base_info.origin_prio),
            unsigned char, origin_prio) *
      store(&(task->exstatus), int, 0)
 */
;
int32 _InitKTask(KTaskDescriptorType task,
              const char *name,
       void (*entry)(void *parameter),
       void *parameter,
       uint32 stack_depth,
       uint8 priority)
/*@ With src_name old_stat
    Require
      entry != 0 &&
      ktask_init_input_arguments_ok(
        entry, parameter, &KTaskQuit,
        stack_depth, priority) &&
      store_string(name, src_name) *
      has_permission(&(task->stack_point)) *
      has_permission_ktask_base_info(task) *
      has_permission_task_sched_member(task, old_stat) *
      has_permission(&(task->exstatus))
    Ensure
      ktask_init_input_arguments_ok(
        entry, parameter, &KTaskQuit,
        stack_depth, priority) &&
      task != 0 && name != 0 && entry != 0 &&
      store_string(name, src_name) *
      (
        ( __return == -KERROR &&
          store_ktask_create_init_failure_private(
            task, old_stat, priority)
        ) ||
        (__return == KOK &&
          exists info,
            tbStackStart(info) != 0 &&
            priority < PRIORITY_MAX &&
            assert_task_base_info_values(
              info, sublist(0, NAME_MAX_SIZE, src_name),
              entry, parameter, stack_depth, priority) &&
            store_task_descriptor_base_info_init_post(
              task, info, &KTaskQuit) *
            store_dll(
              store_task_sched_member,
              &(task->task_dync_sched_member.sched_link), nil) *
            store_task_sched_member(
              &(task->task_dync_sched_member.sched_link),
              mkTaskSchedMemberAbs(
                TASK_INIT |
                  (old_stat &
                    unsigned_last_nbits(~TASK_STAT_MASK, 8)),
                0, priority, 10, 10, 0)) *
            store(&(task->exstatus), int, 0))
      )
 */
;
x_base CriticalAreaLock(void)
/*@ With (sg : StableGlobalState) (st1 : CrtosGlobalState)
    Require
      TaskOutsideCritical(sg, st1)
    Ensure
      exists st_lock,
        TaskRTrans(st1, st_lock) &&
        TaskInsideCritical(sg, st_lock) *
        crtos_inv(sg, st_lock)
 */
;
void CriticalAreaUnLock(x_base lock)
/*@ With (sg : StableGlobalState) (st1 st2 : CrtosGlobalState)
    Require
      TaskGTrans(st1, st2) &&
      TaskInsideCritical(sg, st1) *
      crtos_inv(sg, st2)
    Ensure
      TaskOutsideCritical(sg, st2)
 */
;
// A specific Spec for free tasks
void KERNEL_FREE(void* pointer)
/*@ With (status : Z)
    Require pointer != 0 &&
      store_task_descriptor_free_ready(pointer, status)
    Ensure emp
 */
;
/**
 * 
 * This function init a kernel task in dynamic way .
 *
 * @param name task name
 * @param parameter task process function
 * @param parameter task arg
 * @param stack_depth task stack size
 * @param priority task priority
 * @param tick task time slice
 * 
 * @return EOK on success; ERROR/ENOMEMORY on failure
 */
int32 KTaskCreate(const char *name,
       void (*entry)(void *parameter),
       void *parameter,
       uint32 stack_depth,
       uint8 priority)
/*@ With (sg : StableGlobalState)
         (st_bef : CrtosGlobalState)
         (src_name : list Z)
    Require
      entry != 0 &&
      ktask_init_input_arguments_ok(
        entry, parameter, &KTaskQuit,
        stack_depth, priority) &&
      store_string(name, src_name) *
      TaskOutsideCritical(sg, st_bef)
    Ensure
      ktask_init_input_arguments_ok(
        entry, parameter, &KTaskQuit,
        stack_depth, priority) &&
      entry != 0 &&
      store_string(name, src_name) *
      (
        (exists (st_aft : CrtosGlobalState),
          __return == -NOMEMORY &&
          ktask_create_nomemory(sg, st_bef, st_aft) &&
          TaskOutsideCritical(sg, st_aft))
        ||
        (exists (st_aft : CrtosGlobalState),
          __return == -KERROR &&
          ktask_create_init_failure(sg, st_bef, st_aft) &&
          TaskOutsideCritical(sg, st_aft))
        ||
        (exists (st_aft : CrtosGlobalState)
                (task : addr)
                (info : TaskBaseInfoAbs)
                (sched : TaskSchedMemberAbs),
          0 <= __return && __return < ID_MAX_NUM &&
          priority < PRIORITY_MAX &&
          assert_task_base_info_values(
            info, sublist(0, NAME_MAX_SIZE, src_name),
            entry, parameter, stack_depth, priority) &&
          ktask_create_success(
            sg, st_bef, st_aft, task, __return) &&
          TaskOutsideCritical(sg, st_aft) *
          store_created_task_descriptor(task, __return, info, sched, sg)
        )
      )
 */
{
 struct TaskDescriptor *task = (0);
    int32 id = 0;
    x_base lock = 0;
 // KDEBUG_NOT_IN_INTERRUPT;
 task = (struct TaskDescriptor *)KERNEL_MALLOC(sizeof(struct TaskDescriptor));
 if (task == (0)) {
        // KPrintf("%s %d TaskDescriptor %s malloc failed.\n",__func__,__LINE__,name);
  return -5;
 }
 memset(task, 0x0, sizeof(struct TaskDescriptor));
  /*@ aligned_4(task) &&
      ktask_descriptor_field_offset_ok(task) &&
      CharArray::full(
        task, sizeof(struct TaskDescriptor),
        repeat_Z(0, sizeof(struct TaskDescriptor)))
      which implies
      aligned_4(task) &&
      ktask_descriptor_field_offset_ok(task) &&
      store_zeroed_task_descriptor(task)
   */
  /*@ task > 0 &&
      ktask_descriptor_field_offset_ok(task) &&
      store_zeroed_task_descriptor(task)
      which implies
      ktask_descriptor_field_offset_ok(task) &&
      store_ktask_create_private_zeroed(task) *
      store_idnode_insert_ready(&(task->id)) *
      occupy_dll_node(&(task->link))
   */
  lock = CriticalAreaLock();
    /*@ Given st_lock */
    /*@ TaskInsideCritical(sg, st_lock) *
        crtos_inv(sg, st_lock)
        which implies
        TaskInsideCritical(sg, st_lock) *
        store_idmanager(
          stable_idmanager_abs(sg), task_idmanager_abs(st_lock),
          &k_task_id_manager) *
        store_dll(
          unit_empty,
          &xiaoshan_task_head, task_link_list(st_lock))
     */
    id = IdInsertObj(&k_task_id_manager, &task->id);
    /*@ (id == -1 &&
          idmanager_first_free_id(
            stable_idmanager_abs(sg), task_idmanager_abs(st_lock)) == None &&
          store_idmanager(
            stable_idmanager_abs(sg), task_idmanager_abs(st_lock),
            &k_task_id_manager) *
          store_idnode_insert_ready(&(task->id)))
        ||
        (idmanager_min_free_id(
           stable_idmanager_abs(sg), task_idmanager_abs(st_lock), id) &&
         store_idmanager(
           stable_idmanager_abs(sg),
           idmanager_link(
             stable_idmanager_abs(sg),
             idmanager_add(task_idmanager_abs(st_lock), id),
             id, &(task->id)),
           &k_task_id_manager))
        which implies
        (id == -1 &&
          idmanager_first_free_id(
            stable_idmanager_abs(sg), task_idmanager_abs(st_lock)) == None &&
          store_idmanager(
            stable_idmanager_abs(sg), task_idmanager_abs(st_lock),
            &k_task_id_manager) *
          store_idnode_insert_ready(&(task->id)))
        ||
        (0 <= id &&
         idmanager_min_free_id(
           stable_idmanager_abs(sg), task_idmanager_abs(st_lock), id) &&
         store_idmanager(
           stable_idmanager_abs(sg),
           idmanager_link(
             stable_idmanager_abs(sg),
             idmanager_add(task_idmanager_abs(st_lock), id),
             id, &(task->id)),
           &k_task_id_manager))
     */
    if (id < 0) {
          // KPrintf("%s %d task id malloc failed.\n",__func__,__LINE__);
          /*@ TaskInsideCritical(sg, st_lock) *
              store_idmanager(
                stable_idmanager_abs(sg), task_idmanager_abs(st_lock),
                &k_task_id_manager) *
              store_dll(
                unit_empty,
                &xiaoshan_task_head, task_link_list(st_lock))
              which implies
              TaskGTrans(st_lock, st_lock) &&
              TaskInsideCritical(sg, st_lock) *
              crtos_inv(sg, st_lock)
           */
          CriticalAreaUnLock(lock);
          /*@ store_ktask_create_private_zeroed(task) *
              store_idnode_insert_ready(&(task->id)) *
              occupy_dll_node(&(task->link))
              which implies
              store_task_descriptor_free_ready(task, 0)
           */
          KERNEL_FREE(task);
          return -5;
      }
    /*@ idmanager_min_free_id(
          stable_idmanager_abs(sg), task_idmanager_abs(st_lock), id) &&
        store_idmanager(
          stable_idmanager_abs(sg),
          idmanager_link(
            stable_idmanager_abs(sg),
            idmanager_add(task_idmanager_abs(st_lock), id),
            id, &(task->id)),
          &k_task_id_manager)
        which implies
        0 <= id && id < 65536 &&
        idmanager_query(
          idmanager_link(
            stable_idmanager_abs(sg),
            idmanager_add(task_idmanager_abs(st_lock), id),
            id, &(task->id)), id) == true &&
        store_idmanager(
          stable_idmanager_abs(sg),
          idmanager_link(
            stable_idmanager_abs(sg),
            idmanager_add(task_idmanager_abs(st_lock), id),
            id, &(task->id)),
          &k_task_id_manager)
     */
    // fp (* 初始化==插入*)
    /*@ task > 0 &&
        ktask_descriptor_field_offset_ok(task) && emp
        which implies
        &(task->link) != 0 &&
        unit_empty(&(task->link), tt)
     */
    DoubleLinkListInsertNodeAfter(&xiaoshan_task_head, &(task->link))
      /*@ where storeA = unit_empty,
                  nodes = task_link_list(st_lock), a = tt,
                  head = &xiaoshan_task_head; A = unit */;
    /*@ store_ktask_create_private_zeroed(task)
        which implies
        has_permission(&(task->stack_point)) *
        has_permission_ktask_base_info(task) *
        has_permission_task_sched_member(task, 0) *
        has_permission(&(task->exstatus)) *
        (task->Done == 0) *
        store_ktask_create_init_frame(task)
     */
    task->Done = &Done;
  /*@ emp
      which implies
      KOK == 0 && KERROR == 1 && emp
   */
  CriticalAreaUnLock(lock);
  // `task->Done->init` changed to `_InitKTask(...)` before funct pointer supported
  if( _InitKTask(task, name, entry, parameter, stack_depth, priority) == 0 ) {
      // HOOK(hook.task.hook_TaskCreate, (task));
      /*@ TaskInsideCritical(sg, st_lock) *
          store_idmanager(
            stable_idmanager_abs(sg),
            idmanager_link(
              stable_idmanager_abs(sg),
              idmanager_add(task_idmanager_abs(st_lock), id),
              id, &(task->id)),
            &k_task_id_manager) *
          store_dll(
            unit_empty,
            &xiaoshan_task_head,
            cons(Build_DL_Node(tt, &(task->link)),
                 task_link_list(st_lock)))
          which implies
          TaskGTrans(
            st_lock, ktask_create_publish_state(sg, st_lock, task, id)) &&
          TaskInsideCritical(sg, st_lock) *
          crtos_inv(
            sg, ktask_create_publish_state(sg, st_lock, task, id))
       */
      // CriticalAreaUnLock(lock);
      return id;
  } else {
      // KPrintf("%s %d task init failed.\n",__func__,__LINE__);
      lock = CriticalAreaLock();
        /*@ 0 <= id && id < 65536 &&
            idmanager_query(
              idmanager_link(
                stable_idmanager_abs(sg),
                idmanager_add(task_idmanager_abs(st_lock), id),
                id, &(task->id)), id) == true &&
            store_idmanager(
              stable_idmanager_abs(sg),
              idmanager_link(
                stable_idmanager_abs(sg),
                idmanager_add(task_idmanager_abs(st_lock), id),
                id, &(task->id)), &k_task_id_manager)
            which implies
            &k_task_id_manager != 0 &&
            0 <= id && id < 65536 &&
            idmanager_query(
              idmanager_link(
                stable_idmanager_abs(sg),
                idmanager_add(task_idmanager_abs(st_lock), id),
                id, &(task->id)), id) == true &&
            store_idmanager(
              stable_idmanager_abs(sg),
              idmanager_link(
                stable_idmanager_abs(sg),
                idmanager_add(task_idmanager_abs(st_lock), id),
                id, &(task->id)),
              &k_task_id_manager)
         */
        IdRemoveObj(&k_task_id_manager, id)
          /*@ where(known_node)
                sm = stable_idmanager_abs(sg),
                m = task_idmanager_abs(st_lock),
                idnode = &(task->id) */;
        DoubleLinkListRmNode(&task->link)
          /*@ where(remove_from_head)
                storeA = unit_empty,
                head = &xiaoshan_task_head,
                a = tt,
                suffix = task_link_list(st_lock); A = unit */;
      /*@ &(task->id) != 0 &&
          &(task->id.link) != 0 &&
          TaskInsideCritical(sg, st_lock) *
          store_idmanager(
            stable_idmanager_abs(sg),
            idmanager_remove(
              stable_idmanager_abs(sg),
              idmanager_link(
                stable_idmanager_abs(sg),
                idmanager_add(task_idmanager_abs(st_lock), id),
                id, &(task->id)), id),
            &k_task_id_manager) *
          (task->id.id == 65535) *
          (task->id.link.node_prev == &(task->id.link)) *
          (task->id.link.node_next == &(task->id.link)) *
          store_dll(
            unit_empty,
            &xiaoshan_task_head, task_link_list(st_lock))
          which implies
          TaskGTrans(
            st_lock,
            ktask_create_rollback_state(
              sg,
              ktask_create_publish_state(sg, st_lock, task, id),
              id, nil, task_link_list(st_lock))) &&
          &(task->id) != 0 &&
          &(task->id.link) != 0 &&
          TaskInsideCritical(sg, st_lock) *
          crtos_inv(
            sg,
            ktask_create_rollback_state(
              sg,
              ktask_create_publish_state(sg, st_lock, task, id),
              id, nil, task_link_list(st_lock))) *
          (task->id.id == 65535) *
          (task->id.link.node_prev == &(task->id.link)) *
          (task->id.link.node_next == &(task->id.link))
       */
      CriticalAreaUnLock(lock);
      /*@ &(task->id) != 0 &&
          &(task->id.link) != 0 &&
          store_ktask_create_init_failure_private(task, 0, priority) *
          (task->Done == &Done) *
          store_ktask_create_init_frame(task) *
          (task->id.id == 65535) *
          (task->id.link.node_prev == &(task->id.link)) *
          (task->id.link.node_next == &(task->id.link)) *
          store_dll_node_self(&(task->link))
          which implies
          priority == priority &&
          store_task_descriptor_free_ready(task, 0)
       */
      KERNEL_FREE(task);
      return -1;
  }
}
