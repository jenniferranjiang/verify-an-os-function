#ifndef CRTOS_KTASK_CREATE_H
#define CRTOS_KTASK_CREATE_H
#include "m_ktask.h"
#include "monad.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskCreate */
/*@ Extern Coq
      (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (ktask_init_input_arguments_ok : Z -> Z -> Z -> Z -> Z -> Prop)
      (abs_ktask_create : StableGlobalState -> Z -> list Z -> Z -> Z -> Z -> Z ->
        program (VarGlobalState -> Prop) Z)
      (ktask_create_result : StableGlobalState -> list Z -> Z -> Z -> Z -> Z ->
        Z -> VarGlobalState -> Prop)
 */

/* Stage-1 恢复稿：三类返回与真实分段控制流对应。成功只返回 ID 及最后
 * 发布快照的纯事实；descriptor、stack 和 sched_link 已移交 os_inv。
 * CreateAxiom 的新信任边界仅在实现的两个重入点使用，不由此头导出。
 */
int32 KTaskCreate(const char *name, void (*entry)(void *parameter),
                 void *parameter, uint32 stack_depth, uint8 priority)
/*@ ktask_create_oc
    With (sg : StableGlobalState) (before : VarGlobalState)
         (src_name : list Z) X
    Require
      ktask_init_input_arguments_ok(
        entry, parameter, &KTaskQuit, stack_depth, priority) &&
      safeExec(LastSeen(before),
        abs_ktask_create(sg, name, src_name, entry, parameter, stack_depth, priority), X) &&
      store_string(name, src_name) * OutsideCritical(sg, before)
    Ensure exists after,
      ktask_create_result(sg, src_name, entry, parameter,
        stack_depth, priority, __return, after) &&
      safeExec(LastSeen(after), return(__return), X) &&
      store_string(name, src_name) * OutsideCritical(sg, after)
 */;
#endif
