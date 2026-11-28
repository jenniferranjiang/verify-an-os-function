Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Export CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Import ListNotations MonadErr Monad MonadNotation.
Local Open Scope Z_scope.
Local Open Scope monad.

(** 只改目标信号量计数；ID、地址、等待顺序及其他对象保持。 *)
Definition semaphore_set_value (p value : Z) (ss : SemaphoreState) : SemaphoreState :=
  map (fun s => if Z.eq_dec s.(semaphore_addr) p then
    {| semaphore_addr := s.(semaphore_addr); semaphore_id := s.(semaphore_id);
       semaphore_value := value; semaphore_pending_addrs := s.(semaphore_pending_addrs) |}
    else s) ss.

(** Resume只唤醒当前队首，不写exstatus；取消延时、迁移ready及其余frame
    直接沿用已存在的wakeup接口。非空条件来自调用点。 *)
Definition semaphore_resume_head_effect (p : Z) (before after : VarGlobalState) : Prop :=
  exists sem task rest desc,
    In sem before.(os_semaphores) /\ sem.(semaphore_addr) = p /\
    sem.(semaphore_pending_addrs) = task :: rest /\
    before.(os_tasks).(task_desc_map) task = Some desc /\
    wakeup_semaphore_head p task desc before after.

(** 一次锁内release：不存在返回-ERROR；有等待者时直接交付许可并唤醒首任务；
    无等待者时计数饱和返回-EFULL，否则加一。bool只决定锁外调度。 *)
Definition semaphore_abandon_effect (id : Z) (before : VarGlobalState)
    (result : Z * bool) (after : VarGlobalState) : Prop :=
  ((forall sem, In sem before.(os_semaphores) -> sem.(semaphore_id) <> id) /\
    result = (-KERROR,false) /\ after = before) \/
  exists sem, In sem before.(os_semaphores) /\ sem.(semaphore_id) = id /\
    ((sem.(semaphore_pending_addrs) <> nil /\ result = (KOK,true) /\
       semaphore_resume_head_effect sem.(semaphore_addr) before after) \/
     (sem.(semaphore_pending_addrs) = nil /\
       ((sem.(semaphore_value) = 65535 /\ result = (-KFULL,false) /\ after = before) \/
        (sem.(semaphore_value) <> 65535 /\ result = (KOK,false) /\
         after = replace_semaphores
           (semaphore_set_value sem.(semaphore_addr) (sem.(semaphore_value)+1)
             before.(os_semaphores)) before)))).
Definition abs_semaphore_abandon_locked (id : Z) : program VarGlobalState (Z * bool) :=
  {| nrm := semaphore_abandon_effect id; err := fun _ => False |}.

(** 非法ID在加锁前拒绝；成功唤醒才调用既有调度模型，其他出口不调度。 *)
Definition abs_semaphore_abandon (sg : StableGlobalState) (id : Z)
    : program (VarGlobalState -> Prop) Z :=
  IF (semaphore_id_invalid id)
    (ret (-KERROR))
    (result <- task_atomic_cmd (abs_semaphore_abandon_locked id) ;;
     IF (snd result = true) abs_ktask_assign (ret tt) ;;
     ret (fst result)).
