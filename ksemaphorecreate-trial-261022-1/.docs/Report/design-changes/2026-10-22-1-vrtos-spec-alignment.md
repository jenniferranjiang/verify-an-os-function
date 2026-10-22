# DCHG-20261022-01：VRTOS 规约对齐与创建函数验证

本 trial 的 `KSemaphoreCreate`（4 个顶层 VC）和 `_SemaphoreCreate`（42 个顶层 VC）已完成模块化实现证明。两个 controller run 均通过完整编译、独立 VC 重生成比对及 final-check，状态为 `done`。结果见 `checks/status.json` 和对应 `reports/<run>/controller_state.json`。

## 规约与资源衔接

九个选定 VRTOS 接口的 16 处 canonical/caller 声明保持匹配，依据是 `checks/vrtos-spec-comparison.json` 与固定的 header 快照。两个创建函数公开规约不变，保留入口 `by local` 范围证明。新增局部注解仅用于资源展开与调用参数实例化。

`x_malloc` / `memset` 的字节数组通过 `SemaphoreByteLayout.v` 中已证明的条件引理转换成字段资源。经用户明确批准的字段布局前提参照 LiteOS 放在 `shared_candidates/SemaphoreInv.v` 内存谓词之前，不另建 `SemaphoreABI.v`。真实/切片头文件的 GCC ILP32 检查见 `checks/abi-current.json`；该检查不等于 Rocq 布局证明，也不声称完成 ARM 交叉编译。

ID 插入失败后只保留未知值所有权，由 `SemaphoreOwnership.v` 重组为 `SemaphoreRaw`。释放接口采用既有 trusted KERNEL_FREE 宏目标下的 `SemaphoreRaw -> emp`，不声称这是已找到的 VRTOS 对应接口或本轮重证的实现；调用使用本次分配的原始基址与完整对象资源。

泛型链表插入的纯序列结果、ID 满和最小空闲 ID 的衔接由 `SemaphoreSpecBridge.v` 中的引理证明。插入成功后恢复系统不变量、失败路径资源回收以及三条返回路径均已纳入当前 VC 证明。

## 验证依据与边界

源码一致性与 caller/callee 规约核对在注解接纳后通过，见 `checks/design-audit.json`；后续仅修改允许的 proof/helper，C 与冻结模型未改动。受影响 predicate/spec 审阅结果见 `checks/integration-review.json`。复用 controller final-check 作为最终证明检查，不额外重复运行 raw 编译。

本轮按用户选择只证明两个创建函数，依赖所选小函数规约，不声明整个调用闭包已验证。当前 LittleEndian 断言及全局状态模型与 VRTOS 不同，未声称完成跨模型 helper 实现证明迁移。布局假设和分配/释放来源的信任边界显式保留。旧 `261019-3` trial 与 VRTOS 来源目录保持不变，旧完成记录未当作本轮证明结果。

## 时间

用户要求的新计时段：北京时间 2026-10-22 19:20:57 至最终检查完成的 20:03:43，共 42 分 46 秒，包括编译等待。本轮总历时约 1 小时 48 分 57 秒，早先停顿无法精确扣除。机器可读记录见 `checks/implementation-timing.json`；并行任务时长不相加。
