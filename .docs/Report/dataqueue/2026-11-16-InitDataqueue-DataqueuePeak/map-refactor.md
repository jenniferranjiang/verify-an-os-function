> 当前恢复说明：用户已授权具体DataQueue/DataElem布局事实，已接入dataqueue_layout_abi；下文旧ABI缺失记录是历史阻塞。当前正在map版本重编译与验证，尚无新的实现完成结论。

# Dataqueue 地址map改造

当前修订：`dq-map-20261117-r1`；用户明确授权设计变更，未授权ABI信任例外。本轮为设计改造与受影响依赖检查，不启动QCP实现workflow。

设计含义及变更范围见 [design.md](design.md) 末节。关键正式输入：[DataqueueState.v](../../../../lib/dataqueue/DataqueueState.v)、[DataqueueInv.v](../../../../lib/common/DataqueueInv.v)、[KInitDataqueue.v](../../../../lib/dataqueue/KInitDataqueue.v)、[KDeInitDataqueue.v](../../../../lib/dataqueue/KDeInitDataqueue.v)、[KDataqueuePeak.v](../../../../lib/dataqueue/KDataqueuePeak.v)。全局原CrtosInv和SemaphoreDelete quiescent同步，未引入第二套OS状态或对象列表。

借出接口保留全部map条目的ready/semaphore纯条件，借出key的唯一空间资源留在store_dataqueue，其他条目由store_map_missing_i持有；合回可更新该key并恢复完整不变量。发布要求旧key为空，其他key保持。map key承担对象地址，因此value不重复保存dq_addr。

原r1列表设计审阅和Init生成VC对当前输入均已invalidated，保留历史与恢复状态；未修改generated goal/auto/check/manual。此前ABI布局缺口仍存在；不以编译或迁移审阅通过宣称实现证明完成。

当前检查：三个Dataqueue canonical剥除注释与空白后，与本轮修改前的可执行C完全相同；gcc -m32 -fsyntax-only均通过。Init内导入DeInit的init_cleanup和canonical同步为相同store_dataqueue(p_queue,q)及显式地址program参数。独立reviewer完成源码/资源/接口检查，最终依赖编译已通过。

## 经验条目建议（供讨论，尚未修改skill正文）

建议修订predicate-experience第4条，补充：对于以地址定位、分散存放且需要跨调用记录发布状态的对象，可以用partial function `addr -> option ObjectAbs`作为已发布对象的权威状态，并用`store_map store_object`拥有对应内存；不要求C中存在指针表或全局管理链。对象自身地址放在map key，value记录其状态；对象内部指针仍保留。`M p=Some v`是纯lookup事实，访问权限必须由store_map拆出。未发布对象局部持有，成功发布时移交资源；撤回与内存释放分别描述。连续数组仍用store_array，实际链表的顺序和链指针仍用链表谓词；map不替代这些物理结构，也不证明地址跨释放复用的身份稳定性。

“优先按地址map组织已发布动态对象”应是带条件的经验，而不是“所有malloc内存都用map”。DataQueue结构由caller提供，只有数组由Init malloc；map的含义是共享发布与权威状态，不是分配来源。

## 相对本轮真实工作树的阶段性lib增量

包括注释和空行；不使用HEAD作为基线，不计以前未提交的内容。没有新增实现证明或manual手写证明；原VC未改。本表用于设计改造记录。

| 文件 | 新增 | 删除 | 净增 |
| --- | --- | --- | --- |
| `lib/common/CrtosInv.v` | +9 | -8 | +1 |
| `lib/common/DataqueueInv.v` | +30 | -25 | +5 |
| `lib/dataqueue/DataqueueState.v` | +31 | -25 | +6 |
| `lib/dataqueue/KDataqueuePeak.v` | +6 | -6 | +0 |
| `lib/dataqueue/KDeInitDataqueue.v` | +8 | -8 | +0 |
| `lib/dataqueue/KInitDataqueue.v` | +10 | -9 | +1 |
| `lib/semaphore/KSemaphoreDelete.v` | +1 | -1 | +0 |

最终依赖检查：全部64份lib目标经根Makefile.coq构建exit0，相关.vo已刷新并保留。未重编译已invalidated的旧Init VC，也不将旧其他模块VC认证为通过。

冻结输入：64份lib联合摘要 `884788a6a7b74366e6df9379267e80f750452ad6d51de816f161c3129c2288f0`；7份C按路径排序后接2份header摘要 `051173e125a9eeb74f3690da4530d9c33d4d6cfba618197569bb390216dc3992`。摘要算法沿用每项“相对路径 SHA256\n”拼接再取SHA256。

## 独立审阅结论

Reviewer：map_review（只读、未参与设计修改）。Predicate `dq-predicate-map-20261117-r1`：review-passed（本轮map迁移范围）。Spec `dq-spec-map-20261117-r1`：review-passed，固定上述predicate版本。检查包括完整对象资源、lookup/发布/撤回与其他key frame、split保留纯wf、DeInit导入与canonical一致、Peak观察与输出资源，以及SemaphoreDelete无引用条件。默认白名单001继续仅用于既有assertS设计条件；不免除任何VC。

全部64份lib根构建exit0、三个Dataqueue canonical ILP32 GCC检查通过，独立可执行C对比相等。未发现本轮新增资源遗漏、重复所有权、接口不一致或信任扩大。此结论不是实现证明通过，也不解决既存ABI布局连接问题。没有启动新的QCP workflow，旧run/VC继续保留为invalidated历史。

## 继续验证时的ABI复核

用户要求继续验证map版本，视为确认当前已审阅map revisions并授权实现验证；未视为新增ABI公理授权。重新核对64份lib摘要与本报告冻结值一致。针对当前canonical dataqueue.h实际类型，以gcc -m32 -std=c11 -ffreestanding -nostdinc -fsyntax-only编译_Static_assert，验证两个sizeof、两个_Alignof及八个__builtin_offsetof，全部通过：DataQueueType大小20/对齐4，front/rear/max_len/base/sem_blank/sem_data偏移0/2/4/8/12/16；DataElemType大小8/对齐4，data/length偏移0/4。

这给出了真实C ABI检查结果，尚未连接到Rocq不透明sizeof_alias_type/字段地址接口。检查当前controller和Verification支持代码未找到自动提供此连接的机制；既有EventLayoutABI使用显式布局公理，不能自动扩大到Dataqueue。本次未新增Axiom、未修改Require、未重生成VC，也未以重复启动workflow掩盖既存阻塞。待决定是否授权仅针对上述类型的布局事实；字节到字段、数组拆合、map发布与全部实现VC仍须证明。

## ABI授权后的验证恢复

用户已确认按原第一阶段、再Pop、再Push继续，并授权类似本次有依据的修改。DataqueueInv新增唯一具体ABI公理dataqueue_layout_abi，内容严格为既有dataqueue_layout陈述（两个sizeof及八个字段地址偏移），依据当前ILP32 GCC静态断言检查。此授权不把任何资源拆合、map操作或函数效果当作公理。TrustBase用户文件不修改，既有IRQ边界保持。map设计与canonical契约含义不变；布局缺失的阻塞已补入正式输入，实际VC是否通过仍由新workflow检查。

ABI增量独立审阅：map_review确认predicate/spec均review-passed，版本map-abi-20261117-r1；KInit/KPeak及传递依赖根构建exit0。正式契约含义不变，只有明确布局事实获准接入。新实现run为[InitDataqueue-20261117224043](../../../../reports/InitDataqueue-20261117224043/controller_state.json)，旧列表run不恢复。Init每函数100分钟预算保守继承已用15分钟，余85分钟；环境配置修复不计。

map-abi-20261117-r1全局lib摘要：`6f03c2c1f4d3e227742de916ee2a3632961090eed5513d89804e1107c3f76532`。新run annotation已accepted、依赖准备passed，进入VC-checking；尚无实现证明完成。
