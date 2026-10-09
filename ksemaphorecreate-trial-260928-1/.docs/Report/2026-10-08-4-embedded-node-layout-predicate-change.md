---
file_or_slice: "lib/SemaphoreRep.v — semaphore_layout_32_ok"
approved_version: "predicate-r22-5b808e69a733"
status: review-passed
change_kind: breaking
approved_by: "user standing approval for proof-discovered design corrections"
approved_at: "2026-10-08"
---

# 设计变更：嵌入节点的 call-facing 地址等式

- Change kind：`breaking`。r21 的 layout pure predicate不足以连接QCP真实C表达式，必须形成新predicate revision；所有空间footprint、record/command/protocol类型和public接口保持不变。
- 原批准设计：r21只记录 `Semaphore` nested dot-path的id/id-link/value/pend/link基址，没有记录从真实`IdNode*`或`SysDoubleLinklistNode*`再次取字段的地址。
- 新源码/proof证据：`InsertObj` 使用`idnode->id`与`&idnode->link`并把后者交给DLL helper；`_SemaphoreCreate`把`&sem->pend_list`、`&sem->link`交给相同helper。MCP显示`eval_addr_expr`保持抽象，不能从ABI口头说明自行证明这些call-facing地址等于nested owner地址。r16 review-only lemma只检查nested node地址，未覆盖真实generated expressions。
- 拟议修改：在`semaphore_layout_32_ok`加入IdNode id/link、id-link next/prev、pend next/prev与registry next/prev的call-facing及nested等式，分别固定为offset 0、4/8、16/20、24/28。
- 对 abstract state/command 的影响：无。
- 对 ownership/predicate/spec 的影响：无byte ownership变化；只是使同一owned cell的两种C访问路径可正式重写。canonical Require/Ensure已携带layout且无需变化；局部`which implies`必须显式保留ambient layout等纯事实。
- 对 trust/scope 和已完成工作的影响：trusted symbol集合及source17不变；已有leaf/AllocId证明不依赖被删除事实。受影响caller须重新symbolic/VC/proof。
- 保持不变的 formal types/statements/interfaces：所有抽象类型、command/STS、lifecycle predicate与function canonical contract签名。
- 受影响文件和已批准内容：正式delta仅`SemaphoreRep.v:semaphore_layout_32_ok`；其余六formal与r21逐字相同。helper仅增加可证明的bucket更新/回封lemma。
- 已考虑但拒绝的方案：把call-facing地址当作definitional equality或在manual proof假设相等；二者都不被QCP模型支持并会扩大trust。也拒绝把这些事实逐个塞进public function contract，因为它们本就是统一layout predicate的职责。
- 可独立继续的工作：修正局部focus后重新跑full closure、生成受影响VC并自底向上证明。
- 审阅决定和新版本：独立reviewer以C99/18项ABI断言、真实generated VC、Coq 8.20.1 `coqchk`和trust scan确认全部地址事实，结论`review-passed`。新revision `predicate-r22-5b808e69a733`，完整manifest `5b808e69a7331b3ba4c34100eddaa17e8b6cea4de310b42a406b9e6b55720780`。

用户standing approval覆盖本次proof-discovered回退修复；review-passed后可恢复implement。
