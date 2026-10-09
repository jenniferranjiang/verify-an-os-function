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

## Trial 与工程路径

CRTOS 根目录是 /home/xinra/crtos/。默认 trial 是该根目录的直接子目录：

~~~text
<function-name>-trial-YYMMDD-N/
  annotated_C/src/
  lib/
  VC/
  .docs/Report/
    folded_history/
~~~

用户指定独立目录时使用用户路径。开始 C 分析前解析并报告绝对路径；不得覆盖现有内容，也不得把 trial 建在权威源码子树内。

创建或进入 trial 时，创建或维护 trial 根自己的 _CoqProject。它列出实际使用的外部 -R/-Q 路径，并把本地 lib/ 映射到与 Makefile、QCP 命令及 Require 完全一致的逻辑路径。任何一处逻辑路径变化时同步其余位置并重新编译受影响 .vo。

当前 Coq 8.18--8.20 的 VsRocq 进程不能可靠地为每个文档应用局部 _CoqProject load path。在这些版本下，还要把当前活动 trial 的外部路径和 lib 映射同步到 CRTOS 根 .vscode/settings.json 的 vsrocq.args，并确保 *.v 映射为 rocq。当前 VsRocq 不展开 vsrocq.args 中的 ${workspaceFolder}，这里写已解析且存在的绝对路径。切换 trial 时替换旧 trial 专属映射，不累积多个映射到同一逻辑路径的 lib。Coq/VsRocq 升级后先实测，不延续未经验证的版本假设。

## QCP 与复用位置

- QCP 参考项目固定在 /home/xinra/qcp-binary-democases/。
- CRTOS 已有 predicate/lemma 在 /home/xinra/crtos/task-proof/lib/。
- 已有函数 spec 在 /home/xinra/crtos/task-proof/annotated_C/。
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

- YYYY-MM-DD-N-predicate-design.md：predicate 设计、review issues、reviewed revision 和结论；
- spec review 记录：路径、effect、frame、闭包、issues 和结论；
- final integrity：QCP 结果、VC/证明计数、Rocq 编译和 trust scan。

记录只写职责相关的关键修改、检查结论、必要复现命令和 blocker，不复制 formal source。昨天以前且不再活动的旧记录移入 folded_history/；当前审阅引用的记录留在原位。
