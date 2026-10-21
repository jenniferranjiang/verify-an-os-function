#include "m_ktask.h"
#include "delay_set_views.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSetDelayState */
/*@ Extern Coq
      (None : {A} -> option A)
      (ktask_set_delay_step :
        Z -> TaskDescriptorAbs -> Z -> Z ->
        VarGlobalState -> Z -> VarGlobalState -> Prop)
*/

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

/*
 * IC 切片：调用者的外层锁覆盖整个函数，InsideCritical 由调用者 frame 保留。
 * 正常路径直接使用 for_null_inactive；超长请求独立使用 tick_out_of_bound。
 * task 只借出 delay 指针槽。已有 Delay 必须 inactive 且 link 自环，故下面
 * active 摘链分支在正常规格下不可达；仍完整保留原 C 分支。
 * 按“源代码处理.md”注释两处嵌套锁，展开遍历宏并保留 continue 的增量。
 * Stage 2 直接保持全局前态和 inactive 补集，扫描时只借当前节点。
 * 两个完整 Spec 与 ktask_set_delay.h 逐字一致；不包含该调用者头文件，
 * 避免同一 QCP 输入重复声明同名规格，并保留定义处的 @pre 绑定。
 */
x_err_t KTaskSetDelay(KTaskDescriptorType task, x_ticks_t ticks)
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
{
    // x_base lock = 0;
    struct Delay *delay = NONE;
    struct Delay *dnode = NONE;
    DoubleLinklistType *nodelink = NONE;

    NULL_PARAM_CHECK_1(task);

    /*@ emp which implies KTICK_HALF_RANGE == 2147483647 && emp */

    if (ticks >= (TICK_SIZE_MAX / 2))
        return -EINVALED;

    /*@ os_global_context(sg) && emp $ for_null_inactive which implies
          sg.delay_head_ptr == &xiaoshan_delay_head &&
          sg.os_tick_ptr == heartbeat_ticks_addr && emp */

    if (task->task_dync_sched_member.delay == NONE) {
        delay = (struct Delay *)x_malloc(sizeof(struct Delay))
            /*@ where (delay_object) */;
        if (delay == NONE) {
            return -ENOMEMORY;
        }
        memset(delay, 0x0, sizeof(struct Delay));
        task->task_dync_sched_member.delay = delay;
    } else {
        delay = task->task_dync_sched_member.delay;
        // lock = CriticalAreaLock();
        if (delay->status == TASK_DELAY_ACTIVE) {
            delay->status = TASK_DELAY_INACTIVE;
            DoubleLinkListRmNode(&(delay->link));
        }
        // CriticalAreaUnLock(lock);
    }

    /*@ Assert exists delay_after previous_info,
          task == task@pre && ticks == ticks@pre &&
          0 <= ticks@pre && ticks@pre < KTICK_HALF_RANGE &&
          st_before.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          os_global_context(sg) &&
          sg.delay_head_ptr == &xiaoshan_delay_head &&
          sg.os_tick_ptr == heartbeat_ticks_addr &&
          delay_list_window(st_before.os_tick, st_before.os_delays.delay_active_nodes) &&
          delay == delay_after && delay_after != 0 &&
          addr_aligned(delay_after, ALIGN_SIZE) && nodelink == 0 && dnode == 0 && previous_info.tdStatus == 0 &&
          delay_set_frame(st_before, desc.tdDelay, delay_after) *
          store_ptr(&(task@pre->task_dync_sched_member.delay), delay_after) *
          tick_inv(sg, st_before) *
          store_dll(store_delay_info, &xiaoshan_delay_head, st_before.os_delays.delay_active_nodes) *
          store_delay_unlinked_info(delay_after, previous_info)
     $ for_null_inactive */
    /*@ Given delay_after previous_info */

    delay->ticks = CurrentTicksGain() + ticks;
    delay->task = task;
    delay->status = TASK_DELAY_ACTIVE;

    // lock = CriticalAreaLock();
    /*@ Assert exists new_ticks,
          task == task@pre && ticks == ticks@pre &&
          0 <= ticks@pre && ticks@pre < KTICK_HALF_RANGE &&
          st_before.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          os_global_context(sg) &&
          sg.delay_head_ptr == &xiaoshan_delay_head &&
          sg.os_tick_ptr == heartbeat_ticks_addr &&
          delay_list_window(st_before.os_tick, st_before.os_delays.delay_active_nodes) &&
          delay == delay_after && delay_after != 0 &&
          addr_aligned(delay_after, ALIGN_SIZE) &&
          new_ticks == tick_add(st_before.os_tick, ticks@pre) && nodelink == 0 && dnode == 0 &&
          delay_set_frame(st_before, desc.tdDelay, delay_after) *
          store_ptr(&(task@pre->task_dync_sched_member.delay), delay_after) *
          store_uint(heartbeat_ticks_addr, st_before.os_tick) *
          store_dll(store_delay_info, &xiaoshan_delay_head, st_before.os_delays.delay_active_nodes) *
          store_ptr(field_addr(delay_after, struct Delay, task), task@pre) *
          store_uint(field_addr(delay_after, struct Delay, ticks), new_ticks) *
          store_uchar(field_addr(delay_after, struct Delay, status), 1) *
          CharArray::full(delay_after + 9, 3, cons(0, cons(0, cons(0, nil)))) *
          occupy_dll_node(field_addr(delay_after, struct Delay, link))
     $ for_null_inactive */
    /*@ Given new_ticks */
    /*@ Inv Assert exists prefix_scan suffix_scan dnode_value,
          task == task@pre && ticks == ticks@pre &&
          0 <= ticks@pre && ticks@pre < KTICK_HALF_RANGE &&
          st_before.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          os_global_context(sg) &&
          sg.delay_head_ptr == &xiaoshan_delay_head &&
          sg.os_tick_ptr == heartbeat_ticks_addr &&
          delay_list_window(st_before.os_tick, st_before.os_delays.delay_active_nodes) &&
          delay == delay_after && delay_after != 0 &&
          addr_aligned(delay_after, ALIGN_SIZE) &&
          new_ticks == tick_add(st_before.os_tick, ticks@pre) && dnode == dnode_value &&
          st_before.os_delays.delay_active_nodes == app(prefix_scan, suffix_scan) &&
          delay_prefix_scanned(new_ticks, prefix_scan) &&
          delay_set_frame(st_before, desc.tdDelay, delay_after) *
          store_ptr(&(task@pre->task_dync_sched_member.delay), delay_after) *
          store_uint(heartbeat_ticks_addr, st_before.os_tick) *
          store_delay_scan(&xiaoshan_delay_head, nodelink, prefix_scan, suffix_scan) *
          store_ptr(field_addr(delay_after, struct Delay, task), task@pre) *
          store_uint(field_addr(delay_after, struct Delay, ticks), new_ticks) *
          store_uchar(field_addr(delay_after, struct Delay, status), 1) *
          CharArray::full(delay_after + 9, 3, cons(0, cons(0, cons(0, nil)))) *
          occupy_dll_node(field_addr(delay_after, struct Delay, link))
     */
    /* DOUBLE_LINKLIST_FOR_EACH：continue 仍执行 node_next 增量。 */
    for (nodelink = xiaoshan_delay_head.node_next;
         nodelink != &xiaoshan_delay_head;
         nodelink = nodelink->node_next) {
        /*@ Given prefix_scan suffix_scan dnode_value */
        /* 此处的分解由循环分支决定，保留为局部算法推理。 */
        /*@ nodelink != &xiaoshan_delay_head &&
            store_delay_scan(&xiaoshan_delay_head, nodelink, prefix_scan, suffix_scan)
            $ for_null_inactive which implies
            exists current_info current_link scan_rest,
              suffix_scan == cons(Build_DL_Node(current_info, current_link), scan_rest) &&
              nodelink == current_link &&
              store_delay_dll_focus(&xiaoshan_delay_head, prefix_scan,
                Build_DL_Node(current_info, current_link), scan_rest)
         */
        /*@ Given current_info current_link scan_rest */
        /* 容器转换的存在见证；payload 仍由按需策略读取。 */
        /*@ store_delay_dll_focus(&xiaoshan_delay_head, prefix_scan,
              Build_DL_Node(current_info, current_link), scan_rest)
            $ for_null_inactive which implies
            exists current_delay,
              current_link == field_addr(current_delay, struct Delay, link) &&
              current_delay != 0 && addr_aligned(current_delay, ALIGN_SIZE) &&
              store_delay_dll_focus(&xiaoshan_delay_head, prefix_scan,
                Build_DL_Node(current_info, current_link), scan_rest)
         */
        /*@ Given current_delay */
        dnode = CONTAINER_OF_DELAY_LINK(nodelink)
            /*@ where delay_ptr = current_delay */;
        if ((dnode->ticks - delay->ticks) == 0) {
            continue;
        }
        if ((dnode->ticks - delay->ticks) < (TICK_SIZE_MAX / 2)) {
    /*@ Assert
          task == task@pre && ticks == ticks@pre &&
          0 <= ticks@pre && ticks@pre < KTICK_HALF_RANGE &&
          st_before.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          os_global_context(sg) &&
          sg.delay_head_ptr == &xiaoshan_delay_head &&
          sg.os_tick_ptr == heartbeat_ticks_addr &&
          delay_list_window(st_before.os_tick, st_before.os_delays.delay_active_nodes) &&
          delay == delay_after && delay_after != 0 &&
          addr_aligned(delay_after, ALIGN_SIZE) &&
          new_ticks == tick_add(st_before.os_tick, ticks@pre) && nodelink == current_link && dnode == current_delay &&
          current_link != &xiaoshan_delay_head &&
          st_before.os_delays.delay_active_nodes == app(prefix_scan, cons(Build_DL_Node(current_info, current_link), scan_rest)) &&
          delay_prefix_scanned(new_ticks, prefix_scan) &&
          tick_beforeb(new_ticks, current_info.tdTicks) == true &&
          dll_insert_anchor(&xiaoshan_delay_head, st_before.os_delays.delay_active_nodes, current_link) &&
          field_addr(delay_after, struct Delay, link) != 0 &&
          delay_set_frame(st_before, desc.tdDelay, delay_after) *
          store_ptr(&(task@pre->task_dync_sched_member.delay), delay_after) *
          store_uint(heartbeat_ticks_addr, st_before.os_tick) *
          store_dll(store_delay_info, &xiaoshan_delay_head, st_before.os_delays.delay_active_nodes) *
          store_delay_info(field_addr(delay_after, struct Delay, link), mkTaskDelayAbs(task@pre, new_ticks, 1)) *
          occupy_dll_node(field_addr(delay_after, struct Delay, link))
     $ for_null_inactive */
        DoubleLinkListInsertNodeBefore(nodelink, &delay->link)
            /*@ where (dispatch_case)
                  storeA = store_delay_info, head = &xiaoshan_delay_head,
                  nodes = st_before.os_delays.delay_active_nodes,
                  inserted_data = mkTaskDelayAbs(task@pre, new_ticks, 1);
                  A = TaskDelayAbs */;
    /*@ Assert
          task == task@pre && ticks == ticks@pre &&
          0 <= ticks@pre && ticks@pre < KTICK_HALF_RANGE &&
          st_before.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          os_global_context(sg) &&
          sg.delay_head_ptr == &xiaoshan_delay_head &&
          sg.os_tick_ptr == heartbeat_ticks_addr &&
          delay_list_window(st_before.os_tick, st_before.os_delays.delay_active_nodes) &&
          delay == delay_after && delay_after != 0 &&
          addr_aligned(delay_after, ALIGN_SIZE) &&
          new_ticks == tick_add(st_before.os_tick, ticks@pre) && nodelink == current_link && dnode == current_delay && current_link != &xiaoshan_delay_head &&
          delay_set_frame(st_before, desc.tdDelay, delay_after) *
          store_ptr(&(task@pre->task_dync_sched_member.delay), delay_after) *
          store_uint(heartbeat_ticks_addr, st_before.os_tick) *
          store_dll(store_delay_info, &xiaoshan_delay_head, delay_insert_by_ticks(Build_DL_Node(mkTaskDelayAbs(task@pre, new_ticks, 1), field_addr(delay_after, struct Delay, link)), st_before.os_delays.delay_active_nodes))
     $ for_null_inactive */
            break;
        }
    }

    if (nodelink == &xiaoshan_delay_head) {
    /*@ Assert exists tail_dnode,
          task == task@pre && ticks == ticks@pre &&
          0 <= ticks@pre && ticks@pre < KTICK_HALF_RANGE &&
          st_before.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          os_global_context(sg) &&
          sg.delay_head_ptr == &xiaoshan_delay_head &&
          sg.os_tick_ptr == heartbeat_ticks_addr &&
          delay_list_window(st_before.os_tick, st_before.os_delays.delay_active_nodes) &&
          delay == delay_after && delay_after != 0 &&
          addr_aligned(delay_after, ALIGN_SIZE) &&
          new_ticks == tick_add(st_before.os_tick, ticks@pre) && nodelink == &xiaoshan_delay_head && dnode == tail_dnode &&
          delay_prefix_scanned(new_ticks, st_before.os_delays.delay_active_nodes) &&
          dll_insert_anchor(&xiaoshan_delay_head, st_before.os_delays.delay_active_nodes, &xiaoshan_delay_head) &&
          field_addr(delay_after, struct Delay, link) != 0 &&
          delay_set_frame(st_before, desc.tdDelay, delay_after) *
          store_ptr(&(task@pre->task_dync_sched_member.delay), delay_after) *
          store_uint(heartbeat_ticks_addr, st_before.os_tick) *
          store_dll(store_delay_info, &xiaoshan_delay_head, st_before.os_delays.delay_active_nodes) *
          store_delay_info(field_addr(delay_after, struct Delay, link), mkTaskDelayAbs(task@pre, new_ticks, 1)) *
          occupy_dll_node(field_addr(delay_after, struct Delay, link))
     $ for_null_inactive */
        /*@ Given tail_dnode */
        DoubleLinkListInsertNodeBefore(&xiaoshan_delay_head, &(delay->link))
            /*@ where (dispatch_case)
                  storeA = store_delay_info, head = &xiaoshan_delay_head,
                  nodes = st_before.os_delays.delay_active_nodes,
                  inserted_data = mkTaskDelayAbs(task@pre, new_ticks, 1);
                  A = TaskDelayAbs */;
    /*@ Assert
          task == task@pre && ticks == ticks@pre &&
          0 <= ticks@pre && ticks@pre < KTICK_HALF_RANGE &&
          st_before.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          os_global_context(sg) &&
          sg.delay_head_ptr == &xiaoshan_delay_head &&
          sg.os_tick_ptr == heartbeat_ticks_addr &&
          delay_list_window(st_before.os_tick, st_before.os_delays.delay_active_nodes) &&
          delay == delay_after && delay_after != 0 &&
          addr_aligned(delay_after, ALIGN_SIZE) &&
          new_ticks == tick_add(st_before.os_tick, ticks@pre) && nodelink == &xiaoshan_delay_head && dnode == tail_dnode &&
          delay_set_frame(st_before, desc.tdDelay, delay_after) *
          store_ptr(&(task@pre->task_dync_sched_member.delay), delay_after) *
          store_uint(heartbeat_ticks_addr, st_before.os_tick) *
          store_dll(store_delay_info, &xiaoshan_delay_head, delay_insert_by_ticks(Build_DL_Node(mkTaskDelayAbs(task@pre, new_ticks, 1), field_addr(delay_after, struct Delay, link)), st_before.os_delays.delay_active_nodes))
     $ for_null_inactive */
    }
    // CriticalAreaUnLock(lock);

    /*@ Assert exists final_link final_dnode,
          task == task@pre && ticks == ticks@pre &&
          0 <= ticks@pre && ticks@pre < KTICK_HALF_RANGE &&
          st_before.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          os_global_context(sg) &&
          sg.delay_head_ptr == &xiaoshan_delay_head &&
          sg.os_tick_ptr == heartbeat_ticks_addr &&
          delay_list_window(st_before.os_tick, st_before.os_delays.delay_active_nodes) &&
          delay == delay_after && delay_after != 0 &&
          addr_aligned(delay_after, ALIGN_SIZE) &&
          new_ticks == tick_add(st_before.os_tick, ticks@pre) && nodelink == final_link && dnode == final_dnode &&
          delay_set_frame(st_before, desc.tdDelay, delay_after) *
          store_ptr(&(task@pre->task_dync_sched_member.delay), delay_after) *
          store_uint(heartbeat_ticks_addr, st_before.os_tick) *
          store_dll(store_delay_info, &xiaoshan_delay_head, delay_insert_by_ticks(Build_DL_Node(mkTaskDelayAbs(task@pre, new_ticks, 1), field_addr(delay_after, struct Delay, link)), st_before.os_delays.delay_active_nodes))
     $ for_null_inactive */
    return EOK;
}
