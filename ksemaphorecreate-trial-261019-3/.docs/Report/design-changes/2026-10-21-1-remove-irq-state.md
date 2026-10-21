# DCHG-20261021-01：移除中断状态建模

已按用户 2026-10-21 的要求删除当前 trial 的 `os_irq_saved`，只保留抽象临界区内外的资源交接。本次修改已获用户授权，无需用户操作；修改后的设计不宣称中断状态恢复正确性，也不构成 C 实现证明。

变更范围是 `ksemaphorecreate-trial-261019-3`，沿用原 stm32f103-nano / 非 SMP 配置和源码分析。权威 C 和根共享 `lib/` 未修改。`VarGlobalState` 删除保存中断状态的字段，五个状态构造器同步调整。`CrtosRules` 的转换关系改为 `True`：这是移除原先唯一的中断状态相等约束后保留的 OS 数据关系，并没有增加 OS 数据不变条件。Inside/Outside 保留唯一临界区 token 和纯全局上下文，`os_inv` 与 `CriticalNest` 的资源交接保留。

KSemaphoreCreate、_SemaphoreCreate 的成功和失败出口删除中断状态相等条件，保留返回值、safeExec 和 OutsideCritical。CriticalAreaLock/UnLock 及 trusted Disable/Enable 的接口删除中断保存值关联；当前抽象不检查传入恢复值是否等于入场值。所有 caller-local 副本、logic.h 声明、规格生成脚本和类型检查清单同步修改。C 函数体、真实 lock 返回值和参数传递均保留。

旧 `predicate-r1-8a944cddeb13` 与 `spec-r1-7f4d155c90f7` 的 review-passed 对当前版本失效。原审阅和完成记录保留为历史并已加失效说明；本次仅做修改自检，不宣称新的独立 review-passed。当前源文件指纹见 [清单](../../../checks/remove-irq-state-manifest.json)。旧 r1 清单与共享候选差异快照属于修改前证据。

本次检查通过：

- 使用本机 `/home/xinra/.opam/pv-bench-8.20.1/bin/coqc`，重编译受影响依赖，构建脚本报告 28 个文件通过。最终注释修订后再次编译 CrtosGlobState，并通过 40 个声明接口的类型及依赖一致性检查；见 `checks/predicate-compile.log` 和 `checks/remove-irq-typecheck.log`。默认 `/usr/bin/coqc` 为 8.18，与现有 8.20 依赖不兼容，首次尝试因此失败；切换版本后通过。
- 9 个切片通过 GCC ILP32 语法及告警检查，见 `checks/spec-c-syntax.log`。
- `checks/audit_design.py` 确认权威源码指纹、C 函数体、调用闭包、canonical 与 caller-local 契约副本一致，见 `checks/design-audit.json`。
- 在内存中执行生成逻辑，与全部 9 个 canonical 文件逐字比较一致；主动 C/Rocq 源码及生成、检查脚本没有残留 `os_irq_saved` 引用。

复现构建时将上述 Coq 8.20.1 的 bin 目录置于 PATH 首位，运行 `checks/build_predicates.py`；类型检查使用 trial `_CoqProject` 的路径参数编译 `checks/SpecVocabulary.v`。本次是设计修改和自检；未运行 QCP parser、symbolic、VC 或 C 实现证明。
