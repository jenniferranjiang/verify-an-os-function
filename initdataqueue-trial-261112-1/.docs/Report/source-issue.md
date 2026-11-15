# InitDataqueue 源码问题与实验状态

本轮新实验仅设计及审阅，目标为 predicate 与完整调用闭包 spec 各自 review-passed。用户于 2026-11-13 批准候选补丁后，已应用权威源码修复，恢复 C 分析和设计。formal revision 与编译、审阅的当前状态见 manifest 及后续设计/审阅记录。未启动 verification-orchestrator、QCP parser/symbolic，未生成 VC，未做 C 实现证明，未修改全局库；权威源码仅应用已批准的补丁。

## DQ-001：信号量 ID 的成功与失败判断错误（已按用户批准修复并复查）

权威源码根为 `/home/xinra/crtos`，当前工作树依据及输入 SHA-256 见 [manifest](../../manifest.json)。相关源码包含已有用户修改（semaphore.c、id.c），本轮未覆盖它们。InitDataqueue/DeInitDataqueue 的本地内容与该源码 commit 相同。

`kernel/thread/data_queue.c:52-60` 对两个 KSemaphoreCreate 的返回值使用逻辑非判断失败；`:94-102` 的 DeInitDataqueue 则仅在句柄非零时删除。这里及下文路径相对 `Ubiquitous/XiZi_IIoT_Macro/`。

`kernel/thread/semaphore.c:33-61` 的 _SemaphoreCreate 在成功时返回 ID，分配失败及 ID 耗尽时返回 -ENOMEMORY；`:246-250` 的 KSemaphoreCreate 通过固定 done 表原样转发。`kernel/include/xs_base.h:98-103` 定义 EOK=0、ERROR=1、ENOMEMORY=5。`kernel/thread/id.c:24-52,106-119` 从最低空闲 bit 分配 ID，空 bitmap 的首个 ID 为 0；`kernel/include/xs_id.h:48-55` 的静态 bitmap 初始全零。故合法 ID 0 与失败码 -5 均为当前配置的真实可达结果。

反例一：NodeNumber=8、空信号量 manager、数组和首个信号量分配成功。sem_blank=0 使 InitDataqueue 提前 break。清理释放 base，但因 sem_blank=0 跳过 KSemaphoreDelete；函数返回 -ERROR，已创建的信号量 ID 0 泄漏。

反例二：数组分配成功，两次 KSemaphoreCreate 均因内存不足返回 -5。两处 `!(-5)` 均为假，最终返回 EOK，queue 中却保存两个无效句柄。这会使后续 Push/Pop 无法按初始化成功的预期使用该队列。

不允许通过自加“ID 不为 0”或“创建永不失败”的 Require 隐去这些路径。默认 ReviewWhitelist 001 仅涉及 assertS 临界区观察条件，不覆盖此缺陷；TrustBase 也未授权修改创建结果或省略错误路径。

## 待批准的具体修复

[候选补丁](../../proposed-fixes/data_queue.patch) 已按用户批准于 2026-11-13 应用。它在清零后将两个 semaphore 字段设为 -1，创建失败检查改为 `< 0`，清理条件改为 `>= 0`，删除后重新置 -1；原错误判断和 reset 以注释保留。这样数组分配失败时两个句柄仍是未获取状态，ID 0 可以正常使用/删除，负错误码进入清理。补丁同时修改 Init 和 DeInit，因为仅修改创建检查仍会遗漏 ID 0 的回收。NodeNumber 的合法调用范围及其他模块生命周期条件留待恢复后的设计分析，不冒称已完成完整设计审阅。

补丁改变的无效句柄约定需要重新检查当前调用者：源码中 DeInit 的可见直接调用来自 Init 的错误清理，queue manager 还公开 DeInit 回调；修复后 DeInit 的输入必须是经过初始化流程的对象，不能把任意全零对象当成未获取资源。正式设计将明确该生命周期条件。

## 当前范围与恢复条件

适配后 Init 的直接调用包含 memset、CriticalAreaLock/UnLock、x_malloc、KSemaphoreCreate、DeInitDataqueue；DeInit 包含 x_free、KSemaphoreDelete 和中断保存/恢复。KPrintf 依技能规则去除；当前权威头文件中的 NULL_PARAM_CHECK 是空指针死循环旧版，恢复设计时必须按旧版规则处理，不能采用新版“仅去除诊断观测”的规则。现有 semaphore canonical spec 明确覆盖合法 ID 0 与失败 -5，进一步支持上述接口不匹配判断。是否采用这些 spec 为 reused-spec、IC contract 的适配和完整递归闭包的分类尚未完成，不能把这份初步列表作为闭包已通过的证据。

C analysis agent 与 main agent 分别核对了上述返回值和最短反例。用户需先批准具体源码修复或明确批准排除触发场景的假设；若采用假设，源码缺陷仍须记为存在，结论限于该假设。依据技能 reporting-guide 的源码问题门禁，问题解决前不继续 predicate/spec 编写或审阅。批准修复后需应用并检查补丁、重新冻结源码、完成 C 分析，再继续设计、Rocq 编译和独立审阅。本轮范围仍限于设计和审阅。

候选补丁已通过 `patch --dry-run -p1`（exit 0），且重新核对 manifest 的全部输入 SHA-256 未变。该检查仅确认补丁可应用，不代表修复已应用或 C 实现已获证明。

2026-11-13：用户明确批准上述具体补丁，主 agent 已成功应用到权威源码。原错误判断及 reset 按补丁保留注释；修改前后 SHA-256 见 manifest.source_fix。历史 dry-run 记录不充当修复验证，修复后由 C analysis agent 独立复查。

修复后独立 C 分析确认 DQ-001 已解决：ID 0 走成功路径及非负句柄删除路径，负错误码走失败回滚路径。数组失败留下 (-1,-1)，首个创建失败留下 (-5,-1)，第二个创建失败清理后留下 (-1,-5)；清理不改写已有负值。当前范围内未发现新增未解决源码问题。后续 predicate/spec 按这些真实字段结果设计。

本轮收尾：DQ-001 修复后的 predicate 与完整调用闭包 spec 已分别通过独立设计审阅，详见 [review](review.md) 和 [manifest](../../manifest.json)。设计编译及接口类型检查通过，编译缓存已清理；没有进行实现证明或全局库合并。
