# KSemaphoreCreate 验证上下文配置 blocker

状态：`resolved`

本记录只固定上下文证据；尚未产生 predicate/spec revision，也未运行 QCP parser、symbolic、closure script、VC 或 proof。

## 证据

- `Ubiquitous/XiZi_IIoT_Macro/.config` 当前不存在。
- `Ubiquitous/XiZi_IIoT_Macro/Makefile:11` 以 `BOARD ?= kd233` 选择默认板；`:26-31` 只读取根 `.config` 并包含 `board/$(BOARD)/config.mk`。
- 同一 Makefile 的 `:175-182` 表明只有执行 `menuconfig` 时才把 board `.defconfig` 复制为根 `.config`，因此当前不存在已经激活的 feature config。
- `board/kd233/.defconfig:9-11,177-178` 选择 RV64 且 `CONFIG_ARCH_SMP=y`、`CONFIG_CPUS_NR=2`；`board/kd233/config.mk:1,5` 使用 `-march=rv64imafdc -mabi=lp64d`。
- `board/stm32f103-nano/config` 是仓库中唯一无前导点的已生成 board config，启用 semaphore、禁用 SMP并选择 32 位 Cortex-M3；但根 Makefile 不读取该文件，除非另行把它选为验证配置。
- `annotated_C/src/include/xsconfig.h` 没有启用 `ARCH_SMP`/64 位；`lib/KTaskPure.v` 与 `KTaskDescriptor.v` 的布局说明按 4 字节指针。因此现有 task formal 与默认 kd233 SMP/LP64 配置不一致。

## 影响

配置选择会改变：

- `kernel/thread/CriticalArea.c` 采用 `ARCH_SMP` 还是非 SMP 实现；
- `x_base`、指针及函数指针宽度；
- `struct Semaphore`、`IdNode` 和双向链表字段 offset/size；
- critical/IRQ ownership 协议与可达调用闭包；
- `task-proof` 中 task/DLL/ID-manager formal definitions 是否可复用。

因此，在用户明确固定 board/config/ABI 前，无法满足 predicate review-ready 的“当前配置和源码集合已经固定”，继续设计会引入无依据假设。

## Resolution

用户于 2026-09-28 明确批准本次验证固定使用 `board/stm32f103-nano/config`：32 位 Cortex-M3、非 SMP。该文件是本次验证配置，而不是对根 Makefile 当前已自动激活配置的陈述。后续 source/config manifest、C 分支、ABI layout 与 formal dependencies 均绑定该选择；不采用 kd233 SMP/RV64，也不混用两套 ABI。
