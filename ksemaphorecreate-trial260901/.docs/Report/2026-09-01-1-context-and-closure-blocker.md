# KSemaphoreCreate 设计阶段上下文与闭包 blocker

当前阶段为 `slice-design/write-spec` 的上下文确认与 C 分析。尚未形成 predicate 或 spec review-ready revision，也未运行 QCP parser、symbolic、closure script、VC 生成或 proof。

- Trial：`/home/xinra/crtos/ksemaphorecreate-trial`。
- 权威实现：`/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c`。
- 当前配置依据：仓库中唯一的已生成板级配置 `board/stm32f103-nano/config`。该配置启用 semaphore 与 small-memory allocator，禁用 SMP，并给出 `MEM_ALIGN_SIZE=8`、`SMALL_NUMBER_32B=64`、`SMALL_NUMBER_64B=32`、`ID_HTABLE_SIZE=16`、`ID_NUM_MAX=128`。`XiZi_IIoT_Macro/.config` 当前不存在；本任务按 skill 默认的非 SMP 配置使用上述已生成配置。
- 模块边界：当前配置下 semaphore 模块的全部实现函数是 `_SemaphoreCreate`、`_SemaphoreDelete`、`_SemaphoreObtain`、`_SemaphoreAbandon`、`_SemaphoreSetValue`、`KSemaphoreCreate`、`KSemaphoreDelete`、`KSemaphoreObtain`、`KSemaphoreAbandon`、`KSemaphoreSetValue`。
- 模块直接对象：`k_sem_id_manager`、其 16 字节 ID bitmap 与 16 个连续 hash bucket head、`k_sem_list`、静态 `done` 函数表、动态分配的 `struct Semaphore`，以及 pending-list 中从 task 模块转入/借用的 `sched_link` 与必要 task fields。
- 生命周期：BSS/静态初始化建立 ID manager、空 bitmap/未初始化 bucket heads、空 `k_sem_list` 和只读 dispatch 表；create 经分配、整块清零、进入 critical、登记 ID、初始化 pending list、插入 module list 后发布；delete 从 ID bucket/module list 移除、唤醒 waiters、解锁后释放；obtain/abandon/set-value 在 critical 内改变 value 或 pending membership，并在必要时触发调度。

目标闭包的已解析前缀：

`KSemaphoreCreate -> done.SemaphoreCreate == _SemaphoreCreate`

`_SemaphoreCreate -> x_malloc, memset, CriticalAreaLock, IdInsertObj, x_free (ID-full path), InitDoubleLinkList, DoubleLinkListInsertNodeAfter, CriticalAreaUnLock`

归一证据：`KDEBUG_NOT_IN_INTERRUPT` 在 `semaphore.c` 中被显式重定义为空；`done.SemaphoreCreate` 由同一翻译单元的静态初始化器唯一绑定到 `_SemaphoreCreate`；`SYS_KDEBUG_LOG(KDBG_IPC, ...)` 的 section 常量为 0，但在正式切片中仍需记录其常量分支归一。

## Blocker

主 skill 要求闭包中每个 symbol 只能是“有唯一 active canonical 文件”或“用户逐名批准的 trusted symbol”。当前没有任何获批 trusted symbol，而以下叶子或复杂子系统无法在本设计轮由 main agent 自行跳过：

- `x_malloc`、`x_free`：进入 `kernel/memory/byte_manage.c` 的全局 allocator、静态池和 dynamic buddy 状态及多处分派；
- `memset`：当前 `CONFIG_LIB_NEWLIB=y`，权威实现来自外部 newlib，仓库内没有 active body；
- `DisableLocalInterrupt`、`EnableLocalInterrupt`：当前 Cortex-M3 实现是 naked inline assembly；
- `KPrintf`：`NULL_PARAM_CHECK` 在 ID-manager helpers 中展开出真实调用，即使目标合法入口使该分支不可达，结构闭包仍要求该 call 有 formal API；递归展开 `KPrintf` 会进入 console/varargs/driver 子系统。

最小建议 trusted 集合是：`x_malloc`、`x_free`、`memset`、`DisableLocalInterrupt`、`EnableLocalInterrupt`、`KPrintf`。批准后仍验证 `_SemaphoreCreate`、`CriticalAreaLock`、`CriticalAreaUnLock`、`IdInsertObj`、`AllocId`、`InsertObj`、`InitDoubleLinkList`、`DoubleLinkListInsertNodeAfter` 及 wrapper 本身；trusted contracts 将分别明确 allocator ownership transfer、全零字节效果、IRQ save/restore 与 `KPrintf` 不改变验证资源。

此 blocker 需要用户逐名决定，不能由 review blanket approval 替代。解除前不写会假装这些 callee 已验证的正式 spec，也不把不完整闭包标为 review-passed。

## Blocker resolution

用户在 2026-09-01 紧接上述逐名请求回复“批准继续”。按该回复的唯一上下文，以下六个 C symbol 获准作为本任务 trusted leaf：`x_malloc`、`x_free`、`memset`、`DisableLocalInterrupt`、`EnableLocalInterrupt`、`KPrintf`。后续 formal contracts 必须分别限制为本目标实际依赖的 allocator ownership transfer、整块字节写效果、IRQ save/disable/restore 和不改变验证内存资源的输出副作用；该批准不扩展到 `IdInsertObj`、critical wrapper 或 DLL helpers。
