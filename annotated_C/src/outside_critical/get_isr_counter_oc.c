#include "get_isr_counter_oc.h"
#include "m_ktask.h"
#include "isr_count_view_strategy.h"
/*@ include strategies "isr_count_view.strategies" */

#ifdef ARCH_SMP
extern int GetCpuId(void);
#endif

/* 来源：CRTOS kernel/thread/isr.c 的 GetIsrCounter。
 * 仅在原计数读取周围增加短临界区；返回读取到的局部 ret。
 * m_isr.h 明确限制当前验证配置为非 SMP，保留原源码的条件分支。 */
uint16 GetIsrCounter(void)
/*@ get_isr_counter_oc */
{
    uint16 ret = 0;
    x_base access_lock = 0;

    access_lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given observed from st_lock */
// #ifdef ARCH_SMP
//     ret = isrManager.isr_count[GetCpuId()];
// #else
    ret = isrManager.isr_count;
// #endif
    /*@ ret == observed.os_isr.isrCount &&
        Crtos_RTrans(before, observed) &&
        safeExec(LastSeen(before), abs_get_isr_counterOC, X) &&
        InsideCritical(sg, observed) * os_inv(sg, observed)
        which implies
        safeExec(LastSeen(observed), return(ret), X) &&
        Crtos_GTrans(observed, observed) &&
        InsideCritical(sg, observed) * os_inv(sg, observed)
     */
    CriticalAreaUnLock(access_lock)
        /*@ where (stable) sg = sg, st1 = observed, st2 = observed */;
    return ret;
}
