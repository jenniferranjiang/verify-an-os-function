From Coq Require Import ZArith.
Local Open Scope Z_scope.

(** 对应 xs_base.h 的 EOK、ERROR、ETIMEOUT、EFULL、ENOMEMORY、EINVALED。
    错误码保持正值，由接口按源码约定返回其负值；名称避开 C 宏。 *)
Definition KOK : Z := 0.
Definition KERROR : Z := 1.
Definition KTIMEOUT : Z := 2.
Definition KFULL : Z := 3.
Definition NOMEMORY : Z := 5.
Definition INVALID : Z := 10.

(** 对应 WAITING_FOREVER；与数值相同的负错误码区分。 *)
Definition KWAIT_FOREVER : Z := -1.
