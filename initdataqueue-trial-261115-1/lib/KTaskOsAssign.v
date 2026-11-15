(** Trial adaptation of lib/assign/KTaskOsAssign.v; baseline SHA256 5d816694be96c8bd3d7c875e1e7c1317a763acba6e9619e685cda527c5b2dd06.
    必要修改：将依赖改为扩展后同一 OS state / STS 实例，原全局文件保持只读。 *)
Require Export CRTOS_InitDataqueue.CrtosRules.
From MonadLib.MonadErr Require Import MonadErrBasic.

(**
  用户指定的空临界区调度模型：观察允许的 rely 前态，原样归还共享状态，
  返回 tt，并留下新的 rely 闭包。它不读取或修改共享字段，也不需要额外
  调用者内存；锁协议资源仍由 OutsideCritical/InsideCritical 维护。
  此处不区分主动让出与普通抢占，不承诺调度公平性、下一任务或终止。
*)
Definition abs_ktask_assign : program (VarGlobalState -> Prop) unit :=
  task_atomic_cmd (MonadErr.ret tt).
