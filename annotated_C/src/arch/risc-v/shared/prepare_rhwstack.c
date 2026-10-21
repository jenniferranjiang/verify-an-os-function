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
#include "task_base_info_strategy.h"
/*@ include strategies "task_base_info.strategies" */

 // TODO: QCP工具应该支持自动得知全局变量地址有效： ktask_xubase_value(&KTaskQuit)

uint8 KTaskStackSetup(struct TaskDescriptor *task)
/*@ With info
    Require task != 0 &&
            ktask_xubase_value(&KTaskQuit) &&
            ktask_stack_setup_layout_ok(
              info.tbStackStart, info.tbStackDepth, REG_LENGTH) &&
            has_permission(&(task->stack_point)) *
            store_task_base_info(task, info) *
            UCharArray::full(
              info.tbStackStart, info.tbStackDepth,
              repeat_Z(CHAR_SHARP, info.tbStackDepth))
    Ensure __return == 0 &&
            store(&(task->stack_point), kss_context_addr(info)) *
            store_task_base_info(task, info) *
            store_ktask_stack(
              info.tbStackStart, info.tbStackDepth,
              repeat_Z(
                CHAR_SHARP,
                kss_context_addr(info) - info.tbStackStart),
              ktask_context_regs_setup(
                info.tbFuncEntry, info.tbFuncParam, &KTaskQuit,
                SAVED_MSTATUS, OxFADEFACE))
 */
{
    struct StackRegisterContext *stack_contex;
    int  i;


    /*@ ktask_stack_setup_layout_ok(
          info.tbStackStart, info.tbStackDepth, REG_LENGTH)
        which implies
        ktask_stack_context_layout_ok
     */
    task->stack_point  = (uint8 *)(((x_ubase)((uint8 *)task->task_base_info.stack_start + task->task_base_info.stack_depth)) / 4 * 4);

    task->stack_point = (uint8 *)task->stack_point - sizeof(struct StackRegisterContext);

    stack_contex = (struct StackRegisterContext *)task->stack_point;

    /*@ ktask_stack_setup_layout_ok(
          info.tbStackStart, info.tbStackDepth, REG_LENGTH) &&
        UCharArray::full(
          info.tbStackStart, info.tbStackDepth,
          repeat_Z(CHAR_SHARP, info.tbStackDepth))
        which implies
        aligned_reglen(kss_context_addr(info)) &&
        UCharArray::full(
          info.tbStackStart, kss_context_addr(info) - info.tbStackStart,
          repeat_Z(
            CHAR_SHARP, kss_context_addr(info) - info.tbStackStart)) *
        UCharArray::full(
          kss_context_addr(info), sizeof(struct StackRegisterContext),
          repeat_Z(CHAR_SHARP, sizeof(struct StackRegisterContext))) *
        UCharArray::full(
          kss_aligned_top(info),
          info.tbStackStart + info.tbStackDepth - kss_aligned_top(info),
          repeat_Z(
            CHAR_SHARP,
            info.tbStackStart + info.tbStackDepth - kss_aligned_top(info)))
     */

    /*@ stack_contex == kss_context_addr(info) &&
        UCharArray::full(
          kss_context_addr(info), sizeof(struct StackRegisterContext),
          repeat_Z(CHAR_SHARP, sizeof(struct StackRegisterContext)))
        which implies
        UIntArray::full(stack_contex, 0, repeat_Z(OxFADEFACE, 0)) *
        UCharArray::full(
          (x_ubase *)stack_contex + 0,
          sizeof(struct StackRegisterContext) - 0 * sizeof(unsigned long),
          repeat_Z(
            CHAR_SHARP,
            sizeof(struct StackRegisterContext) - 0 * sizeof(unsigned long)))
     */
	    /*@ Inv
	        stack_contex == kss_context_addr(info) &&
	        aligned_reglen(stack_contex) &&
		        ktask_stack_context_layout_ok &&
        REG_COUNT == 32 &&
        ktask_xubase_value(info.tbFuncEntry) &&
        ktask_xubase_value(info.tbFuncParam) &&
        ktask_xubase_value(&KTaskQuit) &&
        0 <= i && i <= sizeof(struct StackRegisterContext) / sizeof(unsigned long) &&
        UIntArray::full(stack_contex, i, repeat_Z(OxFADEFACE, i)) *
        UCharArray::full(
          (x_ubase *)stack_contex + i,
          sizeof(struct StackRegisterContext) - i * sizeof(unsigned long),
          repeat_Z(
            CHAR_SHARP,
            sizeof(struct StackRegisterContext) - i * sizeof(unsigned long)))
     */
    for (i = 0; i < sizeof(struct StackRegisterContext) / sizeof(x_ubase); i++) {
	        /*@ 0 <= i && i < sizeof(struct StackRegisterContext) / sizeof(unsigned long) &&
            aligned_reglen(stack_contex) &&
            ktask_stack_context_layout_ok &&
            UCharArray::full(
              (x_ubase *)stack_contex + i,
              sizeof(struct StackRegisterContext) - i * sizeof(unsigned long),
              repeat_Z(
                CHAR_SHARP,
                sizeof(struct StackRegisterContext) - i * sizeof(unsigned long)))
            which implies
            exists old,
            store(&(((x_ubase *)stack_contex)[i]), unsigned int, old) *
            UCharArray::full(
              (x_ubase *)stack_contex + (i + 1),
              sizeof(struct StackRegisterContext) -
                (i + 1) * sizeof(unsigned long),
              repeat_Z(
                CHAR_SHARP,
                sizeof(struct StackRegisterContext) -
                  (i + 1) * sizeof(unsigned long)))
         */
        ((x_ubase *)stack_contex)[i] = 0xfadeface;
    }

    /*@ i >= sizeof(struct StackRegisterContext) / sizeof(unsigned long) &&
        i <= sizeof(struct StackRegisterContext) / sizeof(unsigned long) &&
        aligned_reglen(stack_contex) &&
        ktask_stack_context_layout_ok &&
        REG_COUNT == 32 &&
        ktask_xubase_value(info.tbFuncEntry) &&
        ktask_xubase_value(info.tbFuncParam) &&
        ktask_xubase_value(&KTaskQuit) &&
        UIntArray::full(stack_contex, i, repeat_Z(OxFADEFACE, i)) *
        UCharArray::full(
          (x_ubase *)stack_contex + i,
          sizeof(struct StackRegisterContext) - i * sizeof(unsigned long),
          repeat_Z(
            CHAR_SHARP,
            sizeof(struct StackRegisterContext) - i * sizeof(unsigned long)))
        which implies
        i >= sizeof(struct StackRegisterContext) / sizeof(unsigned long) &&
        i <= sizeof(struct StackRegisterContext) / sizeof(unsigned long) &&
        aligned_reglen(stack_contex) &&
        ktask_stack_context_layout_ok &&
        REG_COUNT == 32 &&
        ktask_xubase_value(info.tbFuncEntry) &&
        ktask_xubase_value(info.tbFuncParam) &&
        ktask_xubase_value(&KTaskQuit) &&
        store(&(stack_contex->epc), unsigned int, OxFADEFACE) *
        store(&(stack_contex->ra), unsigned int, OxFADEFACE) *
        store(&(stack_contex->mstatus), unsigned int, OxFADEFACE) *
        store(&(stack_contex->gp), unsigned int, OxFADEFACE) *
        store(&(stack_contex->tp), unsigned int, OxFADEFACE) *
        store(&(stack_contex->t0), unsigned int, OxFADEFACE) *
        store(&(stack_contex->t1), unsigned int, OxFADEFACE) *
        store(&(stack_contex->t2), unsigned int, OxFADEFACE) *
        store(&(stack_contex->s0_fp), unsigned int, OxFADEFACE) *
        store(&(stack_contex->s1), unsigned int, OxFADEFACE) *
        store(&(stack_contex->a0), unsigned int, OxFADEFACE) *
        store(&(stack_contex->a1), unsigned int, OxFADEFACE) *
        store(&(stack_contex->a2), unsigned int, OxFADEFACE) *
        store(&(stack_contex->a3), unsigned int, OxFADEFACE) *
        store(&(stack_contex->a4), unsigned int, OxFADEFACE) *
        store(&(stack_contex->a5), unsigned int, OxFADEFACE) *
        store(&(stack_contex->a6), unsigned int, OxFADEFACE) *
        store(&(stack_contex->a7), unsigned int, OxFADEFACE) *
        store(&(stack_contex->s2), unsigned int, OxFADEFACE) *
        store(&(stack_contex->s3), unsigned int, OxFADEFACE) *
        store(&(stack_contex->s4), unsigned int, OxFADEFACE) *
        store(&(stack_contex->s5), unsigned int, OxFADEFACE) *
        store(&(stack_contex->s6), unsigned int, OxFADEFACE) *
        store(&(stack_contex->s7), unsigned int, OxFADEFACE) *
        store(&(stack_contex->s8), unsigned int, OxFADEFACE) *
        store(&(stack_contex->s9), unsigned int, OxFADEFACE) *
        store(&(stack_contex->s10), unsigned int, OxFADEFACE) *
        store(&(stack_contex->s11), unsigned int, OxFADEFACE) *
        store(&(stack_contex->t3), unsigned int, OxFADEFACE) *
        store(&(stack_contex->t4), unsigned int, OxFADEFACE) *
        store(&(stack_contex->t5), unsigned int, OxFADEFACE) *
        store(&(stack_contex->t6), unsigned int, OxFADEFACE)
     */
    stack_contex->ra      = (x_ubase)KTaskQuit;

    stack_contex->a0      = (x_ubase)task->task_base_info.func_param;
    stack_contex->epc     = (x_ubase)task->task_base_info.func_entry;

    stack_contex->mstatus = 0x00007880;

    return 0;
}
