# Semaphore 辅助文件合并

按用户要求，三个独立辅助文件已合并到所属模块，14 个受影响的 Rocq 文件重新
编译通过。原有引理名称、陈述、证明和信任假设不变；无需用户操作。
本次整理于北京时间 2026-10-22 开始，2026-10-23 完成。

| 原文件 | 归入位置 |
| --- | --- |
| `SemaphoreOwnership.v` | `SemaphoreInv.v` 定义之后的资源拆分、失败回收引理，共 4 个 |
| `SemaphoreByteLayout.v` | `SemaphoreInv.v` 的零字节到字段资源转换引理，共 6 个 |
| `SemaphoreSpecBridge.v` 中的 ID 引理 | `idnode.v` 的 `IDNode` 模块，共 4 个 |
| `SemaphoreSpecBridge.v` 中的头插引理 | `DoubleLinkListSpec.v`，共 1 个 |

三个原文件及对应生成文件已删除，根 `_CoqProject` 移除相应条目，库索引同步更新。
不保留转发文件或旧 `.vo`。使用者可导入：

```coq
Require Import CRTOS_Verify.lib.CrtosInv CRTOS_Verify.lib.DoubleLinkListSpec.
Import IDNode.
```

这两个入口即可访问全部 15 个引理。ID 引理现在的模块限定名为
`CRTOS_Verify.lib.idnode.IDNode.<lemma>`；其余引理使用所在文件的模块路径。
只需要信号量内存表示及资源引理时，可以直接导入 `CRTOS_Verify.lib.SemaphoreInv`。

本次是文件组织调整，由 main agent 自检。逐个比较了全部 15 个引理的陈述和证明，
去除注释及空白后完全一致；没有新增定义、假设或待证项。编译后使用上述公开入口
逐个 `Check` 并查询 `Print Assumptions`，均通过。零字节转换证明仍以布局为
显式前提，不使用 `semaphore_field_offsets_trusted`。

根项目现有 52 个源文件，其中 44 个位于 `lib/`；本轮重编译 14 个受影响文件，
没有缺失或陈旧的项目编译产物。没有重新运行 QCP 或宣称新增 C 实现证明。
历史 trial 文件保持原样，其原有导入及验证记录仍对应自己的快照。

检查依据：

- [逐引理迁移核对](../checks/semaphore-lib-consolidation-261022/audit.json)
- [编译结果](../checks/semaphore-lib-consolidation-261022/build-result.json)及
  [编译日志](../checks/semaphore-lib-consolidation-261022/build.log)
- [公开入口检查](../checks/semaphore-lib-consolidation-261022/Imports.v)及
  [假设输出](../checks/semaphore-lib-consolidation-261022/imports.log)
- [当前源码哈希](../checks/semaphore-lib-consolidation-261022/after-manifest.json)

复现编译：在根目录运行
`make -f Makefile.coq -j2 COQBIN=/home/xinra/.opam/pv-bench-8.20.1/bin/`。
