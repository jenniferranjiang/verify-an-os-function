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

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskDeleteByIdSpec */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.kernel.thread.ktask_delete_by_id_lib */
/*@ Extern Coq
      (KNONE : Z)
      (None : {A} -> option A)
      (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (abs_get_task_with_idnode :
        StableGlobalState -> Z -> program (VarGlobalState -> Prop) (option Z))
      (abs_ktask_delete :
        StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
      (abs_ktask_delete_by_id :
        StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
      (delete_by_id_lookup_post : StableGlobalState ->
        (Z -> (VarGlobalState -> Prop) -> Prop) ->
        option Z -> (VarGlobalState -> Prop) -> Prop)
 */

/* 已验证的 outside_critical/get_task_with_idnode_oc.c 接口。
 * 查询自行加解锁；返回值只通过 continuation 传递，不拥有 descriptor。 */
inline struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ With (sg : StableGlobalState) (before : VarGlobalState) X
    Require id < 65536 &&
      safeExec(LastSeen(before), abs_get_task_with_idnode(sg, id), X) &&
      OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == KNONE &&
        safeExec(LastSeen(after), return(None), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        safeExec(LastSeen(after), return(Some(__return)), X) &&
        OutsideCritical(sg, after))
 */;

/* 已验证的 ktask_delete_oc.c 接口，Require/Ensure 保持一致。
 * GlobalStrings 用于其内部名称检查，查询和 wrapper 自身将其作为 frame。 */
x_err_t _DeleteKTask(KTaskDescriptorType task)
/*@ delete_oc
    With LitMap (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_ktask_delete(sg, task), X) &&
      OutsideCritical(sg, before) * GlobalStrings(LitMap)
    Ensure exists after,
      ((__return == -INVALID && safeExec(LastSeen(after), return(-INVALID), X)) ||
       (__return == KOK && safeExec(LastSeen(after), return(KOK), X))) &&
      OutsideCritical(sg, after) * GlobalStrings(LitMap)
 */;

/*
 * 来源：crtos/kernel/thread/ktask.c:932 的 KTaskDelete。
 * 按“源代码处理.md”：NULL_PARAM_CHECK -> NULL_PARAM_CHECK_1；
 * task->Done->Delete(task) -> _DeleteKTask(task)，实际 Done.Delete 绑定
 * 见原文件的 Done 初始化。保持 OC 调用，不注释被调函数的真实锁边界。
 * 当前 xsconfig.h 未启用 KERNEL_CAPABILITY，故排除 RemoveTaskCaps。
 * KERNEL_DEBUG 已启用，空查询结果在 NULL 检查处不正常返回。
 * 查询 continuation 按真实调用顺序组合；不从查询快照推导删除时的发布性。
 */
x_err_t KTaskDelete(int32 id)
/*@ delete_by_id_oc
    With LitMap (sg : StableGlobalState) (before : VarGlobalState) X
    Require id < 65536 &&
      safeExec(LastSeen(before), abs_ktask_delete_by_id(sg, id), X) &&
      OutsideCritical(sg, before) * GlobalStrings(LitMap)
    Ensure exists after,
      ((__return == -INVALID && safeExec(LastSeen(after), return(-INVALID), X)) ||
       (__return == KOK && safeExec(LastSeen(after), return(KOK), X))) &&
      OutsideCritical(sg, after) * GlobalStrings(LitMap)
 */
{
    struct TaskDescriptor *task = NONE;

    if(id < 0) {
        return -EINVALED;
    }

    /* 本函数的顺序程序分解，不涉及内存表示层的展开。
     * 显式给出 KNONE 的 C 编码，使 NULL 检查后的 None 分支可判为矛盾。 */
    /*@ id >= 0 &&
        safeExec(LastSeen(before), abs_ktask_delete_by_id(sg, id), X)
        which implies KNONE == 0 &&
        safeExec(LastSeen(before), abs_get_task_with_idnode(sg, id),
          delete_by_id_lookup_post(sg, X))
     */
    task = GetTaskWithIdnodeInfo(id)
      /*@ where sg = sg, before = before, X = delete_by_id_lookup_post(sg, X) */;
    /*@ Given seen from after */
    NULL_PARAM_CHECK_1(task);

    /*@ task != KNONE &&
        safeExec(LastSeen(seen), return(Some(task)), delete_by_id_lookup_post(sg, X))
        which implies
        safeExec(LastSeen(seen), abs_ktask_delete(sg, task), X)
     */
    return _DeleteKTask(task)
      /*@ where (delete_oc) LitMap = LitMap, sg = sg, before = seen, X = X */;
}
