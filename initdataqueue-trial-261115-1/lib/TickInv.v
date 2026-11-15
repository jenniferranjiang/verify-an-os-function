(** Trial adaptation of lib/tick/TickInv.v; baseline SHA256 f0f86e05ad3d274e286c09aa5dfbd9fcc39b2f948aa955649797b3ca0efc952e.
    必要修改：将依赖改为扩展后同一 OS state / STS 实例，原全局文件保持只读。 *)
Require Import Coq.ZArith.ZArith Coq.micromega.Lia.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Export CRTOS_InitDataqueue.CrtosRules.
Local Open Scope Z_scope.
Local Open Scope sac.

(**
  [tick_inv sg st] 拥有 [heartbeat_ticks] 的 UInt 单元，并封装当前全局
  tick 的范围。它不约束函数的相对延时参数；[x_ticks_t] 参数的范围由
  相应 C 形参的 UInt 存储保证。只读 tick 的函数在前后归还同一个值。
*)
Definition tick_inv (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ 0 <= st.(os_tick) <= UINT_MAX ” &&
  sg.(os_tick_ptr) # UInt |-> st.(os_tick).

