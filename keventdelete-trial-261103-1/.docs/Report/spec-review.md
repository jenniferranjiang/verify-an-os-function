# 完整调用闭包 Spec 独立审阅

结论：**review-passed**。审阅 revision：`keventdelete-spec-r1`，固定文件列表及17项SHA256见 `checks/spec-revision.json`；所依赖 predicate 为已经独立通过的 `keventdelete-predicate-r1`，见 [predicate-review.md](predicate-review.md)。审阅人是独立 `delete_protocol_review` agent，日期2026-11-03；本结论不是C实现证明或QCP验收。

逐项复核17个spec/类型/逻辑文件的实际hash，均与manifest一致；原权威源码及复用contract来源hash仍与 `checks/source-slices/manifest.json` 一致。范围与用户假设依据 [source-errors.md](source-errors.md)，正式行为解释见 [spec-design.md](spec-design.md)。审阅时未修改formal文件。

## 闭包与接口一致性

从适配后的四份完整active正文手工重扫：公开KEventDelete调用FindEventById和_EventDelete；查找调用Lock、IdGetObj、Event CONTAINER_OF和Unlock；内部删除调用Lock、IsEmpty、Unlock、ResumeAll、IdRemoveObj、RmNode、free和调度；ResumeAll调用Lock、Task CONTAINER_OF、KTaskWakeup和Unlock。合计15个symbol，没有裸调用、未解析done分派、未处理的可执行宏或重复归类。

4个本轮新设计目标均有唯一同名canonical文件、完整函数体与With/Require/Ensure。5个reused-spec边界为IdGetObj、IdRemoveObj、IsDoubleLinkListEmpty、DoubleLinkListRmNode、KTaskWakeup；6个模型/API边界为Lock、Unlock、两种CONTAINER_OF、x_free与KTASK_ASSIGN。后11个声明文件不冒充本轮实现证明输入，不递归其已明确边界内的实现。

已逐一核对caller-local声明与所采用canonical的合同：ID high/low规格、IsEmpty的dll规格、RmNode的remove_member、Wakeup的wakeup_by_id_ic、普通及受限Lock、stable Unlock和新Event OC ResumeAll合同一致。原有具名规格没有因本场景而删改含义。附加的 `checks/caller-contract-equality.json` 对人工确认的18条caller/callee边比较去空白后的合同文本，全部相同；它不替代上述手工闭包检查，也不是QCP closure执行。

Event的ResumeAll是新的锁外调用场景，保留自身Lock/Unlock，原Semaphore IC适配及合同不被重写或宣称涵盖Event。后续共享存档应继续保持独立场景选择，不能把它们共同作为一份编译单元的多重定义。通用Wakeup规格已描述Event来源摘链，调用点可从当前pending和任务ID资源推出其参数关联；没有采用错误的Semaphore专用唤醒合同。

## 路径、作用和所有权

公开及查找入口明确要求 `0 <= id < 65536`，与用户批准一致。C接口保持int32及实际uint16调用；范围保证转换不改变值。没有新增“ID必须已登记”前提，容量之外但uint16范围以内仍覆盖正常未命中；源码负数早返回仍保留，只是不属于这份公开spec覆盖范围。

查找未命中时只归还临界区资源并返回，public随即结束，无释放或调度。命中contract只返回最近观察的纯对象关系和OutsideCritical，不把裸地址当作共享内存权限。查空路径在最终删除锁前依赖获批空链保持条件；查非空路径由实际ResumeAll取得锁时的waiting描述批量唤醒及任务/Delay/ready变化。较早非空但之后已空的路径仍执行resched对应调度。公开void返回的continuation与分段program准确连接这些路径，不额外宣称入口与出口所有OS分量相等。

IsEmpty的load来自event pending DLL；ResumeAll中的哨兵/队首指针来自该DLL，task.exstatus及task.id来自全局任务资源。写exstatus后恢复整体状态再使用Wakeup通用合同，循环每次重新读取队首。合法pending确保节点对应已登记SUSPEND任务，不能只从链地址凭空推断任务字段。

最终IdRemoveObj返还ID字段和自环ID link，RmNode返还payload和自环管理link；未改options/events/padding及空pending共同组成EventRetired，并从共享不变量中移走。恢复后的os_inv与该私有块分离，私有块跨Unlock由EventRaw交给x_free消费，出口不遗留已释放对象的所有权。每条会退出的路径都正确交还OutsideCritical。NULL检查的非返回分支仍显式存在，在有效资源前提下不可达；没有靠删除非终止路径缩减目标。

## 源码、模型和环境条件

四份active正文逐项对照原始摘录及当前权威函数。done.EventDelete唯一initializer解析为_EventDelete，static外部化、debug删除、CONTAINER_OF类型化及调度模型均有技能/TrustBase依据。Find和ResumeAll原锁及最终删除锁均保留。新增inspect_lock只包围原IsEmpty单次共享读取，结果保存到局部pending_empty后解锁再进入原分支，没有扩展为整个删除事务，也没有应用待议修复补丁。

Event位域按已有TrustBase模型展开为两个uint32，模型大小36字节，真实ILP32对象32字节。TaskDescriptor完整当前配置布局保留；读取字段对应sched_link偏移16、exstatus偏移92、id偏移104。实际切片的GCC静态断言及共享布局接口相互一致，没有把字段偏移20误当成sched_link基址。

具名event_delete_gap Lock合同显式限于本轮用户批准的D1/D2环境。它不是ordinary Lock的可证明特化，原rely=True和普通合同未变。D1是同一allocation在命中至注销期间不被其他操作回收/复用，端点p/id不足以排除ABA；D2只对已经观察或建立的空pending提供保持，不冻结其他状态。该额外可信边界依赖已批准的运行条件，不能移用于任意调用者或宣称源码已修复。其他Event API持有旧裸指针等风险不被本次设计结论覆盖。

## 检查证据与后续界限

15份C输入已通过GCC ILP32语法检查；实际切片ABI静态断言通过。GCC不解析QCP注解，这些结果不被称作QCP语法证明。predicate三文件编译通过，`checks/DesignInterface.v`及日志确认此次注解使用的语义接口类型。注解结构和合同连接已人工检查；未运行QCP parser、symbolic、closure、VC生成或C实现证明。

动态状态、continuation的调用实例化、循环不变式、局部资源拆分与重组属于后续Annotation/实现证明阶段。当前合同明确给出所需参数和作用，已知的sg/id/p/empty以及具名spec选择在调用处绑定；不提前把任意X或错误历史状态填作实例。这些待完成证明注解不改变本次设计目标，也不构成“函数实现已满足规格”的证据。

没有剩余的spec设计blocking项。原源码缺陷仍存在，仅在本轮已批准假设与ID范围下给出设计审阅通过结论；正式实现证明仍未开始。
