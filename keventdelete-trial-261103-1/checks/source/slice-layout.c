#include "../../annotated_C/include/slice_types.h"
#define OFF(T, f) __builtin_offsetof(struct T, f)
_Static_assert(sizeof(struct Event) == 36, "expanded Event size");
_Static_assert(OFF(Event,id)==0 && OFF(Event,options)==12 && OFF(Event,events)==16, "Event fields");
_Static_assert(OFF(Event,pend_list)==20 && OFF(Event,link)==28, "Event links");
_Static_assert(sizeof(struct IdNode)==12 && OFF(IdNode,link)==4, "ID node");
_Static_assert(OFF(TaskDescriptor,task_dync_sched_member.sched_link)==16, "task sched link");
_Static_assert(OFF(TaskDescriptor,exstatus)==92, "task exstatus");
_Static_assert(OFF(TaskDescriptor,id)==104 && sizeof(struct TaskDescriptor)==120, "task ID and complete size");
