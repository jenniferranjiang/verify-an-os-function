# QCP / Rocq MCP 运行环境

`launch-mcp rocq` 和 `launch-mcp qcp` 都启动
`/home/xinra/qcp-binary-democases/mcp/` 中的服务。`toolchain.json` 是唯一的环境选择入口；
`coqc` 适配器读取当前工程的 `_RocqProject` / `_CoqProject`，不固定到某个 trial。

当前已有 QCP/CRTOS `.vo` 对应 `pv-bench-8.20.1` 中的 **确切 Coq core/stdlib 构建**。
这个 switch 的名称是历史遗留，不表示使用 pvbench 的 MCP 服务。
新建的 `qcp-rocq-8.20.1` 虽然同为 Coq 8.20.1 / OCaml 4.14.2，仍不能加载这些对象，
因此没有用于当前证明。不能仅凭版本相同换掉工具链。

当前 `pet/coq-lsp` 从 coq-lsp 0.2.5+8.20 release 源码构建到 `.local/bin/`，
与现有 Coq core 链接；没有覆盖 default switch 或原有证明库。
构建使用上游支持的 Coq interruption 后端，未安装可触发 Coq 重建的可选 `memprof-limits`。
`.local/build.json` 记录来源、构建命令和源码/二进制哈希；`.local/build.log` 保存构建输出。

重建前先审查依赖安装计划，确认不会重建 Coq/OCaml 或替换已有库：

```sh
opam install --switch=pv-bench-8.20.1 cmdliner yojson uri dune-build-info tyxml menhir \
  ppx_inline_test ppx_deriving ppx_deriving_yojson ppx_import sexplib \
  ppx_sexp_conv ppx_compare ppx_hash --show-actions
```

确认仅补齐所需依赖后安装，再将解包的对应 release 源码交给
`python3 tools/rocq/build-backend.py --source <source-directory>`。
脚本拒绝覆盖现有 `.local/source`；需先检查并归档旧构建。构建成功仍不等于工具验收通过。

使用 QCP 目录中 rocq-mcp 的 venv Python 执行预检，输出必须是新的工作区目录：

```sh
PYTHON=/home/xinra/qcp-binary-democases/mcp/rocq-mcp/.venv/bin/python
$PYTHON tools/rocq/check-qcp.py \
  --project ksemaphoredelete-trial-261025-1/_CoqProject \
  --output .docs/checks/qcp-smoke-<run>
$PYTHON tools/rocq/check-interactive.py \
  --trial ksemaphoredelete-trial-261025-1 --case SemaphoreDelete \
  --output .docs/checks/rocq-interactive-<run>
```

`check-interactive.py` 当前代表性 lemma 使用 CRTOS 的 `os_inv`，适用于本工程；
换项目需选择对应 predicate。检查真实 case lib/goal 的构建、项目 symbol 查询、
`rocq_start → rocq_check → rocq_step_multi → rocq_check → Qed` 和完整文件编译。
候选中故意包含一个错误 tactic，验证后端确实在检查当前目标。
`check-qcp.py` 检查 QCP parser/symbolic 以及生成 goal 文件编译；生成 proof 模板不算已证明。

两个预检启动独立 MCP 服务，成功不代表 IDE 已有连接已经切换。
Codex 配置中的两个服务分别使用 `launch-mcp` 加 `rocq` / `qcp` 参数，修改后须重启客户端连接。
本环境的执行沙箱曾使 stdio 握手停滞，正常本地进程测试可通过；若复现，应记录运输层失败，
在允许的正常本地执行环境测试，不把停滞误报为证明通过或继续目标证明。

正式门禁见 [Implement 工具就绪检查](../../.agents/skills/verify-c-function-with-qcp/references/toolchain-preflight.md)。
预检失败时先修环境；配置、工具或依赖变化后须重新验收。
