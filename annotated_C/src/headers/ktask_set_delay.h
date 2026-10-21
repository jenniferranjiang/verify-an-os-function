#ifndef KTASK_SET_DELAY_H
#define KTASK_SET_DELAY_H

#include "m_ktask.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSetDelayState */
/*@ Extern Coq
      (None : {A} -> option A)
      (ktask_set_delay_step :
        Z -> TaskDescriptorAbs -> Z -> Z ->
        VarGlobalState -> Z -> VarGlobalState -> Prop)
*/

/*
 * 当前接口仅供已持锁调用，InsideCritical 由调用者 frame 保留。
 * 正常入口只允许 NULL 或 inactive Delay；delay_inv 拥有 inactive 自环和
 * active DLL，结合 map 归属与分离性可排除目标任务仍在 active DLL 中。
 * now 起始窗口要求已有 deadline 均未逾期；该协议不由 delay_inv 或目标
 * 任务的 Suspend 单独保证，必须由调用者/时钟协议建立。
 * task 对象只借出 delay 指针槽；首次分配成功会写此槽，其他字段由调用者
 * frame 保留。ktask_set_delay_step 关联输出指针和后态 descriptor map。
 * 正常后置仅含成功或分配失败，成功时直接向原 active 列表插入。
 * 超长返回由 tick_out_of_bound 单独描述。
 * 非空性由入口 NULL_PARAM_CHECK_1 正常返回建立，不作为调用前置；
 * 这是部分正确性规格，空任务在源代码的检查循环中不返回。
 * 两个 Spec 均直接验证函数体，没有局部资源规格或规格推导桥接。
 * 此处两个完整 Spec 与 ktask_set_delay.c 中的定义规格保持逐字一致。
 */
x_err_t KTaskSetDelay(struct TaskDescriptor *task, x_ticks_t ticks)
/*@ for_null_inactive
    With (sg : StableGlobalState) (st_before : VarGlobalState)
         (desc : TaskDescriptorAbs)
    Require 0 <= ticks && ticks < KTICK_HALF_RANGE &&
            st_before.os_tasks.task_desc_map(task) == Some(desc) &&
            os_global_context(sg) &&
            (desc.tdDelay == 0 ||
             st_before.os_delays.delay_inactive_map(desc.tdDelay) != None) &&
            delay_list_window(st_before.os_tick,
              st_before.os_delays.delay_active_nodes) &&
            store_ptr(&(task->task_dync_sched_member.delay), desc.tdDelay) *
            delay_inv(sg, st_before) *
            tick_inv(sg, st_before)
    Ensure exists st_after delay_after,
             ktask_set_delay_step(
               task, desc, ticks, delay_after,
               st_before, __return, st_after) &&
             store_ptr(&(task->task_dync_sched_member.delay), delay_after) *
             delay_inv(sg, st_after) *
             tick_inv(sg, st_after)
 */
/*@ tick_out_of_bound
    Require ticks >= KTICK_HALF_RANGE && emp
    Ensure __return == -INVALID && emp
 */
;

x_ticks_t CurrentTicksGain(void)
/*@ With os_tick
    Require store_uint(heartbeat_ticks_addr, os_tick)
    Ensure __return == os_tick &&
           store_uint(heartbeat_ticks_addr, os_tick)
 */
;

struct Delay *CONTAINER_OF_DELAY_LINK(DoubleLinklistType *link_ptr)
/*@ With delay_ptr
    Require link_ptr == field_addr(delay_ptr, struct Delay, link) && emp
    Ensure __return == delay_ptr &&
           link_ptr == &(__return->link)
 */
;

#endif
