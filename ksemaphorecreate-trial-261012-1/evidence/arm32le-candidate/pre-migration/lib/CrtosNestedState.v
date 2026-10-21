Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Import SL.CriticalSTS.

(** QCP框架版本兼容adapter：本record逐字复用官方
    Rocq/SeparationLogic/NestedCriticalSTS.v的nested_critical_state。
    当前已安装NestedCriticalSTS.vo依赖的ArrayLib摘要不兼容；官方新源码
    的架构functor参数又不同于已安装接口。这里仅取用所需状态类型，
    不复制无关ModuleType，也不采用允许空环境token嵌套进入的旧transition。
    来源hash和原文对应由evidence/nested-state-adapter.json记录。
    nat是框架原有token类型；没有新建token Record或任何逻辑假设。 *)
Record nested_critical_state {C: critical_STS}: Type :=
  {
    handlers_of_NCS: list Z;
    state_of_NCS: critical_STS_state
  }.
