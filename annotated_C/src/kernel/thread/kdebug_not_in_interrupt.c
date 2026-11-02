#include "kdebug_not_in_interrupt.h"
#include "m_isr.h"
#include "isr_count_view_strategy.h"
/*@ include strategies "isr_count_view.strategies" */

/*
 * 本切片的可信 IRQ primitive 边界，与现有 CriticalSTS/LOS IRQ 接口一致。
 * 这里只建模单核屏蔽中断期间的共享资源借还，不建模 mstatus 的具体值。
 * OutsideCritical 表示归还独占保护，不表示 MIE=1；下面的 C 正常路径
 * 将同一次 Disable 的返回值原样传回 Enable，汇编行为仍属平台边界。
 */
x_base DisableLocalInterrupt(void)
/*@ ordinary
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require OutsideCritical(sg, before)
    Ensure exists observed,
      Crtos_RTrans(before, observed) &&
      InsideCritical(sg, observed) * os_inv(sg, observed)
 */;

void EnableLocalInterrupt(x_base level)
/*@ restore
    With (sg : StableGlobalState) (observed after : VarGlobalState)
    Require Crtos_GTrans(observed, after) &&
      InsideCritical(sg, observed) * os_inv(sg, after)
    Ensure OutsideCritical(sg, after)
 */;

/* 当前非 SMP 实现只读取该 uint16 字段；调用者持有屏蔽中断后的资源。 */
uint16 GetIsrCounter(void)
/*@ With count
    Require store(&(isrManager.isr_count), unsigned short, count)
    Ensure __return == count &&
           store(&(isrManager.isr_count), unsigned short, count)
 */
{
    uint16 ret = 0;
    ret = isrManager.isr_count;
    return ret;
}

/*
 * 提取 kernel/include/xs_kdbg.h 的 KDEBUG_NOT_IN_INTERRUPT 和 CHECK(0)，
 * 按 源代码处理.md 注释打印，并把 isrManager.done->getCounter()
 * 替换为 isr.c 中 isrDone 表绑定的 GetIsrCounter()。此对应以源系统
 * 已执行 SysInitIsrManager 为范围，不声称初始化前的间接调用安全。
 * 原始中断操作保持不变；CriticalAreaLock/UnLock 还会修改调度锁嵌套计数。
 */
void KDEBUG_NOT_IN_INTERRUPT(void)
/*@ outside_critical */
{
    do {
        x_base level;
        level = DISABLE_INTERRUPT()
            /*@ where (ordinary) sg = sg, before = before */;
        /*@ Given observed */
        if (GetIsrCounter()
            /*@ where count = observed.os_isr.isrCount */ != 0) {
            // KPrintf("Function[%s] is not supported in ISR\n", __FUNCTION__);
            do {
                if (!(0)) {
                    // KPrintf("%s CHECK condition is false at line[%d] of [%s] func.\n", "0", __LINE__, __FUNCTION__);
                    /*@ Inv Assert exists saved_level,
                          observed.os_isr.isrCount != 0 &&
                          Crtos_RTrans(before, observed) &&
                          safeExec(LastSeen(before), abs_kdebug_not_in_interrupt, X) &&
                          InsideCritical(sg, observed) * os_inv(sg, observed) *
                          store(&level, int, saved_level)
                     */
                    while (RET_TRUE)
                        ;
                }
            } while (0);
        }
        /*@ observed.os_isr.isrCount == 0 &&
            Crtos_RTrans(before, observed) &&
            safeExec(LastSeen(before), abs_kdebug_not_in_interrupt, X) &&
            InsideCritical(sg, observed) * os_inv(sg, observed)
            which implies
            observed.os_isr.isrCount == 0 &&
            safeExec(LastSeen(observed), return(tt), X) &&
            Crtos_GTrans(observed, observed) &&
            InsideCritical(sg, observed) * os_inv(sg, observed)
         */
        ENABLE_INTERRUPT(level)
            /*@ where (restore) sg = sg, observed = observed, after = observed */;
    } while (0);
}
