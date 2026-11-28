From MonadLib.MonadErr Require Import MonadErrBasic monadesafe_lib.
From SimpleC.SL Require Import Mem.
Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Export CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
Require Export CRTOS_Verify.lib.semaphore.KSemaphoreObtain.
Require Export CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Import ListNotations MonadErr Monad MonadNotation.
Local Open Scope Z_scope.
Local Open Scope monad.
Local Open Scope sac.

(** C的-1失败、0但未写输出、0并写出元素是三个不同结果。
    后两者不能合并为“成功必取出元素”，因为原ring空分支仍返回0。 *)
Inductive DataqueuePopResult :=
| DqPopFailed
| DqPopEmpty
| DqPopItem (element : DataqueueElem).

(** 只在首次短临界区读取data ID；读取所需内存由os_inv提供。 *)
Definition abs_dataqueue_pop_id (p : addr) : program VarGlobalState Z :=
  {| nrm := fun before id after => after = before /\ exists q,
       before.(os_dataqueues).(dataqueue_map) p = Some q /\ id = q.(dq_sem_data);
     err := fun _ => False |}.

(** 同一锁内返回 blank ID 和输出内容；非空时有效序列从 e::rest 变为 rest。
    C 只推进 front，不清空旧槽；None 对应空队列、输出不变。
    未修改OS分量由replace_dataqueues精确保留。 *)
Definition abs_dataqueue_pop_ring (p : addr)
    : program VarGlobalState (Z * option DataqueueElem) :=
  {| nrm := fun before result after => exists q,
       before.(os_dataqueues).(dataqueue_map) p = Some q /\
       fst result = q.(dq_sem_blank) /\
       ((q.(dq_slots) = nil /\ snd result = None /\ after = before) \/
        (exists e rest, q.(dq_slots) = e :: rest /\ snd result = Some e /\
          after = replace_dataqueues
            (dataqueue_publish p (dataqueue_pop q) before.(os_dataqueues)) before));
     err := fun _ => False |}.

(** ring临界区结束后的继续执行：使用该次读取的blank ID调用Abandon，
    忽略其返回码，再按已读取的槽结果返回Empty或Item。命名原内联子程序，
    供调用注解连接同一safeExec后续；不增加临界区或状态变化。 *)
Definition dataqueue_pop_after_ring (sg : StableGlobalState)
    (r : Z * option DataqueueElem)
    : program (VarGlobalState -> Prop) DataqueuePopResult :=
  abs_semaphore_abandon sg (fst r) ;;
  match snd r with None => ret DqPopEmpty | Some e => ret (DqPopItem e) end.

(** Obtain返回后的原有分支：非0立即失败；0才检查下一次queue观察、
    执行ring临界区及其后续。保留成功Obtain后ring仍可能为空的路径。 *)
Definition dataqueue_pop_after_obtain (sg : StableGlobalState) (p status : Z)
    : program (VarGlobalState -> Prop) DataqueuePopResult :=
  IF (status = KOK)
    (assertS (dataqueue_peak_entry sg p) ;;
     r <- os_atomic_cmd (abs_dataqueue_pop_ring p) ;;
     dataqueue_pop_after_ring sg r)
    (ret DqPopFailed).

(** 首次短临界区取得data ID后的继续执行：原样传递timeout给Obtain，
    再按其返回值分支。缓存ID仍不提供跨解锁的对象世代稳定保证。 *)
Definition dataqueue_pop_after_id (sg : StableGlobalState)
    (p timeout obtain_id : Z)
    : program (VarGlobalState -> Prop) DataqueuePopResult :=
  status <- abs_semaphore_obtain sg obtain_id timeout ;;
  dataqueue_pop_after_obtain sg p status.

(** 已批准DQ-02/03副本的完整调用顺序。Obtain非0则不访问ring/输出，
    也不调用Abandon；成功时保留空/非空两分支且忽略Abandon结果。
    每次queue观察分别检查存在，不要求caller传内部ID或结构witness，
    不隐含跨解锁的世代稳定保证。白名单001仅豁免assertS可满足性审阅。 *)
Definition abs_pop_dataqueue (sg : StableGlobalState) (p timeout : Z)
    : program (VarGlobalState -> Prop) DataqueuePopResult :=
  assertS (dataqueue_peak_entry sg p) ;;
  obtain_id <- os_atomic_cmd (abs_dataqueue_pop_id p) ;;
  dataqueue_pop_after_id sg p timeout obtain_id.

(** 仅陈述后续实现所需的ready保持义务，不增加信任假设。 *)
Definition dataqueue_pop_ready_obligation : Prop := forall q,
  dataqueue_ready q -> q.(dq_slots) <> nil ->
  dataqueue_ready (dataqueue_pop q).
