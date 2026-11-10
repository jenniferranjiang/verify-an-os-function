# 环境与路径配置

## 路径配置

首次使用时，在验证工程根目录下创建 `.agents/verify-os.config.json`，内容从本 skill 的 [config.example.json](config.example.json) 复制。已有配置时直接编辑该文件，无需修改 `SKILL.md`。

填写 `qcp_root` 和 `source_root` 两个必填项；其他字段可以保留空字符串。JSON 不支持注释，填写时保留双引号和逗号结构。配置只影响路径选择，不会安装工具或连接 MCP 服务。

验证工程根目录默认是用户启动任务的当前目录，用户明确指定时使用指定目录；不从 skill 安装位置推断。读取根目录的 `.agents/verify-os.config.json`；首次使用复制 [config.example.json](config.example.json)，请用户填写必填项。配置为 JSON 数据，不作为 shell 执行。相对路径统一相对验证工程根目录解析，不相对 trial；不自动展开 `~` 或环境变量。解析后检查路径可用性并记录实际绝对路径。

| 配置项 | 约定 |
|---|---|
| `qcp_root` | 必填，QCP 安装/仓库根目录，须有工具、Rocq 库与工作流说明；缺失时报告并请用户配置，不能跳过 QCP。 |
| `source_root` | 必填，待验证的真实 C 源码根目录；从中确认源码、headers 与激活配置。 |
| `coq_bin` | 可选，兼容当前 QCP 的 Rocq/Coq bin 目录；为空时检查已有工程工具链或 PATH，实际编译前必须确认可用且兼容。 |
| `symexec_bin` | 可选，覆盖 symexec 可执行路径；为空时尝试 `qcp_root/linux-binary/symexec`，其他 QCP 安装布局填写实际位置。 |
| `trust_base` | 可选，用户维护的信任边界文件；配置后必须可读，未配置不继承外部授权。 |
| `annotated_c_dir` | 可选，annotated C 目录；为空时扫描根 `annotatedc/`、`annotated_C/`。都有且用途不明确时询问；都没有时新建 `annotatedc/`。 |
| `references.vrtos`、`references.crtos_verify`、`references.los_verify` | 可选参考根目录，未填写或不可用时说明并跳过，不阻塞验证；实际导入成为构建依赖时须确认该依赖可用。 |

目录扫描、沿用现有结构及验证过程中的编译检查见[工程组织与维护指南](references/project-maintenance-guide.md#路径配置与目录发现)。

## Rocq 编译配置

- 若已有 `tools/rocq/toolchain.json`，沿用并核对与路径配置一致；其他工程不要求此包装器，使用确认后的 `coq_bin` 或 PATH。VsRocq 使用相同环境 bin 目录中的 `vsrocqtop`，路径按本机安装位置填写。
- QCP 库直接引用配置的 `qcp_root` 下的实际目录，沿用工程已有的逻辑名与路径映射；不复制到验证工程，也不保留源码快照。
```sh
# Agent 解析 JSON 并检查后，通过独立环境变量传入路径：
# OS_QCP_ROOT=qcp_root，OS_PROJECT_ROOT=验证工程根目录，
# OS_SOURCE_ROOT=source_root，OS_COQ_BIN=确认后的编译器 bin 目录。
# 不 source JSON，不将配置值拼接成 shell 代码。

# QCP 基础库变化后
cd "$OS_QCP_ROOT/Rocq"
make -f Makefile core COQBIN="$OS_COQ_BIN/"

# CRTOS 根库
cd "$OS_PROJECT_ROOT"
"$OS_COQ_BIN/coq_makefile" -f _CoqProject -o Makefile.coq
make -f Makefile.coq COQBIN="$OS_COQ_BIN/"
```

`makes inconsistent assumptions` 表示混用了新旧 `.vo`；`Cannot find a physical path` 表示 `_CoqProject`/编辑器映射不一致。当前 QCP 使用 `valid_object` 等新接口，不再使用 `isvalidptr_*`、`store_2byte`/`store_4byte` 和 `sizeof_front_end_type_of_ptr_size`。`rocq_mcp_cache_*.v` 是临时文件，不加入构建。

## 编辑器适配

项目已有的 Coq 8.18--8.20 / VsRocq 适配说明记录了局部 `_CoqProject` 路径未按文档生效的情况。遇到该环境时，将共享库、当前活动 trial 的外部路径和本地 `lib/` 映射同步到 CRTOS 根 `.vscode/settings.json` 的 `vsrocq.args`，并确保 `"*.v": "rocq"`。

该适配使用已经解析并确认存在的绝对路径，不依赖 `vsrocq.args` 对 `${workspaceFolder}` 的展开。切换活动 trial 时替换旧 trial 专属映射，不累积映射到同一逻辑路径的多个 `lib/`。

Coq/VsRocq 升级后实测局部项目和路径变量是否生效，再决定是否继续使用此适配；不要仅根据 Coq 版本推断编辑器行为。

## 可选闭包检查脚本

[scripts/check-spec-closure.sh](scripts/check-spec-closure.sh) 适用于标准 trial，不是任意既有工程的通用入口。运行前把配置解析后的 `qcp_root` 作为 `OS_QCP_ROOT` 环境变量传入，非默认 symexec 路径通过 `SYMEXEC_BIN` 传入。路径优先级为 `SYMEXEC_BIN`、trial `CONFIGURE` 的 `SymExec_DIR`、`OS_QCP_ROOT/linux-binary/symexec`；无路径时明确报错，不回退维护者路径。`CONFIGURE` 的相对路径以 trial 为基准。

脚本仍需要 Bash、GNU coreutils/find、make、gcc、rg，trial 的 `make lib`、`VC/`、平铺 `annotated_C/src/` 及 `CRTOS_Verify.VC.strategy`。其他平台、逻辑前缀或构建入口使用对应的等价检查，不为辅助脚本重组用户工程。路径配置不能代替 QCP 与 Rocq MCP 的安装和连接；检查 `agents/openai.yaml` 声明的服务可用性，缺失时报告具体依赖。
