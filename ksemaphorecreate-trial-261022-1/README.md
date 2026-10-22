# KSemaphoreCreate：VRTOS spec 对齐 trial

本目录是 2026-10-22 新建的 `ksemaphorecreate-trial-261022-1`，用于继续用户要求的
VRTOS 被调用函数规约对齐。`261019-3` 保留原样，其证明结果不作为本目录的验证结果。

当前状态是 **两个创建函数均已通过 controller final-check，状态为 `done`**。`KSemaphoreCreate` 的 4 个、`_SemaphoreCreate` 的 42 个顶层 VC 已完成，并通过完整 Rocq 编译及当前 C 的独立 VC 重生成比对。VRTOS spec 对齐及资源衔接已完成。七份 C 切片来自旧 trial，函数体保持原源码
归一后的可执行语义；移除了依赖旧接口的局部证明注解。新 `VC/` 没有复制旧目标或证明。

已将以下九个接口的 16 处声明/定义同步为 VRTOS 所选接口的原文，包括规约标签：

- `AllocId`、`InsertObj`、`IdInsertObj`；
- `InitDoubleLinkList`、`DoubleLinkListInsertNodeAfter` 的 `dispatch_case`；
- `CriticalAreaLock` 的 `ordinary`、`CriticalAreaUnLock` 的 `stable`；
- `x_malloc` 的 `delay_object`、`memset`。

参考文件是 `/home/xinra/vrtos/annotated_C/src/headers/` 下的 `m_id.h`、
`m_double_linklist.h`、`m_ktask.h`。本次实际读取的字节和 SHA256 已固定于
`checks/vrtos-reference/` 和 `checks/spec-alignment.json`。链表纯序列定义来自
VRTOS `libai/DoubleLinkListSpec.v`，只将 DLL import 改为本 trial 的逻辑路径。

`KSemaphoreCreate`、`_SemaphoreCreate` 的公开规约保留。`x_free` 没有找到对应的
VRTOS 注解规约，采用既有 trusted `KERNEL_FREE` 宏目标下的完整对象回收接口
`SemaphoreRaw -> emp`；它不要求字段全零。`KPrintf` 保留调试用接口。

**文本对齐不表示旧证明已可复用。** 当前 trial 仍采用 Cortex-M3 / Arch32 LittleEndian，
VRTOS 的现有断言实例为 Arch32 BigEndian，且全局状态模型不同。用户明确选择只证明两个
创建函数，以小函数规约为外部依赖，不要求本轮重证 helper 实现或宣称整个调用闭包已验证。
失败节点的未知值资源已由 `SemaphoreOwnership.v` 中的已编译引理重组为 `SemaphoreRaw`。

`SemaphoreByteLayout.v` 给出带显式布局前提的零字节到字段资源转换；字段偏移假设按
LiteOS 的组织方式放在 `shared_candidates/SemaphoreInv.v` 的内存谓词之前，不另建 ABI 文件。
C ABI 检查见 `checks/abi-current.json`，用户授权见
`checks/abi-authorization.json`。这里不把 ABI 假设称为已证明定理。

检查与后续工作见 [设计变更记录](.docs/Report/design-changes/2026-10-22-1-vrtos-spec-alignment.md)。
当前结果以 `checks/status.json` 为准；原始来源和旧目录不变性依据见 `checks/trial-origin.json`。

在本目录执行以下命令可以复核规约及可执行源码的一致性，不运行 QCP 或生成 VC：

```sh
python3.12 checks/check_vrtos_specs.py
python3.12 checks/audit_design.py
gcc -m32 -std=gnu11 -Wall -Werror -fsyntax-only annotated_C/src/*.c
```

`_CoqProject` 只映射当前 trial 的候选库；不导入 `261019-3`。本地形式库编译脚本为
`checks/build_predicates.py`，编译结果只说明库可通过 Rocq 检查，不代表 C 实现正确。

编辑时可打开 `KSemaphoreCreate.code-workspace`，其中的 VsRocq 路径指向本 trial；
原工作区的编辑器设置未修改。

完成记录：`checks/status.json`；两次 run 的 `reports/<run>/controller_state.json` 保存 final-check 结果。编译在 controller 的 `_coq_builds` 中完成，`VC/` 中没有 `.vo` 不能据此判断未编译。

计时记录：`checks/implementation-timing.json`。用户要求的新计时段为北京时间 2026-10-22 19:20:57 至 20:03:43，共 42 分 46 秒（包括编译等待）。本轮从 18:14:46 启动至完成的总历时约 1 小时 48 分 57 秒；此前是否停顿无法精确还原，因此不将总历时称为有效工作时间。
