# 当前实现证明的 Rocq MCP 使用方式

2026-10-31：用户明确要求通过 Rocq MCP 工作。

## 已验证可用的接口

使用 `mcp__rocq_mcp__rocq_compile` 迭代候选证明。通过 `ALL_TOOLS` 查工具 schema。
`source` 传完整导入和候选引理；调试时可以 `Show. Abort.` 输出目标，但这种调用不算已完成证明。
保存完整证明前须检查 `success: true`，随后仍执行 assignment 要求的 controller group-check。

现有 MCP 配置指向 `/home/xinra/crtos/StartupKTask/tools/qcp-coqc-wrapper`，原文件缺失。
现已恢复为透明适配器：调用与冻结依赖一致的 pv-bench-8.20.1 Coq，加载已审阅 trial `_CoqProject`，
在 controller staged workspace 中再映射其 `VC`。未修改外部 formal source 或 `.vo`。
wrapper 将这些路径放在 MCP 合成的 `-Q workspace Test` 之后，避免其覆盖当前 VC 别名。

共享库候选证明使用 workspace `/home/xinra/crtos/ksemaphoredelete-trial-261025-1`。
当前 VC 的 `.vo` 存在于 controller 隔离编译目录，canonical `VC` 通常只有 `.v`。
需要导入分组 VC 时，使用该组 controller `group-development` 返回的完整 `build_workspace`
（常为 `_coq_builds/<round>/group_NN/dev`）。静态 workspace_warning 可能仍显示无项目文件；
只有实际 `success: true` 才说明 wrapper 提供的路径已生效。

尚无 staged VC 时，可先在 main trial workspace 迭代只依赖共享库的 helper；也可在 MCP 临时候选源码中
复制**原样的**指定 goal Definition 及必要的本组 annotation-lib 定义以查看目标。
这些临时候选不能替代 controller 对原始生成声明及最终证明的检查。

不要用 `rocq_compile_file` 编译权威外部依赖：其清理行为可能删除原有 `.vo`。
不要修改 spec、predicate、目标声明或其他组文件来解决导入错误。

## 仍不可用的交互后端

当前 pet 由 OCaml 4.14.1 编译，冻结 QCP/CRTOS `.vo` 由4.14.2编译。
`rocq_start/check/query` 可能先表现为常量未找到；在基本 state 中显式 `Require` 才会显示版本不匹配。
不重复调用，也不声称这些接口已通过。`rocq_compile` 使用独立 compiler 入口，已通过共享库和实际分组证明测试。

配置哈希与 smoke 证据见 `checks/rocq-mcp-adapter.json`；实际组的 MCP 结果写入各自 worker 输出说明。
