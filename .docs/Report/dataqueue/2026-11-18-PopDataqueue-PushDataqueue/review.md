> 2026-11-21 更新：Dataqueue 已改为有效元素列表，本文旧 Dataqueue predicate/spec/实现结论不适用于新输入。Init、DeInit、Peak、Pop 的旧表示证明需重新适配；历史记录保留。见 [本轮设计与验证范围](../2026-11-21-FifoRepresentation/design.md)。

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

## 实现阶段 continuation 提取审阅

Revision `dq-pop-continuations-20261119-r1`：独立作者pop_continuations、只读reviewer pop_continuations_review。predicate适用性review-passed，spec语义保持review-passed。仅在原`lib/dataqueue/KPopDataqueue.v`将inline后续子程序提取为`dataqueue_pop_after_ring`、`dataqueue_pop_after_obtain`、`dataqueue_pop_after_id`，顺序和分支不变；没有新状态/内存predicate/Require/Ensure/假设。作者和reviewer分别将真实修改前body定义为old_abs，运行`forall sg p timeout, abs_pop_dataqueue sg p timeout = old_abs sg p timeout`的`reflexivity; Qed`检查通过。root make KPop.vo通过、KPush.vo有效，.vo保留。旧KPop哈希`64cbfa028585131ce06264e2f7f49ab9ab66a2a90284f0cea54641a70173df34`，新`09b2b12e2d9d3579d91a76736f54ca3a98b4872c72f8638461842a78632481a8`。旧设计语义结论继续适用；实现证明仍由当前Pop workflow完成，不能把定义等价当作实现证明。临时基线和等价检查在记录后清理。

## 运行时共享header宏声明修复

Revision `dq-runtime-align-decl-20261119-r1`，作者runtime_header_fix，独立reviewer runtime_header_review：predicate适用性保持、formal接口/spec语义保持review-passed。`semaphore_delete_logic.h`只将`(ALIGN_SIZE : Z)`移至`#ifndef ALIGN_SIZE`保护的独立Extern，原addr_aligned不变。C宏已存在时避免宏展开产生非法逻辑标识符；无宏时逻辑名称仍恰声明一次。19个配置独立预处理对比和GCC-m32检查均通过，当前9个done函数默认输入的完整formal/executable签名都与真实before相同，既有完成结论不失效。其余runtime caller和旧DeleteOC/ResumeAll仅去掉这一冲突声明，仍需后续QCP验证。旧SHA`dd14a8e4740be56d4eb1efd13430849577717c7f91afdbd2df1450c4da751314`，新`632a83680c45f0e6de840936cdac22867ea0e38efa2f8ee69f4aa34806736a9c`。未改lib/spec语义/VC/adapter/vo，临时检查材料在记录后清理。

## LinklistSuspend实参单次求值拆分

Revision `dq-suspend-id-evaluate-once-20261119-r1`，作者suspend_source_split、独立reviewer suspend_split_review：源码等价、predicate适用性保持、spec未变均review-passed。原`SuspendKTask(task->id.id)`改为局部`int32 suspend_id`接收单次字段读取后调用，供注解在二者之间归还ID字段资源。uint16字段的全部值均精确转换为int32，与原隐式实参转换一致；临时变量不逃逸、非法flag仍在读取前返回、业务次序和完整分支保持。formal注释逐字节不变，独立反向替换可恢复before逐字节相同。before/after GCC-m32及额外-Werror/-Wconversion/-Wsign-conversion检查通过。前SHA`c5cc6aade00bc4cc0506244233f0ba12e220d1c86227b29534037ff717bc028c`，后`e391c650bc5ca4d3e21f93e6bd2673d9258ae666157a4446cd903ac57fd52bf5`；原source哈希不变。未改lib/VC/adapter/vo，实际实现证明仍待QCP完成，临时材料记录后清理。

## LinklistSuspend switch等价降级

Revision `dq-suspend-switch-lowering-20261119-r1`，作者suspend_switch_lower、独立reviewer suspend_switch_review。源码行为等价、predicate适用性保持、冻结spec不变均review-passed。为绕开当前symbolic对switch控制值与Assert局部状态重建的交互，将无fallthrough的case0/case1改为if0/else-if1，仅移除两个case终止break，循环内部break保留。独立核对256个uint8选择一致；flag为非volatile、不赋值、不取址的局部参数，多出的纯比较无可观察效果。两个分支语句、分支前prefix及formal注释逐字节保持，反向变换恢复before，GCC-m32严格检查通过。O2汇编不相同，不宣称机器码相同。前SHA`8cdf179eab14f048d000486e2d6f2dca8c7e0e664715f6d8da5e978ba4612aa3`，后`1493b3d1b8731df0398e3e772521c05e7efca5b9617d5010dfa03459b562f8a1`。此结论只审阅适配delta，不证明当前注解或函数实现；原仓库不改，临时材料记录后清理。

归因补充：后续annotation发现基础与派生spec同时附在body上，引发不同规格入口状态合并；此前switch/Assert局部值错位尚不能归因于switch自身工具缺陷。已审阅if降级仍行为等价，但不声称它是唯一必需修复。将按QCP原生示例把派生合同放前置声明，保留基础合同在唯一body并检查派生蕴含VC；这项组织调整的实际检查另记。

## Obtain continuation提取

Revision `dq-obtain-continuations-20261119-r1`，作者obtain_continuations、独立reviewer obtain_continuations_review：predicate适用性保持、spec语义保持review-passed。仅在`KSemaphoreObtain.v`提取after_assign（原status assertS+atomic read）及after_locked（原sum match，inl return / inr assign再after_assign）。guards、ticks、首次观察和原子操作顺序、错误/阻塞语义完全不变；无新假设/状态/内存predicate/Require/Ensure。作者与reviewer分别检查真实before旧body并以`forall sg id msec,new_abs=old_abs`的`reflexivity;Qed`通过coqc。独立coqdep影响集为KObtain/KPop/KPush三库及Pop/Suspend各4VC。三库编译通过，重VC由main审阅后重编译。旧SHA`7a7047ead49087f8c6c2a6b0edb51ed5bd71bbeb16405ed086481589af0de348`，新`f4b64d091e13008aafaa7c8187828133c413c4bc57d7f1e5d15ccea52b85239a`。未改C/VC或适配层，临时等价检查记录后清理。

## Obtain失败回滚ID单次读取适配

Revision `dq-obtain-wakeup-id-evaluate-once-20261119-r1`，作者obtain_wakeup_split、独立reviewer obtain_wakeup_review：source行为等价、predicate适用性保持、spec未变均review-passed。仅SetDelay失败分支将Wakeup的`task->id.id`实参拆为`int32 wakeup_id`单次读取后原调用，供注解归还字段资源。uint16到int32与原实参隐式转换一致，局部不逃逸、失败路径和调用/解锁/返回顺序不变，完整formal注释逐字保持。独立逆变换恢复before、GCC-m32严格语法与类型范围检查通过。前SHA`d47091d0626b2288ed35ee188e39065c78c5dd1104fbaad3175a3eb9c17661ae`，后`5f545b28081d0579efaedff1eec0a4b507d0addb0d0b562becea9c880abe4661`。原source只读不变，无lib/VC/adapter/vo修改，临时材料记录后清理。

## Obtain复用Delay契约等价逻辑适配

Revision `dq-obtain-delay-condition-20261119-r1`，独立reviewer obtain_delay_or_review：predicate适用性保持、reused-spec语义保持review-passed。原KTaskSetDelay for_null_inactive调用前条件`p=0 OR inactive(p)<>None`被本地注解等价写为`p<>0 -> inactive(p)<>None`，避免QCP把合法null路径错选为必须inactive(0)的分支。独立pure Coq以Z.eq_dec构造证明`forall p:Z,P:Prop,(p=0\/P)<->(p<>0->P)`，coqc exit0，Print Assumptions为Closed under global context；不引入公理。With/空间/Ensure/目标/body保持，逆变换恢复r2-before逐字节；与VRTOS原for_null_inactive完整契约比较，逆转本次逻辑和既有os_tick投影写法后规范化相同。这是语义等价适配，不冒称alpha文本相同。新null wit21保留p=0且只要求条件蕴含，nonnull wit20仍有实际inactive前提；由QCP原生生成107auto/36manual顶层/47split，wit21自动进入auto而非手工移动。旧SHA`762f30b23a83865a159d5e1ab807690985b48d351bcc8c6f899146529a93b5d1`，新`25a380ccbb1cf3c6a08fef37d477821f98030d76b7d8aba5d4859ee4b4844956`。原canonical/外部源码未改，实际函数证明仍待完成。

## LinklistResume参数求值拆分

Revision `dq-resume-id-evaluate-once-20261119-r1`：source作者resume_source_author，独立reviewer resume_source_review，review-passed。唯一变换把KTaskWakeup(task->id.id)改为int32 resume_task_id读取后调用，为归还字段wand后匹配os_inv留出注解点。实际uint16字段到int32局部/形参是原本的无损转换，读取次数、顺序、分支及返回不变。逆变换与真实基线逐字节一致，formal注解全部不变；作者和reviewer独立严格GCC m32语法检查退出0。旧SHA3513925998c3c8d6f07f555675f126c25e99ac1b69a81ada113bcff74b02a166，新SHA74f91fa559b13e817778050b91feeae34a152d03c21a3fd0a8998029c22db712。无新源码缺陷、规格或信任变化；源仓库只读，临时基线记录后清理。

## LinklistResume既有契约导入整理

Revision `dq-resume-reused-contract-20261119-r1`，annotation作者resume_annotation，独立reviewer resume_import_review：predicate适用性保持、spec review-passed。caller仅保留KTaskWakeup实际使用的semaphore_pending_head_ic完整接口，删除未用base/detached声明及该已导入契约的派生标记；名称/With/Require/Ensure与既有LinklistResumeAll.c完全一致，来源SHA29ca9f354357150f450eed11198bff152a258c1611f8a3e3d153330f70a13b05，已有于43a2b34e，并非本轮新增特化。当前目标公开规格、其他注解、可执行tokens均不变；调用实例对应实际队首及其ID，其前提资源依然由本轮VC证明。before SHA c87caa464ec627471a9b181e4e19970b160d879bf6dc1ae9c04917d337d3895e，after86e19c162089c20d3172bf3852a6bcf42285c39f28d6162af064c124b1ee08c6。此整理遵循用户reused-spec边界，不将来源函数体或派生义务声称已证明，也不新增trusted；本次不对既有Obtain已完成结果作无关改写。临时基线在记录后清理。
