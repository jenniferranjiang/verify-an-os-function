From SimpleC.SL Require Import Mem SeparationLogic.
Require Import SL.ConAssertion SL.CriticalSTS.
Require Import CrtosProbeFramework.NestedCriticalAdapter.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Import CRTOS_Verify.lib.CrtosRules.
Require Import CRTOS_Verify.sem.CrtosOSPure CRTOS_Verify.sem.CrtosHeapBridge.
Import ListNotations.
Local Open Scope Z_scope.

(** 探针只验证nested carrier与根heap表示可以类型相容；不是批准协议。
    正式r1不导入本文件。NCS现成outside分支不绑定before，真实IRQ环境
    排他性也必须另外证明；不能从编译通过推出正确acquire/release规则。 *)
Module ProbeNested_C_STS <: nested_critical_STS_def.
  Definition nc_sts : critical_STS :=
    Build_critical_STS CrtosOSState CrtosOSTransition.
End ProbeNested_C_STS.
Module ProbeNested_STS.
  Include nested_critical_STS_to_STS_def ProbeNested_C_STS.
End ProbeNested_STS.
Module ProbeNested_Rules.
  Include ProbeNested_STS.
  Include ConAssertion.CSL.
  Include DerivedPredSig.
  Include StoreLibSig.
  Include ArrayLibSig.
  Include MapLibSig.
  Include StringLibSig.
End ProbeNested_Rules.
Module ProbeNestedCritical.
  Include NestedCriticalCSL ProbeNested_C_STS ProbeNested_STS
    ProbeNested_Rules ProbeNested_Rules.
End ProbeNestedCritical.

(** 同一份已证明heap bridge也能用于nested carrier；没有复制heap资源。 *)
Definition ProbeNestedHeap : Task_C_Rules.expr -> ProbeNested_Rules.expr :=
  crtos_heap_lift ProbeNested_STS.sts.

(** 临界计数的局部C写可以与受保护OS投影分开：仅把nest归零，保留全部
    task、Assign、semaphore内容。实际nest仍必须由heap拥有且联系handler深度。
    此投影不是消除65535溢出造成的真实frame变化的许可。 *)
Definition ProbeProtectedOS (s : CrtosOSState) : CrtosOSState :=
  os_with_scheduler (scheduler_with_nest 0 s.(os_scheduler)) s.

(** 正确的stack-depth/真实uint16关系需要允许取模，但单有此式不足以证明
    任意深度进入再退出都恢复nest，所以没有将它加入r1的正式validity。 *)
Definition ProbeDepthMatches (handlers : list Z) (s : CrtosOSState) : Prop :=
  s.(os_scheduler).(scheduler_lock_nest) =
    Z.of_nat (List.length handlers) mod 65536.

Lemma ProbeProtectedOS_increment : forall s,
  ProbeProtectedOS (semaphore_nest_increment s) = ProbeProtectedOS s.
Proof.
  intros [tasks [nest running priority ready bitmap highest] sems].
  reflexivity.
Qed.
Lemma ProbeProtectedOS_decrement : forall s,
  ProbeProtectedOS (semaphore_nest_decrement s) = ProbeProtectedOS s.
Proof.
  intros [tasks [nest running priority ready bitmap highest] sems].
  reflexivity.
Qed.

(** 分离组合仍使用已证明通用桥；此lemma只证明carrier适配，不是IRQ规则。 *)
Lemma ProbeNestedHeap_separates : forall P Q s,
  ProbeNestedHeap (Task_C_Rules.sepcon P Q) s <->
  ProbeNested_Rules.sepcon (ProbeNestedHeap P) (ProbeNestedHeap Q) s.
Proof. intros; apply crtos_heap_lift_sep. Qed.
