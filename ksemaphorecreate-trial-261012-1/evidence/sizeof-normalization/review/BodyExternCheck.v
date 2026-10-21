From Coq Require Import ZArith Lists.List Program.Basics.
Require Import CRTOS_Verify.lib.idnode.
Require Import CRTOS_Verify.sem.SemaphorePure CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.sem.CrtosOSPure CRTOS_Verify.sem.CrtosOSInv.
Import ListNotations IDNode DLL.
Local Open Scope Z_scope.

(** 本文件只检查已有body声明的类型实例，不复制C契约或引入layout事实。 *)
Check (@Basics.const (SemaphoreObject -> Task_C_Rules.expr) Z :
  (SemaphoreObject -> Task_C_Rules.expr) -> Z -> SemaphoreObject -> Task_C_Rules.expr).
Check (@List.map (DL_Node SemaphoreObject) SemaphoreObject :
  (DL_Node SemaphoreObject -> SemaphoreObject) -> list (DL_Node SemaphoreObject) -> SemaphoreState).
Check (@List.In : forall A : Type, A -> list A -> Prop).
Check (@data : forall A : Type, DL_Node A -> A).
Check (@ptr : forall A : Type, DL_Node A -> Z).
Check (semaphore_addr : SemaphoreObject -> Z).
Check (store_semaphore_body : SemaphoreObject -> Task_C_Rules.expr).
Check (@DLL.dll_nodes_nonzero : forall A : Type, list (DL_Node A) -> Prop).
Check (@DLL.dllseg_shift_rev : forall A : Type,
  (Z -> A -> Task_C_Rules.expr) -> Z -> Z -> list (DL_Node A) -> Task_C_Rules.expr).
Check (os_tasks : CrtosOSState -> VarGlobalState).
Check (CrtosBorrowedRep.store_task_semaphore_views : VarGlobalState -> Task_C_Rules.expr).
Check (CrtosBorrowedRep.store_scheduler_view : SchedulerState -> Task_C_Rules.expr).
Check (store_sem_registry : SemaphoreStable -> SemaphoreState -> Task_C_Rules.expr).
Check (store_sem_registered_private : Z -> Task_C_Rules.expr).
Check (store_sem_padding : Z -> Task_C_Rules.expr).
Check (semaphore_object_addresses : Z -> Prop).

(** const仅忽略额外link地址，不制造payload资源。 *)
Example const_payload_reduces : forall p obj,
  Basics.const store_semaphore_body p obj = store_semaphore_body obj.
Proof. reflexivity. Qed.

Print Assumptions const_payload_reduces.
