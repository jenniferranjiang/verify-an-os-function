/* Host fixture only. The included function bodies are verbatim authoritative
 * mutex.c excerpts. Stubs cannot model scheduling or prove OS correctness.
 * Unused blocking paths abort, so this run exercises only ordinary successful
 * recursion/release and the public wrapper's integer argument conversion. */
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "../../annotated_C/include/slice_types.h"
struct TaskDescriptor {
    struct { char name[32]; } task_base_info;
    struct { uint8 cur_prio; DoubleLinklistType sched_link; } task_dync_sched_member;
    int32 exstatus;
};
#define EOK 0
#define ERROR 1
#define ETIMEOUT 2
#define RET_TRUE 1
#define LINKLIST_FLAG_PRIO 1
#define NULL_PARAM_CHECK(p) assert((p) != 0)
#define KDEBUG_IN_KTASK_CONTEXT ((void)0)
#define SYS_KDEBUG_LOG(level,args) ((void)0)
#define DO_KTASK_ASSIGN assert(!"unexpected schedule path")
#define CONTAINER_OF(p,t,f) ((t *)((char *)(p)-offsetof(t,f)))
#define SYS_DOUBLE_LINKLIST_ENTRY(p,t,f) CONTAINER_OF(p,t,f)
static struct Mutex object;
static struct TaskDescriptor task_a, task_b;
static struct TaskDescriptor *current;
struct IdManager k_mutex_id_manager;
DoubleLinklistType k_mutex_list;
static uint16 observed_getter_id;
static struct TaskDescriptor *GetKTaskDescriptor(void) { return current; }
static unsigned int CalculateTickFromTimeMs(unsigned int ms) { return ms; }
static x_base CriticalAreaLock(void) { return 0; }
static void CriticalAreaUnLock(x_base value) { (void)value; }
static void LinklistSuspend(DoubleLinklistType *l, struct TaskDescriptor *t, int f)
{ (void)l; (void)t; (void)f; assert(!"unexpected wait path"); }
static void KTaskSetDelay(struct TaskDescriptor *t, int ticks)
{ (void)t; (void)ticks; assert(!"unexpected timer path"); }
static int IsDoubleLinkListEmpty(const DoubleLinklistType *l)
{ return l->node_next == l; }
static void LinklistResume(DoubleLinklistType *l)
{ (void)l; assert(!"unexpected waiter handoff"); }
static struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
{
    assert(manager == &k_mutex_id_manager);
    observed_getter_id = id;
    return id == 0 ? &object.id : NULL;
}
static int32 _MutexObtain(struct Mutex *mutex, int32 msec);
static struct { int32 (*MutexObtain)(struct Mutex *, int32); } done = {_MutexObtain};
#include "extracted_mutex_functions.inc"
int main(void)
{
    /* Exactly the released field values produced by _MutexCreate. */
    object.id.id = 0;
    object.val = 1;
    object.holder = NULL;
    object.origin_prio = 255;
    object.recursive_cnt = 0;
    object.pend_list.node_next = &object.pend_list;
    object.pend_list.node_prev = &object.pend_list;
    current = &task_a;
    for (unsigned int n = 1; n <= 257; ++n) {
        assert(_MutexObtain(&object, 0) == EOK);
        if (n >= 255)
            printf("A successful obtains=%u recursive_cnt=%u\n", n, object.recursive_cnt);
    }
    assert(object.recursive_cnt == 1);
    assert(_MutexAbandon(&object) == EOK);
    assert(object.val == 1 && object.holder == NULL);
    printf("A releases=1 outstanding_successful_obtains=256 val=%u holder=NULL\n", object.val);
    current = &task_b;
    assert(_MutexObtain(&object, 0) == EOK);
    assert(object.holder == &task_b);
    puts("B obtained successfully while A has 256 unmatched obtains: premature release witnessed");
    assert(KMutexObtain(65536, 0) == EOK);
    assert(observed_getter_id == 0);
    puts("KMutexObtain(65536,0) passed id=0 to uint16 IdGetObj and returned EOK: ID alias witnessed");
    return 0;
}
