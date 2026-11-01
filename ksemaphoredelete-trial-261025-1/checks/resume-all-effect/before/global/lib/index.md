# CRTOS 共享验证库

共享库统一使用 `CRTOS_Verify.lib` 逻辑路径，由根 `_CoqProject` 管理。
当前内存模型为 `Arch32 LittleEndian`；各 trial 分别记录其源码配置及 ABI 适配范围。
新 trial 显式导入共享库，函数专用定义使用自己的逻辑路径。

## Semaphore

| 文件 | 职责 |
| --- | --- |
| `SemaphoreState.v` | 对象地址、ID、计数、等待任务地址序列；稳定管理器配置及纯状态更新 |
| `SemaphoreInv.v` | 对象各生命周期的内存所有权、模块不变量、字段偏移假设，以及资源拆分、失败回收、零字节到字段转换引理 |
| `KSemaphoreCreate.v` | 创建函数的抽象操作；不是 C 实现证明文件 |
| `SemaphoreOps.v` | 非负 ID 的 uint16 查询归一、等待序列更新及对象注销 |
| `KSemaphoreDelete.v` | 删除与逐项唤醒的抽象操作、锁外回收前的完整私有对象表示 |
| `KTaskWakeup.v` | 唤醒所需的任务、RRR 就绪插入及延时取消效果；统一资源接口 `task_wakeup_inv`、结果条件 `tasks_ready_with_exstatus` 与底层局部 view |
| `KTaskUnSetDelay.v` | NULL、inactive、active 延时对象的调用者局部视图 |
| `DoubleLinkListSpec.v` | 链表插入纯序列语义及哨兵处头插引理 |
| `idnode.v` | ID 管理器内存表示，以及最小空闲 ID、容量满等引理（`IDNode` 模块） |

`CrtosGlobState.v` 组合 semaphore 与其他模块的状态；其他模块的更新保留
semaphore 分量。`CrtosRules.v` 提供统一的临界区协议和小端内存模型。
`CrtosInv.v` 组合模块内存，并把信号量等待节点纳入全局唯一所有权约束。

2026-10-25 删除设计修正了等待节点的真实嵌套字段地址，并在 `TaskInv.v`
补充 SUSPEND 任务的 bitmap 一致性。当前删除输入使用非 SMP、32 位验证适配，
调度按《源代码处理》的模型边界处理；设计审阅通过不等于实现证明完成。
revision、共享迁移及检查结果见
[删除设计记录](../ksemaphoredelete-trial-261025-1/.docs/Report/status.md)。

新 trial 可按需要导入，例如：

```coq
Require Import CRTOS_Verify.lib.CrtosInv.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec.
Import IDNode.
```

`CrtosInv` 导出 `SemaphoreInv`，其中包含初始化和资源转换引理；其他 semaphore
函数无需为使用模块状态而导入 `KSemaphoreCreate`。ID 与链表通用引理放在各自模块，
不再单设 `SemaphoreOwnership`、`SemaphoreByteLayout` 或 `SemaphoreSpecBridge` 文件。

## 构建与验证边界

在项目根目录运行：

```sh
make -f Makefile.coq -j2 COQBIN=/home/xinra/.opam/pv-bench-8.20.1/bin/
```

根 `.vscode/settings.json` 使用同一套共享库映射；查看历史创建实验时，可打开
该实验自己的 `KSemaphoreCreate.code-workspace`。

库的编译检查不等于 C 实现已验证。当前创建函数的模块化证明及 helper contract
边界仍见 `ksemaphorecreate-trial-261022-1/checks/status.json`；该 trial 保留原样。
共享库保留既有 ABI 信任假设，不将其标为已证明结论。

迁移范围、编译证据和复用限制见
[共享化记录](../.docs/Report/design-changes/2026-10-22-1-semaphore-shared.md)；
最新文件组织和编译结果见
[合并记录](../.docs/Report/2026-10-22-semaphore-lib-consolidation.md)。
