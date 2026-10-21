Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import SL.ConAssertion.
Require Export CRTOS_Verify.lib.CrtosRules.
Require Import CRTOS_Verify.lib.dll CRTOS_Verify.lib.idnode.

Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.

(**
  当前 32 位验证 ABI 的字段偏移与大小公理集中在 StructFieldOffsetAxiom；
  字段 points-to 使用真实符号地址，不在空间谓词中重复携带布局条件。
  IrqDesc 与 IsrDone 均只有指针槽，无额外 padding；manager 的第 3 字节
  是唯一 padding，IRQ 表占 528 字节，done 在偏移 532，总大小 536。
*)

(**
  单个 IrqDesc 条目：恰好拥有 handler 与 param 两个指针槽。
  空 handler 不强制 param 为零，RegisterHwIrq 本身允许写入任意这两个值。
  IsrCommon 解引用函数指针需要额外证明 irq_num 合法、handler 非空及回调契约。
*)
Definition store_irq_entry (p : addr) (entry : IrqDescAbs) : Assertion :=
  &(p # "IrqDesc" ->ₛ "handler") # Ptr |-> entry.(irqHandler) **
  &(p # "IrqDesc" ->ₛ "param") # Ptr |-> entry.(irqParam).

(** 泛型 QCP store_array 的元素解释；与现有 ready-vector 的结构数组寻址一致。 *)
Definition store_irq_entry_at
    (base : addr) (index : Z) (entry : IrqDescAbs) : Assertion :=
  store_irq_entry (base + index * sizeof("IrqDesc")) entry.

(**
  完整 IRQ 表。复用 QCP ArrayLibCore 的 store_array，包含恰好 IRQ_COUNT
  个条目的长度要求；不像普通 list fold，它不会将短表当作完整数组。
*)
Definition store_irq_table (base : addr) (entries : list IrqDescAbs) : Assertion :=
  store_array store_irq_entry_at base IRQ_COUNT entries.

(** 目标槽以外的数组 frame，用 QCP missing_i 保留全部其他条目和长度约束。 *)
Definition store_irq_table_except
    (base : addr) (index : Z) (entries : list IrqDescAbs) : Assertion :=
  store_array_missing_i_rec store_irq_entry_at base index 0 IRQ_COUNT entries.

(** isrDone 表的十二个槽只由本谓词持有一份；不与 manager.done 指针槽混同。 *)
Definition store_isr_done (p : addr) (done : IsrDoneAbs) : Assertion :=
  &(p # "IsrDone" ->ₛ "isInIsr") # Ptr |-> done.(isrDoneIsInIsr) **
  &(p # "IsrDone" ->ₛ "registerIrq") # Ptr |-> done.(isrDoneRegisterIrq) **
  &(p # "IsrDone" ->ₛ "freeIrq") # Ptr |-> done.(isrDoneFreeIrq) **
  &(p # "IsrDone" ->ₛ "enableIrq") # Ptr |-> done.(isrDoneEnableIrq) **
  &(p # "IsrDone" ->ₛ "disableIrq") # Ptr |-> done.(isrDoneDisableIrq) **
  &(p # "IsrDone" ->ₛ "handleIrq") # Ptr |-> done.(isrDoneHandleIrq) **
  &(p # "IsrDone" ->ₛ "getCounter") # Ptr |-> done.(isrDoneGetCounter) **
  &(p # "IsrDone" ->ₛ "incCounter") # Ptr |-> done.(isrDoneIncCounter) **
  &(p # "IsrDone" ->ₛ "decCounter") # Ptr |-> done.(isrDoneDecCounter) **
  &(p # "IsrDone" ->ₛ "getSwitchTrigerFlag") # Ptr |-> done.(isrDoneGetSwitchFlag) **
  &(p # "IsrDone" ->ₛ "setSwitchTrigerFlag") # Ptr |-> done.(isrDoneSetSwitchFlag) **
  &(p # "IsrDone" ->ₛ "clearSwitchTrigerFlag") # Ptr |-> done.(isrDoneClearSwitchFlag).

(**
  IRQ 表之外的 manager 字段及唯一 padding 字节。UShort/UChar 给出数值范围；
  padding 用未指定值的字节权限，不无依据假定静态或运行时填充总保持为 0。
  volatile 只影响 C 访问语义，不产生新的权限，锁外可写借用协议需另行审阅。
*)
Definition store_isr_manager_header (p : addr) (st : IsrAbs) : Assertion :=
  &(p # "InterruptServiceRoutines" ->ₛ "isr_count") # UShort |-> st.(isrCount) **
  &(p # "InterruptServiceRoutines" ->ₛ "isr_switch_trigger_flag")
    # UChar |-> st.(isrSwitchFlag) **
  (p + 3) # UChar |->_ **
  &(p # "InterruptServiceRoutines" ->ₛ "done") # Ptr |-> st.(isrDonePtr).

(**
  ISR 全部本体资源：manager 头部、66 个条目及独立 isrDone 表恰好各一次。
  参数 sg 给出稳定地址/函数快照，st 给出可变字段；IsrGlobalContext 由外围
  使用者提供。该资源聚合不内建 switch flag 的 0/1 可达性、done 已安装，
  或未登记槽的 param=0 等额外假设，也不拥有任何 handler/param 指向的对象。
*)
Definition isrmanager_inv (sg : IsrStable) (st : IsrAbs) : Assertion :=
  let p := sg.(isrManagerAddr) in
  store_isr_manager_header p st **
  store_irq_table
    (&(p # "InterruptServiceRoutines" ->ₛ "irq_table"))
    st.(isrTable) **
  store_isr_done sg.(isrDoneAddr) sg.(isrDoneSnapshot).

(** 可选的运行状态纯性质，须由具体初始化/调用协议证明，不由空间谓词假设。 *)
Definition isr_flag_binary (st : IsrAbs) : Prop :=
  st.(isrSwitchFlag) = 0 \/ st.(isrSwitchFlag) = 1.

Definition isr_done_installed (sg : IsrStable) (st : IsrAbs) : Prop :=
  st.(isrDonePtr) = sg.(isrDoneAddr).

(**
  局部读取/写入接口直接实例化 QCP 已有泛型数组引理，不展开 manager 或
  全局 os_inv。focus 提取一槽，replace 在写入新 handler/param 后恢复完整表。
*)
Lemma store_irq_table_length : forall base entries,
  store_irq_table base entries |-- “ Zlength entries = IRQ_COUNT ”.
Proof.
  intros base entries. unfold store_irq_table.
  apply store_array_Zlength.
Qed.

Lemma store_irq_table_focus : forall base index entries,
  0 <= index < IRQ_COUNT ->
  store_irq_table base entries |--
  store_irq_entry_at base index (Znth index entries empty_irq_desc) **
  store_irq_table_except base index entries.
Proof.
  intros base index entries Hindex.
  unfold store_irq_table, store_irq_table_except.
  apply store_array_split_to_missing_i. exact Hindex.
Qed.

Lemma store_irq_table_replace : forall base index entries entry,
  0 <= index < IRQ_COUNT ->
  store_irq_entry_at base index entry ** store_irq_table_except base index entries |--
  store_irq_table base (replace_Znth index entry entries).
Proof.
  intros base index entries entry Hindex.
  unfold store_irq_table, store_irq_table_except.
  apply store_array_missing_i_merge_to_array. exact Hindex.
Qed.
