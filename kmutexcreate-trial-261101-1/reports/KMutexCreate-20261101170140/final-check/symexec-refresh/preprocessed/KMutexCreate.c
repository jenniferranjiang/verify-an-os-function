# 0 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/KMutexCreate.c"
# 0 "<built-in>"
#define __STDC__ 1
# 0 "<built-in>"
#define __STDC_VERSION__ 201710L
# 0 "<built-in>"
#define __STDC_UTF_16__ 1
# 0 "<built-in>"
#define __STDC_UTF_32__ 1
# 0 "<built-in>"
#define __STDC_HOSTED__ 0
# 0 "<command-line>"
# 1 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/KMutexCreate.c"
# 1 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/../include/slice_types.h" 1

#define KMUTEX_SLICE_TYPES_H 
/* ILP32 non-SMP slice. Full layouts of every accessed struct are retained.
 * Origin: kernel/include/xs_{base,klist,id,mutex}.h and configured xsconfig.h. */
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef int int32;
typedef long x_base;
typedef unsigned long x_size_t;
typedef unsigned long size_t;
struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
};
typedef struct SysDoubleLinklistNode DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct IdManager {
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    DoubleLinklistType *htable;
};
struct TaskDescriptor;
struct Mutex {
    struct IdNode id;
    uint16 val;
    uint8 recursive_cnt;
    uint8 origin_prio;
    struct TaskDescriptor *holder;
    DoubleLinklistType pend_list;
    DoubleLinklistType link;
};
#define NONE ((void *)0)
#define ENOMEMORY 5
#define UINT_MAX 4294967295U
#define ALIGN_SIZE 4
#define ID_NUM_MAX 128
#define ID_HTABLE_SIZE 16
#define KERNEL_MUTEX 
extern struct IdManager k_mutex_id_manager;
extern DoubleLinklistType k_mutex_list;
# 2 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/KMutexCreate.c" 2
# 1 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/../include/logic.h" 1

#define KMUTEX_LOGIC_H 
/* Only logic declarations: canonical function contracts live in the src C files. */
/*@ Import Coq Require Import CRTOS_Verify.lib.KMutexCreate */
/*@ Import Coq Require Import CRTOS_Verify.lib.DoubleLinkListSpec */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskWakeup */
/*@ Import Coq Import DLL IDNode */
# 1 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/../include/monad.h" 1

#define CRTOS_MONAD_H 

/* Native QCP MonadErr declarations shared by all abstract-program Specs. */
/*@ Import Coq From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope monad */
/*@ Extern Coq (program :: * => * => *) (unit :: *) */
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Extern Coq
      (safeExec : {Sigma} {A} ->
        (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
      (return : {Sigma} {A} -> A -> program Sigma A)
      (tt : unit)
 */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */
# 9 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/../include/logic.h" 2
/*@ Extern Coq addr := Z */
/*@ Extern Coq (StableGlobalState :: *) (VarGlobalState :: *)
               (StableIdmanager :: *) (VarIdmanager :: *)
               (DL_Node :: * => *) */
/*@ Extern Coq
 (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
 (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
 (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
 (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
 (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
 (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
 (abs_mutex_create : StableGlobalState -> program (VarGlobalState -> Prop) Z)
 (addr_aligned : Z -> Z -> Prop)
 (MutexRaw : addr -> Assertion)
 (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion)
 (store_idnode_insert_ready : addr -> Assertion)
 (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop)
 (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
 (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager)
 (CharArray::undef_full : Z -> Z -> Assertion)
 (CharArray::full : Z -> Z -> list Z -> Assertion)
 (repeat_Z : {A} -> A -> Z -> list A)
 (store_node_self_linked : addr -> Assertion)
 (store_dll : {A} -> (addr -> A -> Assertion) -> addr -> list (DL_Node A) -> Assertion)
 (occupy_dll_node : addr -> Assertion)
 (nil : {A} -> list A)
 (cons : {A} -> A -> list A -> list A)
 (app : {A} -> list A -> list A -> list A)
 (Build_DL_Node : {A} -> A -> addr -> DL_Node A)
 (dll_insert_anchor : {A} -> addr -> list (DL_Node A) -> addr -> Prop)
 (dll_insert_after_dispatch : {A} -> addr -> list (DL_Node A) -> addr -> DL_Node A -> list (DL_Node A))
 (sched_link_of : addr -> addr)
 (store_ready_dll_tail_view : addr -> list (DL_Node Z) -> addr -> Assertion)
 (store_priority_ready_bucket : addr -> list (DL_Node Z) -> Assertion)
*/
# 3 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/KMutexCreate.c" 2

/* Fixed done.MutexCreate dispatch and debug removal: see source-analysis.md. */
int32 _MutexCreate(void)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_mutex_create(sg), X) &&
            OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == -5 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        0 <= __return && __return < 128 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
 */;

int32 KMutexCreate(void)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_mutex_create(sg), X) &&
            OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == -5 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        0 <= __return && __return < 128 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
 */
{
    return _MutexCreate() /*@ where (outside_critical) sg = sg, before = before, X = X */;
}
