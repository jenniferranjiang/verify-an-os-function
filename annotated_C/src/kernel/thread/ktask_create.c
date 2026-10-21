#include "m_id.h"
#include "m_ktask.h"

/* KTaskCreate specifications are withdrawn pending human redesign.
 * The rejected owner-token protocol and its verification annotations were removed.
 */

static void _KTaskDyncMemberInit(KTaskDescriptorType task);

int32 _InitKTask(KTaskDescriptorType task,
              const char *name,
							void (*entry)(void *parameter),
							void       *parameter,
							uint32 stack_depth,
							uint8  priority);

// Local declaration retained for the verification slice.
void KERNEL_FREE(void* pointer);

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
							void       *parameter,
							uint32 stack_depth,
							uint8  priority)
{
	struct TaskDescriptor *task = NONE;
    int32 id = 0;
    x_base lock = 0;

	// KDEBUG_NOT_IN_INTERRUPT;
	task = (struct TaskDescriptor *)KERNEL_MALLOC(sizeof(struct TaskDescriptor));
	if (task == NONE) {
        // KPrintf("%s %d TaskDescriptor %s malloc failed.\n",__func__,__LINE__,name);

		return -ENOMEMORY;
	}
	memset(task, 0x0, sizeof(struct TaskDescriptor));

  lock = CriticalAreaLock();

    id = IdInsertObj(&k_task_id_manager, &task->id);

    if (id < 0) {
          // KPrintf("%s %d task id malloc failed.\n",__func__,__LINE__);

          CriticalAreaUnLock(lock);

          KERNEL_FREE(task);

          return -ENOMEMORY;
      }

    // fp (* 初始化==插入*)

    DoubleLinkListInsertNodeAfter(&xiaoshan_task_head, &(task->link));

    task->Done = &Done;

  CriticalAreaUnLock(lock);

  // `task->Done->init` changed to `_InitKTask(...)` before funct pointer supported
  if( _InitKTask(task, name, entry, parameter, stack_depth, priority) == EOK ) {
      // HOOK(hook.task.hook_TaskCreate, (task));
      lock = CriticalAreaLock();
		 // 离开空临界区时，发布task内存断言到os_inv；
      CriticalAreaUnLock(lock);
      return id;
  } else {
      // KPrintf("%s %d task init failed.\n",__func__,__LINE__);
      lock = CriticalAreaLock();
        DoubleLinkListRmNode(&task->link);
        IdRemoveObj(&k_task_id_manager, id);
      CriticalAreaUnLock(lock);

      KERNEL_FREE(task);
      return -ERROR;
  }
}
