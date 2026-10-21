Require Import Coq.ZArith.ZArith.

(** 当前 xs_ktask.h 中 KTASK_INIT/READY/SUSPEND/RUNNING/CLOSE 分别为0..4。
    这里只补根 KTaskPure 实际引用的纯状态类型，不拥有 stat 字节。
    ktask_stat.c 读取低三位、更新时保留高五位；这不是完整字节的枚举。 *)
Inductive TaskStatus : Type :=
| TSK_INIT
| TSK_READY
| TSK_SUSPEND
| TSK_RUNNING
| TSK_CLOSE.
