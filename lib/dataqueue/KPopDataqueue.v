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

(** 同一锁内返回blank ID和输出内容；非空仅推进front，保留所有数组槽。
    None对应空ring、输出不变，Some e对应读取旧front的两个字段。
    未修改OS分量由replace_dataqueues精确保留。 *)
Definition abs_dataqueue_pop_ring (p : addr)
    : program VarGlobalState (Z * option DataqueueElem) :=
  {| nrm := fun before result after => exists q,
       before.(os_dataqueues).(dataqueue_map) p = Some q /\
       fst result = q.(dq_sem_blank) /\
       ((q.(dq_front) = q.(dq_rear) /\ snd result = None /\ after = before) \/
        (q.(dq_front) <> q.(dq_rear) /\ exists e,
          dataqueue_peak q = Some e /\ snd result = Some e /\
          after = replace_dataqueues
            (dataqueue_publish p (dataqueue_pop q) before.(os_dataqueues)) before));
     err := fun _ => False |}.

(** 已批准DQ-02/03副本的完整调用顺序。Obtain非0则不访问ring/输出，
    也不调用Abandon；成功时保留空/非空两分支且忽略Abandon结果。
    每次queue观察分别检查存在，不要求caller传内部ID或结构witness，
    不隐含跨解锁的世代稳定保证。白名单001仅豁免assertS可满足性审阅。 *)
Definition abs_pop_dataqueue (sg : StableGlobalState) (p timeout : Z)
    : program (VarGlobalState -> Prop) DataqueuePopResult :=
  assertS (dataqueue_peak_entry sg p) ;;
  obtain_id <- os_atomic_cmd (abs_dataqueue_pop_id p) ;;
  status <- abs_semaphore_obtain sg obtain_id timeout ;;
  if Z.eq_dec status 0 then
    assertS (dataqueue_peak_entry sg p) ;;
    r <- os_atomic_cmd (abs_dataqueue_pop_ring p) ;;
    abs_semaphore_abandon sg (fst r) ;;
    match snd r with None => ret DqPopEmpty | Some e => ret (DqPopItem e) end
  else ret DqPopFailed.

(** 仅陈述后续实现所需的ready保持义务，不增加信任假设。 *)
Definition dataqueue_pop_ready_obligation : Prop := forall q,
  dataqueue_ready q -> q.(dq_front) <> q.(dq_rear) ->
  dataqueue_ready (dataqueue_pop q).
