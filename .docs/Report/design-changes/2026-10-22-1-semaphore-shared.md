# DCHG-20261022-SHARED-01：信号量共享库与小端内存模型

本记录保存首次共享化时的文件组织和检查结果。后续按用户要求合并了三个辅助文件，
当前组织及验证证据见[合并记录](../2026-10-22-semaphore-lib-consolidation.md)。
下述哈希和日志仍对应合并前版本。

共享化已完成。根库现在包含 semaphore 状态、内存表示和创建相关引理，使用
`Arch32 LittleEndian`；新增文件及受影响的旧库已重新编译通过。无需用户操作。
后续函数可直接导入 `CRTOS_Verify.lib`，无需引用某个创建 trial 的库路径。

用户在本次会话明确同意加入 semaphore 分量，并统一共享模型为 LittleEndian。
适用范围沿用 `ksemaphorecreate-trial-261022-1` 的非 SMP Cortex-M3 / 32 位配置。
本次是共享库集成，不启动新函数的 QCP 验证，也不扩大 helper 的信任边界。

## 改动与依赖

- `CrtosGlobState.v` 增加 `os_semaphore_stable`、`os_semaphores` 及对应上下文；
  现有任务更新保留 semaphore 分量，`replace_semaphores` 保留其他模块分量。
- `CrtosRules.v` 的七组内存接口统一为 LittleEndian，接入已有 `CriticalNest`
  和 `LastSeen`。临界区仍描述资源交接，不证明硬件中断的保存、恢复。
- `CrtosInv.v` 组合 `semaphore_inv`，将 semaphore 等待任务纳入全局调度节点
  唯一所有权约束；原有引理适配扩展后的状态。
- 导入 `SemaphoreState`、`SemaphoreInv`、`SemaphoreOwnership`、
  `SemaphoreByteLayout`、`SemaphoreSpecBridge`、`KSemaphoreCreate` 和
  `DoubleLinkListSpec` 七个模块。函数抽象仍保留在独立文件中。
- 补入已有 trial 使用的三个 MonadLib 源文件，避免共享库依赖 trial vendor。
  其他候选文件规范化 import 后与根库相同，因此不覆盖这些文件。

根 `_CoqProject`、生成的 Makefile 和根工作区 VsRocq 路径同步使用共享库。
根路径中不再包含旧 trial 映射。当前创建 trial 的独立 code-workspace 保留。

## 检查结果与复用边界

本次由 main agent 自检，未使用独立 reviewer；检查范围为迁移差异、状态组合、
资源归属、共享依赖和编译兼容性，不把此次集成当作所有 OS 模块的重新语义审阅。

迁入的 13 个文件（含三个已有核心文件及三个 vendor 文件）在规范化逻辑路径、
去除注释和空白后，与来源完全一致；没有另改定义、定理陈述或证明。
共享文件不导入 `TrialShared` 或 `KSemaphoreCreateTrial`。

根项目有 55 个 Rocq 源文件，其中 47 个位于 `lib/`；此次按依赖重编译 35 个
新增或受影响文件，全部通过。其余源文件的 `.vo` 保持有效，未出现缺失或陈旧产物。
构建命令为：

```sh
make -f Makefile.coq -j2 COQBIN=/home/xinra/.opam/pv-bench-8.20.1/bin/
```

对 15 个迁入引理执行了 `Print Assumptions`。字节转换仍以显式布局前提为条件，
依赖既有 QCP 内存/地址接口及逻辑公理；未增加假设或占位证明。
`semaphore_field_offsets_trusted` 原样保留当前 trial 已批准的 ABI 信任入口。
vendor 中原有 `Hoare_forall` 以 `Abort` 结束，不导出定理或公理，
已用 `Fail Check MonadErrHoare.Hoare_forall` 确认，未将其计为已证明结论。

当前创建 trial 的 43 个已记录源码/配置/状态文件，以及它引用的 15 个根共享模块
及其依赖均保持原字节内容。其两个创建函数的历史完成结果仍绑定原 trial；
没有把旧 C 实现证明自动改称为共享逻辑路径下的新证明。
其他历史消费者若仍针对旧全局状态或大端实例，应先适配并检查自己的规约和证明，
不能仅凭本次共享库编译推断其 C 验证结论仍适用。

## 证据

正式 revision 以 [after-manifest.json](../../checks/semaphore-shared-261022/after-manifest.json)
中的 SHA256 为准。

- [来源与哈希](../../checks/semaphore-shared-261022/origins.json)
- [迁移及 trial 不变性核对](../../checks/semaphore-shared-261022/migration-audit.json)
- [编译结果](../../checks/semaphore-shared-261022/build-result.json)及
  [日志](../../checks/semaphore-shared-261022/build.log)
- [假设查询源文件](../../checks/semaphore-shared-261022/Assumptions.v)及
  [输出](../../checks/semaphore-shared-261022/assumptions.log)
- 修改前共享库源码及配置保存在 `../../checks/semaphore-shared-261022/before/`。

没有阻塞本次共享化的问题。下一步可以为 `KSemaphoreAbandon` / `_SemaphoreAbandon`
建立独立 trial，并在共享模块上增补真实调用路径需要的操作和资源转移接口。
