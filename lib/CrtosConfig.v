Require Import Coq.ZArith.ZArith.
Local Open Scope Z_scope.

(** 各模块共用的既有验证配置常量；不依赖 OS 总状态或临界区协议。 *)
Definition ID_MAX_NUM : Z := 128.
Definition BUCKET_NUM : Z := 16.
Definition PRIORITY_MAX : Z := 32.
Definition CORE_COUNT : Z := 1.
Definition IRQ_COUNT : Z := 66.

