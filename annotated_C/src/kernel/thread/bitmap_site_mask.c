#include "m_assign.h"

/*
 * 用户授权的独立验证切片：展开当前非 SMP 配置下的 BITMAP_SETCOLUMN，
 * 仅移除赋值表达式最外层的冗余括号，以适配当前 QCP 解析器。
 * 保留 signed 字面量 1、NULL 检查以及原有字段读写；原 CRTOS 文件不变。
 * 优先级 31 的证明采用当前 QCP 的 signed_last_nbits 左移模型。
 */
static inline void __BitmapSiteMask(struct TaskDescriptor *task)
/*@ With (prio : Z)
    Require 0 <= prio && prio <= 31 &&
      store_uchar(&(task->task_dync_sched_member.cur_prio), prio) *
      has_permission(&(task->task_dync_sched_member.bitmap_column))
    Ensure
      store_uchar(&(task->task_dync_sched_member.cur_prio), prio) *
      store_uint(&(task->task_dync_sched_member.bitmap_column), 1 << prio)
 */
{
    NULL_PARAM_CHECK_1(task);
    task->task_dync_sched_member.bitmap_column =
        (1 << task->task_dync_sched_member.cur_prio);
}
