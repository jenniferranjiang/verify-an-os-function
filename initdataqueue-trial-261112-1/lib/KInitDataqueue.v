Require Import Coq.ZArith.ZArith Coq.Lists.List.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export InitDataqueueTrial.lib.DataqueueInv.
Require Export InitDataqueueTrial.lib.DataqueueSemaphore.
From MonadLib.MonadErr Require Import MonadErrBasic monadesafe_lib.
Import ListNotations MonadErr Monad MonadNotation.
Local Open Scope Z_scope.
Local Open Scope monad.
Local Open Scope sac.

(** 初始化保留NodeNumber，清零front/rear；数组未初始化，两个ID按实际
    获取结果保存。该纯构造不拥有C内存。 *)
Definition dq_initialized (n b blank data blank_object data_object : Z) : DataqueueAbs :=
  {| dq_front := 0; dq_rear := 0; dq_max_len := n;
     dq_base := b; dq_blank := blank; dq_data := data;
     dq_blank_object := blank_object; dq_data_object := data_object |}.

(** Init成功的结构条件；不把容量0/1排除，不承诺后续Push/Pop都合法。 *)
Definition dq_init_success (q : DataqueueAbs) : Prop :=
  q.(dq_base) <> 0 /\ 0 <= q.(dq_blank) /\ 0 <= q.(dq_data).

(** 失败/成功的C返回码分别为-ERROR/EOK。 *)
Definition dq_init_code (q : DataqueueAbs) : Z :=
  if Z.eqb q.(dq_base) 0 then -1
  else if Z.ltb q.(dq_blank) 0 then -1
  else if Z.ltb q.(dq_data) 0 then -1 else 0.

(** 从当前权威Semaphore对象序列提取创建成功的地址；只记录身份，不
    复制对象权限。合法IDmanager保证同一ID唯一，未命中得到0。 *)
Definition dq_sem_address (id : Z) (st : VarGlobalState) : addr :=
  match find (fun sem => Z.eqb sem.(semaphore_id) id) st.(os_semaphores) with
  | Some sem => sem.(semaphore_addr)
  | None => 0
  end.

(** 锁内初始化先尝试数组分配，再顺序创建两个信号量。
    malloc(0)同时允许空/非空结果；只约束成功地址和长度的32位有效范围。
    val=n-1传uint16时取模，n=0精确得到65535。malloc失败不创建信号量，
    首次创建失败不进行第二次创建。ID=0和-5都保留真实分支。 *)
Definition dq_prepare_locked (sg : StableGlobalState) (n : Z)
    : program VarGlobalState DataqueueAbs :=
  choice
    (ret (dq_initialized n 0 (-1) (-1) 0 0))
    (b <- get (fun (_ : VarGlobalState) (b : Z) => 0 < b /\ b <= 4294967295 - n*8 /\ addr_aligned b 4) ;;
     blank <- dq_semaphore_create_ic sg ((n-1) mod 65536) ;;
     if Z.ltb blank 0 then ret (dq_initialized n b blank (-1) 0 0)
     else blank_object <- get' (dq_sem_address blank) ;;
          data <- dq_semaphore_create_ic sg 0 ;;
          data_object <- get' (dq_sem_address data) ;;
          ret (dq_initialized n b blank data blank_object data_object)).

(** 成功的共享条目保留整个数组的未知slot初值。对象地址就是Init真实
    形参，ghost registry没有新增可执行C结构或全局表。 *)
Definition dq_initial_entry (q : DataqueueAbs) : PublishedDataqueue :=
  {| published_queue := q; published_slots := dataqueue_init_slots q;
     published_phase := DQActive |}.

(** 只有全部初始化成功才把对象和buffer从当前初始化者转给共享invariant。
    同地址旧entry不存在由os_inv与私有Raw分离推导；不是无据禁止ID0或
    创建失败。失败对象不发布，仍由caller资源进入后续IRQ回滚。 *)
Definition dq_init_locked (sg : StableGlobalState) (p : addr) (n : Z)
    : program VarGlobalState DataqueueAbs :=
  q <- dq_prepare_locked sg n ;;
  if Z.eqb (dq_init_code q) 0 then
    update (fun before after => before.(os_dataqueues) p = None /\
      after = replace_dataqueues
        (dataqueue_replace p (Some (dq_initial_entry q)) before.(os_dataqueues)) before) ;;
    ret q
  else ret q.

(** 初始化成功的退出snapshot在OS共享map内持有同一对象及数组。
    此为纯成员关系，不额外授予caller一份对象权限。 *)
Definition dq_published_at (p : addr) (q : DataqueueAbs) (st : VarGlobalState) : Prop :=
  st.(os_dataqueues) p = Some (dq_initial_entry q).

(** rollback所删信号量必须没有等待者。这个纯观察关系不拥有OS内存，
    通过创建时地址witness检查同一对象仍然存在；不能删除同ID的替代对象。 *)
Definition dq_rollback_empty (q : DataqueueAbs) (st : VarGlobalState) : Prop :=
  (q.(dq_blank) < 0 \/ exists sem,
    In sem st.(os_semaphores) /\ sem.(semaphore_id) = q.(dq_blank) /\
    sem.(semaphore_addr) = q.(dq_blank_object) /\ sem.(semaphore_pending_addrs) = nil) /\
  (q.(dq_data) < 0 \/ exists sem,
    In sem st.(os_semaphores) /\ sem.(semaphore_id) = q.(dq_data) /\
    sem.(semaphore_addr) = q.(dq_data_object) /\ sem.(semaphore_pending_addrs) = nil).

(** IRQ保护下顺序free数组、删除blank/data。free只消费caller的buffer，
    不改变OS状态；sem删除用现有系统状态，其他模块由delete效果保持。 *)
Definition dq_deinit_locked (q : DataqueueAbs)
    : program VarGlobalState DataqueueAbs :=
  (if Z.leb 0 q.(dq_blank) then dq_semaphore_delete_ic q.(dq_blank) else ret tt) ;;
  (if Z.leb 0 q.(dq_data) then dq_semaphore_delete_ic q.(dq_data) else ret tt) ;;
  ret (dq_cleared q).

(** 失败路径先Unlock，再在DeInit中Disable。Rely=True时候选状态可能任意，
    必须检查每个可观察合法OS状态的rollback条件；safeExec承担assertS，
    此建模适用白名单001，不将其写作已证明的环境稳定性。IRQ协议不建模
    硬件状态，复用现有Outside/InsideCritical和os_atomic_cmd。 *)
Definition abs_dataqueue_deinit (sg : StableGlobalState) (q : DataqueueAbs)
    : program (VarGlobalState -> Prop) DataqueueAbs :=
  assertS (fun states => forall observed, states observed ->
    os_inv sg observed |-- “ dq_rollback_empty q observed ”) ;;
  os_atomic_cmd (dq_deinit_locked q).

(** 正常路径在一段临界区内完成发布；失败路径加上DeInit的另一段IRQ保护。
    不把两次保护之间的环境变化压缩为单个原子操作。返回对象ghost值
    同时连接C返回码、字段和数组ownership，避免成功/失败结果失联。 *)
Definition abs_init_dataqueue (sg : StableGlobalState) (p : addr) (n : Z)
    : program (VarGlobalState -> Prop) DataqueueAbs :=
  q <- os_atomic_cmd (dq_init_locked sg p n) ;;
  if Z.eqb (dq_init_code q) 0 then ret q else abs_dataqueue_deinit sg q.

(** 初始化成功所创建的两个对象仍以创建时地址和ID关联，等待链为空，
    blank计数为uint16(n-1)，data计数为0；不复制其内存所有权。 *)
Definition dq_created_refs (q : DataqueueAbs) (st : VarGlobalState) : Prop :=
  (exists sem, In sem st.(os_semaphores) /\
    sem.(semaphore_id) = q.(dq_blank) /\ sem.(semaphore_addr) = q.(dq_blank_object) /\
    sem.(semaphore_value) = (q.(dq_max_len)-1) mod 65536 /\
    sem.(semaphore_pending_addrs) = nil) /\
  (exists sem, In sem st.(os_semaphores) /\
    sem.(semaphore_id) = q.(dq_data) /\ sem.(semaphore_addr) = q.(dq_data_object) /\
    sem.(semaphore_value) = 0 /\ sem.(semaphore_pending_addrs) = nil).

(** 原始20字节清零转为字段的设计义务。padding由QCP结构体资源机制保留，
    此陈述不提供证明事实，正式实现需结合前端布局检查与字节拆分完成。 *)
Definition dq_zero_fields_obligation : Prop :=
  dataqueue_layout_obligation -> forall p,
    p <> 0 -> addr_aligned p 4 ->
    CharArray.full p 20 (repeat_Z 0 20) |--
    store_dataqueue_fields p (dq_initialized 0 0 0 0 0 0).

(** 连续未知元素与malloc所得整段字节相互转换；该命题不是已证引理。 *)
Definition dq_buffer_bytes_obligation : Prop :=
  forall b n, 0 <= n ->
    CharArray.undef_full b (n*8) --||--
    store_array store_dataqueue_elem b n (repeat None (Z.to_nat n)).

(** DeInit也允许已经写入的元素：丢弃字段已知值后必须恢复整个原数组
    字节ownership再free。显式布局前提包含DataElemType两个字段，任意slots
    都适用；不是只为初始化None列表准备的特例，也不是已证明的引理。 *)
Definition dq_buffer_forget_obligation : Prop :=
  dataqueue_layout_obligation -> forall q slots,
    dataqueue_buffer q slots |--
    (if Z.eq_dec q.(dq_base) 0 then emp
     else CharArray.undef_full q.(dq_base) (q.(dq_max_len)*8)).

(** 发布必须在真实Lock借出的完整os_inv中集成；此设计义务把私有对象
    资源交入新OS总状态，不能用另建包装或仅import替代。 *)
Definition dq_publish_os_obligation : Prop :=
  forall sg st p q,
    st.(os_dataqueues) p = None ->
    dataqueue_object_valid (dq_initial_entry q) ->
    os_inv sg st ** dataqueue_storage p q (dataqueue_init_slots q) |--
    os_inv sg (replace_dataqueues
      (dataqueue_replace p (Some (dq_initial_entry q)) st.(os_dataqueues)) st).

(** 原始对象与已发布对象不能重叠；用于证明在初始化入口的private
    ownership下，同一地址不可能已经归共享map持有。 *)
Definition dq_private_not_published_obligation : Prop :=
  forall sg st p, os_inv sg st ** DataqueueRaw p |--
    “ st.(os_dataqueues) p = None ”.

Check abs_init_dataqueue.
Check abs_dataqueue_deinit.
Check dataqueue_storage.
Check dq_semaphore_create_effect.
Check dq_semaphore_delete_effect.
