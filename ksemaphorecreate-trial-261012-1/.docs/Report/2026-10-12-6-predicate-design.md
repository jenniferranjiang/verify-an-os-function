本正式设计记录对应已接受并激活的 predicate-nonzero-candidate-fe8c4261db5c。独立审阅见 [predicate review](2026-10-12-6-predicate-review.md)，随后spec也已通过 [单独review](2026-10-12-4-spec-review.md)。以下为审阅时冻结设计说明；其中“候选尚未激活/等待审阅”描述提交时状态，原文及hash保留在 evidence/nonzero-candidate/design.md。五个旧done函数现已通过新revision完整终检；InsertObj及后三函数的实现证明仍在继续。

# 非零对象地址表示候选

当前候选修正完整 C 对象的地址表示，尚未激活，也不把旧机器结果自动迁移到新 revision。新增地址事实从用户已批准的完整对象生命周期边界和权威静态声明开始；它们不是从旧的抽象字段/字节 ownership 推出的定理。候选作者不担任 reviewer，最终语义等价及来源闭合由独立 reviewer 判定。

基线为 source-r2-0c50c37013e9、predicate-r5-0a139d64743c、spec-r4-9f3ebc915b99。读取边界仅为本 trial、根 lib、真实源码、skill 和官方 QCP；没有读取、搜索或导入其他 CRTOS trial。20 个原 formal sources 被复制到本目录；只有此候选的 idnode.v、SemaphoreRep.v 发生表示变化，新增 SemaphoreInitialization.v。根 lib、active formal、C、spec、VC/proof/controller 和 accepted manifest 均未更改。

## 为什么需要改变表示

冻结的 BSS bucket 只有两个零值指针槽，允许 head 为零；detached IdNode 只有三个字段槽，不能推出另一个抽象表达式表示的 link 非零。这与真实 C 完整数组元素及内嵌子对象的地址域不符。initialized DLL 已经要求 head/node 非零，因此删去中间 Assert 不能解决问题。

官方 `Rocq/SeparationLogic/CNotation.v` 的 `eval_addr_expr`、`sizeof_alias_type` 是既有全局 Parameter。`CNotationSig` 仅参数化 `CArchSig`，没有可注入的 struct/field layout 表。`addr_of_arrow_field` 只给 dot/arrow 等价，`addr_of_arrow_field_inv` 给注入性，`addr_of_LE_var_not_zero` 只说明具名全局地址非零；这些接口不能充当本次 ABI 等式。官方 convex_hull 示例用新增 `Axiom sizeof_point`，本任务没有采用。CandidateChecks 中两个 Fail Definition 只检查缺乏定义计算，不能当作逻辑不可证性证明。

## 源事实与定义对应

所有路径以下均相对于 `/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro`。

| 事实 | 权威来源及 ABI 证据 | 候选所在处 |
|---|---|---|
| malloc 成功交出一个完整32字节 Semaphore，基址非零；id 子对象、id.link、pend_list、link 均位于该对象内 | `kernel/thread/semaphore.c:_SemaphoreCreate` 检查分配并以 sizeof(struct Semaphore) 零化；`kernel/include/xs_sem.h:struct Semaphore`、`xs_id.h:struct IdNode`；本 trial `evidence/source-abi.c` 已验证 id=0、id.link=4、pend=16、link=24、size=32 | `semaphore_object_addresses`；`store_sem_allocated` 从生命周期起点携带 metadata，同时原样拥有32-byte undef array |
| memset 只改变对象字节，不改变基址和子对象地址 | 同上，真实调用 `memset(sem,0,sizeof(struct Semaphore))`；user-request.txt 已批准完整对象零化 | `store_sem_zeroed_private` 保持同一 metadata；ID三个字段、value、pend/link各两个槽和两段padding完全保留 |
| generic IdNode 的本体及 link 非零 | `xs_id.h:struct IdNode`、`id.c:InsertObj` 把 `&idnode->link` 交给链表原语 | `store_sem_id_detached`；只加纯地址事实，不改变id/prev/next原值或ownership |
| detached pending/registry 节点本体非零 | `semaphore.c` 对 `&sem->pend_list` 初始化并插入 `&sem->link` | `store_sem_link_detached`；metadata取自完整对象，不取自零槽 |
| 16个 BSS bucket 各为有效数组元素，两个槽初值为零 | `xs_id.h:DECLARE_ID_MANAGER` 声明真实 `DoubleLinklistType[16]`；`semaphore.c` 宏调用；已固定 ID_NUM_MAX=128/ID_HTABLE_SIZE=16 | `store_semaphore_static_initial` 明确携带所有 index∈[0,16) 的对象地址有效性；raw资源使用 `store_sem_static_bucket_at` |
| k_sem_list 为非零全局对象并初始化成自环 | `semaphore.c:k_sem_list = {&k_sem_list,&k_sem_list}` | static initial 的registry地址事实及两个原始自环槽 |

源 ABI 的 size=8/offset=4 等仅作为 C 映射证据，没有被写成无条件 Rocq 等式。`source_layout_implies_object_addresses` 与 `source_array_layout_implies_bucket_nonzero` 明确保留 ABI 等式为前提，只证明“若有桥则足够”，不是本候选来源链中的额外公理。

本次尝试复跑既有 source-abi 命令时，原 `/tmp/crtos-arm-toolchain/root/usr/bin/arm-none-eabi-gcc` 已不存在，PATH 也无 ARM GCC/clang。因此依赖本 trial 已冻结、已通过的 source-check-result/source-abi 源码与汇编证据，不宣称此次新跑了 ARM 编译。Rocq 使用 pv-bench-8.20.1，不受该临时工具路径消失影响。

## 生命周期及初始化构造

`x_malloc` 的 Require 仍为 size=32/emp，NULL 分支仍为 emp；成功分支“完整Semaphore对象”的表示修正为 raw32字节加子对象地址metadata。这不是把 memset 增强成制造新的地址事实。memset 入/出使用同一对象地址，保持metadata，只把全部字节零化。`allocated_full_bytes` 检查候选依旧蕴含原有完整32-byte资源。

零私有对象通过 `zeroed_split_id` 拆成 ID node 和 `store_sem_registered_private`，后者保存 value、pend、registry link、padding 与纯metadata。ID失败返回同一 id/prev/next，`zeroed_failure_rejoin` 重建完整零私有对象交给原 x_free contract；没有丢弃padding或额外资源。成功时ID字段交给manager，pending头仍归对象本体，registry link交给registry；metadata中的各项正好支持这些已有容器的非零条件。发布顺序、最小空闲ID、返回码、临界区与IRQ语义不变。

字节划分保持为：id.id [0,2)，padding [2,4)，id.link [4,12)，value [12,14)，padding [14,16)，pend [16,24)，registry link [24,32)。纯metadata不拥有字节。此划分依赖已经审阅的C/ABI映射；没有声称能从当前opaque `eval_addr_expr` 单独证明空间字段重新拼成raw CharArray32。

静态初始化没有把新 `store_uninit_idbucket` 直接放进输入后宣称完成。输入列出真实声明提供的地址metadata、manager字段、bitmap零字节、16元素数组的raw零槽及registry自环槽。`static_bucket_array_build` 对全部元素归纳构造 BSS bucket owner；`static_empty_id_map` 和 `static_empty_buckets` 检查派生纯状态；`semaphore_static_initial_build` 把上述来源输入实际构造为 `store_semaphore sg []`。该模块heap经现有OSHeap接口进入SemaphoreOSInvariant；task/scheduler借用部分和其既有初始化来源不因本次地址修正改变。

## 信任及审阅边界

新增metadata不与旧raw-bytes predicate在Rocq中逻辑等价：旧模型允许并非真实完整C对象的抽象地址组合。本次主张的是忠于用户已批准的完整typed-object/静态数组语义的representation修正。必须由独立review确认这种修正没有实质扩大六个trusted symbols的实际保证；不能仅因候选编译通过就认定这一点。没有新增 Axiom/Parameter/Admitted/admit。扫描中唯一 Parameter 是从基线逐字复制的 Module Type 字段 `NestedCriticalSTS.nested_critical_STS_def.nc_sts`，不是新公理；新构造证明的 Print Assumptions 仅含既有 eval/sizeof 与标准外延性。没有修改既有框架求值器或导入不兼容默认Coq。

候选manifest及检查日志均限定在本目录。各机器检查只说明新candidate的类型/引理正确性，不说明C实现或现有VC已证明。

## 影响与重跑

表示改动的语义closure包括 AllocId（保留manager）、InsertObj、IdInsertObj、_SemaphoreCreate、KSemaphoreCreate、static initialization，以及 memset/x_malloc/x_free 所引用对象predicate的解释。canonical及caller-local contracts必须按同一revision重查。CriticalAreaLock/UnLock经OS invariant依赖新representation，虽然nest/IRQ规则未变，也要重新编译并进行goal-check/终检。DoubleLinkListInsertNodeAfter/InitDoubleLinkList的正文和contract未变，但它们既有终检绑定旧formal revision，不能直接搬运成新revision结论；至少按controller新的dependency binding重新检查。

五个已终检函数的旧机器结果仍是旧revision证据。此次没有执行QCP/controller，也没有重生成、删除、弱化或证明任何VC；InsertObj三个失败VC需要候选独立通过并由main激活后回到annotation-r2继续处理。

## 固定候选及机械结果

正式revision为 `predicate-nonzero-candidate-fe8c4261db5c`，见 candidate-manifest.json；21个正式文件与 CandidateChecks.v 共22个文件全量编译成功（coqc pv-bench-8.20.1），总耗时 119.964 秒。SemaphoreInitialization 的4条构造引理及 CandidateChecks 的11条检查均Qed；后者含2条明确条件式ABI说明引理，不作无条件来源。active-unchanged.json 确认原20个formal文件和active _CoqProject hashes完全不变。trust-scan.json区分唯一继承Module Type字段与新增代码，introduced_forbidden_tokens为空。源码ABI临时工具不可用情况见source-abi-recheck.json。

作者已停止修改，候选等待独立predicate review；不因这一状态使spec自动通过，也没有执行controller或激活候选。
