#ifndef CRTOS_KDEBUG_NOT_IN_INTERRUPT_H
#define CRTOS_KDEBUG_NOT_IN_INTERRUPT_H

#include "m_ktask.h"
#include "monad.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.KDebug */
/*@ Extern Coq
      (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (abs_kdebug_not_in_interrupt : program (VarGlobalState -> Prop) unit)
 */

/*
 * OC Spec：正常返回说明屏蔽中断期间读到计数零。
 * after 是该次成功观察的快照，OutsideCritical 隐藏的当前状态仍可由
 * rely 推进；因此不授予锁外读取 isrManager 的权限或当前计数零的保证。
 * 非零分支停机；不要求入口 before 的计数为零，也不承诺终止。
 * 实现的 QCP 证明使用本切片声明的可信 IRQ primitive 资源协议；
 * 不把它等同于底层 mstatus 汇编或系统初始化的验证。
 */
void KDEBUG_NOT_IN_INTERRUPT(void)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_kdebug_not_in_interrupt, X) &&
      OutsideCritical(sg, before)
    Ensure
      exists after,
        after.os_isr.isrCount == 0 &&
        safeExec(LastSeen(after), return(tt), X) &&
        OutsideCritical(sg, after)
 */;

#endif
