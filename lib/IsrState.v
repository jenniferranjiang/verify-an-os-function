Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.CrtosConfig.
Require Export CRTOS_Verify.lib.dll_abs CRTOS_Verify.lib.idnode_abs.
Require Export CRTOS_Verify.lib.StructFieldOffsetAxiom.
Import KTaskCNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.

(** IrqDesc 的两个纯指针值；param 指向的对象和 handler 的可调用权限不在内。 *)
Record IrqDescAbs := mkIrqDescAbs {
  irqHandler : addr;
  irqParam : addr
}.

(** 按 xs_isr.h 声明次序保存 isrDone 的十二个纯函数地址。 *)
Record IsrDoneAbs := mkIsrDoneAbs {
  isrDoneIsInIsr : addr;
  isrDoneRegisterIrq : addr;
  isrDoneFreeIrq : addr;
  isrDoneEnableIrq : addr;
  isrDoneDisableIrq : addr;
  isrDoneHandleIrq : addr;
  isrDoneGetCounter : addr;
  isrDoneIncCounter : addr;
  isrDoneDecCounter : addr;
  isrDoneGetSwitchFlag : addr;
  isrDoneSetSwitchFlag : addr;
  isrDoneClearSwitchFlag : addr
}.

(** 稳定地址与函数表纯快照，不含任何独立可复制的内存权限。 *)
Record IsrStable := mkIsrStable {
  isrManagerAddr : addr;
  isrDoneAddr : addr;
  isrDoneSnapshot : IsrDoneAbs
}.

(**
  InterruptServiceRoutines 的可变纯状态。table 按 IRQ 编号顺序保存条目，
  完整长度由 store_irq_table 的 QCP 数组谓词保证。done 仍为真实字段值：
  静态初始化时为 0，SysInitIsrManager 后才指向 isrDone。
*)
Record IsrAbs := mkIsrAbs {
  isrCount : Z;
  isrSwitchFlag : Z;
  isrTable : list IrqDescAbs;
  isrDonePtr : addr
}.

(** 全局符号及 C 静态初始化器的纯对应；此关系本身不拥有函数表内存。 *)
Definition IsrGlobalContext (sg : IsrStable) : Prop :=
  sg.(isrManagerAddr) = &("isrManager") /\
  sg.(isrDoneAddr) = &("isrDone") /\
  sg.(isrDoneSnapshot).(isrDoneIsInIsr) = &("IsInIsr") /\
  sg.(isrDoneSnapshot).(isrDoneRegisterIrq) = &("RegisterHwIrq") /\
  sg.(isrDoneSnapshot).(isrDoneFreeIrq) = &("FreeHwIrq") /\
  sg.(isrDoneSnapshot).(isrDoneEnableIrq) = &("EnableHwIrq") /\
  sg.(isrDoneSnapshot).(isrDoneDisableIrq) = &("DisableHwIrq") /\
  sg.(isrDoneSnapshot).(isrDoneHandleIrq) = &("IsrCommon") /\
  sg.(isrDoneSnapshot).(isrDoneGetCounter) = &("GetIsrCounter") /\
  sg.(isrDoneSnapshot).(isrDoneIncCounter) = &("IncIsrCounter") /\
  sg.(isrDoneSnapshot).(isrDoneDecCounter) = &("DecIsrCounter") /\
  sg.(isrDoneSnapshot).(isrDoneGetSwitchFlag) = &("GetIsrSwitchTrigerFlag") /\
  sg.(isrDoneSnapshot).(isrDoneSetSwitchFlag) = &("SetIsrSwitchTrigerFlag") /\
  sg.(isrDoneSnapshot).(isrDoneClearSwitchFlag) = &("ClearIsrSwitchTrigerFlag").

Definition empty_irq_desc : IrqDescAbs := mkIrqDescAbs 0 0.

(** 静态 isrManager = {0} 的字段值候选，不描述独立 isrDone 的非零初始化器。 *)
Definition isr_static_zero_state : IsrAbs :=
  mkIsrAbs 0 0 (repeat empty_irq_desc (Z.to_nat IRQ_COUNT)) 0.

(**
  SysInitIsrManager 从链接器表按次序复制。重复 IRQ 编号保留最后一次写入，
  不额外要求编号唯一；索引合法性是该 C 循环的独立内存安全义务。
  registrations 的每对值对应 *__isrtbl_idx 与 *__isrtbl 中一个元素。
*)
Definition isr_linker_indices_ok (registrations : list (Z * IrqDescAbs)) : Prop :=
  Forall (fun registration => 0 <= fst registration < IRQ_COUNT) registrations.

Definition isr_linker_table (registrations : list (Z * IrqDescAbs))
    : list IrqDescAbs :=
  fold_left
    (fun table registration => replace_Znth (fst registration) (snd registration) table)
    registrations isr_static_zero_state.(isrTable).

(**
  初始化后的纯候选值：count/flag 清零、done 安装、IRQ 表由链接器输入覆盖。
  这不是 SysInitIsrManager 的已证明后置条件；链接器源表内存、索引范围和
  循环边界仍须在后续 Spec/验证阶段证明，绝不宣称最终 IRQ 表一律全零。
*)
Definition isr_initialized_state
    (sg : IsrStable) (registrations : list (Z * IrqDescAbs)) : IsrAbs :=
  mkIsrAbs 0 0 (isr_linker_table registrations) sg.(isrDoneAddr).

Definition isr_initialized_from
    (sg : IsrStable) (registrations : list (Z * IrqDescAbs)) (st : IsrAbs) : Prop :=
  isr_linker_indices_ok registrations /\ st = isr_initialized_state sg registrations.
