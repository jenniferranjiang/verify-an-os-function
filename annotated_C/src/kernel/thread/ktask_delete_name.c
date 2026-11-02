#include "ktask_delete_name.h"
#include "task_name_view.h"
#include "string_literal_view.h"
/*@ include strategies "task_name_view.strategies" */
/*@ include strategies "critical_task_view.strategies" */
/*@ include strategies "string_literal_view.strategies" */
/*@ Extern Coq
  (valid_string : list Z -> Prop)
  (ktask_strncmp_result : list Z -> list Z -> Z -> Z -> Prop)
 */
/*@ Printing Coq Name valid_string := SimpleC.StdLib.string_lib.valid_string */

/* libc 接口原样复用 ktask_search 的 strncmp 和 ktask_prior_set 的 strlen。
 * 这是调用边界，未声称已验证当前配置链接的 libc 实现。 */
size_t strlen(const char *s)
/*@ With (text : list Z)
    Require valid_string(text) && string_length(text) < INT_MAX &&
      store_string(s, text)
    Ensure __return == string_length(text) && store_string(s, text)
 */;

int strncmp(const char *s1, const char *s2, size_t n)
/*@ With (left right : list Z) (capacity : Z)
    Require valid_string(left) && valid_string(right) &&
      0 <= n && n < INT_MAX &&
      string_length(left) < INT_MAX && string_length(right) < INT_MAX &&
      store_string_n(s1, capacity, left) * store_string(s2, right)
    Ensure ktask_strncmp_result(left, right, n, __return) &&
      store_string_n(s1, capacity, left) * store_string(s2, right)
 */;

/* 与 ktask_delete.c 的 OC 切片相同：只添加证明注解，原有锁、短路和返回保留。 */
static inline x_err_t __JudgeKTaskIsIdleOrZombierecycle(KTaskDescriptorType task)
/*@ delete_name_oc */
{
    x_base lock = 0;

    NULL_PARAM_CHECK_1(task);
    lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ safeExec(LastSeen(before), abs_ktask_delete_name(sg, task), X) &&
        Crtos_RTrans(before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies exists desc,
          safeExec(LastSeen(before), task_atomic_cmd(ktask_delete_name_locked(task)), X) &&
          st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
          Crtos_RTrans(before, st_lock) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given desc */
    if(0 == strncmp(task->task_base_info.name,"ktaskidle0",strlen("ktaskidle0")) ||
        0 == strncmp(task->task_base_info.name,"ktaskidle1",strlen("ktaskidle1")) ||
        0 == strncmp(task->task_base_info.name,"ZombieRecycleKTask",strlen("ZombieRecycleKTask")) )
    {
    /*@ Assert exists saved_lock,
      ktask_delete_name_result(desc.tdBaseInfo.tbName, 1) &&
      safeExec(LastSeen(before), task_atomic_cmd(ktask_delete_name_locked(task@pre)), X) &&
      Crtos_RTrans(before, st_lock) &&
      st_lock.os_tasks.task_desc_map(task@pre) == Some(desc) &&
      store_ptr(&task, task@pre) * store_int(&lock, saved_lock) *
      InsideCritical(sg, st_lock) * os_inv(sg, st_lock) * GlobalStrings(LitMap)
    */
    /*@ Given saved_lock */
    /*@ safeExec(LastSeen(before), task_atomic_cmd(ktask_delete_name_locked(task)), X) &&
        ktask_delete_name_result(desc.tdBaseInfo.tbName, 1) &&
        Crtos_RTrans(before, st_lock) &&
        st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        safeExec(LastSeen(st_lock), return(1), X) &&
        Crtos_GTrans(st_lock, st_lock) &&
        store_ptr(&task, task) * InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
        CriticalAreaUnLock(lock)
            /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
        return RET_TRUE;
    }
    /*@ Assert exists saved_lock,
      ktask_delete_name_result(desc.tdBaseInfo.tbName, 0) &&
      safeExec(LastSeen(before), task_atomic_cmd(ktask_delete_name_locked(task@pre)), X) &&
      Crtos_RTrans(before, st_lock) &&
      st_lock.os_tasks.task_desc_map(task@pre) == Some(desc) &&
      store_ptr(&task, task@pre) * store_int(&lock, saved_lock) *
      InsideCritical(sg, st_lock) * os_inv(sg, st_lock) * GlobalStrings(LitMap)
    */
    /*@ Given saved_lock */
    /*@ safeExec(LastSeen(before), task_atomic_cmd(ktask_delete_name_locked(task)), X) &&
        ktask_delete_name_result(desc.tdBaseInfo.tbName, 0) &&
        Crtos_RTrans(before, st_lock) &&
        st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        safeExec(LastSeen(st_lock), return(0), X) &&
        Crtos_GTrans(st_lock, st_lock) &&
        store_ptr(&task, task) * InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    CriticalAreaUnLock(lock)
        /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
    return EOK;
}
