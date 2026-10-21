Require Import Coq.ZArith.ZArith.
Local Open Scope Z_scope.
(** delay.c 到期测试的无符号32位半圈关系；本次不使用延时排序推论。 *)
Definition tick_not_after (a b : Z) : Prop := (b - a) mod 4294967296 < 2147483647.
