# QCP / Rocq MCP 交互环境与 implement 门禁

2026-11-01：兼容后端构建、独立新 MCP 服务的交互验收和持久配置修改完成。
**当前聊天的旧 MCP 连接尚未重启，不标为 ready。** 本轮只做工具修复与诊断，没有新增目标函数证明。

## 配置与兼容性

- QCP 与 Rocq MCP 均来自 `/home/xinra/qcp-binary-democases/mcp/`。
- `~/.codex/config.toml` 中两项服务改为使用
  `/home/xinra/crtos/tools/rocq/launch-mcp`，参数分别为 `qcp`、`rocq`。
  已删除这两项的旧 default PATH、StartupKTask 编译 wrapper 覆盖；其余配置与工具审批设置保留。
  原配置备份：`~/.codex/config.toml.before-qcp-interactive-20261101`。
- 工具配置集中在 [toolchain.json](../../tools/rocq/toolchain.json)。实际编译器仍使用
  `~/.opam/pv-bench-8.20.1/bin/` 中与现有 QCP/CRTOS 对象匹配的 Coq 8.20.1 / OCaml 4.14.2。
  switch 名称是历史命名，不是 MCP 工具来源。
- `pet/coq-lsp` 从 coq-lsp 0.2.5+8.20 release 源码针对上述 core 构建，位于
  `tools/rocq/.local/bin/`。新增 49 项构建依赖，没有重建原有 Coq/OCaml 或覆盖证明库。
  使用上游 Coq interruption 后端；没有安装可能触发 Coq 重建的可选 memprof-limits。
- 新建 `qcp-rocq-8.20.1` switch 的版本号虽相同，实际导入报
  `inconsistent assumptions over library Coq.Init.Prelude`，因此没有用于最终配置。
  该实验环境留作诊断，不是当前选择，也没有改变全局 default switch。

## 验收证据

[Rocq 交互结果](../checks/rocq-interactive-20261101-r4/result.json) 记录实际可执行路径、版本、哈希、
后端构建来源、输入哈希及完整 MCP 调用。测试在隔离目录中重新构建真实
`SemaphoreDelete_lib.v` 和 `SemaphoreDelete_goal.v`，复用工程原有路径映射与依赖：

1. `rocq_start` 得到非空目标 `forall sg st, os_inv sg st |-- os_inv sg st`，state 1。
2. `rocq_query` 成功查询真实 `os_inv`、`semaphore_pending_nodes` 类型。
3. `rocq_check` 执行 `intros sg st.`，得到含上下文的新目标，state 2。
4. `rocq_step_multi` 中 `apply derivable1_refl.` 成功，`exact I.` 被正确拒绝。
5. `rocq_check` 提交成功 tactic，state 3；随后 `Qed`，state 4；再次查询已定义 lemma。
6. 将已完成脚本写回独立诊断文件，`rocq_compile_file` 成功；`rocq_diag` 无近期错误。
   文件编译后返回正常的会话刷新提示；没有继续使用旧 state。

[QCP 结果](../checks/qcp-smoke-20261101-r4/result.json) 记录独立 QCP MCP 的
`load_target_file → symbolic → close`。诊断 C 为有范围约束的整数加一，符号执行成功；
另通过发行包 `symexec` 生成 VC，生成的 goal 文件在同一 Coq 环境编译成功。
生成 proof 模板没有作为已完成证明计入验收。

原有 QCP `Mem.vo`、CRTOS `KSemaphoreDelete.vo` 和所用 trial 源文件的保护哈希检查通过。
本轮没有修改批准的 predicate/spec 或目标 proof 文件。
两项 skill 的 `quick_validate.py` 和修改指南的相对链接检查通过。

失败尝试也保留：首轮标准库指纹不兼容；第二轮发现 Python `-m rocq_mcp.server`
引起重复模块导入，已改用规范模块入口；执行沙箱中的 stdio initialize 会停滞，
正常本地进程可完成同一握手，最终验收在该环境执行。QCP 预检脚本的 JSON 响应解析错误已修正。
这些失败没有被当作工具 ready。

## 文档与后续使用

[OS implement 指南](../../.agents/skills/verify-an-os-function/references/implementation-and-validation-guide.md)
和通用 implement 指南均要求先通过
[工具就绪门禁](../../.agents/skills/verify-c-function-with-qcp/references/toolchain-preflight.md)：
依赖构建、QCP parser/symbolic、真实项目导入、Rocq MCP 交互推进、完整文件编译缺一不可。
失败时只能修复工具或执行最小诊断，不能继续目标 VC 证明，不能用批量编译替代交互证明。
工具、环境、路径或依赖变化后重新验收；工具 ready 与目标 proof passed 分开记录。

运行命令与重建说明见 [tools/rocq/README.md](../../tools/rocq/README.md)。
[持久配置记录](../checks/rocq-interactive-20261101-r4/configuration.json) 确认最终启动参数与已验收服务一致。
[当前连接诊断](../checks/rocq-interactive-20261101-r4/current-connection-diag.json) 显示聊天仍连接到旧进程
（pet 已运行约 105000 秒，保留 OCaml 4.14.1/4.14.2 不匹配错误）。
需要在 Codex 扩展中执行 Restart extension，再在新连接实际检查导入与交互；
不能只调用 `force_restart`，因为旧 server 仍持有旧启动环境。
