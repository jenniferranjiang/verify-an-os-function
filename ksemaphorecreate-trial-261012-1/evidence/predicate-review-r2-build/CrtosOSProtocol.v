Require Import Coq.ZArith.ZArith.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import SL.ConAssertion SL.CriticalSTS.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.CrtosHeapBridge.

(** 本次 CRTOS-global candidate 把 task、scheduler、semaphore 的统一状态
    接入 QCP 既有 critical_STS。真实 IRQ disable/restore 是资源交接边界；
    普通内存读写不自行产生临界 token。 *)
Module Crtos_C_STS <: critical_STS_def.
  Definition c_sts : critical_STS :=
    Build_critical_STS CrtosOSState CrtosOSTransition.
End Crtos_C_STS.

Module Crtos_STS.
  Include critical_STS_to_STS_def Crtos_C_STS.
End Crtos_STS.

(** 唯一 OS assertion carrier。这里使用 QCP 原有 CSL、store、array、map
    框架接口；没有添加任何本次实验的假设或改变根共享 Task 定义。 *)
Module Crtos_C_Rules.
  Include Crtos_STS.
  Include ConAssertion.CSL.
  Include DerivedPredSig.
  Include StoreLibSig.
  Include ArrayLibSig.
  Include MapLibSig.
  Include StringLibSig.
End Crtos_C_Rules.

Module CrtosCritical.
  Include CriticalCSL Crtos_C_STS Crtos_STS Crtos_C_Rules Crtos_C_Rules.
End CrtosCritical.

(** 正式根库的纯 heap 断言使用同一 OS carrier；CrtosHeapBridge 已证明
    该解释保持分离组合与既有 entailment，不迁移 Task 协议 token。 *)
Definition OSHeap := crtos_heap_lift Crtos_STS.sts.
