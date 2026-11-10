# 工程配置指南

配置 trial、增补共享定义、复用 annotated C 或调整库路径时参考本指南。

## Trial 与全局库

每个 trial 根目录的 `_CoqProject` 列出本次使用的外部 `-R`/`-Q` 路径、全局库和本地实验库。本地实验库按主 skill 的 [文件组织与存放](../SKILL.md#文件组织与存放)统一映射 `trial/lib/`，只包含需要修改的共享库文件副本及新增库文件；未修改的依赖直接从全局库导入，不复制整个依赖闭包。全局库与本地实验库使用不同的逻辑前缀，避免同名模块相互遮蔽；依赖实验副本时使用本地逻辑路径，仍直接复用的共享模块使用全局逻辑路径。若依赖者必须调整 imports、类型或接口才能使用修改版，将这些需要修改的文件纳入 trial，避免在同一依赖链中混用不兼容的全局原版与 trial 修改版。路径映射与 Makefile、QCP 命令及 `Require` 使用的逻辑名称保持一致；相对路径按对应项目的工作目录解析。

CRTOS 全局库由 `/home/xinra/crtos/_CoqProject` 管理。现有映射为 `-R ./lib CRTOS_Verify.lib`，外部依赖也在该文件中声明。沿用此组织，不另在 `lib/` 内维护一份重复配置。

Trial 不会因为位于 CRTOS 根目录下就自动继承根 `_CoqProject`，使用全局库时仍需显式配置映射及所需外部依赖。路径变化后同步构建、QCP 和编辑器配置，并重新编译受影响的 `.vo`。

上述组织与外部库引用规则在 implement 阶段继续适用，必须[沿用现有 trial 工程](implementation-and-validation-guide.md#沿用现有工程)进行验证。由 QCP 工具侧适配本 OS 工程的格式与外部库引用，不因工具默认约定而重新配置、复制整套依赖或重组工程。

## Rocq 编译配置

- 统一使用 `tools/rocq/toolchain.json` 指定的 `pv-bench-8.20.1`；VsRocq 路径为 `/home/xinra/.opam/pv-bench-8.20.1/bin/vsrocqtop`。
- `FP` 和 `MonadLib` 只映射 QCP 树中的库；`vendor/fixedpoints` 和 `vendor/MonadLib` 仅作源码快照。
- 新 `.v` 加入所属 `_CoqProject`。先构建根 `lib/`，trial VC 再按 `lib -> goal -> proof_auto -> proof_manual -> goal_check` 编译。

需要编译的时机有三处：predicate 完成并准备审阅时，编译相关 predicate 文件；VC 完成后，编译本次生成的 VC 和证明文件；implement 完成并将 trial 库合并到全局 `lib/` 后，使用根项目配置重新编译新增或修改的库文件及其依赖者，并检查 trial 的引用。草案阶段不要求每次修改后都编译。

```sh
# QCP 基础库变化后
cd /home/xinra/qcp-binary-democases/Rocq
make -f Makefile core COQBIN=/home/xinra/.opam/pv-bench-8.20.1/bin/

# CRTOS 根库
cd /home/xinra/crtos
coq_makefile -f _CoqProject -o Makefile.coq
make -f Makefile.coq COQBIN=/home/xinra/.opam/pv-bench-8.20.1/bin/
```

`makes inconsistent assumptions` 表示混用了新旧 `.vo`；`Cannot find a physical path` 表示 `_CoqProject`/编辑器映射不一致。当前 QCP 使用 `valid_object` 等新接口，不再使用 `isvalidptr_*`、`store_2byte`/`store_4byte` 和 `sizeof_front_end_type_of_ptr_size`。`rocq_mcp_cache_*.v` 是临时文件，不加入构建。


## 全局 lib 目录结构

全局验证库按语义归属组织，不把 `.v` 文件平铺在 `lib/` 根目录：

```text
lib/
├── common/
├── <module-a>/
├── <module-b>/
└── index.md
```

- 每个 OS 模块使用稳定的小写全局目录名，例如 `event/`、`mutex/`、`semaphore/`、`task/`、`assign/`、`delay/`。首次新增某模块的定义或证明支持时，文件仍放在平铺的 `trial/lib/`，同时记录 implement 完成后的目标 `lib/<module>/` 路径。
- 模块目录主要包含该模块的 state/operations、具体函数的抽象 program、专用 lemmas 和 proof support。可以按职责拆成 `<Module>State.v`、`<Module>Ops.v`、`K<Function>.v` 等，但不为凑齐名称创建空文件。
- `common/` 保存通用基础定义、跨模块系统组合、统一协议、共享 predicate/invariant 接口和通用引理。沿用 VRTOS 的已有分层，`EventInv.v`、`MutexInv.v`、`SemaphoreInv.v`、`TaskInv.v`、`IsrManagerInv.v` 等仍放在 `common/`；全局状态、系统不变量与 critical/IRQ 规则也放在 `common/`。
- 是否属于 `common/` 按验证层次判断，不只看文件名或引用次数。id、list 等具有独立概念和接口的共享子系统使用自己的 `id/`、`list/` 目录。
- `trial/lib/` 始终保持单层，不创建 `event/`、`common/` 等子目录。修改 `lib/event/EventState.v` 时使用 `trial/lib/EventState.v`；新增通用文件时也直接放在 `trial/lib/<File>.v`，并记录其目标是 `lib/common/<File>.v`。
- 全局逻辑路径保留目录层次。根映射 `-R ./lib CRTOS_Verify.lib` 下，例如使用 `Require Import CRTOS_Verify.lib.event.EventState.` 和 `Require Import CRTOS_Verify.lib.common.CrtosRules.`。Trial 的本地逻辑路径则按单层 `trial/lib/` 配置。
- 对本轮触及的历史根目录 `.v` 文件，在平铺的 `trial/lib/` 中修改并记录它将迁入的全局目标路径；与当前任务无关的历史文件不做批量搬迁。纯路径变化不改变 formal semantics，但仍需完成引用和构建一致性检查。

## 共享库的增量维护

### 已有共享库的复用与修改

`/home/xinra/crtos/lib/` 中的已有定义应优先复用，也允许按当前源码和验证需求增补或修改。已有接口缺少所需元素、操作或引理时，在职责对应的 `lib/<module>/` 或 `lib/common/` 中增量补充。

无需修改的文件直接从全局库导入。需要修改的文件复制到平铺的 `trial/lib/`，记录全局来源和可比较的基线版本，在副本中修改；新增库文件也直接放在 `trial/lib/`，并记录目标全局路径。若依赖者必须调整 imports、类型或接口才能使用修改版，只将这些需要修改的文件一并纳入 trial。设计、审阅和 implement 期间不写回或移动全局原文件，不复制整套库或整个依赖闭包。

共享库的修改可以涉及定义含义或接口，但必须符合真实源码与系统协议，并同步调整受影响的构造、操作、predicate、spec 和证明。已有全局lib或者spec不符合当前skill可以直接报告，然后再进行修改。若修改导致已有审阅或证明结论不再适用，明确其影响并重新审阅受影响部分，不沿用失效结论。修改已有文件时检查修改处及受影响内容，新建文件时检查完整文件。共享库的修改权限不允许间接改变复用 spec 的原语义；涉及已有 spec 时仍须满足下文的语义保持规则。

### 实现完成后合并共享库

按主 skill 的[实现完成后自动合并库](../SKILL.md#实现完成后自动合并库)执行：设计、审阅和 implement 期间只修改 trial 副本及新增文件；复制时记录全局来源和可用于比较的基线版本。在完整验证流程中，用户确认已通过审阅的 predicate/spec revisions，且 QCP controller 返回 `done`（含 `final-check`）后，main agent 按已记录的目标路径主动合并平铺在 `trial/lib/` 中的修改及新增文件到对应 `lib/<module>/` 或 `lib/common/`，无需另设共享库更新审批。模块文件和函数专用文件均适用，不要求被多个模块或 trial 使用。未到 `done` 时保留 trial 产物，不写入全局库。

新增模块状态时，在平铺的 `trial/lib/` 中建立状态文件，并记录其目标模块目录；完成 implement 后再创建或更新全局模块目录，并在 `common/` 中的全局状态与系统不变量中接入该模块。导入仅使定义可用，不会自动更新 record 构造、状态更新函数或不变量；这些使用处随接口变化同步调整。仅新增局部引理或操作时，不需要改动全局组合。

合并前检查依赖、名称冲突及目标文件的最新内容，以复制时基线、trial 修改版及全局最新版本比较并合并，不得直接用旧副本覆盖其他工作。共享文件只能依赖共享库或外部库，不能依赖 trial 的实验文件或专属路径；从 trial 引入的必要新依赖在 implement 完成后一并纳入全局库。若合并需要改变已审阅且已实现证明的定义含义或接口，先回到 trial 修改，重新审阅、经用户确认并 implement 到 `done`，再执行合并。

合并后，按模块更新 `lib/index.md` 中的文件职责与实际子目录路径，并按实际变化更新根项目和 trial 的 `_CoqProject`、相关 Makefile、QCP 配置、编辑器路径以及使用处的 imports；将当前 trial 对已合并定义的引用切回全局逻辑路径。使用根项目配置重新编译新增或修改的 `.v` 文件及受影响的依赖者，并检查当前 trial 的引用与类型一致性，不沿用 trial 的 `.vo` 作为共享库编译结果。检查通过后才能报告共享库更新完成；语义或接口变化时按上述规则退回 trial。此处一致性检查在已完成的 QCP `final-check` 之后执行，不重复启动 symbolic、VC 或实现证明。

Trial 中保留此次完成 implement 的版本，便于追溯，并记录该版本到合并后文件及逻辑路径的对应关系。纯路径迁移且不改变已实现证明的语义时不要求重新审阅或实现证明。

## 全局 Annotated C 目录结构

全局 `annotated_C/` 只把 `src/` 中的 canonical 输入纳入长期维护：

```text
annotated_C/
└── src/
    ├── kernel/
    │   ├── common/          # 跨模块通用 kernel helper 及其 canonical spec
    │   └── <module>/        # 归属于具体模块的函数及 canonical spec
    ├── outside_critical/       # 明确的临界区外接口
    ├── riscv_shared/          # 架构共享实现
    ├── memory/
    ├── headers/
    └── include/
```

- `kernel/common/` 只放不属于某个具体模块的通用 kernel 函数及 canonical spec。函数即使被多个模块调用，只要其语义上属于 task、delay、assign 等模块，仍放在对应模块目录。
- Trial 始终使用平铺的 `trial/annotated_C/src/` 作为本轮一函数一文件输入，不复制全局 `kernel/<module>/` 层次。复制已有 canonical 文件时记录全局来源、基线和 revision；新增文件时记录 implement 完成后的全局目标路径。
- 对于 `kernel/`中没有的模块，新建模块文件夹放入即可


## Annotated C 的增量维护

### 已有 spec 的复用与特化

`/home/xinra/crtos/annotated_C/` 或其他证明工程中已有的函数 spec 应直接导入 trial 使用。导入 `g` 的 spec 时，只提取当前调用需要的函数声明、完整 `With/Require/Ensure` 和必要依赖，写在调用者 `f.c` 的 `f` 定义前，并标明来源文件和 revision；不新建 `trial/annotated_C/src/g.c`，不复制 `g` 的函数体，也不为汇集导入 spec 新建文件。来源是多函数文件时仍只提取所需 contract。导入时完成必要的等价适配和依赖配置，保持原 contract 的语义；多个 caller 中的同名 spec 须与所采用的同一来源版本一致。只有本轮新写 spec、需要实现验证的函数按一函数一文件组织；已有目标文件直接修改。设计、审阅和 implement 期间仅修改 trial 中的内容，并记录每个本地 canonical 文件的全局目标路径；实现完成后的合并规则见下节。

**从根 `annotated_C/` 或其他证明工程导入复用已有 spec 的依赖函数，本轮不需要生成其实现的 VC，也不重新证明其函数体。** 将其标记为 `reused-spec` 边界，记录来源文件、spec revision 和采用的 contract；其 canonical 依据是原证明中的 spec，不要求 trial 中另有同名函数文件。导入前核对原证明状态和适用假设，导入后的适用性、类型、源码适配及 caller-local contract 一致性仍须检查，不以缺少本地函数或 proof 文件为由自动建文件或安排重新证明。

仅做等价适配的导入仍适用上述规则；新增或改变语义的 contract 及新增特化的推导义务另行记录，不能当作原 spec 已覆盖。本轮新写后合并到全局目录的 spec 不追认为已有导入 spec；用户明确指定的实现证明目标仍按目标范围执行。

允许在 trial 的 caller-local spec 中调整 imports、名字、typedef 或 predicate 表示，但须保持原 contract 的含义、调用范围、返回路径、effect、ownership 和 frame。原 spec 不适用于当前源码或无法等价适配时，说明不匹配及影响，不通过偷偷加强 Require 或弱化 Ensure 继续复用；确需改变原语义时，作为独立的设计变更交由用户决定。

调用场景有额外事实时，可以保留原 spec，并新增具名的特化 spec。本轮实现验证函数的特化写在其 canonical 文件中；导入 spec 的特化与原 spec 一起写在 caller 定义前，记录来源和推导义务，不因新增特化而新建被调用函数文件，也不将特化视为已由原证明覆盖。

例如 semaphore 调用 `KTaskWakeup` 时，若已知目标 task 位于该 semaphore 的等待链表中，可新增具名的 semaphore 场景 spec：将通用 spec 的来源链表参数实例化为该等待链表，并从 semaphore predicate 导出 task 成员关系及调用所需资源。后置状态须由通用 spec 的链表变化和相关 predicate 推导，重新组合 semaphore 的表示与未修改资源；不能把调用前的成员关系原样断言为调用后仍成立。该成员事实也不能代替原 spec 对 task 状态、ID 解析、临界区或其他资源的要求。

审阅时记录特化所依据的原 spec revision、参数对应与推导义务，检查推导在语义上成立。

### 实现完成后合并 annotated C

在完整验证流程中，用户确认已通过审阅的 predicate/spec revisions，且 QCP controller 返回 `done`（含 `final-check`）后，与共享库一样主动合并本次等价修改及新增特化到根 `annotated_C/src/`，无需另设更新审批。比较基线、trial 版本及全局最新版本，已有 canonical 文件按原函数位置增量合并，新增 canonical 文件按已记录的目标路径写入 `src/kernel/<module>/`、`src/kernel/common/` 或 `src/` 下其他适用子目录，并保留其他工作和原 contract；导入 spec 的修改从 caller-local 声明提取，不为合并另建 trial 函数文件。其他证明工程的来源只作复用依据，不因此写回外部工程。不以单函数切片覆盖原多函数文件，不把 trial 专属路径写入全局文件。所需新增库依赖一并按共享库规则合并；`scenarios/`、`gen/`、`dep/` 不是合并目标。未到 `done` 时不写入根 `annotated_C/src/`。

合并后核对 imports、具名 spec、受影响的 caller-local contracts 及源码等价性，记录 trial 与全局文件的版本对应；trial 继续保留本轮已完成 implement 的一函数一文件输入，导入 spec 保留在 caller 定义前。共享 `.v` 依赖按根项目配置编译，annotated C 完成人工结构与语义一致性检查，不重复启动 QCP。合并表示本轮已完成实现证明并进入全局维护；导入复用部分按上述 `reused-spec` 规则免于本轮 VC 和函数体重证。若合并时发现新的或受影响的证明义务，退回 trial 更新并重新走 review、用户确认和 implement，不把它们留到合并后处理。

## 编辑器适配

项目已有的 Coq 8.18--8.20 / VsRocq 适配说明记录了局部 `_CoqProject` 路径未按文档生效的情况。遇到该环境时，将共享库、当前活动 trial 的外部路径和本地 `lib/` 映射同步到 CRTOS 根 `.vscode/settings.json` 的 `vsrocq.args`，并确保 `"*.v": "rocq"`。

该适配使用已经解析并确认存在的绝对路径，不依赖 `vsrocq.args` 对 `${workspaceFolder}` 的展开。切换活动 trial 时替换旧 trial 专属映射，不累积映射到同一逻辑路径的多个 `lib/`。

Coq/VsRocq 升级后实测局部项目和路径变量是否生效，再决定是否继续使用此适配；不要仅根据 Coq 版本推断编辑器行为。
