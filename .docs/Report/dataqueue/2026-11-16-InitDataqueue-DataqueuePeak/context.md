> 本轮报告目录：`.docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/`，主目标为InitDataqueue与DataqueuePeak，必要调用闭包及后续待办在本目录各报告中说明。

# Dataqueue 当前工作上下文

用户已明确要求把最新InitDataqueue工作成果整合进全局lib、annotated C及报告，并在核对后删除两个InitDataqueue工作目录。原C仓库 `/home/xinra/crtos` 保持只读；最新输入来自 `initdataqueue-trial-261115-1`，另一个旧目录按用户既有要求未读取、未复用。

## 当前范围

已设计并在迁移前审阅的函数为InitDataqueue、DeInitDataqueue的init_cleanup、KSemaphoreCreate/_SemaphoreCreate的dataqueue_ic、KSemaphoreDelete/_SemaphoreDelete的dataqueue_cleanup_ic以及DataqueuePeak。这里的完成指设计审阅，不是C实现证明。

PushDataqueue、PopDataqueue以及_SemaphoreObtain当前只保留源码修复/分析副本，尚无本轮已通过的完整spec。最新输入没有VC、verification_runs或controller状态可迁入，本次不启动QCP、不生成VC。全局已有Semaphore等VC源码和证明保留，受共享状态变化影响的检查结果见integration-review。

## 持续有效的授权

- Init/DeInit以-1表示未取得ID，Create以<0判失败、Delete以>=0判持有；已负的创建错误码保留。Push/Pop统一按timeout调用Obtain并检查失败。这些批准只针对验证副本。
- Peak检查和读取放在同一临界区，两出口解锁；Push/Pop的共享semaphore ID在锁内缓存，调用仍在锁外。缓存不排除对象退役或ID复用。
- _SemaphoreObtain已获批并应用零超时分支：msec==0保留wait_time=0；真实副本经独立对照测试通过。调度后exstatus读取保护尚未实施。
- DisableLocalInterrupt/EnableLocalInterrupt为本轮ILP32非SMP可信IRQ资源交接，保存值必须原样恢复；不包含硬件mstatus正确性。其他信任按配置TrustBase，未扩大授权。

## 尚未处理的源码问题

KTaskSetDelay按普通数值排序与CheckTaskDelay回绕判断不一致，可挡住已到期任务；_SemaphoreObtain忽略Delay分配失败，可使有限等待缺少超时节点。这两项尚未获修复授权，相关新增设计暂停。证据与提案见source-errors.md及source-changes.md，迁移不把它们标为已解决。

## 记录与构建

长期设计说明为design.md，源码原因与前后差异为source-changes.md，缺陷及状态为source-errors.md，函数范围见function-status.md；predicate-review/spec-review保留原审阅证据，integration-review记录本次全局整合检查。

全局使用现有 `CRTOS_Verify.lib` / `CRTOS_Verify.VC` 逻辑根和根_CoqProject构建入口，保留.vo供交互式使用。用户本次授权的是成果整合与删除指定目录，不是新函数证明或额外源码修复。

整合和独立对应性检查已完成，两个用户指定InitDataqueue目录已删除；全局64份lib通过编译且.vo保留，Init/Peak交互加载通过。既有VC七项首要失败与合并前隔离基线一致，不能称全部旧证明通过。原OC删除生命周期问题及两个等待源码缺陷继续保留为待处理事项。

迁移收尾已完成：本轮源快照/临时构建和旧未采用草稿已清理，恢复入口是当前全局文件与报告。待处理的Delay回绕反例提案仍在/tmp/crtos-verify-initdataqueue-trial-261115-1-delay-wrap-Q4gwoM，未获修复授权、未应用；源码错误记录已保存完整触发过程与建议差异。
