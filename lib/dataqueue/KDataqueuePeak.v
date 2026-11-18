Require Import Coq.ZArith.ZArith Coq.Lists.List.
From SimpleC.SL Require Import Mem.
From MonadLib.MonadErr Require Import MonadErrBasic monadesafe_lib.
Require Export CRTOS_Verify.lib.common.CrtosInv.
Import ListNotations MonadErr.
Import Monad MonadNotation.
Local Open Scope Z_scope.
Local Open Scope monad.
Local Open Scope sac.

(** StartAddr指向的单个输出指针槽。Some记录已有值，None仅拥有未初始化
    或未知内容；两种形态都允许成功路径覆写，不拥有所存payload指针的目标。 *)
Definition peak_data_slot (p : addr) (old : option Z) : Assertion :=
  match old with
  | Some v => p # Ptr |-> v
  | None => p # Ptr |->_
  end.

(** size指向的x_size_t输出槽；当前ILP32下为32位unsigned long，与UInt
    使用同一32位无符号存储表示。空分支保持Some的旧值或None的未知内容。 *)
Definition peak_length_slot (p : addr) (old : option Z) : Assertion :=
  match old with
  | Some v => p # UInt |-> v
  | None => p # UInt |->_
  end.

(** 真实C参数p_queue定位随后加锁观察中的共享对象。这里的存在事实来自
    该观察的os_inv，不从入口纯状态或裸指针获得访问权限；ready和槽初始化
    由dataqueue_inv提供。assertS采用默认审阅白名单001，不改变锁契约。 *)
Definition dataqueue_peak_entry (sg : StableGlobalState) (p : addr)
    (states : VarGlobalState -> Prop) : Prop :=
  forall observed, states observed ->
    os_inv sg observed |--
      “ exists q, observed.(os_dataqueues).(dataqueue_map) p = Some q ”.

(** 一次锁内查询的完整行为：front=rear时None，否则返回当前front槽。
    after=before仅表示这一次锁内操作不写任何OS对象，包括queue数组及
    semaphore；它不把进入函数到加锁间的环境变化抹掉。 *)
Definition abs_dataqueue_peak_locked (p : addr)
    : program VarGlobalState (option DataqueueElem) :=
  {| nrm := fun before result after =>
       after = before /\ exists q,
         before.(os_dataqueues).(dataqueue_map) p = Some q /\
         ((q.(dq_front) = q.(dq_rear) /\ result = None) \/
          (q.(dq_front) <> q.(dq_rear) /\ exists e,
            dataqueue_peak q = Some e /\ result = Some e));
     err := fun _ => False |}.

(** 检查候选观察后只做一段真实临界区；两种C出口均解锁。
    None对应-1并保持caller输出，Some对应0并复制指针及长度；输出cell
    ownership由C契约单独保留，不混入共享queue或payload模型。 *)
Definition abs_dataqueue_peak (sg : StableGlobalState) (p : addr)
    : program (VarGlobalState -> Prop) (option DataqueueElem) :=
  assertS (dataqueue_peak_entry sg p) ;;
  os_atomic_cmd (abs_dataqueue_peak_locked p).

(** 借出已登记queue后保留所有其他OS资源及其精确归还关系；Peak读后交回
    同一store_dataqueue即可恢复同一锁内os_inv。仅陈述待证义务，不是公理。 *)
Definition dataqueue_peak_focus_obligation : Prop := forall sg st p q,
  st.(os_dataqueues).(dataqueue_map) p = Some q ->
  os_inv sg st |--
    store_dataqueue p q ** (store_dataqueue p q -* os_inv sg st).
