# Semaphore IC 调用闭包与词汇接口

本记录说明 InitDataqueue 锁内创建和失败清理所需的新增 IC 设计。当前源文件及完整来源 hash、所选接口、边界分类与未来合并目标见 [spec-sources.json](../../spec-sources.json)；编译类型检查结果见 [header-type-audit.json](../../header-type-audit.json)。本记录不是 review-passed 结论，也不是 C 实现证明。

## 新增的 canonical

`annotated_C/src/` 平铺保存 KSemaphoreCreate、_SemaphoreCreate、KSemaphoreDelete、_SemaphoreDelete 四份独立 C，每份只有一个同名 active body 和新增的 dataqueue_ic spec。实际 contract 正文仅在这些 C 文件。原根 canonical 的 OC 契约和 body 保留在原文件，通过 trial C 注释的路径/hash 追溯；没有给 IC-adapted body 保留失效的 active OC spec，也没有把新增 IC 当作原 OC 等价已证。

body 取自当前权威 semaphore.c。依《源代码处理》去除 caller 已持临界区/IRQ 时的嵌套加锁解锁，去除诊断，按 static done initializer 唯一解析 wrapper dispatch，按 TrustBase 处理 CONTAINER_OF，按规定模型解析 DO_KTASK_ASSIGN。其余返回、分配、失败回滚、列表和字段操作均保留。变量 lock 因嵌套锁删除而未使用，不影响 C 结构。

创建的 malloc 失败和 ID 耗尽都返回 -5；成功 ID 允许 0。两个创建层次使用同一个 IC 效果接口和同一 os_inv 资源交接。IdInsertObj 直接采用根 id_module_spec.h 的原接口：没有借用历史 _SemaphoreCreate caller-local 额外加强的 first-free=None 结论。分配失败原态保持分支足以表达此处 -5 返回。

删除仅为 dataqueue 失败回滚的空 pending 场景设计，Require 显式引用 dq_sem_delete_empty。调用者必须从其已审阅的 checked cleanup 观察条件建立这个前提，不能仅凭句柄非负断言。非空 pending/reschedule 分支仍保留真实代码和 imported API；在该具名场景下不可达，因此并不宣称此 IC spec 覆盖一般含等待者的删除。原一般 OC 删除语义仍由源 canonical 保留。

## 完整直接调用

KSemaphoreCreate 调用本轮 _SemaphoreCreate；后者调用 x_malloc、memset、IdInsertObj、x_free、InitDoubleLinkList、DoubleLinkListInsertNodeAfter。

KSemaphoreDelete 调用本轮 _SemaphoreDelete；后者调用 IdGetObj、CONTAINER_OF_SEMAPHORE_ID、IsDoubleLinkListEmpty、LinklistResumeAll、IdRemoveObj、DoubleLinkListRmNode、x_free、KTASK_ASSIGN。所有直接 API 在 caller 定义前有完整声明/spec；复用或明确模型/API 边界不继续安排其原始内部实现闭包。

所选命名接口为 DoubleLinkListInsertNodeAfter.dispatch_case、IsDoubleLinkListEmpty.dll、IdRemoveObj.low_level_spec、DoubleLinkListRmNode.remove_member、LinklistResumeAll.semaphore_waiters、KTASK_ASSIGN.outside_critical。其余采用唯一相关默认接口。来源和信任类别逐项冻结在 spec-sources.json，不把 reused-spec 的设计输入称为本轮重新证明成功。

## Header、全局库增量接入与检查

当前按用户要求收敛为七份formal输入：现有CrtosGlobState/CrtosRules/CrtosInv的真实语义扩展副本，加四份dataqueue文件；未改的外部原库直接导入，不复制只改imports的依赖文件。trial VarGlobalState直接保留原字段并加入os_dataqueues，project_core重构原全局record供根库API使用；没有新的OsGlobalState或独立core+queues状态层。

根库唯一Assertion/STS载体直接复用。完整Lock/IRQ协议操作trial扩展状态和完整os_inv；旧core helper接口显式使用CoreVarGlobalState、core_os_inv及对应core协议别名。词汇header的最终类型和来源随design冻结，不用同名猜测连接新旧record。

KOK在根lib/task/KTaskParseInfo.v定义为0；ResumeAll caller-local返回码采用归约值0，不新增已有常量，也不为该常量引入额外栈证明辅助。QCP addr是Z别名。扩展状态的frame/lifting义务和本轮empty-pending分支不可达限制仍保留，不宣称旧证明自动覆盖新IC目标。

前一轮34文件审计已失效。当前七份formal全部重新编译后，tools/check-header-types.py对四份header的75条Extern显式类型检查全部通过；所有full/core词汇按全限定Printing Coq Name检查，另用Rocq eq_refl检查四个core别名确与根接口定义相等。结果冻结当前七份formal与四份header，检查期间输入不变。5处新canonical调用契约一致，8个复用helper及KTASK_ASSIGN模型接口在空白、已核对的core别名及KOK->0归约后与来源一致。临时审计输入/产物已清理；具体结果见header-type-audit.json，来源见spec-sources.json。

Rocq类型检查不调用QCP parser，不构成symbolic、VC或C实现证明。

## 保留边界

当前只保留 trial 设计。即使 review-passed 也不合并到全局。只有后续明确批准的完整流程 implement done（含 final-check）之后才增量合并，并保留全局原 OC 变体；不能用此 IC-adapted body 整体覆盖原 OC canonical。头文件未来目标同样列在 spec-sources.json。
