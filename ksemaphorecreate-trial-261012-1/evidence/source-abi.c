/* Current authoritative headers; generated board config is first include path. */
#include <xs_sem.h>
#include <xs_ktask.h>
#include <xs_assign.h>
#define S(t,n) _Static_assert(sizeof(t)==(n), "sizeof " #t)
#define O(t,f,n) _Static_assert(__builtin_offsetof(t,f)==(n), "offset " #t "." #f)
#ifdef ARCH_SMP
#error SMP is forbidden
#endif
#ifdef ARCH_CPU_64BIT
#error 64 bit is forbidden
#endif
#ifndef BOARD_STM32F103_NANO
#error Wrong board
#endif
#ifdef SOURCE_REQUIRE_ARM
#ifndef __ARM_ARCH_7M__
#error Target is not Cortex-M3 ARMv7-M
#endif
#ifndef __thumb__
#error Thumb must be enabled
#endif
#endif
_Static_assert(__CHAR_BIT__==8, "8-bit bytes");
_Static_assert(__alignof__(struct Semaphore)==4, "semaphore alignment");
_Static_assert(__alignof__(uint16)==2, "uint16 alignment");
S(void*,4); S(int,4); S(long,4); S(short,2); S(char,1);
S(x_size_t,4); S(x_base,4); S(uint16,2); S(uint8,1);
_Static_assert((x_size_t)-1 > 0, "x_size_t unsigned");
_Static_assert(ID_NUM_MAX==128 && ID_HTABLE_SIZE==16, "manager configuration");
S(DoubleLinklistType,8); O(DoubleLinklistType,node_next,0); O(DoubleLinklistType,node_prev,4);
S(struct IdNode,12); O(struct IdNode,id,0); O(struct IdNode,link,4);
S(struct IdManager,12); O(struct IdManager,id_max,0); O(struct IdManager,hoffset,2);
O(struct IdManager,id_map,4); O(struct IdManager,htable,8);
S(struct Semaphore,32); O(struct Semaphore,id,0); O(struct Semaphore,value,12);
O(struct Semaphore,id.link.node_next,4); O(struct Semaphore,id.link.node_prev,8);
O(struct Semaphore,pend_list,16); O(struct Semaphore,link,24);
O(struct Semaphore,pend_list.node_next,16); O(struct Semaphore,pend_list.node_prev,20);
O(struct Semaphore,link.node_next,24); O(struct Semaphore,link.node_prev,28);
S(struct TaskDescriptor,116); O(struct TaskDescriptor,task_dync_sched_member.cur_prio,6);
O(struct TaskDescriptor,task_dync_sched_member.sched_link,16);
O(struct TaskDescriptor,exstatus,88); O(struct TaskDescriptor,id,100);
S(struct OsAssignReadyVector,264); S(struct Assign,276);
O(struct Assign,os_running_task,264); O(struct Assign,ready_vector_done,268);
O(struct Assign,current_priority,272);
_Static_assert(ENOMEMORY==5, "failure code");
