Require Import Coq.ZArith.ZArith.
Local Open Scope Z_scope.
(** 当前100Hz源码在乘法前转uint64；uint32输入的乘积不溢出，余数5至9才加1。
    与VRTOS旧32位回绕契约不同，本轮新写CalculateTickFromTimeMs规格。 *)
Definition tick_from_time_ms (ms : Z) : Z :=
 let ticks := (ms * 100) / 1000 in
 if Z.eq_dec ticks 0 then 1
 else let rem := (ms * 100) mod 1000 in
 if andb (Z.leb 5 rem) (Z.leb rem 9) then ticks + 1 else ticks.
