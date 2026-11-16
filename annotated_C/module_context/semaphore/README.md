# Semaphore 已批准源码副本

`_SemaphoreObtain.c`保留用户批准的零超时修复：msec==0时wait_time保持0；-1仍表示无限等待，其他输入仍使用原CalculateTickFromTimeMs。原分支完整留在注释中，未回写原仓库。

这是尚未完成规格设计的源码处理副本，不是canonical spec或已证明函数。最终task->exstatus共享读取的最小锁适配尚未实施；后续推进还须处理已确认的Delay跨回绕源码门禁。此迁移没有默默补上这些待处理修改。

授权、检查与未解决项见[源码改动记录](../../../.docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/source-changes.md)；整体设计边界见[全局设计说明](../../../.docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/design.md)。
