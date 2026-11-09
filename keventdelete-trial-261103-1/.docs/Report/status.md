# KEventDelete 验证状态

2026-11-03，新实验 `keventdelete-trial-261103-1`。原误建的Create实验已按用户要求删除；权威C源码保持不变，未应用修复候选。

| 产物 | 固定版本 | 独立审阅结论 |
|---|---|---|
| Predicate | `keventdelete-predicate-r1` | **review-passed**，见 [predicate-review.md](predicate-review.md) |
| 完整15-symbol调用闭包spec | `keventdelete-spec-r1` | **review-passed**，引用同一predicate版本，见 [spec-review.md](spec-review.md) |

验证前提为用户批准的 `0 <= id < 65536`，以及D1/D2环境条件：命中的同一分配对象从查询到本次注销不被其他操作删除、回收或复用；观察/清空后的空pending到注销前保持为空。128..65535仍覆盖查询未命中返回，不要求ID已登记。源码竞争缺陷仍存在，本轮只在这些条件下验证，不宣称任意Event并发环境安全。批准内容、影响及源码位置见 [source-errors.md](source-errors.md)。

正式predicate的精确审阅版保留在trial `lib/`，已停止作为本trial构建输入；已合并的活动版本为根 `lib/EventInv.v`、`EventOps.v`、`KEventDelete.v`。精确spec审阅版保存在 `checks/reviewed-spec/r1/annotated_C/`，活动trial输入在 `annotated_C/`，共享场景在根 `annotated_C/scenarios/event-delete/`。活动输入只引用全局 `CRTOS_Verify.lib`；版本hash及纯逻辑路径迁移对应见 `checks/predicate-revision.json`、`checks/spec-revision.json`、`checks/migration.json`。原Semaphore和Mutex场景未覆盖，用户已有CrtosInv/KEventCreate修改未改动。

设计阶段三份predicate编译、注解语义接口类型检查、15个C文件的GCC ILP32语法检查、实际Event及切片Task布局检查均通过。18条已知caller/callee边的合同文本逐一一致。共享合并后根项目重新编译11个新增或受影响的库文件，退出码0；trial活动路径的Rocq接口类型检查、共享场景的GCC ILP32语法检查也通过。20个审阅到共享文件映射仅发生已记录的逻辑导入路径迁移，其他内容一致；全部源码/配置/复用接口证据hash未变。完整结果见 `checks/design-completion.json`，构建日志为 `checks/shared-merge-build.log` 与 `checks/migrated-interface.log`。

设计说明见 [predicate-design.md](predicate-design.md) 与 [spec-design.md](spec-design.md)。完整源码分析见 [c-analysis.md](c-analysis.md)。新设计目标4个：KEventDelete、FindEventById、_EventDelete、Event场景LinklistResumeAll；5个依赖为已有spec复用边界，6个为明确的模型/API边界。

以上为设计阶段完成时的结论；当时未启动verification-orchestrator、symbolic、VC生成或C实现证明。设计review-passed不等于实现verified。随后用户批准实施，当前进度如下。

## 实现阶段已获批准

2026-11-03 用户回复“做吧”，确认以上两份审阅revision并授权开始实现证明。从本次授权起按 [implementation-handoff.md](implementation-handoff.md) 进入verification-orchestrator。四个实现目标现已全部通过final-check；最终结论见下文。

四个实现目标的运行清单及owner映射见 `checks/implementation-runs.json`。四个目标已全部达到controller done，源码一致性复核已通过。

## 实现实时进度

下表直接读取各run的controller_state.json，不作为独立控制状态。组accepted不等于函数done。

| 目标 | Run | 阶段 | 已接纳组/总组 | 进行中 |
|---|---|---|---:|---|
| FindEventById | `FindEventById-20261103170357` | done | 10/10 | final-check通过 |
| LinklistResumeAll | `EventLinklistResumeAll-20261103172104` | done | 14/14 | final-check通过 |
| _EventDelete | `EventDelete-20261103173023` | done | 21/21 | final-check通过 |
| KEventDelete | `KEventDelete-20261103211513` | done | 5/5 | final-check通过 |

四个目标均已完成annotation、独立VC检查、全部50个证明组、parent、final-apply及final-check；源码一致性复核通过。

ResumeAll在annotation r2从旧os_inv提取并保留world/task纯事实，修复旧状态唯一归属丢失；IdRemoveObj仅作typed-field/store等价适配，已同步trial及共享Event场景canonical/caller并通过ILP32语法检查，见checks/idremoveobj-syntax-adaptation.json。公开规格及用户前提未改变。

## 最终完整性结论

2026-11-04，状态为 **verified（在已批准条件下）**。FindEventById、_EventDelete、KEventDelete、Event场景LinklistResumeAll均由controller完成parent、final-apply、final-check并返回done。复用controller的实际终检结果，未另运行一套证明检查。最终证明位于trial `VC/`，目标分别为 `FindEventById`、`EventDelete`、`KEventDelete`、`EventLinklistResumeAll`。

四份活动C输入与已有源码一致性审计时完全相同，26份源码、配置、信任及复用接口证据hash未变；20份共享设计映射与原记录或已记录的IdRemoveObj等价适配一致。精确run状态与证据链接见 [implementation-completion.json](../../checks/implementation-completion.json)。

结论依赖 `0 <= id < 65536`、D1同一分配对象从命中到注销不被他人回收/复用、D2本次观察/清空后的空pending到注销保持为空，以及审阅采用的TrustBase和模型/API适配。`CriticalAreaLock.event_delete_gap`仍是此环境范围下的可信接口，不是从普通锁保证推得的无条件结论。权威C及候选修复补丁均未修改，原并发缺陷并未修复；错误触发场景按用户批准的条件排除。

5个reused-spec依赖及6个模型/API边界不计为本轮新完成的C函数体证明；它们的适用性与接口一致性按已审阅闭包使用。两条导入KTaskWakeup特化接口的推导义务已随LinklistResumeAll完成，不代表重证KTaskWakeup函数体。

## 审批阻塞已解除

2026-11-04 用户直接确认“明确授权继续实现证明”，所答问题明确包含symbolic、VC、Rocq并覆盖最初仅设计限制。该授权已被Rocq自动审批接受，先前被拒的同一调用成功，`import_sem_refinement` 已通过完整group-check及controller接纳。

控制器原先没有重开基础设施阻塞组的入口；已补充受限resume-run参数并通过5项针对性检查。该入口只把指定基础设施阻塞组交回原owner，保留proof和已接纳组，拒绝语义缺口及已通过组，后续仍须全部验收；未手改controller状态或跳过证明。补丁与测试见 `checks/controller-recovery/`。
