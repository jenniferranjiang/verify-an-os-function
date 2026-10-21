# Predicate 独立审阅

审阅对象为 `P-261019-2-r2`，文件及 SHA-256 由
`checks/predicate-revision.json` 固定。独立 reviewer 已逐项重算 25 个文件的
hash，全部一致；未读取任何其他 trial，也未恢复删除的 SemaphoreInv。
当前结论：**review-passed**。r1 的完整检查及 r2 的受影响内容复查均已完成，
没有影响本次设计正确性的未解决问题。

## 初始化问题及本次修复

首次审阅 r1 时，`lib/semaphore.v` 缺少模块静态初始状态和静态内存来源。
权威 `semaphore.c` 中的
`DECLARE_ID_MANAGER` 建立固定 manager、16 个零 bitmap 字节和 16 个零指针对的
bucket；`k_sem_list` 直接初始化为自环。`CriticalArea.c` 的独立计数槽初值为 0。
运行态 `semaphore_inv` 可以表达空模块，但不能用它本身代替这些资源的初始化来源。

r2 的 `semaphore_initial_state`、`semaphore_static_resources` 已按这些初始化器
逐项给出资源；hash 数组使用 QCP `store_array`，与运行态 lazy bucket 形态吻合。
两个具名 initialization obligation 是可类型检查的待证命题，既没有当成公理，
也没有加入运行时 Require。`critical_initial_resources` 包含真实计数槽初值 0；
`critical_bootstrap_package` 需要实际 IRQ 上下文，明确区分系统协议安装与普通
heap entailment，没有从 BSS 零值创造 IRQ 观察或 token。该项已修复。

r2 还移除了候选 StructFieldOffsetAxiom 中 27 个未用历史 ABI 公理，避免把
非 Cortex-M3 的 Task/RISC-V 假设带入本次逻辑；根文件未修改。复查确认只有这
三个文件发生 formal 变化，既有函数接口和操作语义不变，全部传递依赖重编通过。

## 已完成的完整检查

源码依据固定为 `checks/source-hashes.json` 所列 Cortex-M3 ILP32、非 SMP
配置及权威代码；独立核对了创建三条返回路径、ID 分配/插入、DLL 四次写入、
critical 两个 wrapper、NULL trap 和固定 done dispatch。ABI 编译证据为
`checks/abi-compile.txt`：原 headers 与切片同一组偏移断言通过 GCC `-m32`；
这是 ILP32 布局证据，不是 ARM 机器码证明。

检查确认：

- 完整对象的 32 字节在各阶段均有唯一 owner，包括两处实际 padding；ID 字段和
  ID link 在登记后交给 manager，管理 link 在发布后交给 DLL，失败路径仍可重组
  完整全零未发布对象供 free 消费。已有对象与等待 sched_link 保留。
- 模块以一个对象列表为权威状态，ID bitmap 和 hash 成员由它派生；没有重复
  Task 状态、DLL 结构或 done 表。共享 ID/DLL 的算法定义和引理保持，只有不再需要
  的直接协议 imports 被移除。Task、Delay 仅提供未访问的纯类型依赖。
- `semaphore_publish` 逐项保留非 semaphore 全局状态。空间层明确是本闭包的
  `critical_projection`，没有冒称已经建立整个 Cortex-M3 OS 不变量。
- 同一个全局 IRQ 协议表达真实 mask、outer/nested 和原 anchor。NonemptyCSL
  在 carrier 层排除空观察，防止互斥 IRQ 观察经分离交集丢失；mask=1 持有 CPU
  排他 token。进入/退出的 token 守恒和不重叠有编译通过的证明。跨 IRQ 只采用
  当前闭包中状态集合为 full 的 heap frames，不承诺任意不稳定 ghost frame。
- malloc NULL、ID 满、成功分别有非空抽象路径；成功返回最低空 ID 并建立 value
  和空 pend_list，失败释放并保持模块状态。uint16 计数的 65535 回绕到 0 没有
  被无依据前置条件排除。`safeExec` 直接复用当前 QCP 定义。

`checks/predicate-compile.log` 的 16 个候选依赖全部 EXIT 0；8 个 vendor 文件
与白名单 QCP 源逐字一致且编译通过。协议回归检查验证 mask/phase 互斥、masked
精确观察以及四个真实 enter/leave 转换；header 词汇检查只做 Coq 类型检查。
候选 lib/libai 文件没有 Axiom、Parameter、Admitted/admit。当前保存的布局
常量和纯命题不宣称自己已经证明；本次使用的 semaphore 布局由上述 ILP32 编译
核对支持，字节与字段的 Rocq 桥接仍属于后续实现证明义务。

本结论只批准 predicate 设计审阅，spec 仍须独立审阅；未运行 QCP parser、symbolic、VC、orchestrator 或
C 实现证明。设计编译和审阅不等于 KSemaphoreCreate 已得到实现正确性证明。
