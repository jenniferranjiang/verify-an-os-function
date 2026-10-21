Require Import Coq.ZArith.ZArith Coq.Lists.List.
Require Import SL.CriticalSTS.

(** QCP框架状态adapter：本record逐字复用官方
    Rocq/SeparationLogic/NestedCriticalSTS.v的nested_critical_state。
    初版因当时选用旧框架的二进制接口不兼容而引入此最小状态类型；
    现已将两个heap载体重编为官方Arch32 LittleEndian，仍保留同一record，
    使已审阅owner-sensitive协议定义不变。这里不复制无关ModuleType，
    也不采用允许空环境token嵌套进入的旧transition。
    来源hash和原文对应由evidence/nested-state-adapter.json记录。
    nat是框架原有token类型；没有新建token Record或任何逻辑假设。 *)
Record nested_critical_state {C: critical_STS}: Type :=
  {
    handlers_of_NCS: list Z;
    state_of_NCS: critical_STS_state
  }.
