(** KMutexDelete、_MutexDelete 与 LinklistResumeAll 的纯效果及抽象 program。 *)
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import SetsClass.SetsClass.
From Logic.lib Require Import Coqlib.
From SimpleC.SL Require Import Mem CNotation IntLib.
From MonadLib.MonadErr Require Export MonadErrBasic monadesafe_lib.
Require Export KMutexDeleteTrial.lib.MutexInv.

Import KTaskCNotation ListNotations MonadErr SetsNotation.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope Z_scope.
Local Open Scope list_scope.
Local Open Scope sets_scope.
Local Open Scope string_scope.
Local Open Scope sac.

(** 参考消息队列删除接口，将对象有效域放在原生 program 的检查中。
    该条件只约束随后可能取得的锁观察；不拥有内存，也不加强 Lock 契约。
    它必须由 safeExec 的调用条件承担，不能把不存在对象时的空正常关系
    当成安全保证。当前 True rely 下的可满足性须单独审查。 *)
Definition mutex_resume_entry_condition (sg : StableGlobalState) (p : addr)
    (states : VarGlobalState -> Prop) : Prop :=
  forall observed, states observed ->
    os_inv sg observed |-- “ mutex_present p observed ”.

(** 注销操作需要同一次锁观察中的目标对象和空 pending。
    对象描述及内部 ID 的 witness 留在抽象语义内部，不成为公开 With 参数。
    A1--A3 的文档批准并不自动证明此集合上的检查成立。 *)
Definition mutex_detach_entry_condition (sg : StableGlobalState) (p : addr)
    (states : VarGlobalState -> Prop) : Prop :=
  forall observed, states observed ->
    os_inv sg observed |--
      “ exists mutex,
          mutex_delete_find_addr p observed.(os_mutexes) = Some mutex /\
          mutex.(mutex_pending_addrs) = nil ”.

(** 已持有 共享任务模型 critical 资源时的 uint16 ID 查询。 *)
Definition abs_mutex_lookup_locked (id : Z)
    : program VarGlobalState (option addr) :=
  {| nrm := fun before result after =>
       after = before /\
       match result with
       | None =>
           mutex_delete_find_id (mutex_delete_query_id id)
             before.(os_mutexes) = None
       | Some p => exists mutex,
           mutex_delete_find_id (mutex_delete_query_id id)
             before.(os_mutexes) = Some mutex /\
           p = mutex.(mutex_addr)
       end;
     err := fun _ => False |}.

(** LinklistResumeAll 在一次加锁观察中的 fresh 批量效果。 *)
Definition abs_linklist_resume_all_locked (p : addr)
    : program VarGlobalState Z :=
  {| nrm := fun before result after =>
       result = 0 /\ mutex_delete_resume_all_step p before after;
     err := fun _ => False |}.

(** _MutexDelete 第二个临界区的注销效果；公开 target 只有 p。 *)
Definition abs_mutex_detach_locked (p : addr)
    : program VarGlobalState MutexAbs :=
  {| nrm := fun before removed after =>
       mutex_delete_find_addr p before.(os_mutexes) = Some removed /\
       removed.(mutex_pending_addrs) = nil /\
       mutex_delete_detach_step p before after;
     err := fun _ => False |}.

(** 先检查目标有效域，再沿用系统既有 atomic lifting。
    因而公开 C spec 不必重复给出 exists obj 或对象描述符参数。 *)
Definition abs_linklist_resume_all (sg : StableGlobalState) (p : addr)
    : program (VarGlobalState -> Prop) Z :=
  assertS (mutex_resume_entry_condition sg p) ;;
  task_atomic_cmd (abs_linklist_resume_all_locked p).

(** 两段真实临界区依 C 顺序组合。目标存活与第二段 pending 仍空作为
    program 的 checked 条件交给 safeExec，不添加新锁语义或 env 参数。
    已批准 A1--A3 尚需连接到允许的观察集合，不能用文字批准代替此证明。
    注销产生的 MutexRaw 由空间接口交给 x_free，纯状态无需记录已释放内存。 *)
Definition abs_mutex_delete (sg : StableGlobalState) (p : addr)
    : program (VarGlobalState -> Prop) unit :=
  assume!! (p <> 0) ;;
  abs_linklist_resume_all sg p ;;
  assertS (mutex_detach_entry_condition sg p) ;;
  task_atomic_cmd (abs_mutex_detach_locked p) ;;
  ret tt.

(**
  KMutexDelete 的公开 id 行为。负值不取锁；非负值按 uint16 查询；
  命中后转入仅以 p 表示的 _MutexDelete 行为。
*)
Definition abs_kmutex_delete (sg : StableGlobalState) (id : Z)
    : program (VarGlobalState -> Prop) unit :=
  IF (id < 0) (ret tt)
    (found <- task_atomic_cmd (abs_mutex_lookup_locked id) ;;
     match found with
     | None => ret tt
     | Some p => abs_mutex_delete sg p
     end).

(** 空 pending 注销不改变任何调度节点 owner；纯 world-wf 保持义务。 *)
Definition mutex_delete_detach_preserves_world_obligation : Prop :=
  forall sg p before after,
    os_world_wf sg before ->
    mutex_delete_detach_step p before after ->
    os_world_wf sg after.

Check @safeExec.
Check @task_atomic_cmd.
Check abs_mutex_delete.
Check abs_kmutex_delete.
