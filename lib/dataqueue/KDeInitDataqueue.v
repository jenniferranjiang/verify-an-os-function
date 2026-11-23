From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
From SimpleC.SL Require Import Mem.
Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Export CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Require Export CRTOS_Verify.lib.dataqueue.DataqueueInv.
Import ListNotations MonadErr.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope Z_scope.
Local Open Scope sac.

(** 仅函数调用期间保存的 semaphore 地址/ID 对应；不复制其字段或内存。
    负 sentinel 无对象；非负 ID 对应首次取得的地址，跨解锁不重选。
    相同地址/ID可能经历ABA复用；该见证不提供分配世代或永久生命周期身份。 *)
Definition DataqueueSemRefs := (option addr * option addr)%type.
Definition dataqueue_sem_ref (id : Z) (ref : option addr)
    (ss : SemaphoreState) : Prop :=
  match ref with
  | None => id < 0
  | Some p => 0 <= id < 128 /\ exists s,
      In s ss /\ s.(semaphore_addr) = p /\ s.(semaphore_id) = id /\
      s.(semaphore_pending_addrs) = nil
  end.

(** 当前 cleanup 仅接收尚未发布的部分初始化对象；删除关联 semaphore 前
    检查保存的地址/ID 对应、空 pending，及没有其他已发布 queue 借用这些 ID。
    caller-owned queue 本体/数组始终在 os_inv 之外，直到 free 后返还结构。 *)
Definition dataqueue_cleanup_guard (p : addr) (q : DataQueueAbs) (refs : DataqueueSemRefs)
    (st : VarGlobalState) : Prop :=
  st.(os_dataqueues).(dataqueue_map) p = None /\
  dataqueue_sem_ref q.(dq_sem_blank) (fst refs) st.(os_semaphores) /\
  dataqueue_sem_ref q.(dq_sem_data) (snd refs) st.(os_semaphores) /\
  semaphore_delete_quiescent q.(dq_sem_blank) st /\
  semaphore_delete_quiescent q.(dq_sem_data) st.

(** 与 C 的两个条件 delete 同序；base free 不修改 OS 状态；未负 ID 先变 -1，
    已负错误码保持。结构/数组的具体变化由 dataqueue_retired 和 owned 表示。 *)
Definition dataqueue_cleanup_effect (q : DataQueueAbs)
    (before after : VarGlobalState) : Prop :=
  exists middle,
    (if Z.leb 0 q.(dq_sem_blank)
     then semaphore_delete_ic_effect q.(dq_sem_blank) before middle
     else middle = before) /\
    (if Z.leb 0 q.(dq_sem_data)
     then semaphore_delete_ic_effect q.(dq_sem_data) middle after
     else after = middle).

(** 默认审阅白名单001适用：assertS由safeExec承担随后IRQ观察条件，
    不加强trusted IRQ接口，也不将宽松Rely下条件可满足性声称为已证。 *)
Definition dataqueue_cleanup_entry (sg : StableGlobalState) (p : addr) (q : DataQueueAbs)
    (refs : DataqueueSemRefs) (states : VarGlobalState -> Prop) : Prop :=
  forall observed, states observed ->
    os_inv sg observed |-- “ dataqueue_cleanup_guard p q refs observed ”.
Definition abs_deinit_dataqueue_locked (q : DataQueueAbs)
    : program VarGlobalState unit :=
  {| nrm := fun before _ after => dataqueue_cleanup_effect q before after;
     err := fun _ => False |}.
Definition abs_deinit_dataqueue (sg : StableGlobalState) (p : addr) (q : DataQueueAbs)
    (refs : DataqueueSemRefs) : program (VarGlobalState -> Prop) unit :=
  assertS (dataqueue_cleanup_entry sg p q refs) ;;
  os_atomic_cmd (abs_deinit_dataqueue_locked q).
