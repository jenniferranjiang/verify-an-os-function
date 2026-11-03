/* Host regression fixture. Real function bodies are extracted by run.py.
 * Hardware, dispatch/ready-vector storage and context switching are modeled;
 * this does not claim a target-board test or a C implementation proof. */
#include <assert.h>
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef uint8_t uint8;
typedef uint16_t uint16;
typedef uint32_t uint32;
typedef uint64_t uint64;
typedef int32_t int32;
typedef long x_base;
typedef unsigned long x_ubase;
typedef long x_err_t;
typedef uint32 x_ticks_t;
typedef int x_bool;
#define NONE NULL
#define EOK 0
#define ERROR 1
#define ENOMEMORY 5
#define EINVALED 10
#define ETIMEOUT 2
#define RET_TRUE 1
#define RET_FALSE 0
#define KTASK_READY 1
#define KTASK_SUSPEND 2
#define KTASK_RUNNING 3
#define TASK_DELAY_ACTIVE 1
#define TASK_DELAY_INACTIVE 0
#define LINKLIST_FLAG_FIFO 0
#define LINKLIST_FLAG_PRIO 1
#define EVENT_AND 1U
#define EVENT_OR 2U
#define EVENT_AUTOCLEAN 4U
#define EVENT_EVENTS_MASK 0x1fffffffU
#define EVENT_OPTIONS_MASK 7U
#define TICK_PER_SECOND 100U
#define MIN_TICKS 1U
#define NULL_PARAM_CHECK(p) assert((p) != NULL)
#define CHECK(p) assert(p)
#define KDEBUG_IN_KTASK_CONTEXT assert(current.task_dync_sched_member.stat == KTASK_RUNNING)
#define SYS_KDEBUG_LOG(section,args) ((void)0)
#define HOOK(function,args) ((void)0)
#define CONTAINER_OF(p,T,m) ((T *)((char *)(p) - offsetof(T,m)))
#define SYS_DOUBLE_LINKLIST_ENTRY(p,T,m) CONTAINER_OF(p,T,m)
#define DOUBLE_LINKLIST_FOR_EACH(n,h) for ((n)=(h)->node_next;(n)!=(h);(n)=(n)->node_next)
#define DISABLE_INTERRUPT() disable_irq()
#define ENABLE_INTERRUPT(x) restore_irq(x)
#define DO_KTASK_ASSIGN schedule_model()
struct SysDoubleLinklistNode { struct SysDoubleLinklistNode *node_next,*node_prev; };
typedef struct SysDoubleLinklistNode DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct TaskDescriptor;
struct Delay { struct TaskDescriptor *task; x_ticks_t ticks; uint8 status; DoubleLinklistType link; };
struct KTaskDone { x_err_t (*suspend)(struct TaskDescriptor *); x_err_t (*wake)(struct TaskDescriptor *); };
struct TaskDescriptor {
    struct { uint8 stat,cur_prio; DoubleLinklistType sched_link; struct Delay *delay; } task_dync_sched_member;
    struct IdNode id;
    uint32 event_id_trigger,event_mode;
    x_err_t exstatus;
    struct KTaskDone *Done;
};
typedef struct TaskDescriptor *KTaskDescriptorType;
struct Event { struct IdNode id; uint32 options:3,events:29; DoubleLinklistType pend_list,link; };
struct ReadyDone { void (*insert)(struct TaskDescriptor *); void (*remove)(struct TaskDescriptor *); };
static struct { struct ReadyDone *ready_vector_done; } Assign;
static struct TaskDescriptor current,neighbor;
static struct Event event;
static struct Delay delay_storage;
static DoubleLinklistType ready_head,xiaoshan_delay_head;
static uint16 KTaskOsAssignLockNest;
static int irq_enabled=1,allocation_failure,allocation_calls,schedule_calls,simulate_timeout;
static int ready_inserts,ready_removes;
static x_base disable_irq(void) { x_base old=irq_enabled; irq_enabled=0; return old; }
static void restore_irq(x_base old) { irq_enabled=(int)old; }
static void schedule_model(void);
static void ready_insert(struct TaskDescriptor *task);
static void ready_remove(struct TaskDescriptor *task);
static struct TaskDescriptor *GetKTaskDescriptor(void) { return &current; }
static struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id) { assert(id==current.id.id); return &current; }
static int JudgeKTaskStatIsSuspend(struct TaskDescriptor *t) { return t->task_dync_sched_member.stat==KTASK_SUSPEND; }
static int JudgeKTaskStatIsReady(struct TaskDescriptor *t) { return t->task_dync_sched_member.stat==KTASK_READY; }
static int JudgeKTaskStatIsRunning(struct TaskDescriptor *t) { return t->task_dync_sched_member.stat==KTASK_RUNNING; }
static void KTaskStateSet(struct TaskDescriptor *t,int state) { t->task_dync_sched_member.stat=(uint8)state; }
static x_ticks_t CurrentTicksGain(void) { return 1000; }
static void *x_malloc(size_t size) {
    assert(size==sizeof(struct Delay)); ++allocation_calls;
    assert(KTaskOsAssignLockNest>0 && !irq_enabled);
    return allocation_failure ? NULL : &delay_storage;
}
void InitDoubleLinkList(DoubleLinklistType *);
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *,DoubleLinklistType *);
void DoubleLinkListInsertNodeBefore(DoubleLinklistType *,DoubleLinklistType *);
void DoubleLinkListRmNode(DoubleLinklistType *);
int IsDoubleLinkListEmpty(const DoubleLinklistType *);
x_base CriticalAreaLock(void);
void CriticalAreaUnLock(x_base);
x_err_t KTaskUnSetDelay(KTaskDescriptorType);
x_err_t KTaskSetDelay(KTaskDescriptorType,x_ticks_t);
x_err_t _KTaskWakeup(KTaskDescriptorType);
x_err_t _SuspendKTask(KTaskDescriptorType);
x_err_t SuspendKTask(int32);
x_err_t KTaskWakeup(int32);
x_err_t LinklistSuspend(DoubleLinklistType *,struct TaskDescriptor *,uint8);
x_ticks_t CalculateTickFromTimeMs(uint32);
void KTaskTimeout(void *);
static int32 _EventTrigger(struct Event *,uint32);
static int32 _EventProcess(struct Event *,uint32,uint32,int32,uint32 *);

#include "extracted.inc"

static void ready_insert(struct TaskDescriptor *task) {
    assert(!irq_enabled && KTaskOsAssignLockNest>0);
    assert(task->task_dync_sched_member.sched_link.node_next==&task->task_dync_sched_member.sched_link);
    task->task_dync_sched_member.stat=KTASK_READY;
    DoubleLinkListInsertNodeBefore(&ready_head,&task->task_dync_sched_member.sched_link);
    ++ready_inserts;
}
static void ready_remove(struct TaskDescriptor *task) {
    assert(!irq_enabled && KTaskOsAssignLockNest>0);
    DoubleLinkListRmNode(&task->task_dync_sched_member.sched_link); ++ready_removes;
}
static void schedule_model(void) {
    assert(KTaskOsAssignLockNest==0 && irq_enabled); ++schedule_calls;
    if (JudgeKTaskStatIsSuspend(&current)) {
        /* Old source reaches this point after failed Delay allocation.
         * Fail fast instead of simulating an indefinitely blocked task. */
        if (!current.task_dync_sched_member.delay) {
            fputs("REGRESSION: task still suspended without a timeout at schedule\n",stderr);
            exit(20);
        }
        assert(current.task_dync_sched_member.delay->status==TASK_DELAY_ACTIVE);
        if (simulate_timeout) {
            struct Delay *d=current.task_dync_sched_member.delay;
            DoubleLinkListRmNode(&d->link); d->status=TASK_DELAY_INACTIVE;
            KTaskTimeout(&current);
        } else {
            assert(_EventTrigger(&event,1)==EOK);
        }
    }
    if (JudgeKTaskStatIsReady(&current)) {
        DoubleLinkListRmNode(&current.task_dync_sched_member.sched_link);
        current.task_dync_sched_member.stat=KTASK_RUNNING;
    }
    assert(JudgeKTaskStatIsRunning(&current));
}
static struct ReadyDone ready_done={ready_insert,ready_remove};
static struct KTaskDone task_done={_SuspendKTask,_KTaskWakeup};
static void reset(unsigned policy,int with_neighbor) {
    memset(&current,0,sizeof current); memset(&neighbor,0,sizeof neighbor);
    memset(&event,0,sizeof event); memset(&delay_storage,0,sizeof delay_storage);
    InitDoubleLinkList(&ready_head); InitDoubleLinkList(&xiaoshan_delay_head);
    InitDoubleLinkList(&event.pend_list); InitDoubleLinkList(&event.link);
    InitDoubleLinkList(&current.task_dync_sched_member.sched_link);
    InitDoubleLinkList(&neighbor.task_dync_sched_member.sched_link);
    current.id.id=7; current.Done=&task_done;
    current.task_dync_sched_member.stat=KTASK_RUNNING;
    current.task_dync_sched_member.cur_prio=2;
    neighbor.task_dync_sched_member.stat=KTASK_SUSPEND;
    neighbor.task_dync_sched_member.cur_prio=3;
    neighbor.event_mode=EVENT_AND; neighbor.event_id_trigger=2;
    if (with_neighbor) DoubleLinkListInsertNodeBefore(&event.pend_list,&neighbor.task_dync_sched_member.sched_link);
    event.options=policy; Assign.ready_vector_done=&ready_done;
    KTaskOsAssignLockNest=0; irq_enabled=1; allocation_failure=0;
    allocation_calls=schedule_calls=ready_inserts=ready_removes=simulate_timeout=0;
}
static void restored(int with_neighbor) {
    assert(KTaskOsAssignLockNest==0 && irq_enabled);
    assert(JudgeKTaskStatIsRunning(&current));
    assert(IsDoubleLinkListEmpty(&ready_head));
    assert(IsDoubleLinkListEmpty(&xiaoshan_delay_head));
    assert(current.task_dync_sched_member.sched_link.node_next==&current.task_dync_sched_member.sched_link);
    assert(current.task_dync_sched_member.sched_link.node_prev==&current.task_dync_sched_member.sched_link);
    if (with_neighbor) {
        assert(event.pend_list.node_next==&neighbor.task_dync_sched_member.sched_link);
        assert(event.pend_list.node_prev==&neighbor.task_dync_sched_member.sched_link);
        assert(neighbor.task_dync_sched_member.sched_link.node_next==&event.pend_list);
        assert(neighbor.task_dync_sched_member.sched_link.node_prev==&event.pend_list);
        assert(JudgeKTaskStatIsSuspend(&neighbor));
    } else assert(IsDoubleLinkListEmpty(&event.pend_list));
}
int main(void) {
    int cases=0;
    for(unsigned policy=0;policy<2;++policy) for(int other=0;other<2;++other) {
        reset(policy,other); allocation_failure=1; uint32 output=0xabcdef01;
        for(int retry=0;retry<2;++retry) {
            assert(_EventProcess(&event,1,EVENT_AND,1000,&output)==-ENOMEMORY);
            assert(current.exstatus==-ENOMEMORY && output==0xabcdef01);
            assert(event.events==0 && event.options==policy);
            assert(current.task_dync_sched_member.delay==NULL);
            assert(allocation_calls==retry+1 && schedule_calls==retry+1);
            assert(ready_inserts==retry+1 && ready_removes==retry+1);
            restored(other);++cases;
        }
    }
    for(unsigned policy=0;policy<2;++policy) {
        reset(policy,1); uint32 output=99;
        assert(_EventProcess(&event,1,EVENT_AND,1000,&output)==EOK);
        assert(output==1 && current.exstatus==EOK && allocation_calls==1);
        assert(current.task_dync_sched_member.delay==&delay_storage);
        assert(delay_storage.status==TASK_DELAY_INACTIVE); restored(1);++cases;
        reset(policy,0);current.task_dync_sched_member.delay=&delay_storage;allocation_failure=1;output=99;
        assert(_EventProcess(&event,1,EVENT_AND,1000,&output)==EOK);
        assert(output==1 && allocation_calls==0);restored(0);++cases;
        reset(policy,0);event.events=1;output=99;
        assert(_EventProcess(&event,1,EVENT_AND|EVENT_AUTOCLEAN,1000,&output)==EOK);
        assert(event.events==0 && output==1 && !allocation_calls && !schedule_calls);restored(0);++cases;
        reset(policy,0);simulate_timeout=1;output=99;
        assert(_EventProcess(&event,1,EVENT_AND,1000,&output)==-ETIMEOUT);
        assert(current.exstatus==-ETIMEOUT && output==99);restored(0);++cases;
    }
    printf("PASS: %d scenarios, real Process/Delay/Suspend/Wakeup/DLL bodies, modeled scheduler\n",cases);
    return 0;
}
