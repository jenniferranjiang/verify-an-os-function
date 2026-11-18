> 当前恢复说明：用户已授权具体DataQueue/DataElem布局事实，已接入dataqueue_layout_abi；下文旧ABI缺失记录是历史阻塞。当前正在map版本重编译与验证，尚无新的实现完成结论。

> **2026-11-17 当前变更：** 用户已授权地址map改造，本文r1列表版本及旧Init VC适用性已invalidated；历史证据保留。当前设计与迁移检查见 [map-refactor.md](map-refactor.md)。ABI布局连接缺口仍待解决。

# 当前 Predicate 审阅

- Revision：`dq-predicate-crtoslatest-20261116-r1`。
- 结论：**review-passed（当前七函数实验的 predicate 设计）**；不是实现证明或通用 OC 契约认证。
- Reviewer：独立 C analysis / predicate reviewer；未修改 formal 或 C，未运行 QCP。
- 输入：`lib/` 全部 64 个 `.v`，按工程相对路径排序，将每项 `path sha256\n` 拼接后计算 SHA-256：`61159901adf3504b7349629579a8aae45cd8ab222b12b9ffa404bb3e32734d7b`。
- 源码依据：crtoslatest `a07641a0b58469ae3ea19317cce2cf48974989bb`；适用非 SMP、100Hz、未启用 `KERNEL_DEFER_IPC_SCHED` / `KERNEL_STATIC_OBJECTS` 的当前实验配置。

## 本轮变化与复查

相对本轮修改前快照，64 个输入中只有 `lib/semaphore/SemaphoreOps.v` 和 `lib/semaphore/KSemaphoreDelete.v` 改变；其余 62 个保持字节一致。本次依 skill 只复查变化和受影响接口，原 native carrier、完整对象 ownership、模块 state 集成及生命周期审阅见 [整合记录](integration-review.md)。作者报告 64 个 lib 全部通过类型检查；本 reviewer 未重复编译，也未将类型检查当作引理证明。

`semaphore_id_invalid` 精确表达新源码 `SemIdInvalid` 的 `id < 0 || id > UINT16_MAX`。`semaphore_query_id` 仍保留通用 uint16 转换；公开 Delete 的抽象 program 在原子操作之前检查完整 ID，非法输入直接返回，故 65536 不再别名到 ID 0。128..65535 并未被错误地视为表示越界，仍由实际 ID lookup 决定是否存在。

IC effect 对非法输入要求 `after = before`；有效输入保留 lookup-miss 或准确注销所查对象的原行为。quiescent 条件只对 0..65535 的输入要求 pending 为空及无已发布 dataqueue 引用；无效输入不再被错误地要求其低 16 位对象满足这些条件。有效路径原有资源回收、其他模块 frame 与对象关联要求未削弱。没有新增 Axiom、Admitted 或信任边界。

Init/DeInit/Peak 删除旧 `NULL_PARAM_CHECK` 非空保证模型符合新宏只做日志/计数的语义。访问权限仍来自原资源：Init 的 `DataqueueStorage` 显式拥有非零、对齐的完整 20 字节；DeInit 的参数与 `dataqueue_owned` 对象地址相等，并拥有完整结构及数组；Peak 在锁内从 `os_inv` 中所观察到的 queue 成员取得 `dataqueue_owned`，输出槽在入口分别拥有。Peak 没有在获得锁内资源前解引用 queue。非空队首初始化及单槽拆合义务未改变。移除诊断模型没有以裸指针替代空间权限。

默认白名单 001 继续适用于 Peak 及 cleanup 的 assertS 观察条件；未以 Rely=True 下可满足性/非真空性作为 blocker。它不免除字段所有权、返回路径或后续实现证明。未证明的 Prop 义务仍是待证陈述，未升级为定理。

## 结论边界

本轮四个 Semaphore 函数只审阅 dataqueue 使用的 IC 设计。虽然为匹配新源码同步了 OC 抽象入口的范围判断，旧通用 OC Delete 仍存在“删除被已发布 queue 引用的 semaphore 后无法恢复 dataqueue invariant”的生命周期待办；本报告不宣称该 OC 契约成立。此前既有 VC 未全部通过，当前也未重新证明，详见整合记录。本次通过允许 main 继续当前 spec review，不表示七个 C 函数已经完成验证。

本轮map改造已分别独立审阅通过：`dq-predicate-map-20261117-r1` / `dq-spec-map-20261117-r1`。64份lib依赖编译通过、.vo保留；无新实现证明。当前正式输入与检查见[map-refactor.md](map-refactor.md)。
