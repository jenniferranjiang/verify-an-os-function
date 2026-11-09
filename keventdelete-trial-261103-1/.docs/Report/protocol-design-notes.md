# 删除环境条件的协议设计检查

2026-11-03，独立 reviewer 的设计阶段建议；本文不是 predicate/spec 的最终审阅结论。依据用户明确排除 D1/D2 场景并确认 `0 <= id < 65536`，权威 C 不应用修复补丁。

`CrtosRules.v` 的统一协议把 rely 定义为任意全局状态间均允许转换。`OutsideCritical` 不持有共享堆，`LastSeen` 允许环境推进。因而，单凭“刚查到 p”与普通加锁接口，无法推出下一次加锁时 p 仍登记；单凭“刚清空 pending”也不能推出它仍为空。将环境条件仅写成报告文字，或者声称普通 lock contract 自然保留这两项事实，都不足以支持正式设计。

可行的最小适配是沿用同一个断言载体、`InsideCritical`、`OutsideCritical`、`os_inv`、`LastSeen`，不修改全局 rely，不新建锁 token；把用户批准的条件精确落实到这次删除适用的具名加锁边界 contract 与分段抽象操作。它是原已受信 `CriticalAreaLock` 在本次受限环境下采用的额外保证，不是从普通 lock contract 推导出的引理。正式定义附近与采用该 spec 的切片均须明确这项依赖，不得泛化为所有 lock 调用都满足。

各阶段仅需以下保证：

| 实际间隙 | 下一次取得锁时允许要求的条件 |
| --- | --- |
| Find 成功解锁到 pending 检查 | 同一 p 仍以同一 ID 登记；不冻结 pending、事件位、任务或其他模块。 |
| 检查为非空到 ResumeAll 取得锁 | 同一 p 仍登记；旧等待者可以已离队，甚至 pending 已经为空，也可以出现将在本次 ResumeAll 内处理的新等待者。 |
| 检查为空到注销锁，或 ResumeAll 清空后到注销锁 | 同一 p 仍登记，且 pending 仍为空。 |

要求“仍为空”的加锁合同前置必须已经给出旧观察中目标存在且 pending 为空，不能让任意 caller 用一个 true 标志凭空要求空链。该保证只表达 D2 排除的对应窗口；它不表示所有临界区之间整个 OS 或整个 Event 对象均不变。

批量唤醒的效果应以 ResumeAll 实际取得锁时的等待序列为准，不能使用更早检查时的序列。`resched` 由更早的 IsDoubleLinkListEmpty 结果确定：即使检查非空但 ResumeAll 取得锁时已经空，C 仍在删除之后执行一次调度模型调用。这条路径必须保留。

上述关系不提供任何堆权限；共享字段仍必须在加锁后从真实 `os_inv` 拆出，并在解锁前恢复。注销后得到的完整私有 Event 资源独立穿过解锁并由 free 消费，不能同时留在 event_inv 内。受限原子操作可选择满足对应环境条件的实际获取状态，错误关系也须采用相同约束；正式设计应检查有合法观察与可执行分支，不能通过不可能的前提或空行为集合获得真空通过。

`LinklistResumeAll` 的根 canonical 当前是 Semaphore 调用场景下删去内部嵌套锁的 IC 适配。原 Event 调用在其删除锁之前，必须保留 ResumeAll 自身锁。新的 Event OC contract 是独立场景，不能当成旧 semaphore 合同的参数改名或已证明特化。Trial 应只有一份对应本场景的 active canonical。共享保存时可另设明确的场景目录保留 Event OC 输入，不覆盖根已有 Semaphore IC 输入；各 caller 必须引用自己所选场景的相同合同，两个适配单元不能共同当作一份 C 定义编译。
