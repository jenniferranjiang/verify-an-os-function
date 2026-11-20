> 2026-11-21 更新：Dataqueue 已改为有效元素列表，本文旧 Dataqueue predicate/spec/实现结论不适用于新输入。Init、DeInit、Peak、Pop 的旧表示证明需重新适配；历史记录保留。见 [本轮设计与验证范围](../2026-11-21-FifoRepresentation/design.md)。

> 当前证明文件已按用户要求恢复QCP原生auto/manual分工，Init和DeInit均重新final-check通过。最新文件、计数及信任说明见[native-auto-restoration.md](native-auto-restoration.md)。下文旧全部manual计数是历史记录。

> 最新结果：InitDataqueue run InitDataqueue-20261117224043 已由controller返回done，final-check passed（63个顶层VC）。这是相对于callee契约的Init函数证明；第一阶段闭包尚未完成。当前串行进入DeInitDataqueue run DeInitDataqueue-20261118121138。用户已取消VC预算上限。下文早期预算/部分VC计数为历史记录。

> 2026-11-18最新状态：Init已接纳44/62顶层VC（10组），累计预算约99–100分钟，停止新增证明尝试；无函数final-check。余18个目标、局部对齐注解修复及重试，详见[implementation-result.md](implementation-result.md)。

> 当前恢复说明：用户已授权具体DataQueue/DataElem布局事实，已接入dataqueue_layout_abi；下文旧ABI缺失记录是历史阻塞。当前正在map版本重编译与验证，尚无新的实现完成结论。

> **2026-11-17 当前变更：** 用户已授权地址map改造，本文r1列表版本及旧Init VC适用性已invalidated；历史证据保留。当前设计与迁移检查见 [map-refactor.md](map-refactor.md)。ABI布局连接缺口仍待解决。

# Dataqueue 当前函数进度

当前成果位于全局lib、annotated C和本报告目录，已有实验输入已按crtoslatest同步。用户要求的整合已完成，检查见 [integration-review.md](integration-review.md)。**设计审阅通过不等于实现证明完成；本轮Dataqueue没有新增VC或C实现证明。**

## 已完成的设计及全局位置

| 函数 | Predicate / 抽象程序 | Spec | 适用范围 |
| --- | --- | --- | --- |
| [InitDataqueue](../../../../annotated_C/src/kernel/dataqueue/InitDataqueue.c) | 定义沿用，依赖已按新源码同步 | 已按新源码同步，当前审阅见spec-review | 初始化、三类失败和回滚，含n=0/1 |
| [DeInitDataqueue](../../../../annotated_C/src/kernel/dataqueue/DeInitDataqueue.c) | 同上 | init_cleanup已迁入 | 未发布对象的初始化失败清理，非通用并发销毁 |
| [KSemaphoreCreate](../../../../annotated_C/src/kernel/semaphore/KSemaphoreCreate.c) | IC效果已迁入，原OC接口保留 | dataqueue_ic已增补 | Init实际持锁创建场景 |
| [_SemaphoreCreate](../../../../annotated_C/src/kernel/semaphore/_SemaphoreCreate.c) | 同上 | dataqueue_ic已增补 | IC以规则去除嵌套锁的切片为对象，OC body完整保留 |
| [KSemaphoreDelete](../../../../annotated_C/src/kernel/semaphore/KSemaphoreDelete.c) | IC效果已迁入，原OC接口保留 | dataqueue_cleanup_ic已增补 | 回滚中无等待者且无queue引用的删除 |
| [_SemaphoreDelete](../../../../annotated_C/src/kernel/semaphore/_SemaphoreDelete.c) | 同上 | dataqueue_cleanup_ic已增补 | IC需源码规则适配；通用OC删除生命周期另有待处理项 |
| [DataqueuePeak](../../../../annotated_C/src/kernel/dataqueue/DataqueuePeak.c) | 定义沿用，依赖已按新源码同步 | 已按新源码同步，当前审阅见spec-review | 同锁观察队首；支持未知输出槽 |

当前审阅版本为 `dq-predicate-crtoslatest-20261116-r1` 和 `dq-spec-crtoslatest-20261116-r1`，均已通过当前实验范围的设计审阅，见[predicate-review.md](predicate-review.md)与[spec-review.md](spec-review.md)。此前整合记录保留为历史依据。本轮修改两份Semaphore库文件，64份全局lib编译通过，.vo保留供交互式使用。

## 尚未完成的新增设计

| 函数/接口 | 当前状态与下一步 |
| --- | --- |
| `PopDataqueue` / `PushDataqueue` | 已批准修复代码保留在报告；分析副本已删除，无完整新spec/函数抽象 |
| KSemaphoreObtain / `_SemaphoreObtain` | 缺少适用既有spec；分析副本已删除，新版等待行为及共享读取适配见source-changes，完整等待语义仍待设计 |
| KSemaphoreAbandon / _SemaphoreAbandon | 缺少适用既有spec；尚未建立本轮canonical |
| LinklistSuspend / LinklistResume的Semaphore场景 | 现有参考契约不覆盖该场景，需相应新接口及body目标，下层已有适用契约可复用 |
| KTaskSetDelay | 新来源已修改排序与时间窗口处理，后续按新实现核对可用参考契约 |
| CalculateTickFromTimeMs / GetKTaskDescriptor等 | 已找到参考契约，按实际调用条件核对后复用，不因证明状态复制body |

新来源已处理原来的等待路径缺陷。2026-11-17按用户要求删除Push/Pop/_Obtain分析副本，保留报告中的修复和适配说明；后续正式写spec时落实到canonical文件。当前错误报告仍只列新源码中的四项问题。

## 原有证明与复用边界

Init闭包复用IdInsertObj、IdGetObj、IdRemoveObj、四个DLL接口及LinklistResumeAll等已记录契约；它们不因来源证明状态而自动扩为本轮body证明目标。

既有46份VC原样保留，回归有7个首要错误；与合并前隔离构建逐项一致，后续被阻塞证明仍未检查完成。另有通用OC SemaphoreDelete可能删除live queue引用ID的语义问题，新os_inv下的原通用保证需重新处理生命周期条件。这些均在integration-review中明确区分，不能把“库已编译”说成“全局证明全部通过”。

长期解释见 [design.md](design.md)，源码前后及原因见 [source-changes.md](source-changes.md)。

2026-11-17 当前实现状态：Init已生成VC并接纳annotation/VC-checking，首组因缺少正式DataQueue/DataElem ABI连接被controller接纳为blocked；无实现证明或final-check完成，后续阶段未启动。当前结果、任务表与待决方案见[implementation-result.md](implementation-result.md)。

本轮map改造已分别独立审阅通过：`dq-predicate-map-20261117-r1` / `dq-spec-map-20261117-r1`。64份lib依赖编译通过、.vo保留；无新实现证明。当前正式输入与检查见[map-refactor.md](map-refactor.md)。
