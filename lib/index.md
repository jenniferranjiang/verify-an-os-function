# CRTOS 共享验证库

共享库使用 `CRTOS_Verify.lib` 逻辑路径，由根目录 `_CoqProject` 管理。
全局 `.v` 按职责放在 `common/` 或对应模块目录，`lib/` 根目录不保存
`.v`。

## 当前范围

本分支移除了 task、assign、delay 子系统及其全局 predicate。全局状态只组合：

- event、mutex、semaphore 的纯状态与对象内存表示；
- ISR 状态与内存表示；
- 通用 ID manager 与双向链表；
- 非任务专用的对象创建抽象关系。

`os_inv` 不再拥有 task descriptor、调度队列、delay、tick、zombie、service
slot 或 exstatus。同步对象等待链仍保留地址序列与链表所有权，但其节点 payload
使用 `empty_wait_payload`，不再连接任何 task predicate。

## 保留的底层模块

- `common/dll_abs.v`、`common/dll.v`
- `list/NodeSelfLinked.v`、`list/DoubleLinkListSpec.v`
- `id/idnode_abs.v`、`id/idnode.v`、`id/IdModuleSpec.v`
- `common/StructFieldOffsetAxiom.v`
- `common/ObjectWaitNode.v`（仅计算同步对象等待链的嵌入节点地址，不拥有
  descriptor，也不定义 task state/predicate）
- `common/RemoveFound.v`

这些模块仍在根构建清单中，避免因清理 task 子系统而误删纯链表或 ID 基础设施。

## Annotated C

`annotated_C/src/kernel/task`、`assign`、`delay` 以及对应 task 专用头文件已
移除。原 event/mutex/semaphore annotated C 会直接展开 task invariant 或调用
task wakeup，因此也从本分支清理；保留 `kernel/list`、`kernel/id` 与其通用
头文件。

## 构建

```sh
make -f Makefile.coq -j2 COQBIN=/home/xinra/.opam/pv-bench-8.20.1/bin/
```

该构建只检查保留的共享 Rocq 库，不代表任何 C 实现已经完成验证。

## 完整任务模型恢复（2026-11-10）

根 `lib/*.v` 恢复完整 task/assign/delay 状态与不变量，使用原有
`CRTOS_Verify.lib.*` 路径，供 mutex deletion trial 直接导入。
此前裁剪后的 `common/` 等目录保持独立的模块路径；两套全局状态不能混用。
来源、QCP 依赖与本次未完成编译验证的说明见 `TASK_MODEL.md`。
