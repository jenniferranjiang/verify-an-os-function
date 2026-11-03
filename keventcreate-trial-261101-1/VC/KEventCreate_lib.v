From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

(** 外层包装只转发已审阅的事件创建操作和共享临界区协议；不重复定义规格。 *)
Require Import CRTOS_Verify.lib.KEventCreate.
