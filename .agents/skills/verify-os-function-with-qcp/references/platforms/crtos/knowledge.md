# CRTOS 公共知识

本文件只在目标工程是 CRTOS 时读取。它为 $verify-c-function-with-qcp 提供公共工程事实与知识路由，不替代权威 CRTOS C、当前配置或正式 trial 定义。

按阶段继续读取：

- Predicate 设计与审阅：[CRTOS Predicate Knowledge](predicate-knowledge.md)。
- Spec 设计与审阅：[CRTOS Spec Knowledge](spec-knowledge.md)。
- Implement 与 final integrity：使用本文件中的 trial、logical path、QCP 工具和记录约定。

## 适用范围

- 默认处理当前配置实际编译的非 SMP 代码；若用户选择 SMP 或其他配置，先重新确认并覆盖此默认值。
- 真实 CRTOS 源码与当前配置是语义依据。已有 proof、Task 快照和 LOS 示例都只能作为组织或语法参考。
- 跨模块资源应复用已审阅 owner 和借用/转移接口；缺失接口保持 [OPEN]。

## 项目信任边界

Context 阶段完整读取用户维护的 [TrustBase.md](/home/xinra/TrustBase.md)，作为项目的信任边界依据。该文件仅由人工编辑，agent 不修改它。

其中的工具适配假设须与实际转换核对，一致性检查要求仍须执行，trusted specs 按列明范围使用。已明确授权且适用于本任务的条目无需重复批准；宽泛类别不自动批准任意 symbol 或 contract，新增信任假设或范围扩展仍需用户批准。本文档为通用流程提供项目的既有信任依据，不使 trusted 接口成为 proved，也不豁免其余待证义务。

Implement 交接时提供 TrustBase 文件路径；最终结论说明基于信任假设的适配和适用限制，不声称无条件的源码等价或无信任依赖。TrustBase 或实际依赖变化时复查受影响结论。

## Trial 与工程路径

CRTOS 根目录是 /home/xinra/crtos/。默认 trial 是该根目录的直接子目录：

~~~text
<function-name>-trial-YYMMDD-N/
  annotated_C/src/
  lib/
  VC/
  .docs/Report/
    source-errors/
    design-changes/
    folded_history/
~~~

用户指定独立目录时使用用户路径。开始 C 分析前解析并报告绝对路径；不得覆盖现有内容，也不得把 trial 建在权威源码子树内。

创建或进入 trial 时，创建或维护 trial 根自己的 _CoqProject。它列出实际使用的外部 -R/-Q 路径，并把本地 lib/ 映射到与 Makefile、QCP 命令及 Require 完全一致的逻辑路径。任何一处逻辑路径变化时同步其余位置并重新编译受影响 .vo。

当前 Coq 8.18--8.20 的 VsRocq 进程不能可靠地为每个文档应用局部 _CoqProject load path。在这些版本下，还要把当前活动 trial 的外部路径和 lib 映射同步到 CRTOS 根 .vscode/settings.json 的 vsrocq.args，并确保 *.v 映射为 rocq。当前 VsRocq 不展开 vsrocq.args 中的 ${workspaceFolder}，这里写已解析且存在的绝对路径。切换 trial 时替换旧 trial 专属映射，不累积多个映射到同一逻辑路径的 lib。Coq/VsRocq 升级后先实测，不延续未经验证的版本假设。

## QCP 与复用位置

- QCP 参考项目固定在 /home/xinra/qcp-binary-democases/。
- CRTOS 已有 predicate/lemma 在 /home/xinra/crtos/lib/。
- 写 spec 时可参考 /home/xinra/crtos/annotated_C/ 中已有的 annotated C；它们不自动成为当前目标的 canonical 或 trusted spec。
- 写新 definition、strategy、assertion 或 annotation 前，先用 rg 搜索 QCP 教程/示例、当前 trial 和已有 CRTOS 定义。不得猜测 QCP 语法。
- 复用前检查内容、revision、assumptions 和验证状态；有疑点时在任务回复及对应设计/review 记录中标记 [OPEN]。未经用户明确授权不修改或删除共享文件。

## Implement 工具配置

当前 CRTOS trial 的 QCP strategy 逻辑名通常是 CRTOS_Verify.VC.strategy，但运行前以 trial 的 CONFIGURE、Makefile、_CoqProject 和实际 strategy 文件为准。调用通用闭包脚本时显式设置：

~~~bash
QCP_STRATEGY=CRTOS_Verify.VC.strategy \
bash <verify-c-function-with-qcp-dir>/scripts/check-spec-closure.sh <trial-dir>
~~~

若 CONFIGURE 已声明 QCP_Strategy，则使用已确认配置。SYMEXEC_BIN 可显式指定；否则脚本从 CONFIGURE 的 SymExec_DIR 解析。CRTOS 本机可把 /home/xinra/qcp-binary-democases/linux-binary/symexec 显式设为 SYMEXEC_BIN；通用脚本不内置该路径。

## 记录

trial 的 .docs/Report/ 按用途保存：

- YYYY-MM-DD-N-predicate-design.md：当前 predicate 设计与 formal revision；正文按对象、生命周期、分层或决策组织，不要求固定栏目；
- spec review 记录：绑定 revision 的路径、effect、frame、闭包、issues 和结论；
- source-errors/YYYY-MM-DD-N-<short-slug>.md：已确认位于权威 C 的源码缺陷、影响和源码修复状态；
- design-changes/YYYY-MM-DD-N-<short-slug>.md：已审阅 predicate/spec 等 formal 设计的变化、影响范围和批准状态；
- final integrity：当前有效的 QCP 结果、VC/证明计数、Rocq 编译、trust scan，以及未解决 `SRCERR`/`DCHG`。

源码错误、设计变更、验证实施问题和工具问题的分类使用通用 skill 的 [验证记录指南](../../../../verify-c-function-with-qcp/references/reporting-guide.md)。记录只写职责相关的当前事实，不复制 formal source。昨天以前且不再活动的旧记录移入 folded_history/；当前审阅引用的记录、未解决源码错误和未批准设计变更留在原位。
