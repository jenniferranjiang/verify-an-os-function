Require Import Coq.ZArith.ZArith.
From AUXLib Require Import ListLib.
Search (Z.testbit _ 0).
Search (Z.land _ 1).
Search (Z.land _ (Z.ones _)).
Search (Z.testbit 1 _).
Search (0 <= Z.shiftr _ _).
Search (Z.shiftr _ _ <= _).
Search (Z.shiftr _ 1).
Search (Z.shiftr _ _ = _ / _).
Search Z.shiftr.
Search (0 <= _ / _).
Check Z.div_pos.
Check Z.div_le_upper_bound.
Check Z.div_str_pos.
Check Forall_Znth.
Check Zlength_replace_Znth.
Check Znth_replace_Znth.
