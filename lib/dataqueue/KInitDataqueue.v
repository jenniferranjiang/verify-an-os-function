From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
From SimpleC.SL Require Import Mem.
Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Export CRTOS_Verify.lib.semaphore.KSemaphoreCreate.
Require Export CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.
Import ListNotations MonadErr.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope Z_scope.

(** malloc后尚不初始化数组元素；memset只覆盖20字节queue结构。
    base=0时无数组；n=1允许成功，n=0由本轮allocator contract返回0。 *)
Definition dataqueue_constructed (n base blank data : Z) : DataQueueAbs :=
  {| dq_base := base; dq_max_len := n;
     dq_front := 0; dq_rear := 0; dq_sem_blank := blank; dq_sem_data := data;
     dq_slots := if Z.eq_dec base 0 then nil else repeat None (Z.to_nat n) |}.

(** 第一段临界区的局部结果；semaphore地址witness随结果跨失败解锁传递，
    不进入模块状态、也不作为用户C参数。 *)
Record DataqueueInitAttempt := {
  dq_attempt_object : DataQueueAbs;
  dq_attempt_refs : DataqueueSemRefs
}.
Definition dataqueue_attempt_succeeded (a : DataqueueInitAttempt) : bool :=
  (0 <=? a.(dq_attempt_object).(dq_sem_blank)) &&
  (0 <=? a.(dq_attempt_object).(dq_sem_data)).

(** malloc失败、首次create失败、第二次create失败、成功四条真实路径。
    各次create效果复用IC定义，成功后才把queue资源发布到os_dataqueues。
    refs在获得ID的同一状态选取并保持，用于失败后cleanup的地址/ID 对应检查。 *)
Definition dataqueue_init_phase_effect (sg : StableGlobalState) (p n : Z)
    (before : VarGlobalState) (a : DataqueueInitAttempt) (after : VarGlobalState) : Prop :=
  (a = {| dq_attempt_object := dataqueue_constructed n 0 (-1) (-1);
          dq_attempt_refs := (None, None) |} /\ after = before) \/
  (exists base blank first,
    0 < n /\ base <> 0 /\ addr_aligned base 4 /\
    semaphore_create_ic_effect sg (n-1) before blank first /\
    ((blank = -5 /\
      a = {| dq_attempt_object := dataqueue_constructed n base blank (-1);
             dq_attempt_refs := (None, None) |} /\ after = first) \/
     (0 <= blank /\ exists blank_ptr data second,
       dataqueue_sem_ref blank (Some blank_ptr) first.(os_semaphores) /\
       semaphore_create_ic_effect sg 0 first data second /\
       ((data = -5 /\
         a = {| dq_attempt_object := dataqueue_constructed n base blank data;
                dq_attempt_refs := (Some blank_ptr, None) |} /\ after = second) \/
        (0 <= data /\ exists data_ptr,
          dataqueue_sem_ref data (Some data_ptr) second.(os_semaphores) /\
          a = {| dq_attempt_object := dataqueue_constructed n base blank data;
                 dq_attempt_refs := (Some blank_ptr, Some data_ptr) |} /\
          second.(os_dataqueues).(dataqueue_map) p = None /\
          after = replace_dataqueues
            (dataqueue_publish p a.(dq_attempt_object) second.(os_dataqueues)) second))))).

Definition abs_init_dataqueue_phase (sg : StableGlobalState) (p n : Z)
    : program VarGlobalState DataqueueInitAttempt :=
  {| nrm := dataqueue_init_phase_effect sg p n;
     err := fun _ => False |}.

(** 成功只经历一段临界区；三类失败均先Unlock，再通过DeInit的IRQ临界区
    清理，最后返回-1。顺序记法保留该可抢占窗口，不把两段合为原子操作。 *)
Definition abs_init_dataqueue (sg : StableGlobalState) (p n : Z)
    : program (VarGlobalState -> Prop) Z :=
  a <- os_atomic_cmd (abs_init_dataqueue_phase sg p n) ;;
  if dataqueue_attempt_succeeded a then ret 0
  else abs_deinit_dataqueue sg p a.(dq_attempt_object) a.(dq_attempt_refs) ;;
       ret (-1).
