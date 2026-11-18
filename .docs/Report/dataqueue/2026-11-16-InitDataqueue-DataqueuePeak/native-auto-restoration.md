# Init / DeInit 原生auto/manual分工恢复

按用户明确要求移除本地新增的auto转manual适配，并修正已完成的两个函数证明。没有修改C、predicate、规格或TrustBase；没有减少目标集合。Peak及Semaphore IC闭包不属于本次修正，尚待后续验证；Pop/Push由另一窗口负责。

## 已完成结果

| 函数 | 原生auto条目 | manual顶层目标 | workflow / final-check | 证据 |
| --- | --- | --- | --- | --- |
| InitDataqueue | 51 | 12 | done / passed | [controller](../../../../reports/InitDataqueue-20261118165045/controller_state.json) |
| DeInitDataqueue | 35 | 10 | done / passed | [controller](../../../../reports/DeInitDataqueue-20261118171259/controller_state.json) |

Init manual另有6个split；DeInit另有12个split，其中2个属于未选用路线而保持生成Abort，所有选用的manual顶层路线及必要split均完成Qed。两函数goal和goal_check与修正前完成版本逐字一致，auto/manual声明不交且并集保持。auto与各自final-check独立重放的原生生成结果逐字一致。

## 修正内容和结论边界

删除QCP本地symexec_tooling.py中未提交增补的_route_unproved_auto_obligations、调用点及对应回执字段。保留工程目录/ILP32/预处理等无关适配，没有重置整个QCP工作树。函数证明由新controller run重新生成原始auto/manual，manual通过逐条statement相等检查后复用旧Qed证明，再经组接纳、parent、final-apply和final-check完成；未手工编写或修改generated auto/goal/check。

原生auto分别包含51/35个生成器Admitted条目，按用户确认的QCP自动求解器边界保留。它们是工具自动结果，不宣称拥有对应Rocq闭合证明项，也不冒称人工证明。manual的12/10个顶层目标具有实际Qed证明。原先把原生auto中Admitted一律认作失败并搬到manual是不必要的本地扩展，已撤除。此处明确区分恢复工具约定与所有目标均有Rocq证明项的旧加强结果。

旧完成run InitDataqueue-20261117224043与DeInitDataqueue-20261118121138及其完整proof候选保留，包含曾额外完成的auto对应证明，不因此次恢复而丢弃历史证据。当前结论仍相对于原callee contracts和既定模型/IRQ/ABI边界成立；不以两个函数完成推出整个调用闭包完成。

## 检查与增量

两函数新workflow均done且final-check passed；当前manual无Admitted，声明/目标匹配；原生auto由独立重放逐字核对。根构建恢复正式.vo供编辑器使用。此次没有新增lib或手写证明，只调整已有证明归属；manual行差异包含被移回原生auto的声明及旧额外证明，不能解读为删去验证义务。相对于修改前实际工作树快照：

| 文件 | 新增行 | 删除行 | 净增 |
| --- | --- | --- | --- |
| `VC/dataqueue/InitDataqueue_proof_manual.v` | 0 | 277 | -277 |
| `VC/dataqueue/DeInitDataqueue_proof_manual.v` | 0 | 218 | -218 |

本次检查仅使用本地controller/Rocq编译；先前向Rocq MCP传项目源码被自动审批拒绝后，没有重试或绕过。
