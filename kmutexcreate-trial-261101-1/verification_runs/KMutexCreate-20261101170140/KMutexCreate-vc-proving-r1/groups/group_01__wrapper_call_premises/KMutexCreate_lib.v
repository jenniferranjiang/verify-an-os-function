From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

(** 包装函数直接复用已审阅的创建操作和共享协议；不另定义同义规格。 *)
Require Import CRTOS_Verify.lib.KMutexCreate.
