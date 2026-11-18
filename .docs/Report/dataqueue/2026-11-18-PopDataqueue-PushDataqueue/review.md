# PopDataqueue / PushDataqueue 独立设计审阅

结论：predicate **review-passed**；完整调用闭包 spec **review-passed**。Reviewer 为独立 agent `/root/reviewer`，未编写本轮 formal 输入。2026-11-18 在 main 提交完整候选及成功编译证据后首次完整审阅；先通过 predicate，再以同一冻结 predicate 检查 spec。未启动 QCP、symbolic、VC 或实现证明。

- Predicate revision：`dq-pop-push-predicate-20261118-r1`。
- Spec revision：`dq-pop-push-spec-20261118-r1`，固定引用上述 predicate revision。
- 设计解释见 [design.md](design.md)，配置、实际工作树基线和历史修复授权见 [context.md](context.md)，调用闭包及复用来源版本见 [source-analysis.md](source-analysis.md)。

## Predicate 审阅

审阅八个新增 Rocq 文件及其实际使用的 Dataqueue、Semaphore、Task、Delay、调度、共享协议依赖。确认 `CrtosGlobState`、`CrtosInv`、`DataqueueState`、`DataqueueInv`、`SemaphoreInv`、`KTaskWakeup` 相对本轮开始的实际快照未改；复用原定义与原系统集成，没有第二套总状态或协议。

模块范围覆盖 Init、DeInit、Peak、Pop、Push：queue map 拥有每个结构和完整数组，未知及旧槽仍持有内存，payload 不解引用；两个 semaphore ID 只构成纯关联，信号量、ID manager 和等待链各有原有唯一 owner。显式 padding 与当前 `struct_padding=emp` 约定一致。初始化、私有清理、发布及退役仍使用原生命周期模型，本轮没有把已发布队列并发销毁声明为已解决。

Push 只在非满分支更新 rear 槽和 rear；Pop 只在非空分支读取 front 并推进 front，所有槽保留；局部 `replace_dataqueues` 保留其他对象和 OS 分量。各临界段间允许原 rely 的环境变化，缓存 semaphore ID 或 task 地址不冒称世代保活或排除 ABA。

等待路径先清 task.exstatus，复用精确 Suspend 关系取回 sched_link 后转交 semaphore；priority 插入使用首个严格低优先级位置，同优先级留在前方，不假设输入等待链排序。Delay 更新仅改 task.delay、inactive map、active DLL，失败保持这些资源；回滚由原 wakeup 关系迁回 ready。Abandon 的非空等待链只唤醒首任务，不写 exstatus；无等待者时仅修改计数。原 `os_inv` 的节点唯一归属与跨模块一致性保留。

新文件没有新增 Axiom、Admitted 或 Parameter。ready 保持和资源拆合的 Prop 陈述是明确待证义务，不当作证明事实。类型检查通过只证明定义良型，不冒称这些义务或 C 精化已证明。

## Spec 与完整调用闭包审阅

本轮九个新 canonical 各有唯一 active 完整函数体、直接可读的 `With/Require/Ensure`，每个保留 callee 在 caller 定义前有完整契约。人工重扫的闭包为：

| 新 canonical | 保留的直接调用及边界 |
|---|---|
| PopDataqueue / PushDataqueue | Lock、Unlock（既有协议）；KSemaphoreObtain、KSemaphoreAbandon（本轮） |
| KSemaphoreObtain / KSemaphoreAbandon | 固定 done 分派归一为对应 `_Semaphore*`（本轮） |
| _SemaphoreObtain | Lock/Unlock、CONTAINER_OF、KTASK_ASSIGN 模型；本轮 tick 转换及 LinklistSuspend；复用 IdGetObj、GetKTaskDescriptor、KTaskSetDelay、KTaskWakeup |
| _SemaphoreAbandon | Lock/Unlock、CONTAINER_OF、KTASK_ASSIGN 模型；复用 IdGetObj、IsDoubleLinkListEmpty；本轮 LinklistResume |
| LinklistResume | CONTAINER_OF 模型；复用 KTaskWakeup |
| LinklistSuspend | CONTAINER_OF 模型；复用 SuspendKTask、DoubleLinkListInsertNodeBefore/After |
| CalculateTickFromTimeMs | 叶子，无调用 |

复用边界使用来源已有契约，未复制函数体，也未将未证依赖标为 trusted 或本轮已证。VRTOS 原 LinklistSuspend 仅 Msg/Event、原 tick 转换采用32位回绕，均不适合直接复用，最终已正确归入新写规格。SuspendKTask/Wakeup 的本轮调用使用实际已登记任务 ID，不依赖其宽泛来源入口对任意未登记 ID 的安全性。SetDelay 的 null/inactive 和 delay-window 前提由等待观察显式检查；有限正 int32 毫秒在100Hz下转换至多214748364 ticks，小于2147483647的半区间界限，故 Obtain 不触达超长拒绝路径。caller-local 与 canonical 同名合同一致，引用的纯关系适配后保持 dataqueue 分量。

逐分支检查已批准修复副本：所有 timeout 恰传给 Obtain 一次，非0则根返回-1且不执行 ring/Abandon；成功后仍保留满/空不更新、仍 Abandon 且忽略其错误、最终0的分支。Pop 三个抽象结果分别连接失败/空时输出保持、非空时输出两个字段，输出 cell 独立归还。Obtain 覆盖非法 ID/timeout、未登记、减计数、立即超时、无限/有限等待、分配失败回滚与恢复后 exstatus；不承诺阻塞终止。Abandon 覆盖未登记、饱和、加计数、唤醒和有条件调度。Suspend 非法 flag 在调用前拒绝，FIFO/PRIO 与源码一致。tick 保留64位乘法、最少1以及原余数5至9判断。

读取当前 source_root 的 data_queue.c、semaphore.c、linklist.c、tick.c、delay.c、ktask.c，核对宏和静态分派。DQ-02/03 的已批准修复只落在验证副本；共享读取最小加锁、IC嵌套锁移除、诊断/HOOK省略按既有规则执行。原源码 DQ-02/03 缺陷仍存在，结论不外推为原源码等价或实现正确。

## 白名单、检查证据及限制

默认白名单001用于 `dataqueue_peak_entry`（由两根程序使用）、`semaphore_obtain_entry`、`semaphore_status_entry` 的原生 assertS 观察检查：宽松 `Rely=True` 下的全称观察条件可满足性/非真空性未证，不作为本轮 blocker；不声称这些条件由正常入口或环境自动保证。未新增用户白名单或信任范围。

main 提交并审阅复用的检查证据：根 Makefile 对 Pop/Push `.vo` 目标及全部新增传递依赖编译退出码0；九份 canonical 经 `gcc -m32 -std=c11 -fsyntax-only -Wall -Wextra` 退出码0；runtime/dataqueue header 共17个新增 term Extern 逐项 `Check (symbol : signature)`，采用根映射和 Coq 8.20.1，独立类型检查退出码0。未运行 QCP parser 或闭包脚本，QCP 注解接受性留待将来获准的实现阶段。

没有未解决的设计 blocker。唯一发现的非语义问题是 Obtain 中 LinklistSuspend canonical 路径注释，已修正并复核；该注释不影响 predicate/spec 含义。后续若 formal 输入改变，应复查受影响结论。本轮实现状态为 **not-verified**；来源契约、ABI和临界区模型的信任及未证义务继续有效，设计审阅不代替 C 实现证明。

## 冻结输入

摘要算法：按仓库相对路径字典序，对每个文件拼接 `path + NUL + SHA256(file bytes) + LF`，再取 SHA-256。全局 lib 摘要用于固定依赖版本，不表示本轮重新审阅或证明了所有无关文件。

- 全部 72 份正式 `lib/**/*.v` 依赖版本摘要：`56e798260047a115b5f6ea27db83b8d0c486a32d0f2bc88173b82bc8a7061182`。
- 九个 canonical 与全部 20 份模块 header 输入摘要：`3a384a3381fc1f41d641ab4129b2081556d4260c9522446f4a048a72b455bf2e`。
- 默认白名单文件 SHA-256：`936815c7f167b58e50dc3e4332133bea94146b91cc75b47781100743487313b4`。

| 本轮正式文件 | SHA-256 |
|---|---|
| `lib/dataqueue/KPopDataqueue.v` | `64cbfa028585131ce06264e2f7f49ab9ab66a2a90284f0cea54641a70173df34` |
| `lib/dataqueue/KPushDataqueue.v` | `7d3ba8bc8fa0146939b19b91a9a1e7af2c4962bf5c73a67fb3ae9c4b826e7c98` |
| `lib/semaphore/KSemaphoreObtain.v` | `7a7047ead49087f8c6c2a6b0edb51ed5bd71bbeb16405ed086481589af0de348` |
| `lib/semaphore/KSemaphoreAbandon.v` | `78da54eb51eda1408f67051267d7b5253ac850ec3e7989bac698a149854d94b0` |
| `lib/pendlist/LinklistSuspend.v` | `7e466f542019120380c2fcf35646dbe4332793bd5c15bd17154d579b80d3c97d` |
| `lib/task/KTaskSuspend.v` | `8458dd65686aed840a5fa285afa062283f1d7d77e954a4ca1a4c3bc2deb95340` |
| `lib/delay/KTaskSetDelayState.v` | `5f7cda5bb98e2438ed120043325cdf4247cad52ec95591cd5048d1a479d05cf7` |
| `lib/common/TickConversion.v` | `e58d7b1c5138edc2bfe34994c81d4a4223d26af82d6f987e4a60521d8d473d76` |
| `annotated_C/src/kernel/dataqueue/PopDataqueue.c` | `f6b7cdbaf941f328ec54cd75fe2c9d6378128b1649f339046404a0eaaeedd9a4` |
| `annotated_C/src/kernel/dataqueue/PushDataqueue.c` | `a09d68da59577601a738410cc3c874e6afc679f2ac7802e75ab6508d26802bae` |
| `annotated_C/src/kernel/semaphore/KSemaphoreObtain.c` | `0ff7a97e67ec660db89a59bd3d4c6ece986c1e316801b56ebce49b3c911dee79` |
| `annotated_C/src/kernel/semaphore/_SemaphoreObtain.c` | `0f5012e6e93fbfea6bcadd91db93b54ccb8a2084e880e44f2e8b1291dc0f5621` |
| `annotated_C/src/kernel/semaphore/KSemaphoreAbandon.c` | `1977cd3c60dc36f2f0adfeb259cb055e6e3243e1b3fc228ca0391f29db721eb2` |
| `annotated_C/src/kernel/semaphore/_SemaphoreAbandon.c` | `03e9c32a3e097bb357c43d850aaefb10513df8ef384cb927da1ac755d3f44497` |
| `annotated_C/src/kernel/semaphore/LinklistResume.c` | `3513925998c3c8d6f07f555675f126c25e99ac1b69a81ada113bcff74b02a166` |
| `annotated_C/src/kernel/pendlist/LinklistSuspend.c` | `c5cc6aade00bc4cc0506244233f0ba12e220d1c86227b29534037ff717bc028c` |
| `annotated_C/src/kernel/common/CalculateTickFromTimeMs.c` | `730772d71c1b6f712cdd4a91e5d87266748af08ed5ba12f6c44a6235bb9c4fc2` |
| `annotated_C/src/headers/dataqueue.h` | `58aaf07542723e67c9f4f8cabb8d0c3d696614dec25c73450d0622e17fcccf8c` |
| `annotated_C/src/headers/semaphore_runtime_logic.h` | `73fe7e156ad85e22cce840087a2aa20dd2e6ec3e5f7011e64fbfd31bea50c9a0` |
| `_CoqProject` | `fb1b9bca1cb90b4cf456dcb56bcffb5580faf3530b519702f9eff27c07523380` |

权威源码内容版本（根 `/home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/`，commit 见 context）：

| 文件 | SHA-256 |
|---|---|
| `thread/data_queue.c` | `a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601` |
| `thread/semaphore.c` | `dafd02bf7c6fa5a7324c6e0f824d9a1ddc1544c43f9e71aabeb902d832f30ab8` |
| `thread/linklist.c` | `53eed893164c56e2eee7c4772eacba3d07cd4f31c71c388e326ed57a30103461` |
| `thread/tick.c` | `ddf26d9067e046fc206ea3f15ad117fc23c9bfb0933ada2902a8ada18591771c` |
| `thread/delay.c` | `3d158b413ad0524125680ea91c14fc83c01395b5979b379c1bd80509e75b4976` |
| `thread/ktask.c` | `3bbfd8bd47a40bf5df235575708881f58c8426d6f51cd269015fb496e98ea93a` |
| `include/xs_dataqueue.h` | `fb10a4ae331e8646d0cf26c3302c63d0b199e3bb6562d351a9130aa705454df8` |

## 共享header按需启用（第一阶段窗口兼容修复）

第一阶段恢复时将dataqueue.h新增Pop/Push词汇块置于CRTOS_DATAQUEUE_WITH_OPERATIONS条件下，并在PopDataqueue.c/PushDataqueue.c include前定义该宏。两份C经同参数GCC预处理，忽略空白和新增guard结束注释后，包含formal注解的全部预处理文本与修改前完全相同；规格、body及import不变。Init/DeInit/Peak不再引入无关Pop/Push语义模块，保持已有生成前导。此为非语义include适配，不启动第二阶段workflow，也不把设计审阅改称实现证明。更新文件哈希如下（替代上方同文件旧值）：
- `annotated_C/src/headers/dataqueue.h`：`95fc4e87bb93606957b80da5e6796dee98229b51ff26f68ec5271b0cc5934c79`
- `annotated_C/src/kernel/dataqueue/PopDataqueue.c`：`0466f1d8340af4bb0535f65ac6eca45b5f7ab66f30a29b35ffdcf4c23eb9e569`
- `annotated_C/src/kernel/dataqueue/PushDataqueue.c`：`767436057dcae1d30a979210db1c9e2a76d5f0132f1e2695de8f8252a0fc073e`
