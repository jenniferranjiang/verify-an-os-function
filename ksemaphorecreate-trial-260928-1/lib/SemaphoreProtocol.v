Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Export CRTOS_Verify.sem.CrtosOSPure.
Require Export CRTOS_Verify.sem.CrtosOSProtocol.

(**
  Semaphore 不再实例化第二套 STS/assertion carrier。本文件只保留模块命名的
  薄接口，全部定义直接指向 [CrtosOSProtocol] 的统一 task/scheduler/semaphore
  world；因此真实共享的 CriticalAreaLock 只能打开同一份 OS ghost state。
*)

Definition SemaphoreCritical := CrtosOSInsideCritical.
Definition SemaphoreOutsideCritical := CrtosOSOutsideCritical.

Definition SemaphoreInsideCritical
    (handler : Z) (handlers : list Z)
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Assertion :=
  CrtosOSInsideCritical (handler :: handlers) stable world.

Definition SemaphoreRely := CrtosOSRely.
Definition SemaphoreGuarantee := CrtosOSGuarantee.

Lemma SemaphoreRely_refl :
  forall stable world, SemaphoreRely stable world world.
Proof.
  exact CrtosOSRely_refl.
Qed.

Lemma SemaphoreGuarantee_refl :
  forall stable world, SemaphoreGuarantee stable world world.
Proof.
  exact CrtosOSGuarantee_refl.
Qed.
