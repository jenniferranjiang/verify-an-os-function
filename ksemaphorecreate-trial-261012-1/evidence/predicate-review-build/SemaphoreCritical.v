Require Import CRTOS_Verify.lib.idnode_abs CRTOS_Verify.sem.SemaphorePure CRTOS_Verify.sem.CrtosOSPure.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import CRTOS_Verify.sem.CrtosOSProtocol CRTOS_Verify.sem.CrtosOSInv.
Import Crtos_C_Rules.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope sac.

(** static semaphore 管理器与链表对应当前权威 C 的全局符号；done dispatch
    已唯一解析为直接调用，不作为 heap field 或 ghost state 重复建模。 *)
Definition SemaphoreStableContext (sg : CrtosOSStable) : Prop :=
  let sem := sg.(os_sem_stable) in
  sem.(semaphore_manager_addr) = &("k_sem_id_manager") /\
  sem.(semaphore_registry_addr) = &("k_sem_list") /\
  sem.(semaphore_manager_abs).(idmax) = 128 /\
  sem.(semaphore_manager_abs).(hoffset) = 16 /\
  sem.(semaphore_manager_abs).(id_map) = &("__id_map_k_sem_id_manager") /\
  sem.(semaphore_manager_abs).(htable) = &("__htable_k_sem_id_manager").

(** Cortex-M3 的 PRIMASK 只使用bit0，DisableLocalInterrupt 返回原mask，
    EnableLocalInterrupt 原样恢复；既允许0也允许1，不将返回handler伪造为0。 *)
Definition semaphore_irq_handler_ok (handler : Z) : Prop :=
  handler = 0 \/ handler = 1.

(** 当前对外 create API 的非嵌套边界：没有 caller 持有调度禁止层，nest=0。
    OS rely 可以推进 task/scheduler/semaphore，但临界区外观察仍是nest0；
    该定义不把 heap invariant放在outside，而由真实IRQ边界原子交出。 *)
Definition SemaphoreOutsideCritical (sg : CrtosOSStable) (before : CrtosOSState)
    : Assertion :=
  “ SemaphoreStableContext sg /\
    before.(os_scheduler).(scheduler_lock_nest) = 0 ” &&
  CrtosCritical.OutsideCritical before.

(** 真实IRQ acquire后的唯一inside token，索引仍是刚关中断的current。
    handler 是原PRIMASK；内存随后可以经过 nest+1、create、nest-1 改变，
    token不随局部写同步改索引，IRQ exit借保证关系提交最后OS invariant。 *)
Definition SemaphoreInsideCritical (sg : CrtosOSStable) (handler : Z)
    (current : CrtosOSState) : Assertion :=
  “ SemaphoreStableContext sg /\ semaphore_irq_handler_ok handler ” &&
  CrtosCritical.InsideCritical current.

(** OutsideCritical内部存在一条Rely，因此before有效性已来自协议，不需要
    给公共Require另加一个业务假设。非法before不存在这样的资源。 *)
Lemma SemaphoreOutsideCritical_valid : forall sg before,
  SemaphoreOutsideCritical sg before |--
  “ CrtosOSValid before ” && SemaphoreOutsideCritical sg before.
Proof.
  intros sg before.
  unfold SemaphoreOutsideCritical, CrtosCritical.OutsideCritical.
  Intros later.
  cbn [Crtos_C_STS.c_sts] in *.
  unfold CrtosOSTransition in *.
  Intros.
  Exists later.
  entailer!.
  change (CrtosOSTransition before later) in H.
  exact (proj1 H).
Qed.
