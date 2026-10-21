Require Import Coq.ZArith.ZArith.
From SimpleC.SL Require Import SeparationLogic.
Local Open Scope Z_scope.
Example pointer_width : Snaive_C_Rules.ptr_size_Z = 4. Proof. reflexivity. Qed.
Example endian : Snaive_C_Rules.merge_short 1 0 1. Proof. reflexivity. Qed.
