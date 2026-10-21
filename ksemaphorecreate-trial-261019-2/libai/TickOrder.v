Require Import Coq.ZArith.ZArith.
Local Open Scope Z_scope.

(** 本轮权威 delay.c:74 用 delay->ticks < dnode->ticks 插入排序。
    tick_not_after 采用普通非降序，与该比较一致；范围由 UInt store 保证。
    delay.c:134 的模2^32差值超时比较是另一操作，不是插入比较。
    此定义不声称跨回绕时刻的时间序，也不证明 delay 算法正确。 *)
Definition tick_not_after (earlier later : Z) : Prop := earlier <= later.
