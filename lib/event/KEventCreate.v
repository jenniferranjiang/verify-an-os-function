Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic CNotation.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.common.CrtosInv.
From MonadLib.MonadErr Require Export MonadErrBasic monadesafe_lib.
Import CrtosCNotation ListNotations IDNode DLL MonadErr.
Local Open Scope Z_scope.
Local Open Scope sac.
Local Open Scope string.

(** 锁内创建失败返回-ENOMEMORY=-5且模块不变；复用IdInsertObj规格不保证
    失败必然容量满。成功选择最小空闲ID，发布options低3位/events=0/空等待链
    的新对象，并保持其他所有OS分量。地址新鲜性由malloc分离所有权支持。 *)
Definition abs_event_create_locked (sg : StableGlobalState) (options : Z)
    : program VarGlobalState Z :=
  {| nrm := fun before result after =>
       let sidm := sg.(os_event_stable).(event_manager_stable) in
       let idm := event_manager before.(os_events) in
       (result = -5 /\ after = before) \/
       (exists p,
         p <> 0 /\ addr_aligned p 4 /\
         ~ In p (map event_addr before.(os_events)) /\
         idmanager_min_free_id sidm idm result /\
         after = replace_events
           (event_publish p result options before.(os_events)) before);
     err := fun _ => False |}.

(** malloc失败在锁外直接返回；其余路径执行一次原子创建。
    LastSeen允许进入临界区前环境推进，不能断言入口/返回状态相等，亦不保证
    解锁后对象仍存在；操作自身的效果由锁内关系明确约束。 *)
Definition abs_event_create (sg : StableGlobalState) (options : Z)
    : program (VarGlobalState -> Prop) Z :=
  choice (MonadErr.ret (-5))
    (os_atomic_cmd (abs_event_create_locked sg options)).

Check @safeExec.
Check LastSeen.
Check abs_event_create.
Check EventRaw.
Check EventZero.
