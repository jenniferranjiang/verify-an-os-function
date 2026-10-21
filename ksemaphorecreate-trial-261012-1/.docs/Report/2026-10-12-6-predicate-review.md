本轮 predicate delta review 结论为 **review-passed**。完整对象的地址有效性现在从分配或静态声明的来源边界携带，BSS bucket 与 detached 子对象的非零事实不再留给下游凭空证明。初始化构造、完整私有对象拆合及独立全量编译通过，没有剩余 predicate blocker。该修改保持用户已批准的完整 C 对象语义，按第八节一次性授权可以接受此 predicate revision，无需新增用户决定；spec 仍须随后单独审阅，当前 C/VC/proof 尚未因此完成。

审阅对象是冻结的 **predicate-nonzero-candidate-fe8c4261db5c**，`evidence/nonzero-candidate/candidate-manifest.json` SHA-256 为 **fe8c4261db5cff754395f3d9038769b3e50420d542347262a831aa3ce6a422b3**，共21个正式文件。设计记录为同目录 `design.md`，SHA-256 **d275e8a9db35b38786b1aa1a7847cda7ae7bee0300f818401a8eca548566572d**；检查文件为 `CandidateChecks.v`，SHA-256 **1c282dca3bfc4101fd307dae54e0c935ed737d60c29307ef321164f28f245bdc**。作者为 `nonzero_predicate_author`，本独立 reviewer 为 `nonzero_source_review`。依据仍为 source-r2-0c50c37013e9、Cortex-M3 ILP32 little-endian 非 SMP，以及用户既有完整对象、行为、嵌套调用域和六 trusted 边界。

本轮针对 [DCHG-20261012-03](design-changes/2026-10-12-3-object-address-validity.md) 做 delta review：相对 r5，18个正式文件逐字相同；改动为 trial 的 `shared-candidate/arm32le/idnode.v`、`lib/SemaphoreRep.v`，新增 `lib/SemaphoreInitialization.v`。检查了变化全文、直接与传递依赖、初始化及生命周期来源；未重新打开 r5 中与此次地址表示无关的协议/ABI结论。前置来源审计及官方接口证据见 [source-and-framework-boundary.md](../../evidence/nonzero-review/source-and-framework-boundary.md)。当前权威47个 source/config文件逐一 hash 匹配接受的manifest，原20个active formal也未变。没有读取或依赖其他 trial，没有改动根 lib、真实 C、active formal、canonical、VC/proof、controller 或作者冻结候选。

**表示语义与 trust 判断。** 新谓词是旧 Rocq raw-byte/field 表示的逻辑加强，不能称为 alpha-equivalent、旧新 Rocq 等价或已证明 ABI bridge。官方 `eval_addr_expr`/alias-size 仍抽象；源码 ARM ABI 检查不被冒充为这些符号的无条件等式。接受依据是用户原已批准“完整32-byte semaphore对象”与真实静态数组的 C 语义：对象内的 id、id.link、pend_list、link 是有效非空子对象，BSS 两个零值槽属于有效 bucket 对象。新增 conjunct 排除旧表示误允许的非 C 对象组合，没有排除任何批准域内的真实完整对象。原 C/config未变，因此既有 ARM probe仍适用；此次未宣称重跑已消失临时工具路径下的 ARM 编译。

`semaphore_object_addresses` 只列本体及这四个被访问子对象的非零地址，不加新状态、heap owner、token、字段值或行为。`store_sem_allocated` 保留原32-byte undef array；zeroed、detached、registered-private各层携带对应 metadata。BSS `store_uninit_idbucket` 增加本体非零，`store_idbucket_cases` 在 BSS 分支导出它；initialized分支的DLL非零域保持。没有利用抽象字段 ownership 或 `isvalidptr` 推出非零；独立前置probe已证明后者允许零。

对六 trusted 边界的 predicate 语义影响如下；这是表示含义审计，不替代下一轮 canonical/caller-local spec 一致性审阅。

| trusted symbol | 判断 |
|---|---|
| x_malloc | Require仍为size=32/emp，失败仍为NULL/emp；成功的完整Semaphore对象从生命周期起点携带其自身及子对象地址metadata，并交出原完整32字节。没有额外caller条件或新对象保证。 |
| memset | 入参和返回dest保持，value=0/size=32保持；同一metadata在allocated与zeroed两端明确相同，零化只更新字节。原由trusted完整零化契约承担的raw-to-fields解释没有扩大为新布局公理。 |
| x_free | 仍消费完整已清零、未发布对象并返回emp；新Require中的metadata是该完整对象固有地址解释。ID失败返还资源可精确重组，不要求额外资源或调用者证明无来源条件。 |
| DisableLocalInterrupt | 协议、handler、Rely和outside→inside转换未变；取得的同一个OS invariant使用修正后的真实对象表示，不创建对象或metadata。静态来源与后续操作维持该invariant。 |
| EnableLocalInterrupt | handler、Guarantee、inside/invariant→outside转换未变，交还同一完整invariant；没有改变IRQ状态或 ownership transfer。 |
| KPrintf | emp→emp未变，与新增predicate无资源依赖。 |

**生命周期与 ownership。** 新纯事实不拥有任何字节，重复携带它们不会复制资源。ID仍占id字段及两个link槽，两个padding仍分别占[2,4)、[14,16)，value、pending及registry link的旧划分保持，完整32字节无新增/遗漏owner。`zeroed_split_id` 实际证明将零私有对象拆成同一detached ID及registered-private余部；`zeroed_failure_rejoin` 反向合并同一id/prev/next零值及余部，恢复free入口。allocated_full_bytes确认未用纯metadata替代分配块。

成功路径的ID ownership转交manager后，registered-private保留 pending/registry 非零事实及原字段/padding，支持后续初始化和插入；published manager/DLL/body本已携带对应非零域。新增事实不改变最小空闲ID、返回值、value、pending内容、registry/bucket次序或发布时机。退休表示继承detached/link的有效性，不扩大本目标批准的free contract到正常delete。task/scheduler借用字段、ready/pending节点唯一owner、未触及分量及IRQ token保持；CrtosOSPure、protocol和carrier均hash不变，间接依赖的新invariant组合与临界frame全量重编通过。

**静态初始化实际闭合。** `store_semaphore_static_initial` 明确列出manager四字段、16-byte零bitmap、所有16个bucket的raw零槽，以及registry两个自环槽。地址metadata来源是权威 `xs_id.h:DECLARE_ID_MANAGER` 创建的真实数组元素及 `semaphore.c:k_sem_list` 全局对象，采用相同配置和符号绑定；它不被伪称为raw槽值推论，也没有新增初始化token。新 `static_bucket_array_build` 对全部元素归纳转交raw槽到BSS表示；两个empty-state引理核验bitmap及bucket抽象内容；`semaphore_static_initial_build` 最终实际构造 `store_semaphore sg []`。因此来源声明与Rocq资源构造两层均明确，先前缺口没有仅前移到未说明的入口。该lemma是模块heap初始化，不冒充整个OS启动证明；不变的task/scheduler来源和OSHeap组合仍按既有review边界处理。

**独立机器检查。** reviewer把21个manifest源码及CandidateChecks复制到 `evidence/nonzero-review/independent-build/`，重写本地load path，仅使用官方QCP及该隔离快照；没有复用作者.vo。指定 `/home/xinra/.opam/pv-bench-8.20.1/bin/coqc` 全量22文件全部exit 0，机械耗时 **118.636秒**。manifest逐项hash、delivery artifacts hash、18个未变文件及active源码保护检查均通过。复现脚本为 `evidence/nonzero-review/review_checks.py`；结果为 `independent-checks.json`，另有 `source-current-check.json`、`boundary-checks.json`。

去注释扫描全部formal与检查文件无新增Axiom、Parameter、Admitted、admit或Abort。唯一保留Parameter是基线逐字不变的官方Module Type字段。初始化构造及11条检查的assumptions仅出现已有CNotation地址/sizeof参数和标准函数/命题外延性；两个带ABI等式前提的说明lemma未作为无条件来源使用，两个Fail检查仅说明没有定义归约。没有新增用户公理、未证明占位或generated-auto依赖。

本轮关闭了BSS bucket与detached ID非零表示缺项，以及相同类型的pending/registry来源风险；上述官方布局接口限制仍被明确保留为模型边界，不称为已实现的布局证明。没有尚需修复的predicate issue。r5/spec-r4的历史invalidated记录不撤销，旧成功proof仍仅属于旧revision。main可接受本候选并绑定新active predicate manifest；随后必须单独固定并审阅受影响spec，再按controller重走InsertObj annotation及受影响VC/proof/goal-check/final integrity。此处不作spec review-passed、VC完成或最终verified声明。
