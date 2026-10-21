Require Import CRTOS_Verify.lib.idnode_abs CRTOS_Verify.sem.SemaphorePure CRTOS_Verify.sem.CrtosOSPure.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import CRTOS_Verify.sem.CrtosOSProtocol CRTOS_Verify.sem.CrtosOSInv CRTOS_Verify.sem.CrtosNestedState.
Require Import CRTOS_Verify.sem.CrtosOSProtocolProof.
Require Import SetsClass.SetsClass.
Import SetsNotation Crtos_C_Rules.
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

(** 相对于当前API的outside资源：无外层IRQ栈时，heap invariant仍归全局，
    最后观察nest为0；已有caller栈时，单份caller token及既有invariant整体借入。
    hs不等于nest深度，因为裸IRQ屏蔽不改变KTaskOsAssignLockNest。
    这里不加nest<65535；该新增用户授权域只放在会执行++的API入口。
    因而IRQ自身及已持65535计数的资源仍可被准确表示。 *)
Definition SemaphoreOutsideCritical (sg : CrtosOSStable) (hs : list Z)
    (before : CrtosOSState) : Assertion :=
  “ SemaphoreStableContext sg /\ semaphore_irq_stack_ok hs /\
    CrtosOSValid before /\
    (hs = nil -> before.(os_scheduler).(scheduler_lock_nest) = 0) ” &&
  match hs with
  | nil => CrtosOutsideProtocol before
  | _ :: _ => CrtosInsideProtocol hs before ** SemaphoreOSInvariant sg before
  end.

(** IRQ获取之后的唯一组合token，明确包含原caller的全部outer prefix。
    heap invariant单独返回；current是真正Disable边界取得的状态，随后C的
    ++/--只改变物理nest，不自动改变受保护协议投影或制造新token。
    内层handler=1来自合法保存栈所编码的真实PRIMASK语义，不是新增trusted符号。
    空caller栈入口的真实nest=0事实单独保留，不能被去nest投影抹掉。 *)
Definition SemaphoreInsideCritical (sg : CrtosOSStable) (hs : list Z)
    (handler : Z) (current : CrtosOSState) : Assertion :=
  “ SemaphoreStableContext sg /\ semaphore_irq_stack_ok (handler :: hs) /\
    (hs = nil -> current.(os_scheduler).(scheduler_lock_nest) = 0) ” &&
  CrtosInsideProtocol (handler :: hs) current.

Lemma SemaphoreOutsideCritical_valid : forall sg hs before,
  SemaphoreOutsideCritical sg hs before |--
  “ CrtosOSValid before ” && SemaphoreOutsideCritical sg hs before.
Proof. intros; unfold SemaphoreOutsideCritical; entailer!. Qed.

(** 真实dataqueue调用边界：外层CriticalAreaLock已经返回，nest已+1；
    可以把caller拥有的同一token/invariant借给内层KSemaphoreCreate，
    没有再向全局取第二份heap，也不要求nest=0。 *)
Lemma SemaphoreInsideCritical_borrow_for_nested_call : forall sg hs handler current,
  SemaphoreInsideCritical sg hs handler current **
  SemaphoreOSInvariant sg (semaphore_nest_increment current) |--
  SemaphoreOutsideCritical sg (handler :: hs) (semaphore_nest_increment current).
Proof.
  intros sg hs handler current.
  sep_apply (SemaphoreOSInvariant_valid sg (semaphore_nest_increment current)).
  Intros.
  unfold SemaphoreOutsideCritical, SemaphoreInsideCritical; cbn -[semaphore_irq_stack_ok].
  unfold CrtosInsideProtocol. rewrite CrtosOSProtected_increment.
  entailer!.
  discriminate.
Qed.

(** 内层API返回相同hs后，caller恢复原来的外层token形状和单份已更新heap。
    空外层来源必须仍能恢复nest0：裸IRQ父调用的after.nest=0、正常CriticalLock
    父调用的after.nest=1均满足。该纯事实由真实caller前态及内层scheduler保持
    提供，不能从丢掉来源信息的任意token中凭空取得。 *)
Lemma SemaphoreOutsideCritical_return_to_caller : forall sg hs handler after,
  (hs = nil -> (semaphore_nest_decrement after).(os_scheduler).(scheduler_lock_nest) = 0) ->
  SemaphoreOutsideCritical sg (handler :: hs) after |--
  SemaphoreInsideCritical sg hs handler (semaphore_nest_decrement after) **
  SemaphoreOSInvariant sg after.
Proof.
  intros sg hs handler after Horigin.
  unfold SemaphoreOutsideCritical, SemaphoreInsideCritical; cbn -[semaphore_irq_stack_ok].
  unfold CrtosInsideProtocol. rewrite CrtosOSProtected_decrement.
  entailer!.
Qed.

(** Exit只做STS允许的提交，确实弹出本次handler并返还相同caller prefix。 *)
Lemma SemaphoreIRQExit_protocol_step : forall hs handler before after,
  semaphore_irq_stack_ok (handler :: hs) -> SemaphoreGuarantee before after ->
  CrtosIRQStep
    (Build_nested_critical_state Crtos_C_STS.c_sts (handler :: hs) (CrtosOSProtected before),
      CrtosPrefixTokens (handler :: hs))
    (Build_nested_critical_state Crtos_C_STS.c_sts hs (CrtosOSProtected after),
      CrtosPrefixTokens hs).
Proof.
  intros hs handler before after Hhandlers Hguarantee.
  constructor.
  - exact Hhandlers.
  - apply SemaphoreGuarantee_protected_transition; exact Hguarantee.
  - reflexivity.
  - reflexivity.
Qed.


(** dataqueue式CriticalLock父调用的精确返还前提：子API保持完整scheduler，
    因而空外层的0→1经过子调用后仍为1，下一次Unlock可以回到0。 *)
Lemma SemaphoreNestedCall_preserves_caller_origin : forall (hs : list Z) parent_before after,
  (hs = nil -> parent_before.(os_scheduler).(scheduler_lock_nest) = 0) ->
  SemaphoreGuarantee (semaphore_nest_increment parent_before) after ->
  hs = nil -> (semaphore_nest_decrement after).(os_scheduler).(scheduler_lock_nest) = 0.
Proof.
  intros hs parent_before after Horigin [_ [_ [_ Hscheduler]]] Hempty.
  specialize (Horigin Hempty).
  change (Z.max 0 (after.(os_scheduler).(scheduler_lock_nest) - 1) = 0).
  rewrite Hscheduler.
  change (Z.max 0 (((parent_before.(os_scheduler).(scheduler_lock_nest) + 1) mod 65536) - 1) = 0).
  rewrite Horigin. reflexivity.
Qed.

(** 原outside的空栈计数事实经既定Rely保持，可建立Inside所需来源事实；
    无需加强DisableLocalInterrupt的Require或另加保证子句。 *)
Lemma SemaphoreIRQEnter_preserves_origin : forall hs before current,
  (hs = nil -> before.(os_scheduler).(scheduler_lock_nest) = 0) ->
  SemaphoreRely hs before current ->
  hs = nil -> current.(os_scheduler).(scheduler_lock_nest) = 0.
Proof.
  intros hs before current Horigin [_ [_ [Hnest _]]] Hnil.
  rewrite <- Hnest. apply Horigin; exact Hnil.
Qed.

(** 原IRQ-exit前提已经蕴含返回Outside的所有动态纯条件；嵌套时同一heap
    返还caller，空栈时nest仍为0，避免把去nest投影错当原计数恢复。 *)
Lemma SemaphoreIRQExit_outside_facts : forall hs handler before after,
  semaphore_irq_stack_ok (handler :: hs) ->
  (hs = nil -> before.(os_scheduler).(scheduler_lock_nest) = 0) ->
  SemaphoreGuarantee before after ->
  semaphore_irq_stack_ok hs /\ CrtosOSValid after /\
  (hs = nil -> after.(os_scheduler).(scheduler_lock_nest) = 0).
Proof.
  intros hs handler before after [_ [_ Hstack]] Horigin [_ [Hvalid [_ Hscheduler]]].
  split; [exact Hstack|]. split; [exact Hvalid|].
  intros Hnil. rewrite Hscheduler. apply Horigin; exact Hnil.
Qed.
