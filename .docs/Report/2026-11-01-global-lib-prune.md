# 全局库清理与 Mutex 同步（2026-11-01）

按用户要求核对 `kmutexcreate-trial-261101-1/lib/MutexInv.v`、`MutexState.v` 与全局版本：仅将 trial 的逻辑前缀替换为 `CRTOS_Verify.lib` 后，两者已经完全一致，因此无需再次覆盖。整个 trial 未作修改；其中 lib 的 174 个文件（含编译产物）在操作前后哈希一致。

全局库删除 `EventState.v`、`EventInv.v`、`MsgQueueState.v`、`MsgQueueInv.v` 及其旧编译产物。同步删除 `CrtosGlobState` 的对应字段、上下文和 record 更新，`CrtosInv` 的资源组合与等待者覆盖，`KTaskWakeup` 的对应状态关系及消息队列专用接口。`StructFieldOffsetAxiom` 中仅属于这两个模块的大小、偏移定义及六项公理也已移除，未新增替代公理或占位定义。

根 `_CoqProject` 移除四个文件后重新生成 Makefile。根 `annotated_C/include/logic.h`、`src/headers/ktask_wakeup.h`、`src/LinklistResumeAll.c` 删除对应的消息队列专用 extern/spec，避免留下引用已删除定义的合同。剩余 QCP 注解块与修改前相同，`LinklistResumeAll` 可执行 C 保持不变。任务结构自己的事件字段及其 ABI 仍保留，它们是 `TaskDescriptor` 的真实字段，不是独立 event 模块。

## 检查结果

根项目全部 49 个全局库源文件均在 `_CoqProject` 中。执行 `make -f Makefile.coq -j2 COQBIN=/home/xinra/.opam/pv-bench-8.20.1/bin/`，受影响依赖实际重编译，退出码 0，包括 `MutexInv`、`CrtosInv`、`KTaskWakeup`、`KMutexCreate`、`KSemaphoreCreate` 和 `KSemaphoreDelete`。构建过程未使用 trial/lib 旧产物代替全局编译。

检查证据：[构建日志](../checks/global-lib-prune-20261101/build.log)、[构建结果](../checks/global-lib-prune-20261101/build-result.json)、[一致性检查](../checks/global-lib-prune-20261101/consistency.json)、[完成记录及源码哈希](../checks/global-lib-prune-20261101/result.json)。

## 版本与验证范围

这是用户明确要求的模型范围变更，不是对旧 os_inv 的等价重写。当前全局模型不表示 event/msgqueue 的资源和等待者；后续证明这两个模块时需要重新设计其状态、资源归属及跨模块关联。未修改内核 C，也未证明这两个模块的实现。

旧 KMutexCreate trial 的 controller `done`、审阅记录和证明文件全部保留，它们对应清理前的全局库版本。该 trial 的 active imports 指向全局库，保留 trial/lib 快照本身不会固定 active imports；因此旧完成状态不能直接用于修改后的全局库。此次只完成全局库编译与一致性检查，没有重新运行旧 trial 的 symbolic、VC 或 C 实现证明。
