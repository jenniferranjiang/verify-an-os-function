# Predicate 独立审阅

结论：**review-passed**。审阅对象为 P1，`checks/predicate-manifest.sha256` 的 SHA-256 为 `cf17462f93b883ac756270977ee6484c105d16260bc9507c7fb1fac6697aff52`；该清单冻结 13 个 `lib/*.v` 和 `_CoqProject`。审阅者为独立 reviewer agent，作者为 predicate design agent。本结论只认可设计与类型检查，不表示 C 实现已经证明。

审阅依据为当前权威源码 `Ubiquitous/XiZi_IIoT_Macro/`、stm32f103-nano 配置、[源码分析](source-analysis.md)、[predicate 设计](predicate-design.md)、本次布局编译证据以及当前根共享库。逐项核对清单哈希与正式文件一致；查看新定义完整内容及根共享候选差异，确认全部 13 个模块的最终编译日志 `checks/predicate-compile.log` 完整通过，两个外层/嵌套 `safeExec` 接口类型成立。九个 vendor 文件已逐一与当前 QCP Rocq 源文件作字节比较，完全相同；load path 仅含本 trial 和指定 QCP 库。

`SemaphoreInv.v` 对私有分配、完整清零、ID 已登记、待发布和稳定登记阶段给出不同所有权。结合当前 32 字节 ABI，ID manager 获得 id 字段及 id.link，全局链获得 link，map 获得 value、pend_list、等待 sched_link 和两段 padding；没有重复或漏掉创建路径访问的字节。清零失败对象保留全部 32 字节并尚未发布，能支持批准的 x_free 边界。QCP 当前 struct_padding 为 emp，因此显式 padding owner 有依据。底层 DLL/ID 表示直接复用共享定义及现有引理；没有增加 semaphore 专用链表或 task 副本。

唯一对象 map 保存 ID、value 和 pending task 地址；ID manager 的列表和桶从 map/管理链派生。当前源码的两处头插及删除保持次序支持该派生。全局管理链和 map 双向覆盖，已登记对象必须存在；ID 唯一性沿用共享 ID 表示，不额外加入经验性 NoDup。空桶的未初始化零指针与已初始化空链两种形态仍存在。静态初始资源的常量、数组和自环哨兵有当前源码依据；其折叠证明尚未执行，不作为已证引理使用。

`CrtosRules.v` 将 PRIMASK 与全局临界状态放在一个真实 STS carrier 中。锁 token 与 IRQ token 分开持有且不能复制；IRQ 断言明确约束真实位。草案阶段发现 QCP has_tokens 的 empty 观察会被分离合成的交集吸收，作者已在同一 carrier 用 owns_tokens 的 full 中性观察修正；最终版本不再丢失 mask。环境转换只在 outside/PRIMASK=0；已持锁时不会再次取出共享资源。外层保存位 0/1 和嵌套保存位 1 均有接口，未排除 data_queue.c 中真实嵌套调用。uint16 计数与逻辑锁身份分开，65535→0→0 的实际路径保留。所有空间谓词使用 Arch32/LittleEndian。

`KSemaphoreCreate.v` 的具名操作保留 malloc 失败、ID 耗尽和成功发布：成功得到最小空闲 ID，value 使用输入，等待链为空，更新只替换 semaphore 分量；其他全局抽象分量保持。嵌套操作不引入环境观察，并单独记录计数是否经历一次 lock/unlock。外层沿用全局 rely 的状态集合模型。`slice_OS_inv` 明确只拥有本 slice 的完整 semaphore 模块与临界计数，未宣称拥有所有 OS 内存。

本 trial 没有新 Axiom、Parameter、Admitted 或占位定义。StructFieldOffsetAxiom 候选移除旧布局公理；现有 QCP 库的符号寻址接口与基础假设仍是框架依赖，不能据此宣称整个依赖无公理。raw32 与字段地址的对应本次通过当前 C 类型及布局检查审阅，尚未形成 Rocq 桥接证明；后续前端必须采用同一已核对类型环境，不能更换布局。初始化折叠、发布派生状态等实现证明义务保留为待证，不影响本次完整定义的设计结论。共享候选尚未覆盖根 lib，根其他模块不因此取得兼容性或验证结论。

**隔离执行偏差：** reviewer 在定位 QCP 框架源码时误执行过一次 `/home/xinra` 范围的文件名枚举，输出包含历史 trial 下 NestedCriticalSTS 文件路径。这违反了用户禁止搜索旧 trial 的要求。没有打开或读取这些旧文件内容，也未将这些路径或旧结论用于本次设计/审阅；随后全部读取和搜索限定到明确白名单。不能声称本轮全过程没有遍历到旧 trial。此偏差不改变上述代码审阅证据的来源，但必须向用户披露。
