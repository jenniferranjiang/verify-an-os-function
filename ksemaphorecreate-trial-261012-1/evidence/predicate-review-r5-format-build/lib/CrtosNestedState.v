Require Import SL.CriticalSTS.
Require Export CRTOS_Verify.framework.NestedCriticalSTS.

(** 直接复用逐字保存的官方nested_critical_state；来源hash与未改正文证据在
    evidence/arm32le-candidate/framework-source.json。该文件以独立framework
    namespace编译，不遮盖SimpleC.SL或混装旧vo。实际OS协议仍是本trial审阅的
    owner-aware CrtosIRQStep，不采用此官方文件中的宽松nested transition。

    以下透明别名只保留CrtosOSProtocolProof已有的qualified projection接口；
    没有再定义状态record、constructor或token类型。 *)
Definition handlers_of_NCS {C : critical_STS}
    (state : @nested_critical_state C) := NestedCriticalSTS.handlers_of_NCS state.
