#include <xs_id.h>
#include <xs_sem.h>
#include <xs_ktask.h>
#include <xs_assign.h>
#define OFFSET(type,field,n) _Static_assert(__builtin_offsetof(struct type,field)==n,#type "." #field)
#define SIZE(type,n) _Static_assert(sizeof(struct type)==n,#type " sizeof")
_Static_assert(sizeof(void*)==4 && sizeof(long)==4 && sizeof(int)==4,"ILP32");
SIZE(Semaphore,32); OFFSET(Semaphore,id,0); OFFSET(Semaphore,value,12); OFFSET(Semaphore,pend_list,16); OFFSET(Semaphore,link,24);
SIZE(IdNode,12); OFFSET(IdNode,id,0); OFFSET(IdNode,link,4);
SIZE(SysDoubleLinklistNode,8); OFFSET(SysDoubleLinklistNode,node_next,0); OFFSET(SysDoubleLinklistNode,node_prev,4);
SIZE(IdManager,12); OFFSET(IdManager,id_max,0); OFFSET(IdManager,hoffset,2); OFFSET(IdManager,id_map,4); OFFSET(IdManager,htable,8);
SIZE(TaskDyncSchedMember,28); OFFSET(TaskDyncSchedMember,stat,0); OFFSET(TaskDyncSchedMember,advance_cnt,1); OFFSET(TaskDyncSchedMember,cur_prio,2); OFFSET(TaskDyncSchedMember,origin_timeslice,4); OFFSET(TaskDyncSchedMember,rest_timeslice,8); OFFSET(TaskDyncSchedMember,sched_link,12); OFFSET(TaskDyncSchedMember,bitmap_column,20); OFFSET(TaskDyncSchedMember,delay,24);
SIZE(TaskBaseInfo,52); OFFSET(TaskBaseInfo,name,0); OFFSET(TaskBaseInfo,func_entry,32); OFFSET(TaskBaseInfo,func_param,36); OFFSET(TaskBaseInfo,origin_prio,40); OFFSET(TaskBaseInfo,stack_depth,44); OFFSET(TaskBaseInfo,stack_start,48);
SIZE(TaskDescriptor,116); OFFSET(TaskDescriptor,stack_point,0); OFFSET(TaskDescriptor,task_dync_sched_member,4); OFFSET(TaskDescriptor,task_dync_sched_member.sched_link,16); OFFSET(TaskDescriptor,task_base_info,32); OFFSET(TaskDescriptor,exstatus,88); OFFSET(TaskDescriptor,link,92); OFFSET(TaskDescriptor,id,100); OFFSET(TaskDescriptor,Done,112);
SIZE(Delay,20); OFFSET(Delay,task,0); OFFSET(Delay,ticks,4); OFFSET(Delay,status,8); OFFSET(Delay,link,12);
SIZE(OsAssignReadyVector,264); OFFSET(OsAssignReadyVector,priority_ready_vector,0); OFFSET(OsAssignReadyVector,priority_ready_group,256); OFFSET(OsAssignReadyVector,highest_prio,260);
SIZE(Assign,276); OFFSET(Assign,os_assign_ready_vector,0); OFFSET(Assign,os_running_task,264); OFFSET(Assign,ready_vector_done,268); OFFSET(Assign,current_priority,272);
