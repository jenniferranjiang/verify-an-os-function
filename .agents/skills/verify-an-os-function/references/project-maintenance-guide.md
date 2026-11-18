# 工程组织与维护指南

本指南说明如何直接在全局lib、annotated C和VC中增量工作；工具与本机配置见 [CONFIGURATION.md](../CONFIGURATION.md)。

## 文件组织以用户为准

本指南中的lib、annotated C和VC目录结构、文件名模板及路径示例都只是默认方案，不是要求用户工程满足的固定格式。三类产物分别按以下优先级确定实际位置：

1. **用户明确指定的目录、命名及文件组织方式。** 即使与本文默认示例不同，也按用户要求执行。
2. **项目已有的组织方式和配置。** 用户未另作指定时，沿用实际布局；新增文件也遵循同类文件的约定，不因新增模块就改用另一套默认结构。
3. **本文默认示例。** 仅在用户未指定、项目也没有对应约定时采用，按实际需要创建目录与文件。

因此，`lib/common/`、`lib/<module>/`、`annotated_C/src/kernel/<module>/`、`VC/<module>/`、header位置和文件名模板均可由用户布局替代。文中的路径、imports、构建命令和工具参数须映射到实际位置，不能为了套用示例移动、重命名、拆分或合并现有文件。三类目录不必采用相同层次；例如lib平铺、annotated C按模块、VC按函数组织，也应分别沿用。

“直接维护全局工程”指直接维护当前验证工程中权威的库、注解C及证明文件，不要求它们必须采用字面上的目录名 `lib`、`annotated_C`、`VC`。目录布局可变，源码对应、契约一致性、依赖检查和证明完整性要求仍须满足；工具适配用户布局，不能反过来要求用户布局迁就工具默认值。

## 源码工程与验证工程分离

CRTOS源码可由独立的上游仓库 `https://www.gitlink.org.cn/chos/crtos` 跟踪；其他OS使用其实际源码。`source_root`与验证工程根目录分别配置，不从skill安装位置推断。记录源码URL（若有）、commit、本地差异及激活配置，不把Ubiquitous或APP_Framework整树复制进验证工程。

原始源码只读。源码适配和用户批准的缺陷修复直接作用于验证工程的annotated C副本，保留原始依据、差异与授权，不回写source_root。两者在同一仓库时也必须区分权威源码路径与验证副本。

## 路径配置与目录发现

开始时按[环境与路径配置](../CONFIGURATION.md)确认工程、源码、工具根目录。扫描 `lib/`、解析后的annotated C目录、`VC/`、根 `_CoqProject`、构建文件及imports，记录实际布局和逻辑前缀。

从设计阶段起就在这些全局目录读写。已有布局优先：分模块、平铺或其他结构均沿用，不为任务重组现有文件。下文路径是新建工程的默认示例；例如已有平铺工程可直接维护 `lib/TaskInv.v` 和 `annotatedc/KTaskCreate.c`。按实际产物创建目录，不预建空模块或设计阶段不需要的VC目录。

修改前记录文件的实际工作树基线和已有未提交改动。新增文件、语义修改、必要imports适配与只需重编译的依赖分别记录；不得用HEAD覆盖未提交内容，也不能整文件替换掉无关定义或证明。

## 全局工作区与依赖维护

全局 `lib/` 是唯一项目库来源。已有定义直接import，需要改动就在所属文件原位修改，沿用项目的逻辑前缀与模型。QCP等外部基础库直接引用配置路径。

根手写 `Makefile` 维护外部映射、全局lib和VC的实际输入，并生成 `_CoqProject`；`Makefile.coq` 仅转发到统一构建入口。编辑器、QCP与Rocq使用同一套路径和现有逻辑名称，不将两个物理目录映射为同一前缀来隐式替换定义。

共享接口改变时：

1. 定位定义、直接使用处和传递依赖，区分语义改变、imports适配与缓存失效。
2. 在全局原文件增量修改必要使用处，维护相关caller-local contracts、构建配置及索引。不能从一次类型错误推出全部共享库都需重设计，也不为减少文件改动数量引入桥接证明层。
3. 重编译受影响依赖并核对语义。当前文件必须使用一致的总状态和Assertion模型，不能靠绑定旧定义的.vo掩盖冲突。
4. 若原审阅或证明不再适用于当前版本，标为invalidated并记录影响。受影响的已有证明编译检查不等于扩大本轮C函数体证明目标；新VC生成/重证仍由批准范围内的QCP workflow管理。需扩大实现证明范围时说明具体原因与范围。

新增dataqueue等模块时，直接修改现有CrtosGlobState/CrtosInv等文件，补入模块状态与资源，使用同一套系统状态和协议。必要的共享接口和依赖一致性随本轮修改处理。

构建从工程根目录执行，例如 `make lib/<module>/<File>.vo` 构建所需目标及依赖，`make lib -j2` 构建共享库。新增输入或修改映射时编辑 `Makefile` 中的 `lib_FILES`、`VC_code_proof_FILES`、`COQ_FLAG`；构建自动更新 `_CoqProject` 和 `.depend`，不要再用 `coq_makefile` 覆盖手写入口。工具链沿用 `tools/rocq/toolchain.json`。默认保留.vo，其他缓存按[主skill保留边界](../SKILL.md#临时产物与保留边界)处理。提交时确保所提交构建配置引用的输入一并提供，不提交指向未提供文件或任务临时目录的必需依赖。

接续已有成果时，核对来源基线、当前文件及授权，逐文件整合有效差异，并检查受影响的结果。

## Implement 阶段的 QCP 路径配置

Controller的 `--main-root` 与MCP调用的 `workspace` 使用验证工程根目录，目标文件路径相对于该根目录；构建、依赖解析和编辑器均使用根配置。QCP安装目录仍由qcp_root指定，不与验证工作目录混淆。

交接明确本轮函数/文件列表、冻结revisions、复用边界及VC输出位置。全局目录中存在其他函数，不表示它们全部进入本轮workflow。工具的路径解析和目标选择应适配用户的实际布局。

## 编译与检查

新增.v加入根构建。设计完成准备审阅时检查相关lib和必要依赖；已存在的受影响证明可以做编译回归检查，但设计阶段不运行QCP或生成新VC。实现阶段按 `lib -> goal -> proof_auto -> proof_manual -> goal_check` 编译本轮目标。

共享修改后检查受影响依赖，未改变版本的成功结果可以复用；草案不必每次编辑后全量编译。完成时确认本轮新增/修改文件及受影响依赖的检查结果有效。原有失败与本轮引入的问题分别记录；不能把未检查或失效的旧证明宣称为当前已通过。

## 全局 lib 目录结构

本节仅给出没有用户指定或项目约定时的默认方案，优先级遵循[文件组织以用户为准](#文件组织以用户为准)。默认结构为 `lib/common/`、`lib/<module>/` 和已有索引，模块名使用稳定小写名，例如event、mutex、semaphore、task、assign、delay。已有平铺或其他分层方式时直接沿用；以下目录分工和文件名模板也按实际约定对应，不强制新建common或模块子目录。

- 模块目录保存state/operations、函数抽象program、专用lemmas和proof support；按职责拆分，不为凑名称创建空文件。
- common保存通用基础、系统组合、统一critical/IRQ协议、共享predicate接口。沿用VRTOS分层时，模块共享Inv也放common；已有其他布局不搬迁。
- 函数专用抽象、view、引理放 `K<Function>.v`，不再为该函数另建State/Inv文件。模块公共能力写回所属模块。
- id、list等有独立概念的子系统使用自己的模块目录。
- 逻辑路径沿用工程前缀，例如 `CRTOS_Verify.lib.event.EventState`；不加入本轮任务名。

## 共享库的增量维护

### 已有共享库的复用与修改

先查已有定义。适用的直接Require Import，需要向下游公开则Require Export。接口缺少内容时在所属原文件补充，模块不存在才新增文件；定义不符合当前源码时说明差异与影响，再增量修正。

修改遵守真实源码和系统协议，直接在现有总state和os_inv中集成模块，见[Predicate指南](predicate-lemma-design-guide.md#65-组合模块-predicate)。不以保留旧Assertion carrier为由创建另一套系统协议。

新文件审阅完整内容，已有文件审阅修改处及受影响内容。不能通过改变共享predicate偷偷改变复用spec含义；相关契约、caller和已有证明的处理遵循下节及[全局依赖规则](#全局工作区与依赖维护)。

## 全局 Annotated C 目录结构

本节仅为默认示例，用户指定及现有项目布局优先。无其他约定时，canonical位置为 `annotated_C/src/kernel/<module>/`，跨模块且不属于具体模块的kernel helper放 `src/kernel/common/`。已有annotatedc平铺、其他模块层次或不同header位置时直接沿用，不强制增加src/kernel层。每个函数的权威body位置应明确，已有多函数文件不以单函数切片覆盖。

公共header沿用既有位置，默认 `annotated_C/src/headers/`，配置include沿用 `src/include/`。目录名使用解析结果，例如annotatedc，不硬编码用户布局。

仅供模块分析的函数按主skill的文件组织规则处理。gen/dep等工具生成临时目录不自动成为权威输入；不自行新增scenarios来替代用户已有组织方式。

## Annotated C 的增量维护

### 已有 spec 的复用与特化

#### 导入已有 spec

优先查当前全局annotated C，再查配置的参考工程。导入g的spec时，只提取所需声明、完整With/Require/Ensure与依赖，写在caller f.c的定义之前，记录来源及revision。不复制g的body、不新建重复g.c，也不为汇集导入spec建立新文件；来源为多函数文件时仍只提取所需contract。

多个caller使用同名spec时，保持同一来源版本和语义。已有canonical文件直接原位增补；除用户明确指定的实现目标外，只有确实新写spec的函数才新增包含真实body的canonical文件。

#### 复用 spec 的验证范围

**已有可复用spec作为reused-spec边界，本轮不生成其实现VC或重新证明函数体。** 全局已存在callee body并不使它自动成为目标；来自外部工程的边界也不要求在本工程补建同名body。

分别核对契约适用性和证明状态。调用条件、结果、ownership、frame、类型与源码适配必须适用；proof缺失、Admitted、架构或Assertion差异单独记录，不据此扩body范围。未证契约不自动标trusted或已证，caller结论须注明相对于这些契约成立。

等价适配、重命名或可从原spec推导的特化，不算新写函数体契约。确实缺少可用语义或无法由原契约推导时才新写spec；新增特化推导义务不当作已由原证明覆盖。本轮刚写入全局的spec仍属于本轮新增目标，不能因路径全局化就追认为已有复用边界。

#### 保持原 spec 的语义

允许调整imports、名字、typedef或predicate表示，但保持调用范围、返回路径、effect、ownership和frame。来源语义不适用于当前源码时明确报告，不偷偷加强Require或弱化Ensure。确需改变已有语义，按设计变更规则说明并交由用户决定；同步受影响caller声明和审阅状态。

#### 新增场景特化

有调用场景事实时，保留原spec并新增具名特化。本轮实现目标的特化放在其全局canonical文件；复用边界的特化与原spec一起放在caller定义前，记录来源与推导义务，不复制body。

同一IC/OC场景已有相似特化时复用结构与抽象操作，仅具体化真实对象、参数及资源。不能因为新增特化就删除原规格或宣称新的函数体证明已完成。维护规则见[Spec指南](spec-writing-guide.md#43-在全局文件中增量增加模块特化)。

### 模块 header

类型、宏、公共声明、Coq imports和Extern Coq词汇集中在已有模块header；需要修改就在原位置增补，没有才创建。同模块不按函数机械拆成多个小header，也不把完整With/Require/Ensure集中到模块级specs.h。

同步include路径，检查受影响C的声明、ABI和注解词汇，不能改变字段布局以迁就验证工具。外部参考工程只作读取来源，不写回其header。

### Canonical 与 caller 一致性

新增/修改契约时同步实际使用处并核对同名spec，保留同文件其他契约、body和用户改动。检查源码对应关系及采用的模型/适配依据；全局文件的位置本身不能证明源码一致性或contract正确。

## 全局 VC 目录与维护

本节的 `VC/<module>/` 和 `VC/common/` 也是默认示例，用户指定及项目现有布局优先。没有其他约定时，按模块保存goal、proof_auto、proof_manual、goal_check及函数辅助文件，共享strategy放VC/common。已有按函数、code_proof、平铺或其他组织方式时沿用，新目标放入对应位置，不要求统一成模块目录，也不迁移无关证明。文件名按实际工具与项目约定解析，需完整保留各类目标和证明之间的对应关系。

VC生成和更新由批准后的QCP workflow管理。只提交本轮目标，不能扫描全局VC后全部重生成。手工证明只改proof_manual，不手改goal/proof_auto/goal_check来绕过义务；旧有效证明和其他任务产物保留，版本冲突按workflow处理。

根构建纳入实际正式文件并检查依赖到goal_check。路径/import调整不改变VC陈述或假设；已有证明受共享修改影响时标记状态并处理，不能假借旧编译缓存。完成后的[收尾](../SKILL.md#全局一致性检查与收尾)完成一致性确认、记录整理和临时产物清理。
