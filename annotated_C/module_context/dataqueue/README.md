# Dataqueue 已批准源码副本

此目录保留 PushDataqueue、PopDataqueue 的批准修复及共享ID访问适配副本，供后续模块分析和规格设计使用。它们尚无正式canonical spec，也没有实现证明；不要作为已验证输入或当前VC目标。

保留的修复包括统一按timeout调用Obtain、失败立即返回，以及锁内缓存Obtain/Abandon使用的semaphore ID。原错误代码和适配依据仍在各C文件注释中，原仓库未因此修改。

InitDataqueue、DeInitDataqueue及DataqueuePeak的设计输入在 [src/kernel/dataqueue](../../src/kernel/dataqueue/)，不在这里重复保存它们的body。已批准Peak同锁检查和读取的适配保留在唯一canonical中。

当前设计范围、依赖和待证条件见[全局设计说明](../../../.docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/design.md)；源码改动、授权及尚未解决的Delay问题见[源码改动记录](../../../.docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/source-changes.md)。
