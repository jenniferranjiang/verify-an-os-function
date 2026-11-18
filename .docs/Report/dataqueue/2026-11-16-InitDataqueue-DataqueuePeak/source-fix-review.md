# 当前源码同步与副本修复复核

> 2026-11-17：按用户要求删除Push/Pop/_SemaphoreObtain三个分析副本。下文涉及这些副本的同步与测试是删除前的历史记录；修复及适配代码保留在[source-changes.md](source-changes.md)，不表示当前仍有对应实现文件。七份canonical、lib和VC不受此次删除影响。

日期2026-11-16。依据crtoslatest `a07641a0b58469ae3ea19317cce2cf48974989bb`及当前ILP32、非SMP、100Hz配置。C同步作者与独立源码reviewer分开；main再次执行差异检查和受控测试。本记录替代旧来源下的阶段状态，具体修复前后见[source-changes.md](source-changes.md)，现存缺陷仅见[source-errors.md](source-errors.md)。

## 复核结论

四项Dataqueue问题在新源码中仍存在，验证副本保留已批准的Init/DeInit ID修复、Push/Pop统一Obtain并检查返回值，以及Peak同锁检查和读槽。没有回写原仓库或扩大算法修复。Push/Pop的锁内缓存ID适配继续保留，不据此宣称排除生命周期或ABA问题。

本轮采用上游自身的Obtain零超时、非法ID/timeout拒绝及Delay失败唤醒回滚行为，不再把这些行为称为本地补丁。Delete同步上游范围检查；诊断NULL宏按规则移除，不再假设它保证非空；_Obtain末尾exstatus采用最小临界区读取。配置宏处理与IRQ授权边界不变。

独立reviewer核对当前源码、宏和配置，确认本轮差异属于上游同步、保留批准修复及现有规则适配。Main复查十一份已有C/header的有效语句，差异仅为规定的NULL移除及Delete范围检查；_Obtain恢复纯helper、调试语句及原末尾读取后，与新版上游body逐字一致。

## 检查证据

- 本轮七份canonical通过GCC `-m32 -fsyntax-only` 检查；header中63项限定词汇及Peak槽资源类型通过Coq检查。
- 从当前_Delete、_Obtain、Push、Pop提取实际body，使用受控依赖测试22例；作者执行后，main独立重编译运行通过。覆盖ID=-1/0/65535/65536/INT_MAX，Delete命中及有无等待者、Obtain非法timeout/零等待/计数可用/Delay失败回滚/有限及无限等待、Push空payload、Pop输出和失败frame。检查了锁配对、调用次数及参数。
- 既有批准修复的历史检查覆盖Init的ID0成功、三类失败回滚、重复DeInit、n=0/1、Peak空/非空，以及Push/Pop timeout=-1/0/1/20的16例控制流。该证据仍支持未变的修复逻辑；本轮没有把历史测试冒充重新执行。
- 全局64份lib编译通过，并保留对应.vo。Main检查当前64份均有.vo；本轮只修改两份Semaphore库文件。
- 既有46份VC源码相对任务开始快照逐字未变，本轮未生成或手改VC。

受控执行测试运行于宿主环境，不能代替ILP32布局检查、真实调度并发验证或形式化证明。当前七函数设计审阅见[predicate-review.md](predicate-review.md)及[spec-review.md](spec-review.md)。_Obtain等分析副本仍未拥有完整新spec/实现证明；全局旧OC Delete生命周期及既有VC问题另见[integration-review.md](integration-review.md)。
