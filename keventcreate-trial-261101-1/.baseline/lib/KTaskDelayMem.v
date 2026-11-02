Require Import Coq.ZArith.ZArith.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.

Require Import CRTOS_Verify.lib.CrtosRules.
Require Export CRTOS_Verify.lib.KTaskDelay.
Require Export CRTOS_Verify.lib.StructFieldOffsetAxiom.

Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(**
  [store_delay_info link info] 拥有一个 [Delay] 对象中除链表指针以外的
  payload 字段和 32 位布局 padding。

  参数 [link] 是外围对象的 [Delay.link] 地址。谓词通过存在量恢复动态
  分配的 [delay] 基址，并保存 allocator 提供的四字节对齐条件。它拥有
  [task]、[ticks]、[status] 与 padding，但不拥有
  [link.node_prev/node_next]，因而可以直接作为 [store_dll] 的 payload。
  TaskDescriptor 中的 delay 指针槽也不属于本谓词。

  本空间模块单向依赖 [CrtosRules]；低层纯类型仍在 [KTaskDelay.v]，所以
  [CrtosGlobState] 不会经空间断言形成循环导入。
*)
Definition store_delay_info
    (link : addr)
    (info : TaskDelayAbs) : Assertion :=
  EX delay : addr,
    “ delay <> 0 /\
      link = &(delay # "Delay" ->ₛ "link") /\
      addr_aligned delay ALIGN_SIZE ” &&
    &(delay # "Delay" ->ₛ "task") # Ptr |-> info.(tdTaskPtr) **
    &(delay # "Delay" ->ₛ "ticks") # UInt |-> info.(tdTicks) **
    &(delay # "Delay" ->ₛ "status") # UChar |-> info.(tdStatus) **
    CharArray.full (delay + 9) 3 (repeat_Z 0 3).
