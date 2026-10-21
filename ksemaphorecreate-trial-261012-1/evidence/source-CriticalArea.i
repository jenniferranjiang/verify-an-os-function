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
void KPrintf(const char *fmt, ...);
int32 ArchEnableHwIrq(uint32 irq_num);
int32 ArchDisableHwIrq(uint32 irq_num);
typedef void (*IsrHandlerType)(int vector, void *param);
struct IrqDesc
{
    IsrHandlerType handler;
    void *param;
};
struct IsrDone
{
    x_bool (*isInIsr)();
    int32 (*registerIrq)(uint32 irq_num, IsrHandlerType handler, void *arg);
    int32 (*freeIrq)(uint32 irq_num);
    int32 (*enableIrq)(uint32 irq_num);
    int32 (*disableIrq)(uint32 irq_num);
    void (*handleIrq)(uint32 irq_num);
    uint16 (*getCounter)() ;
    void (*incCounter)();
    void (*decCounter)();
    uint8 (*getSwitchTrigerFlag)();
    void (*setSwitchTrigerFlag)();
    void (*clearSwitchTrigerFlag)();
};
struct InterruptServiceRoutines {
       volatile uint16 isr_count ;
       volatile uint8 isr_switch_trigger_flag;
    struct IrqDesc irq_table[(64)];
    struct IsrDone *done;
};
extern struct InterruptServiceRoutines isrManager ;
x_base DisableLocalInterrupt();
void EnableLocalInterrupt(x_base level);
void SysInitIsrManager();
void InitHwinterrupt(void);
typedef struct SysDoubleLinklistNode
{
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
typedef struct SingleLinklistNode
{
    struct SingleLinklistNode *node_next;
} SysSingleLinklistType;
void InitDoubleLinkList(DoubleLinklistType *linklist_head);
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node);
void DoubleLinkListInsertNodeBefore(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node);
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node);
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
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode);
struct IdNode *IdGetObj(struct IdManager *manager, uint16 id);
void IdRemoveObj(struct IdManager *manager, uint16 id);
struct Timer
{
    struct IdNode id_node;
    char name[32];
    uint8 active_status;
    uint8 trigger_mode;
    void (*func_callback)(void *param);
    void *param;
    x_ticks_t origin_timeslice;
    x_ticks_t deadline_timeslice;
    DoubleLinklistType link;
    DoubleLinklistType sortlist;
    uint8 prio;
    struct Work * t_work;
    struct TimerDone* done;
};
typedef struct Timer *TimerType;
struct TimerDone
{
    void (*Init)(struct Timer *timer,
                    const char *name,
                    void (*timeout)(void *parameter),
                    void *parameter,
                    x_ticks_t time,
                    uint8 trigger_mode);
    x_err_t (*Delete)(TimerType timer);
    x_err_t (*StartRun)(TimerType timer);
    x_err_t (*QuitRun)(TimerType timer);
    x_err_t (*Modify)(TimerType timer, x_ticks_t ticks);
};
int32 KCreateTimer(const char *name,
                           void (*timeout)(void *parameter),
                           void *parameter,
                           x_ticks_t time,
                           uint8 trigger_mode);
x_err_t KDeleteTimer(int32 timer_id);
x_err_t KTimerStartRun(int32 timer_id);
x_err_t KTimerQuitRun(int32 timer_id);
x_err_t KTimerModify(int32 timer_id, x_ticks_t ticks);
x_err_t KTimerAssignMemberRun(int32 timer_id, x_ticks_t ticks);
TimerType KGetTimer(int32 id);
int32 KGetTimerID(TimerType timer);
x_ticks_t TimerNextTimeoutTick(void);
void CheckTimerList(void);
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
    char name[32];
    void *func_entry;
    void *func_param;
    uint8 origin_prio;
    uint32 stack_depth;
    void *stack_start;
};
typedef struct TaskBaseInfo TaskBaseInfoType;
struct TaskDyncSchedMember {
    uint8 stat;
    uint8 advance_cnt;
    uint8 cur_prio;
    x_ubase origin_timeslice;
    x_ubase rest_timeslice;
    DoubleLinklistType sched_link;
    uint32 bitmap_column;
    DelayType delay;
};
typedef struct TaskDyncSchedMember TaskDyncSchedMembeType;
struct TaskDescriptor
{
    void *stack_point;
    TaskDyncSchedMembeType task_dync_sched_member;
    TaskBaseInfoType task_base_info;
    uint32 event_id_trigger : 29 ;
    uint32 event_mode : 3;
    x_err_t exstatus;
    DoubleLinklistType link;
    struct IdNode id;
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
                        uint32 stack_size,
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
                             uint32 stack_size,
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
void KTaskStateSet(KTaskDescriptorType task, uint8 stat);
void KTaskStatSetAsInit(KTaskDescriptorType task);
void KTaskStatSetAsReady(KTaskDescriptorType task);
void KTaskStatSetAsSuspend(KTaskDescriptorType task);
void KTaskStatSetAsRunning(KTaskDescriptorType task);
void KTaskStatSetAsClose(KTaskDescriptorType task);
uint8 KTaskStatGet(KTaskDescriptorType task);
_Bool JudgeKTaskStatIsInit(KTaskDescriptorType task);
_Bool JudgeKTaskStatIsReady(KTaskDescriptorType task);
_Bool JudgeKTaskStatIsSuspend(KTaskDescriptorType task);
_Bool JudgeKTaskStatIsRunning(KTaskDescriptorType task);
_Bool JudgeKTaskStatIsClose(KTaskDescriptorType task);
extern struct Assign Assign;
struct PriorityReadyVectorDone
{
    void (*init)(struct OsAssignReadyVector *ready_vector);
    void (*insert)(struct TaskDescriptor *task);
    void (*remove)(struct TaskDescriptor *task);
};
struct Assign
{
    struct OsAssignReadyVector os_assign_ready_vector;
    struct TaskDescriptor *os_running_task;
    struct PriorityReadyVectorDone *ready_vector_done;
    uint8 current_priority;
};
void SwitchKtaskContext(x_ubase from, x_ubase to , struct TaskDescriptor *to_task);
void SwitchKtaskContextTo(x_ubase to, struct TaskDescriptor *to_task);
void HwInterruptcontextSwitch( x_ubase from, x_ubase to, struct TaskDescriptor *to_task ,void *context);
void KTaskInsertToReadyVector(struct TaskDescriptor *task);
int PrioCaculate(uint32 bitmap);
void SysInitOsAssign(void);
void ResetCriticalAreaLock(void );
void StartupOsAssign(void);
x_base CriticalAreaLock(void);
void CriticalAreaUnLock(x_base lock);
uint16 GetOsAssignLockLevel(void);
int32 JudgeAssignReadyBitmapIsEmpty(struct OsAssignReadyVector *ready_vector);
void OsAssignReadyVectorInit(struct OsAssignReadyVector *ready_vector);
void AssignPolicyInsert(struct TaskDescriptor *task, struct OsAssignReadyVector* ready_table);
struct TaskDescriptor * ChooseTaskWithHighestPrio(struct OsAssignReadyVector *ready_vector);
void _KTaskOsAssignStackCheck(struct TaskDescriptor *task);
void InitBoardMemory(void *begin_addr, void *end_addr);
void *x_malloc(x_size_t nbytes);
void x_free(void *ptr);
void *x_realloc(void *ptr, x_size_t nbytes);
void *x_calloc(x_size_t count, x_size_t size);
void UserInitBoardMemory(void *begin_addr, void *end_addr);
void *x_umalloc(x_size_t nbytes);
void x_ufree(void *ptr);
void *x_urealloc(void *ptr, x_size_t nbytes);
void *x_ucalloc(x_size_t count, x_size_t size);
void MemoryInfo(uint32 *total, uint32 *used, uint32 *max_used);
struct AssignHook
{
    void (*hook_Assign)(KTaskDescriptorType from, KTaskDescriptorType to);
};
struct TaskHook
{
    void (*hook_TaskCreate) (KTaskDescriptorType task);
    void (*hook_TaskSuspend)(KTaskDescriptorType task);
    void (*hook_TaskResume) (KTaskDescriptorType task);
};
struct MemHook
{
    void (*hook_Malloc)(void *ptr, x_size_t size);
    void (*hook_Free)(void *ptr);
};
struct TimerHook
{
    void (*hook_TimerEnter)(struct Timer *timer);
    void (*hook_TimerExit)(struct Timer *timer);
};
struct IsrHook
{
    void (*hook_IsrEnter)(void);
    void (*hook_IsrLeave)(void);
};
struct IdleHook
{
    void (*hook_Idle)(void);
};
struct TestHook
{
     void (*hook_test)(const char *buf);
};
struct KernelHook
{
   struct AssignHook assign;
   struct TaskHook task;
   struct MemHook mem;
   struct TimerHook timer;
   struct IsrHook isr;
   struct IdleHook idle;
   struct TestHook test;
};
extern struct KernelHook hook;
int hook_init(void);
static uint16 KTaskOsAssignLockNest;
uint16 GetOsAssignLockLevel(void) {
    return KTaskOsAssignLockNest;
}
inline void ResetCriticalAreaLock(void ) {
    KTaskOsAssignLockNest = 0;
}
x_base CriticalAreaLock(void) {
    x_base lock;
    lock = DisableLocalInterrupt();
    KTaskOsAssignLockNest ++;
    return lock;
}
void CriticalAreaUnLock(x_base lock) {
    if (KTaskOsAssignLockNest >= 1) {
        KTaskOsAssignLockNest --;
    }
    EnableLocalInterrupt(lock);
}
