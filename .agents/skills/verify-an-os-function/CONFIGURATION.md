# 环境与路径配置

## 路径配置

本文中的 **workspace** 指用户放置本 skill、维护验证成果的项目。直接使用当前 workspace 根目录，即使任务从其子目录启动，也无需用户配置 workspace 路径。

**QCP 和 Rocq。** 读取 workspace 根目录已有的 `CONFIGURE`、`Makefile` 以及它们实际引用的工具链配置。按构建时生效的变量和路径解析两项工具的位置。例如，项目可能用 `SymExec_DIR` 和 `SL_DIR` 指向 QCP 的符号执行器和库，用 `COQBIN` 或 opam 启动器选择 Rocq。分别核对 QCP 安装目录和该构建环境中实际使用的 Rocq 编译器。如果现有配置只能确定一项或两项都缺失，提醒用户在 workspace 根目录创建或补全 `CONFIGURE`，指定缺少的工具路径。

**构建入口中的本机绑定。** 首次配置或迁移机器时，沿 `Makefile → 启动脚本 → 工具链配置` 检查实际调用链。`which coqc` 只说明当前 shell 的选择，不能证明构建使用了同一编译器。重点核对 `OPAM_EXEC`、`COQBIN`、`SL_DIR`、QCP 路径、opam root/switch，以及脚本重设的 `PATH`；例如 `tools/rocq/toolchain.json` 可能仍指定原机器的用户目录。

Agent 可以为当前验证环境增量修改 workspace 内的 `CONFIGURE`、Makefile、启动脚本及其工具链配置，使其使用已确认的实际路径；这些文件不是只读的原始 OS 源码。优先使用已有配置入口，不要求迁移到特定文件格式。若启动脚本忽略配置或写死原机器路径，应修改对应脚本或生效配置，不能只在 `CONFIGURE` 中填写一个未被读取的值。保留其他用户配置；用户明确要求不修改的本地配置保持不动，说明仍需配置的位置。

配置后，通过实际构建所用的启动入口核对 `coqc`、`coqdep` 的路径和版本，并编译本轮所需的最小目标及依赖；不能仅用 shell 中的 `which coqc` 判定配置完成。普通编译若被启动脚本中无关的 MCP 后端检查阻塞，可将工具检查按用途拆分：构建检查所需编译工具，服务启动检查对应后端，保留真实依赖检查。更换工具链后核对 QCP 库及已有 `.vo` 的兼容性，按需重编译受影响依赖，不因版本号相同就认定二进制兼容。完成后报告修改过的配置文件、实际工具路径与检查结果。

**OS 原始源码。** 先检查 workspace 的 `CONFIGURE` 是否已指定源码目录。若已指定，核对该目录下的目标源码和构建配置；路径失效或指向其他源码时，请用户纠正。若未指定，由 agent 查找并记录。

1. Agent 根据项目说明、构建引用或既有验证记录查找源码，优先检查 workspace 的上层目录及其下的同级项目。用目标函数的原始定义、头文件和配置核对候选，排除带注释的验证副本。
2. 能唯一确定时，agent 将源码路径写入 workspace 的 `CONFIGURE`。找不到或仍有多个可信候选时，说明查找结果，请用户指定，再将确定的路径写入。
3. 写入时沿用已有变量名和文件格式，保留其他配置与用户改动。若没有对应变量，可写作 `OS_SOURCE_ROOT = ../my-os`（路径仅为示例）。若 `CONFIGURE` 尚不存在，则在 workspace 根目录新建；Makefile 中已生效的工具设置无需抄入。

**仅首次汇报配置。** 用户在该 workspace 首次使用本 skill 时，agent 在开始验证前一次列出 OS 原始源码目录、QCP 工具根目录和 Rocq 编译器的实际绝对路径，注明各自依据，请用户确认。无论路径来自现有配置、自行发现还是用户补充，均执行这次汇报。将确认结果记入已有验证上下文，后续任务复用该记录；若某项路径失效，只处理该项。

**原始 OS 源码始终只读。** Agent 不得修改原始源码或在其目录生成文件。源码适配、注解和经用户批准的缺陷修复都写入 workspace 的验证副本；写入前确认副本与原文件确实分离，包括符号链接指向的实际位置。

## 可选项目设置

需要自定义下列设置时，可使用 workspace 下的 `.agents/verify-os.config.json`，字段见[可选设置示例](config.example.json)。所有字段均可省略。JSON 中的相对路径以 workspace 根目录为基准，按字面解析。旧 JSON 中的工具和源码路径可作为查找线索；实际采用的位置按上节规则确定。

| 配置项 | 约定 |
|---|---|
| `source_processing` | 可选，用户维护的源码处理规则文件；省略或为空时只使用 skill 默认规则，填写后必须可读。与默认规则冲突的条目以用户规则为准，其余共同生效。 |
| `trust_base` | 可选，用户维护的补充信任说明；配置后必须可读，未配置不继承外部授权。原内置 TrustBase 已拆入源码处理指南的 Trusted specs、QCP 工具指南及 Spec 审阅章节；无需为这些内置内容重复配置。 |
| `review_whitelist` | 可选，用户维护的 predicate/spec 审阅补充白名单；配置后必须可读。省略或为空时只使用 skill 默认白名单；冲突条目以用户规则为准，其余共同生效。 |
| `annotated_c_dir` | 可选，annotated C 目录；为空时扫描根 `annotatedc/`、`annotated_C/`。都有且用途不明确时询问；都没有时新建 `annotatedc/`。 |
| `references.vrtos`、`references.crtos_verify`、`references.los_verify` | 可选参考根目录，未填写或不可用时说明并跳过，不阻塞验证；实际导入成为构建依赖时须确认该依赖可用。 |

目录扫描、沿用现有结构及验证过程中的编译检查见[工程组织与维护指南](references/project-maintenance-guide.md#路径配置与目录发现)。

## 用户源码处理规则

默认规则保存在 [源代码处理](references/source-processing-guide.md)。用户可自行创建规则文件，例如 `.agents/source-processing.md`，然后在 `.agents/verify-os.config.json` 中设置 `"source_processing": ".agents/source-processing.md"`，无需修改 skill。已有配置缺少该字段时仍可直接使用默认规则。

用户文件只需写补充的对原始源代码的处理规则即可，即如何将源代码处理为合适的验证切片代码，并说明适用对象或条件。

默认文件和用户文件分别保留，使用时同时参考；冲突条目以用户规则为准，其余规则共同生效。未配置用户文件时使用默认文件。

## 用户审阅白名单

默认白名单保存在 [review-whitelist.md](references/review-whitelist.md)，随 skill 维护。
用户可自行创建补充文件，例如 `.agents/review-whitelist.md`，然后在 `.agents/verify-os.config.json`
中设置 `"review_whitelist": ".agents/review-whitelist.md"`。路径解析规则与其他配置相同。
已有配置缺少该字段或字段为空时，只使用默认白名单。

默认文件和用户文件分别保留，设计与审阅时同时读取；冲突条目以用户规则为准，其余规则共同生效。
用户可按条目 ID 覆盖、收窄或明确禁用默认条目，无需复制整份默认文件。
Agent 不自行新增、修改或扩大默认及用户白名单；用户明确要求修改时按指定范围执行。

每条规则应有稳定 ID，并说明适用的建模方式或定义、豁免的审阅要求和保留的检查。
Predicate/spec 设计与审阅前读取适用文件，只对符合适用条件的有效条目执行例外，其余审阅条件照常执行。
命中条目时，在现有审阅记录中注明文件版本（如内容哈希）、条目 ID、适用 formal symbols/revisions
以及结论限制，不把被豁免的性质写成已证明结论。白名单变化后只复查受影响的审阅结论，
不自动将旧 `needs-fix` 改为通过。

白名单只调整设计审阅的通过条件，不新增 Rocq 公理、trusted contract 或源码适配授权，
使用白名单后仍须证明实际生成的 VC，进入 Stage 2 仍需用户确认 Stage 1 完成并明确指定进入实现证明。

## Rocq 编译配置

根 `_CoqProject` 与根Makefile统一管理全局 `lib/` 和 `VC/` 输入，设计、实现和编辑器使用相同配置。文件直接在所属全局目录维护，已有定义在原位置增量修改，沿用项目的逻辑前缀和根构建入口，见[全局工作区规则](references/project-maintenance-guide.md#全局工作区与依赖维护)。

共享接口变动时同步必要imports与使用处，编译本轮目标及受影响依赖，不混用绑定旧定义的缓存；依赖一致性随当前改动处理。外部QCP基础库仍按配置直接引用。QCP的main-root/workspace都指向验证工程根目录，输入和VC输出明确限定本轮目标。

- 用 workspace 已选定的 Rocq 工具链构建；使用 VsRocq 时选用同一环境的 `vsrocqtop`。
- 外部 QCP、Rocq 等工具的源码、脚本和库代码只读，供查阅接口和示例。使用已安装的工具，在验证工程自己的 `CONFIGURE`、Makefile 和路径映射中配置实际位置，项目库和证明使用本工程的构建入口。若当前安装与项目不兼容，报告缺失的接口或依赖以及受阻的检查。

`makes inconsistent assumptions` 表示混用了新旧 `.vo`；`Cannot find a physical path` 可能由 `_CoqProject`/编辑器映射不一致或依赖 `.vo` 缺失导致。先核对逻辑路径与编译产物，再按依赖顺序构建所缺或失效的目标；保留结果供交互式加载，不通过无差别清缓存处理。当前 QCP 使用 `valid_object` 等新接口，不再使用 `isvalidptr_*`、`store_2byte`/`store_4byte` 和 `sizeof_front_end_type_of_ptr_size`。`rocq_mcp_cache_*.v` 是临时文件，不加入构建。

## 编辑器适配

编辑器应使用根 `_CoqProject` 的同一组映射。项目已有 Coq 8.18--8.20 / VsRocq 未自动采用工程映射的情况；遇到该环境时，将根配置中的全局lib、VC与外部库映射同步到根 `.vscode/settings.json` 的 `vsrocq.args`，并确保 `"*.v": "rocq"`，不为单个任务另建项目配置。

该适配使用已经解析并确认存在的绝对路径，不依赖 `vsrocq.args` 对 `${workspaceFolder}` 的展开。修改根配置时同步受影响的编辑器映射，不把多个物理目录映射到同一逻辑前缀来隐式替换定义。

Coq/VsRocq 升级后实测局部项目和路径变量是否生效，再决定是否继续使用此适配；不要仅根据 Coq 版本推断编辑器行为。

## 工具检查入口

Stage 1 只做源码、契约一致性和 Rocq 类型检查等设计审阅工作。用户确认 Stage 1 完成并指定进入 Stage 2 后，QCP verification-orchestrator 统一管理工具闭包检查、符号执行、VC 生成与证明。工具路径沿用 workspace 的构建配置，实际调用参数和检查顺序遵循 QCP 工作流。

路径配置不能代替QCP与Rocq MCP的安装和连接；检查 `agents/openai.yaml` 声明的服务可用性，缺失时报告具体依赖。工具使用项目实际目录结构及统一的路径映射。
