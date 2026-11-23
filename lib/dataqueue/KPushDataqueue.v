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

(** 第一段短临界区仅缓存blank ID，不预订额度，也不提供跨解锁保活。
    后续每次访问各自检查观察中的对象存在；不将相同地址冒称同一世代。 *)
Definition abs_dataqueue_push_id (p : addr) : program VarGlobalState Z :=
  {| nrm := fun before id after => after = before /\ exists q,
       before.(os_dataqueues).(dataqueue_map) p = Some q /\ id = q.(dq_sem_blank);
     err := fun _ => False |}.

(** 用有效序列长度判断满：count=max_len-1 时整个 OS 状态不变，
    非满时在序列末尾追加元素；C 对应写 rear 槽并推进 rear。
    返回本次锁内读到的data ID，供解锁后的Abandon调用；不读取payload。
    Obtain成功不自动推出非满，故两分支都属于正常行为。 *)
Definition abs_dataqueue_push_ring (p data length : Z) : program VarGlobalState Z :=
  {| nrm := fun before id after => exists q,
       before.(os_dataqueues).(dataqueue_map) p = Some q /\
       id = q.(dq_sem_data) /\
       (if Z.eq_dec (dataqueue_count q) (q.(dq_max_len)-1)
        then after = before
        else after = replace_dataqueues
          (dataqueue_publish p (dataqueue_push q
            {| dq_data := data; dq_length := length |}) before.(os_dataqueues)) before);
     err := fun _ => False |}.

(** 已批准DQ-02/03修复版：每个timeout恰调用一次Obtain，错误统一映射-1。
    成功后执行ring并调用Abandon，忽略Abandon返回值，最终返回0。
    三个阶段之间保留原临界区协议的环境变化，不声称整次Push原子。
    assertS沿用白名单001，检查随后os_inv实际提供queue字段访问权限。 *)
Definition abs_push_dataqueue (sg : StableGlobalState) (p data length timeout : Z)
    : program (VarGlobalState -> Prop) Z :=
  assertS (dataqueue_peak_entry sg p) ;;
  obtain_id <- os_atomic_cmd (abs_dataqueue_push_id p) ;;
  status <- abs_semaphore_obtain sg obtain_id timeout ;;
  IF (status = 0)
    (assertS (dataqueue_peak_entry sg p) ;;
     abandon_id <- os_atomic_cmd (abs_dataqueue_push_ring p data length) ;;
     abs_semaphore_abandon sg abandon_id ;; ret 0)
    (ret (-1)).

(** 追加元素后恢复共享对象的待证接口：front、容量及 ID 保持；
    此Prop只记录实现阶段义务，不作为公理或已证lemma使用。 *)
Definition dataqueue_push_ready_obligation : Prop := forall q e,
  dataqueue_ready q ->
  dataqueue_count q < q.(dq_max_len)-1 ->
  dataqueue_ready (dataqueue_push q e).
