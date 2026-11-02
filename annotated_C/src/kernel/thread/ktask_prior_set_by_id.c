#include "get_task_with_idnode_oc.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskPrioSetByIdSpec */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.kernel.thread.ktask_prior_set_by_id_lib */
/*@ Extern Coq
      (abs_ktask_prio_set :
        StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
      (abs_ktask_prio_set_by_id :
        StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
      (prio_set_by_id_lookup_post : StableGlobalState -> Z ->
        (Z -> (VarGlobalState -> Prop) -> Prop) ->
        option Z -> (VarGlobalState -> Prop) -> Prop)
 */

/* 原样复用 ktask_prior_set.c 的 OC 合同；包括名字比较的字符串资源。 */
x_err_t _KTaskPrioSet(KTaskDescriptorType task, uint8 prio)
/*@ prior_set_oc
    With LitMap (sg : StableGlobalState) (st_before : VarGlobalState) X
    Require
      safeExec(LastSeen(st_before), abs_ktask_prio_set(sg, task, prio), X) &&
      OutsideCritical(sg, st_before) *
      GlobalStrings(LitMap)
    Ensure
      exists after,
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after) *
        GlobalStrings(LitMap)
 */;

/* 来源：../crtos 的 kernel/thread/ktask.c:KTaskPrioSet。
 * 只替换 NULL 宏和 Done.prioset；不新增负 ID 或越界优先级错误返回。
 * 查询及优先级更新分别保留 OC 锁边界；cut 只分解顺序程序。 */
x_err_t KTaskPrioSet(int32 id, uint8 prio)
/*@ prior_set_by_id_oc
    With LitMap (sg : StableGlobalState) (before : VarGlobalState) X
    Require id < 65536 &&
      safeExec(LastSeen(before), abs_ktask_prio_set_by_id(sg, id, prio), X) &&
      OutsideCritical(sg, before) * GlobalStrings(LitMap)
    Ensure exists after,
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after) * GlobalStrings(LitMap)
 */
{
    struct TaskDescriptor *task = NONE;

    /*@ safeExec(LastSeen(before), abs_ktask_prio_set_by_id(sg, id, prio), X)
        which implies KNONE == 0 &&
        safeExec(LastSeen(before), abs_get_task_with_idnode(sg, id),
          prio_set_by_id_lookup_post(sg, prio, X))
     */
    task = GetTaskWithIdnodeInfo(id)
        /*@ where sg = sg, before = before, X = prio_set_by_id_lookup_post(sg, prio, X) */;
    /*@ Given seen from after */
    NULL_PARAM_CHECK_1(task);

    /*@ task != KNONE &&
        safeExec(LastSeen(seen), return(Some(task)), prio_set_by_id_lookup_post(sg, prio, X))
        which implies
        safeExec(LastSeen(seen), abs_ktask_prio_set(sg, task, prio), X)
     */
    return _KTaskPrioSet(task, prio)
        /*@ where (prior_set_oc) LitMap = LitMap, sg = sg, st_before = seen, X = X */;
}
