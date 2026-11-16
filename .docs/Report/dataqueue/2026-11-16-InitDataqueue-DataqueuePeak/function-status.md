# Dataqueue 当前函数进度

当前成果位于全局lib、annotated C和本报告目录。用户要求的整合已完成，检查见 [integration-review.md](integration-review.md)。**设计审阅通过不等于实现证明完成；本轮Dataqueue没有新增VC或C实现证明。**

## 已完成的设计及全局位置

| 函数 | Predicate / 抽象程序 | Spec | 适用范围 |
| --- | --- | --- | --- |
| [InitDataqueue](../../../../annotated_C/src/kernel/dataqueue/InitDataqueue.c) | 原设计已审阅，全局库类型检查通过 | 原设计已审阅，迁入全局 | 初始化、三类失败和回滚，含n=0/1 |
| [DeInitDataqueue](../../../../annotated_C/src/kernel/dataqueue/DeInitDataqueue.c) | 同上 | init_cleanup已迁入 | 未发布对象的初始化失败清理，非通用并发销毁 |
| [KSemaphoreCreate](../../../../annotated_C/src/kernel/semaphore/KSemaphoreCreate.c) | IC效果已迁入，原OC接口保留 | dataqueue_ic已增补 | Init实际持锁创建场景 |
| [_SemaphoreCreate](../../../../annotated_C/src/kernel/semaphore/_SemaphoreCreate.c) | 同上 | dataqueue_ic已增补 | IC以规则去除嵌套锁的切片为对象，OC body完整保留 |
| [KSemaphoreDelete](../../../../annotated_C/src/kernel/semaphore/KSemaphoreDelete.c) | IC效果已迁入，原OC接口保留 | dataqueue_cleanup_ic已增补 | 回滚中无等待者且无queue引用的删除 |
| [_SemaphoreDelete](../../../../annotated_C/src/kernel/semaphore/_SemaphoreDelete.c) | 同上 | dataqueue_cleanup_ic已增补 | IC需源码规则适配；通用OC删除生命周期另有待处理项 |
| [DataqueuePeak](../../../../annotated_C/src/kernel/dataqueue/DataqueuePeak.c) | 原设计已审阅，全局库类型检查通过 | 原设计已审阅，迁入全局 | 同锁观察队首；支持未知输出槽 |

迁移前审阅版本为dq-predicate-native-20261116-r1和dq-spec-native-20261116-r1；原证据见predicate-review/spec-review。此次dq-global-integration-20261116-r1记录增量整合及对应性检查，不追认为新实现证明。全局新增5份库、修改5份共享文件，64份全局lib已编译通过，.vo保留供交互式使用。

## 尚未完成的新增设计

| 函数/接口 | 当前状态与下一步 |
| --- | --- |
| [PopDataqueue](../../../../annotated_C/module_context/dataqueue/PopDataqueue.c) / [PushDataqueue](../../../../annotated_C/module_context/dataqueue/PushDataqueue.c) | 已批准源码修复保留；无完整新spec/函数抽象，等待依赖源码问题处理 |
| KSemaphoreObtain / [_SemaphoreObtain](../../../../annotated_C/module_context/semaphore/_SemaphoreObtain.c) | 缺少适用既有spec；内部零超时修复已批准、应用并复核，完整等待语义仍待设计 |
| KSemaphoreAbandon / _SemaphoreAbandon | 缺少适用既有spec；尚未建立本轮canonical |
| LinklistSuspend / LinklistResume的Semaphore场景 | 现有参考契约不覆盖该场景，需相应新接口及body目标，下层已有适用契约可复用 |
| KTaskSetDelay | 现有参考契约与当前源码排序语义不同，尚不能直接采用 |
| CalculateTickFromTimeMs / GetKTaskDescriptor等 | 已找到参考契约，按实际调用条件核对后复用，不因证明状态复制body |

两项源码问题仍阻塞新增等待路径：SetDelay回绕排序可挡住已到期任务；Obtain忽略Delay分配失败可使有限等待没有超时节点。未获额外修复授权，见 [source-errors.md](source-errors.md)。调度后exstatus共享读取适配也尚未实施。

## 原有证明与复用边界

Init闭包复用IdInsertObj、IdGetObj、IdRemoveObj、四个DLL接口及LinklistResumeAll等已记录契约；它们不因来源证明状态而自动扩为本轮body证明目标。

既有46份VC原样保留，回归有7个首要错误；与合并前隔离构建逐项一致，后续被阻塞证明仍未检查完成。另有通用OC SemaphoreDelete可能删除live queue引用ID的语义问题，新os_inv下的原通用保证需重新处理生命周期条件。这些均在integration-review中明确区分，不能把“库已编译”说成“全局证明全部通过”。

长期解释见 [design.md](design.md)，源码前后及原因见 [source-changes.md](source-changes.md)。
