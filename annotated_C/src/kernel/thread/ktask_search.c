/*
 * Copyright (c) 2020 AIIT XUOS Lab
 * XiUOS is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 *        http://license.coscl.org.cn/MulanPSL2
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 */

#include "m_ktask.h"
#include "monad.h"
#include "task_list_read.h"
#include "task_name_view.h"
/*@ include strategies "task_list_read.strategies" */
/*@ include strategies "task_name_view.strategies" */
/*@ include strategies "critical_task_view.strategies" */

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskPrioSet */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSearch */
/*@ Extern Coq
      (valid_string : list Z -> Prop)
      (ktask_strncmp_result : list Z -> list Z -> Z -> Z -> Prop)
      (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (task_atomic_cmd : {A} -> program VarGlobalState A -> program (VarGlobalState -> Prop) A)
      (ktask_search_locked : list Z -> program VarGlobalState Z)
      (ktask_search_published : (Z -> option TaskDescriptorAbs) -> list Z -> list Z -> Prop)
      (ktask_search_scanned : VarGlobalState -> list Z -> list Z -> Prop)
      (abs_ktask_search :
        StableGlobalState -> list Z -> program (VarGlobalState -> Prop) Z)
 */
/*@ Printing Coq Name valid_string := SimpleC.StdLib.string_lib.valid_string */

/*
 * 来源：../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c。
 * 按“源代码处理.md”提取 KTaskSearch，保留锁外调用入口及原有临界区。
 * 所有共享链表和任务名读取均在原有临界区内，无需额外加锁。
 * 遍历宏按 xs_klist.h 展开；容器转换参照 get_task_with_idnode.c、
 * ktask_set_delay.c 抽象为只计算地址的辅助函数。
 * 已保留调用者 checked 条件；循环只借用并归还读取所需的共享资源。
 */

/*
 * 沿用 ktask_prior_set.c 的 libc 边界：同一纯 strncmp 结果关系、QCP
 * valid_string、INT_MAX 界限和 CRTOS 字符串内存谓词。本函数的参数
 * 顺序相反：s1 是任务的固定容量名字槽，s2 是调用者的有终止符字符串。
 * 保留两个缓冲区所有权；n 无需小于 capacity，因为遇到 NUL 即停止。
 * 该声明不是对实际链接 libc 实现的验证结论。
 */
int strncmp(const char *s1, const char *s2, size_t n)
/*@ With (left right : list Z) (capacity : Z)
    Require valid_string(left) && valid_string(right) &&
      0 <= n && n < INT_MAX &&
      string_length(left) < INT_MAX && string_length(right) < INT_MAX &&
      store_string_n(s1, capacity, left) * store_string(s2, right)
    Ensure ktask_strncmp_result(left, right, n, __return) &&
      store_string_n(s1, capacity, left) * store_string(s2, right)
 */;

/*
 * 对应 SYS_DOUBLE_LINKLIST_ENTRY(node, struct TaskDescriptor, link)。
 * 仅从任务管理链表节点地址恢复任务地址，不读取或取得任务字段所有权。
 */
KTaskDescriptorType CONTAINER_OF_TASK_LINK(DoubleLinklistType *link_ptr)
/*@ With (task : Z)
    Require link_ptr == field_addr(task, struct TaskDescriptor, link) && emp
    Ensure __return == task &&
           link_ptr == &(__return->link)
 */;

/**
 * find a task in manage list.
 *
 * @param name task name
 *
 * @note in interrupt status,this function is not permitted to call.
 *
 * 按管理链顺序返回首个 task_base_info.name 与 name 相同的任务地址，
 * 无匹配则返回 NONE；不比较 func_entry，也不按任务状态筛选。
 * name 是调用者独立持有的字符串，调用前后内容及所有权不变。
 * abs_ktask_search 的 checked 条件要求实际扫描前缀的名字可从 os_inv
 * 借出；该条件尚需调用场景审阅，不能由链表成员资格直接推出。
 * 查询基于本次加锁观察；返回地址不附带任务所有权或锁外存活保证。
 */
KTaskDescriptorType KTaskSearch(char *name)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState)
         (query : list Z) X
    Require
      valid_string(query) && string_length(query) < INT_MAX &&
      safeExec(LastSeen(before), abs_ktask_search(sg, query), X) &&
      OutsideCritical(sg, before) * store_string(name, query)
    Ensure
      exists after,
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after) * store_string(name, query)
 */
{
    x_base lock = 0;
    KTaskDescriptorType temp_task = NONE;
    struct SysDoubleLinklistNode *node = NONE;

    lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ safeExec(LastSeen(before), abs_ktask_search(sg, query), X) &&
        Crtos_RTrans(before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        safeExec(LastSeen(before), task_atomic_cmd(ktask_search_locked(query)), X) &&
        ktask_search_published(st_lock.os_tasks.task_desc_map, query, st_lock.os_tasks.task_ptr_list) &&
        sg.os_task_stable.task_list_head == &xiaoshan_task_head &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */

    /* 原宏：DOUBLE_LINKLIST_FOR_EACH(node, &xiaoshan_task_head) */
    /*@ Inv Assert exists prefix suffix saved_task saved_lock,
          name == name@pre && temp_task == saved_task && lock == saved_lock &&
          valid_string(query) && string_length(query) < INT_MAX &&
          Crtos_RTrans(before, st_lock) &&
          safeExec(LastSeen(before), task_atomic_cmd(ktask_search_locked(query)), X) &&
          sg.os_task_stable.task_list_head == &xiaoshan_task_head &&
          st_lock.os_tasks.task_ptr_list == app(prefix, suffix) &&
          ktask_search_scanned(st_lock, query, prefix) &&
          ktask_search_published(st_lock.os_tasks.task_desc_map, query, suffix) &&
          node == ktask_search_cursor(&xiaoshan_task_head, suffix) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock) *
          store_string(name@pre, query)
     */
    for (node = xiaoshan_task_head.node_next;
         node != &xiaoshan_task_head;
         node = node->node_next)
    {
        /*@ Given prefix suffix saved_task saved_lock */
        /* 当前分支和 published 共同确定下一待查任务；不自动展开任意链表。 */
        /*@ node != &xiaoshan_task_head &&
            node == ktask_search_cursor(&xiaoshan_task_head, suffix) &&
            ktask_search_published(st_lock.os_tasks.task_desc_map, query, suffix) &&
            st_lock.os_tasks.task_ptr_list == app(prefix, suffix) &&
            emp
            which implies
            exists current rest desc,
              suffix == cons(current, rest) &&
              st_lock.os_tasks.task_ptr_list == app(prefix, cons(current, rest)) &&
              node == field_addr(current, struct TaskDescriptor, link) &&
              st_lock.os_tasks.task_desc_map(current) == Some(desc) &&
              ktask_search_published(st_lock.os_tasks.task_desc_map, query, cons(current, rest)) &&
              emp
         */
        /*@ Given current rest desc */
        /* 原宏：SYS_DOUBLE_LINKLIST_ENTRY(node, struct TaskDescriptor, link) */
        temp_task = CONTAINER_OF_TASK_LINK(node)
            /*@ where task = current */;
        if (0 == strncmp(temp_task->task_base_info.name, name, NAME_NUM_MAX)
            /*@ where left = desc.tdBaseInfo.tbName, right = query, capacity = 32 */)
        {
            /*@ Given retval */
            /*@ retval == 0 &&
                ktask_strncmp_result(desc.tdBaseInfo.tbName, query, 32, retval) &&
                st_lock.os_tasks.task_desc_map(temp_task) == Some(desc) &&
                st_lock.os_tasks.task_ptr_list == app(prefix, cons(temp_task, rest)) &&
                ktask_search_scanned(st_lock, query, prefix) &&
                valid_string(query) &&
                Crtos_RTrans(before, st_lock) &&
                safeExec(LastSeen(before), task_atomic_cmd(ktask_search_locked(query)), X) &&
                InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
                which implies
                safeExec(LastSeen(st_lock), return(temp_task), X) &&
                Crtos_GTrans(st_lock, st_lock) &&
                InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
             */
            CriticalAreaUnLock(lock)
                /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
            return temp_task;
        }
        /*@ Given retval */
        /* 将本次不匹配加入已扫描前缀；不改变共享状态。 */
        /*@ retval != 0 &&
            ktask_strncmp_result(desc.tdBaseInfo.tbName, query, 32, retval) &&
            st_lock.os_tasks.task_desc_map(current) == Some(desc) &&
            ktask_search_scanned(st_lock, query, prefix) &&
            ktask_search_published(st_lock.os_tasks.task_desc_map, query, cons(current, rest)) &&
            valid_string(query) && os_inv(sg, st_lock)
            which implies
            ktask_search_scanned(st_lock, query, app(prefix, cons(current, nil))) &&
            ktask_search_published(st_lock.os_tasks.task_desc_map, query, rest) &&
            os_inv(sg, st_lock)
         */
    }

    /*@ Given prefix suffix saved_task saved_lock */
    /*@ node == &xiaoshan_task_head &&
        node == ktask_search_cursor(&xiaoshan_task_head, suffix) &&
        sg.os_task_stable.task_list_head == &xiaoshan_task_head &&
        st_lock.os_tasks.task_ptr_list == app(prefix, suffix) &&
        ktask_search_scanned(st_lock, query, prefix) &&
        Crtos_RTrans(before, st_lock) &&
        safeExec(LastSeen(before), task_atomic_cmd(ktask_search_locked(query)), X) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        safeExec(LastSeen(st_lock), return(0), X) &&
        Crtos_GTrans(st_lock, st_lock) &&
        store_ptr(&node, &xiaoshan_task_head) *
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    CriticalAreaUnLock(lock)
        /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;

    return NONE;
}
