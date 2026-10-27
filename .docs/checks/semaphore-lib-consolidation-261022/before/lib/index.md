# CRTOS 共享验证库

共享库统一使用 `CRTOS_Verify.lib` 逻辑路径，由根 `_CoqProject` 管理。
当前内存模型为 `Arch32 LittleEndian`，对应本轮非 SMP Cortex-M3 配置。
新 trial 显式导入共享库，函数专用定义使用自己的逻辑路径。

## Semaphore

| 文件 | 职责 |
| --- | --- |
| `SemaphoreState.v` | 对象地址、ID、计数、等待任务地址序列；稳定管理器配置及纯状态更新 |
| `SemaphoreInv.v` | 对象各生命周期的内存所有权、模块不变量、已批准的字段偏移假设 |
| `SemaphoreOwnership.v` | 创建过程中资源拆分及失败回收的证明引理 |
| `SemaphoreByteLayout.v` | 在显式布局前提下，将零字节资源转换为字段资源的证明引理 |
| `SemaphoreSpecBridge.v` | ID 最小空闲值/容量满与链表头插的纯逻辑衔接引理 |
| `KSemaphoreCreate.v` | 创建函数的抽象操作；不是 C 实现证明文件 |
| `DoubleLinkListSpec.v` | 可供其他模块复用的链表插入纯序列语义 |

`CrtosGlobState.v` 组合 semaphore 与其他模块的状态；其他模块的更新保留
semaphore 分量。`CrtosRules.v` 提供统一的临界区协议和小端内存模型。
`CrtosInv.v` 组合模块内存，并把信号量等待节点纳入全局唯一所有权约束。

新 trial 可按需要导入，例如：

```coq
Require Import CRTOS_Verify.lib.CrtosInv.
Require Import CRTOS_Verify.lib.SemaphoreOwnership.
```

`SemaphoreByteLayout` 主要用于初始化；其他 semaphore 函数无需为使用模块状态
而导入 `KSemaphoreCreate`。`SemaphoreSpecBridge` 暂保留已有文件边界，避免迁移时
改变已审阅接口，其通用引理可由其他函数直接引用。

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
[共享化记录](../.docs/Report/design-changes/2026-10-22-1-semaphore-shared.md)。
