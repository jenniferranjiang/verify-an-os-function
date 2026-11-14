# 工程组织与维护指南

本指南说明 trial 与全局文件如何组织、复用、检查和合并；工具与本机环境配置见 [CONFIGURATION.md](../CONFIGURATION.md)。

## 源码工程与验证工程分离

CRTOS 源码由独立的上游仓库 `https://www.gitlink.org.cn/chos/crtos` 跟踪。源码根目录与验证工程根目录分别配置，不从 skill 所在目录推断源码位置，也不把 `Ubiquitous/`、`APP_Framework/` 复制进 skill 或验证仓库。

源码与验证工程分别配置；其他 OS 使用其实际源码，不要求上述 CRTOS 仓库。源码分析从源码工程读取实现、headers 和配置，验证产物放在验证工程；两者也可在同一仓库，但 trial 不建在权威源码子树内。记录源码 URL（若有）、commit、本地差异及激活配置，以便追溯源码依据。

## 路径配置与目录发现

开始时按[环境与路径配置](../CONFIGURATION.md)读取并检查用户配置，确认验证工程、源码和工具位置。

开始验证先扫描 `lib/`、解析后的 annotated C 目录、已有 `VC/`、`_CoqProject`、构建文件和 imports，记录实际布局与逻辑前缀。全局正式产物分别由 `lib/`、annotated C 和 `VC/` 目录维护；按实际产物逐步创建所需目录和文件，不预建无关空模块，仅设计审阅时不要求创建空 `VC/`。已有目录分别沿用各自结构：与示例一样就按示例，平铺就继续在根目录增补 `.v` 和 canonical `.c`，其他布局按同类文件位置增补，不迁移现有文件。

本文及主 skill 的全局 `lib/<module>/`、`lib/common/`、`annotated_C/src/...` 和根目录限制仅适用于默认布局；复制、合并、索引和 imports 使用实际路径。例如平铺目标可以是 `lib/TaskInv.v` 和 `annotatedc/KTaskCreate.c`。沿用已有逻辑前缀；无 `_CoqProject` 时按实际依赖建立，不硬编码 `CRTOS_Verify`。已有索引则维护，没有则按需要创建。

Trial 的 Rocq 文件平铺在 `trial/lib/`，函数切片平铺在 `trial/annotated_C/src/`，模块 header 放在与 `src/` 同级的 `trial/annotated_C/headers/`；三者与全局布局分别记录，由 QCP 适配工作布局。不同全局目录的同名文件复制到 trial 时先解决名称/逻辑路径冲突，不能覆盖。

## Trial 与全局库

验证工程根目录的 `_CoqProject` 统一列出外部 `-R`/`-Q` 映射、全局库、当前纳入构建的 trial 逻辑路径及正式 `.v` 输入。根 Makefile（或由根 `_CoqProject` 生成的 Makefile.coq）提供统一构建入口；trial 不另维护 Makefile、`_CoqProject` 或一套重复的编译路径配置。

`trial/lib/` 只保存新增库及确实修改定义或接口的文件。未修改库通过原逻辑路径直接引用，不因编译、传递依赖或 import 路径不同而复制。遇到接口类型不匹配，先检查现有库接口、外部映射和修改处的兼容性处理；需要改变定义时记录具体语义差异，不能把只改路径的副本当成必需的模块修改。全局库与各 trial 使用不同逻辑前缀，避免同名文件互相遮蔽。

构建命令从工程根目录执行，所有相对映射以根目录解析；例如先在根目录运行 `coq_makefile -f _CoqProject -o Makefile.coq`，再用 `make -f Makefile.coq <trial>/lib/<File>.vo` 构建目标及其依赖。编辑器和工具使用同一根项目配置，不依赖从 trial 工作目录自动继承。新 trial 直接使用根配置，无需独立配置迁移。仅在已有旧 trial 仍维护独立配置时，先将其映射和输入纳入根配置并实际编译通过，再移除重复入口及失效的脚本或工具参数。

统一根构建配置后，仍需按提交范围检查它引用的文件是否齐全。如果本次暂不提交某个 trial，也不要提交对该 trial 文件的必需构建引用，否则其他人拉取后会因缺少输入而构建失败。需要发布该 trial 时，将它与对应根构建配置变更一同提交即可；trial 文件已随提交提供时，无需额外处理。这与是否将 trial 库合并到全局 `lib/` 无关。

上述组织与外部库引用规则在 implement 阶段继续适用，必须[沿用现有 trial 工程](implementation-and-validation-guide.md#沿用现有工程)进行验证。由 QCP 工具侧适配本 OS 工程的格式与外部库引用，不因工具默认约定而重新配置、复制整套依赖或重组工程。

## Implement 阶段的 QCP 路径配置

沿用已配置可用的 QCP/Rocq 环境，将验证工作目录指向当前 trial：controller 的
`--main-root` 和 MCP 调用的 `workspace` 使用该 trial 目录，目标文件路径相对此解析，
Rocq 编译及依赖解析则明确使用验证工程根目录的 `_CoqProject` 和根构建入口。trial 工作目录与构建配置根目录分别传递并实际核对，不为迎合工具默认行为另建 trial 配置。这里调整的是验证工作目录，不是 QCP 安装目录。

若已经指向当前 trial 且环境可用，直接继续，无需重新配置；切换 trial 时只更新
受影响的工作目录和路径。本 skill 不重复 QCP 的工具安装与环境配置说明。

## 编译与检查

- 新 `.v` 加入根 `_CoqProject`，由根构建入口解析全局库及 trial 依赖。设计阶段只编译所需 lib；进入实现阶段后，VC 按 `lib -> goal -> proof_auto -> proof_manual -> goal_check` 编译。

需要编译的时机有三处：predicate 完成并准备审阅时，编译相关 predicate 文件；VC 完成后，编译本次生成的 VC 和证明文件；implement 完成并迁出正式成果后，使用根项目配置在全局路径下重新编译新增或修改的库文件、受影响的依赖者及 VC/证明到 goal_check，并确认正式文件不再引用 trial。草案阶段不要求每次修改后都编译。

工具链选择、编译命令和环境问题见[环境与路径配置](../CONFIGURATION.md#rocq-编译配置)。

## 全局 lib 目录结构

以下仅是新建/空目录的默认布局；已有结构优先，允许平铺，不迁移用户现有文件：

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
- 已有文件记录其原始全局目标路径，不因本次验证迁移已有平铺或其他布局。

## 共享库的增量维护

### 已有共享库的复用与修改

当前验证工程 `lib/` 中的已有定义应优先复用，也允许按当前源码和验证需求增补或修改。已有接口缺少所需元素、操作或引理时，按职责确定 `lib/<module>/` 或 `lib/common/` 的目标位置，在对应 trial 文件中增量补充。模块级 state、predicate/invariant 和共享接口缺失时，补齐对应模块定义，并接入全局状态与系统不变量；已有定义直接复用。针对特定函数新增的抽象操作、program、局部 view、引理和证明辅助，统一放入该函数的 K<Function>.v，不另建函数专用的 State/Inv 文件。确属模块共享能力的增补，仍归入对应模块文件。

新增定义前先查全局库：已有且适用的定义直接通过原逻辑路径引用；已有定义或接口确实需要增补或修改时，才把所属文件复制到平铺的 `trial/lib/`，记录来源、基线及具体要改的定义或接口；全局库没有的内容才新建本地文件。编译、被其他文件引用、调整路径或重新生成 `.vo` 都不是复制理由。

直接引用遇到错误时，先区分外部路径配置问题与实际类型/接口冲突。需要改变接口时，说明具体不匹配和必要改动，再处理对应文件；不根据传递依赖图自动复制全部依赖，也不为解决工程组织问题自行改变验证范围或既定模型。审阅准备时核对 trial 库清单，只有 import/逻辑路径替换而没有定义或接口改动的副本应移出，恢复外部引用。设计、审阅和 implement 期间不写回或移动全局原文件。

共享库的修改可以涉及定义含义或接口，但必须符合真实源码与系统协议，并同步调整受影响的构造、操作、predicate、spec 和证明。已有全局lib或者spec不符合当前skill可以直接报告，然后再进行修改。若修改导致已有审阅或证明结论不再适用，明确其影响并重新审阅受影响部分，不沿用失效结论。修改已有文件时检查修改处及受影响内容，新建文件时检查完整文件。共享库的修改权限不允许间接改变复用 spec 的原语义；涉及已有 spec 时仍须满足下文的语义保持规则。

### 共享库迁出细节

迁出条件和顺序统一按主 skill 的[正式成果迁出与 trial 删除](../SKILL.md#正式成果迁出与-trial-删除)执行。共享库目标为已记录的 `lib/<module>/`、`lib/common/` 或用户已有位置。设计阶段的模块状态与系统 invariant 集成应已在 trial 中完成，不推迟到迁出时才设计。

同步必要依赖、imports、全局组合和已有索引。trial 为复用原库而导入同名根文件时，须解决兼容定义和命名关系，避免直接覆盖造成 self-import；核对受影响的全局依赖者。

## 全局 Annotated C 目录结构

以下是新建/空目录的默认布局，目录名称使用解析结果；已有平铺或其他结构保持原样。全局 `annotated_C/` 长期维护 `src/` 中的函数及其 spec，也可以维护它们引用的公共 header：

```text
annotated_C/
└── src/
    ├── kernel/
    │   ├── common/          # 跨模块通用 kernel helper 及其 canonical spec
    │   └── <module>/        # 归属于具体模块的函数及 canonical spec
    ├── outside_critical/       # 明确的临界区外接口
    ├── riscv_shared/          # 架构共享实现
    ├── memory/
    ├── headers/               # 按模块维护公共类型、宏和声明，如 semaphore.h
    └── include/
```

- `kernel/common/` 只放不属于某个具体模块的通用 kernel 函数及 canonical spec。函数即使被多个模块调用，只要其语义上属于 task、delay、assign 等模块，仍放在对应模块目录。
- Trial 始终使用平铺的 `trial/annotated_C/src/` 作为本轮一函数一文件输入，不复制全局 `kernel/<module>/` 层次。复制已有 canonical 文件时记录全局来源、基线和 revision；新增文件时记录 implement 完成后的全局目标路径。
- 对于 `kernel/` 中没有的模块，按需新建模块目录。
- 全局 header 沿用既有位置（上图示例为 `src/headers/`）；trial 的模块 header 统一放在 `trial/annotated_C/headers/<module>.h`，不放在 `src/` 或 `src/headers/`。`annotated_C` 名称按工程实际目录映射，例如使用 `annotatedc` 时就是 `trial/annotatedc/headers/`。header 的维护方式见下节。


## Annotated C 的增量维护

### 已有 spec 的复用与特化

#### 导入已有 spec

当前工程的 annotated C 目录或其他证明工程中已有的函数 spec，应优先导入 trial 使用。

导入 `g` 的 spec 时，只提取当前调用需要的函数声明、完整 `With/Require/Ensure` 和必要依赖，写在调用者 `f.c` 的 `f` 定义前，并标明来源文件和 revision；不新建 `trial/annotated_C/src/g.c`，不复制 `g` 的函数体，也不为汇集导入 spec 新建文件。来源是多函数文件时仍只提取所需 contract。

导入时完成必要的等价适配和依赖配置，保持原 contract 的语义；多个 caller 中的同名 spec 须与所采用的同一来源版本一致。只有本轮新写 spec、需要实现验证的函数按一函数一文件组织；已有目标文件直接修改。设计、审阅和 implement 期间仅修改 trial 中的内容，并记录每个本地 canonical 文件的全局目标路径；实现完成后的合并规则见下节。

#### 复用 spec 的验证范围

**从根 `annotated_C/` 或其他证明工程导入复用已有 spec 的依赖函数，本轮不需要生成其实现的 VC，也不重新证明其函数体。** 将其标记为 `reused-spec` 边界，记录来源文件、spec revision 和采用的 contract；其 canonical 依据是原证明中的 spec，不要求 trial 中另有同名函数文件。导入前核对原证明状态和适用假设，导入后的适用性、类型、源码适配及 caller-local contract 一致性仍须检查，不以缺少本地函数或 proof 文件为由自动建文件或安排重新证明。

仅做等价适配的导入仍适用上述规则；新增或改变语义的 contract 及新增特化的推导义务另行记录，不能当作原 spec 已覆盖。本轮新写后合并到全局目录的 spec 不追认为已有导入 spec；用户明确指定的实现证明目标仍按目标范围执行。

#### 保持原 spec 的语义

允许在 trial 的 caller-local spec 中调整 imports、名字、typedef 或 predicate 表示，但须保持原 contract 的含义、调用范围、返回路径、effect、ownership 和 frame。原 spec 不适用于当前源码或无法等价适配时，说明不匹配及影响，不通过偷偷加强 Require 或弱化 Ensure 继续复用；确需改变原语义时，作为独立的设计变更交由用户决定。

#### 新增场景特化

调用场景有额外事实时，可以保留原 spec，并新增具名的特化 spec。本轮实现验证函数的特化写在其 canonical 文件中；导入 spec 的特化与原 spec 一起写在 caller 定义前，记录来源和推导义务，不因新增特化而新建被调用函数文件，也不将特化视为已由原证明覆盖。

例如 semaphore 调用 `KTaskWakeup` 时，若已知目标 task 位于该 semaphore 的等待链表中，可新增具名的 semaphore 场景 spec：将通用 spec 的来源链表参数实例化为该等待链表，并从 semaphore predicate 导出 task 成员关系及调用所需资源。后置状态须由通用 spec 的链表变化和相关 predicate 推导，重新组合 semaphore 的表示与未修改资源；不能把调用前的成员关系原样断言为调用后仍成立。该成员事实也不能代替原 spec 对 task 状态、ID 解析、临界区或其他资源的要求。

审阅时记录特化所依据的原 spec revision、参数对应与推导义务，检查推导在语义上成立。

### 公共 header 的维护

同一模块的 C 类型、宏、公共声明、Coq imports 和共享 `Extern Coq` 词汇默认集中在模块 header，由各函数切片直接引用。不要把“一函数一文件”延伸成“一函数一 header”，也不要为 create/delete 等单个操作建立仅转发 include 或几条声明的小 header。已有 ABI/逻辑 header 分层有明确用途时可以沿用，不机械合并不同模块；跨模块内容放回其所属模块或已有公共 header。函数的 `With/Require/Ensure` 仍按规则写在 `.c` 的 canonical 定义及 caller-local 声明上，不集中到模块级 `*_specs.h`。

开始时先查已有模块 header，能直接用就直接引用。需要修改时只把相关 header 复制到 `trial/annotated_C/headers/`，记录来源和基线；新增模块 header 也放在此处，并记录将来的全局目标路径。同模块已有 header 时在其中增补，不再按函数追加一层 header。同步根构建和工具的 include 路径，让 `src/` 中的 `.c` 能引用这些模块头文件；不为迁就工具默认目录而把 header 放回 `src/`。类型和结构体布局须与当前源码及配置一致。

迁出时，header 与函数文件一起归入全局目标；已有模块 header 在其内容上整合，没有才新建。同步调整 `#include` 和包含路径，不保留对 trial 的依赖，并检查受影响的 `.c`，确认整理 header 没有改变声明、类型布局或 spec 的含义。

### Annotated C 迁出细节

按主 skill 的[收尾流程](../SKILL.md#正式成果迁出与-trial-删除)，已有 canonical 文件按原函数位置增量整合，新增文件移动到已记录的 `src/kernel/<module>/`、`src/kernel/common/` 或其他适用位置。保留原 contract；导入 spec 的修改从 caller-local 声明提取，不为迁出另建 trial 函数文件。不以单函数切片覆盖原多函数文件；其他证明工程只作复用依据，不因此写回外部工程。`scenarios/`、`gen/`、`dep/` 不是全局维护目标。

核对具名 spec、受影响的 caller-local contracts、imports 及源码等价性；导入 spec 仍保留在正式 caller 定义前。Annotated C 完成人工结构与语义一致性检查；导入复用部分仍按上述 `reused-spec` 规则处理，不追认为本轮新完成的函数体证明。

## 全局 VC 目录与维护

与 `lib/` 一样，VC 按模块维护；函数专属文件归入对应函数目录，跨函数共享的 strategy 等证明放在公共部分。新目录默认如下，已有布局则沿用实际位置并记录映射：

```text
VC/
├── common/                    # 共享 strategy 和辅助证明
└── <module>/
    └── <function>/            # goal、proof_auto、proof_manual、goal_check 等正式文件
```

按主 skill 的[收尾流程](../SKILL.md#正式成果迁出与-trial-删除)，将 trial 中当前有效的 VC 目标、自动/手工证明、goal_check 及必要辅助文件成套迁出。复用且未改的全局证明直接引用；不要搬入重复生成结果、编译缓存或旧失败版本。已有目标先比较并保留其他有效证明，不以同名文件直接覆盖不兼容的内容。

通过工具完成所需路径/import 调整，核对逻辑名称和 theorem 依赖；路径整理不能改变 VC 陈述、假设或证明内容来绕过检查。全局根构建配置纳入这些正式文件，并按依赖顺序重新编译到 goal_check。
