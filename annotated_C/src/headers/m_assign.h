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

/**
* @file:   xs_assign.h
* @brief:  function declaration and structure defintion of system assign
* @version: 1.0
* @author:  AIIT XUOS Lab
* @date:    2020/3/10
*
*/

#ifndef XS_ASSIGN_H
#define XS_ASSIGN_H

#include "xs_base.h"
#include "m_ktask.h"
// #include <xs_klist.h>
// #include <xs_spinlock.h>

// #ifdef __cplusplus
// extern "C" {
// #endif

#define MERGE_FLAG(src, flag) (*(src) |= flag)
#define CLEAR_FLAG(src, flag)  (*(src) &= ~flag)

struct PriorityReadyVectorDone
{
    void (*init)(struct OsAssignReadyVector *ready_vector);
    void (*insert)(struct TaskDescriptor *task);
    void (*remove)(struct TaskDescriptor *task);
};


struct Assign
{
    struct OsAssignReadyVector os_assign_ready_vector;
    struct TaskDescriptor *os_running_task;

    struct PriorityReadyVectorDone *ready_vector_done;
    
    uint8 current_priority;
};

/*
 * DISABLE_INTERRUPT/ENABLE_INTERRUPT 在当前验证切片中作为临界区接口，
 * ordinary/stable 两个行为与已经使用并验证的
 * CriticalAreaLock/CriticalAreaUnLock 规格逐字保持一致。
 * nested 行为只恢复调用前已经持有的 critical view；其余临界区内的
 * 局部内存资源由 separation-logic frame 原样保存。
 */
x_base DISABLE_INTERRUPT(void)
/*@ ordinary
    With (sg : StableGlobalState) (st1 : VarGlobalState)
    Require
      OutsideCritical(sg, st1)
    Ensure
      exists st_lock,
        Crtos_RTrans(st1, st_lock) &&
        InsideCritical(sg, st_lock) *
        os_inv(sg, st_lock)
 */
/*@ nested
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require
      InsideCritical(sg, st)
    Ensure
      InsideCritical(sg, st)
 */
;

void ENABLE_INTERRUPT(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require
      Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) *
      os_inv(sg, st2)
    Ensure
      OutsideCritical(sg, st2)
 */
/*@ nested
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require
      InsideCritical(sg, st)
    Ensure
      InsideCritical(sg, st)
 */
;

void SwitchKtaskContext(x_ubase from, x_ubase to , struct TaskDescriptor *to_task);
void SwitchKtaskContextTo(x_ubase to, struct TaskDescriptor *to_task);
void HwInterruptcontextSwitch( x_ubase from, x_ubase to, struct TaskDescriptor *to_task ,void *context);

void KTaskInsertToReadyVector(struct TaskDescriptor *task);
int PrioCaculate(uint32 bitmap);
void SysInitOsAssign(void);
void ResetCriticalAreaLock(void );
void StartupOsAssign(void);
uint16 GetOsAssignLockLevel(void);
int32 JudgeAssignReadyBitmapIsEmpty(struct OsAssignReadyVector *ready_vector);
void OsAssignReadyVectorInit(struct OsAssignReadyVector *ready_vector);
void AssignPolicyInsert(struct TaskDescriptor *task, struct OsAssignReadyVector* ready_table);
struct TaskDescriptor * ChooseTaskWithHighestPrio(struct OsAssignReadyVector *ready_vector);

#ifdef KERNEL_STACK_OVERFLOW_CHECK
void _KTaskOsAssignStackCheck(struct TaskDescriptor *task);
#endif


#define DO_KTASK_ASSIGN                              \
    do                                               \
    {                                                \
        NOT_IN_CRITICAL_AREA;                        \
        x_base lock;                                 \
        lock = DISABLE_INTERRUPT();                  \
        KTaskOsAssign();                             \
        ENABLE_INTERRUPT(lock);                      \
    } while (0);

/*
 * QCP 需要在单个验证翻译单元中看到这两个全局对象的具体定义。
 * m_ktask.h 已经声明 CriticalAreaLock/CriticalAreaUnLock，因此本头文件不再
 * 重复声明它们，避免 QCP 对重复函数声明的前端崩溃。
 */
struct Assign Assign;
static struct PriorityReadyVectorDone SingleReadyVectorDone =
{
    OsAssignReadyVectorInit,
    KTaskInsertToReadyVector,
    KTaskOsAssignRemoveKTask
};

#endif

// #ifdef __cplusplus
// }
// #endif
