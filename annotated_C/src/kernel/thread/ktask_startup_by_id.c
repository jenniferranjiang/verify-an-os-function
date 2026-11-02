#include "get_task_with_idnode_oc.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskStartupByIdSpec */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.kernel.thread.ktask_startup_by_id_lib */
/*@ Extern Coq
      (abs_ktask_startup :
        StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
      (abs_ktask_startup_by_id :
        StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
      (startup_by_id_lookup_post : StableGlobalState ->
        (Z -> (VarGlobalState -> Prop) -> Prop) ->
        option Z -> (VarGlobalState -> Prop) -> Prop)
 */

/* 原样复用 ktask_startup.c 的 OC 合同，包括现有 Spec 名称。
 * checked 首次启动域属于被调程序，查询不替调用者建立该条件。 */
x_err_t _StartupKTask(KTaskDescriptorType task)
/*@ outside_critica
    With (sg : StableGlobalState) (st_before : VarGlobalState) X
    Require
      safeExec(LastSeen(st_before), abs_ktask_startup(sg, task), X) &&
      OutsideCritical(sg, st_before)
    Ensure
      exists after,
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after)
 */;

/* 来源：../crtos 的 kernel/thread/ktask.c:StartupKTask。
 * 按“源代码处理.md”替换 NULL 宏及 Done.start 调用；保留 OC 被调锁。
 * 局部 cut 只分解顺序程序；不从查询结果推导内层 checked 条件。 */
x_err_t StartupKTask(int32 id)
/*@ startup_by_id_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require id < 65536 &&
      safeExec(LastSeen(before), abs_ktask_startup_by_id(sg, id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */
{
    struct TaskDescriptor *task = NONE;

    if(id < 0) {
        return -EINVALED;
    }

    /*@ id >= 0 &&
        safeExec(LastSeen(before), abs_ktask_startup_by_id(sg, id), X)
        which implies KNONE == 0 &&
        safeExec(LastSeen(before), abs_get_task_with_idnode(sg, id),
          startup_by_id_lookup_post(sg, X))
     */
    task = GetTaskWithIdnodeInfo(id)
        /*@ where sg = sg, before = before, X = startup_by_id_lookup_post(sg, X) */;
    /*@ Given seen from after */
    NULL_PARAM_CHECK_1(task);

    /*@ task != KNONE &&
        safeExec(LastSeen(seen), return(Some(task)), startup_by_id_lookup_post(sg, X))
        which implies
        safeExec(LastSeen(seen), abs_ktask_startup(sg, task), X)
     */
    return _StartupKTask(task)
        /*@ where (outside_critica) sg = sg, st_before = seen, X = X */;
}
