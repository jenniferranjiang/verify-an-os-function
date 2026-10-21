> 当前范围更新：CriticalAreaLock/UnLock 已改为 trusted spec，当前七个实现目标及自检结果见 [spec 设计](spec-design.md#trusted-临界区接口调整)。下文为旧 revision 的历史记录。

> 2026-10-21 更新：用户已要求移除中断状态建模。以下为修改前 r1 的历史记录，其中审阅通过和检查结论不适用于当前版本。当前修改及检查见 [DCHG-20261021-01](design-changes/2026-10-21-1-remove-irq-state.md)。

# KSemaphoreCreate 新实验设计完成

本实验创建于 2026-10-19，跨日持续完成于 2026-10-20，目录保持 `ksemaphorecreate-trial-261019-3`。依据当前权威源码和指定 stm32f103-nano 配置重新分析；历史 trial 仅查看顶层目录名称计算序号，未读取或复用内容。

两份正式 revision 均由未参与 predicate/spec 编写的独立 reviewer 审阅通过：

| 产物 | 固定 revision | 结论与清单 |
|---|---|---|
| Predicate | `predicate-r1-8a944cddeb13` | [review-passed](predicate-review.md)，[SHA256 清单](../../checks/predicate-r1-manifest.json) |
| 完整调用闭包 spec | `spec-r1-7f4d155c90f7` | [review-passed](spec-review.md)，[SHA256 清单](../../checks/spec-r1-manifest.json) |

正式代码在 trial 的 `shared_candidates/`、`lib/KSemaphoreCreate.v` 和 `annotated_C/src/`。设计说明分别为 [predicate-design.md](predicate-design.md) 和 [spec-design.md](spec-design.md)，源码依据见 [source-analysis.md](source-analysis.md)。

9 个非 trusted 函数均有唯一同名 canonical 文件、完整真实函数体及契约：KSemaphoreCreate、_SemaphoreCreate、CriticalAreaLock、CriticalAreaUnLock、IdInsertObj、AllocId、InsertObj、InitDoubleLinkList、DoubleLinkListInsertNodeAfter。19 条直接调用边均有 caller-local contract。仅批准的 x_malloc、x_free、memset、DisableLocalInterrupt、EnableLocalInterrupt、KPrintf 被作为 trusted，全部契约纳入独立审阅。

入口表达协议临界区外且不持有其保护资源，允许真实 PRIMASK 为 0 或 1。锁内辅助调用采用各自实际状态。设计覆盖分配失败、ID 耗尽时完整清零私有对象释放、成功发布，以及共享资源归还和真实中断状态恢复。

设计检查全部通过：

- 28 个 predicate 及必要依赖 `.v` 实际编译通过；[编译记录](../../checks/predicate-compile.log)。
- Spec 声明的 41 个 formal 接口实际 Rocq 类型检查通过；[类型检查](../../checks/spec-vocabulary.log)。
- 9 个切片 C 语法及告警检查通过；[记录](../../checks/spec-c-syntax.log)。
- 权威 header 和切片 header 的 ILP32 布局静态断言通过；Semaphore 为 32 字节。[原布局检查](../../checks/abi-check.log)、[切片布局检查](../../checks/slice-abi-check.log)。环境没有 ARM 交叉编译器，采用 GCC `-m32` 与指定 Cortex-M3 自然布局人工核对，未声称执行 ARM 编译。
- 完整函数体与当前源码归一结果、所有 caller 契约副本、完整可达闭包、源码和配置指纹均通过检查；[结构审计](../../checks/design-audit.json)、[源码指纹](../../checks/source-manifest.json)。未运行 QCP parser。
- [Load path 审计](../../checks/load-path-audit.json) 排除全部历史 trial 及根目录递归映射。未新增公理、Parameter 或占位证明。

共享库候选均保留在本 trial，根共享 `lib/` 未修改：新增 `SemaphoreState.v`、`SemaphoreInv.v`；扩展 `CrtosGlobState.v` 的 semaphore/PRIMASK 状态、`CrtosRules.v` 的统一协议及 LittleEndian 实例、`CrtosInv.v` 的 semaphore 资源与等待任务覆盖。另有 17 个既有依赖文件仅调整 namespace 以保持统一 Assertion carrier。函数程序位于 `lib/KSemaphoreCreate.v`。差异见 [候选差异记录](../../checks/shared-candidate-diff.json)。既有共享基础假设仍作为导入依赖，没有被声称为本次新证明；`SemaphoreLayout` 等后续空间推导义务亦未作为公理使用。

本次已到达用户指定停止位置。未启动 verification-orchestrator、symbolic、VC 或 C 实现证明；设计审阅通过不表示 KSemaphoreCreate 已验证。等待用户决定后续。
