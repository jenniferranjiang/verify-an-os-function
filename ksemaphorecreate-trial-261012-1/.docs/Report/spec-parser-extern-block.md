这次修复只将逻辑类型声明和逻辑函数声明分开，保持已接受的 spec 语义不变。当前已完成局部修复和 Rocq 接口检查，等待独立 delta review；实际 parser 是否通过仍须由原 controller 的 annotation owner 重试确认。无需用户新增授权。

Controller 的首次 parser 在 `semaphore_logic.h:23:12` 的 `(OSHeap : ...)` 声明冒号处报告 unexpected `:`、expected `::`。此前同一 Extern Coq 块已经开始解析 `:: *` 类型 kind 声明。官方 `QCP_examples/Applications_human/minisat/solver_qcp.h:49–64`、`QCP_examples/QCP_demos_human/avl_def.h` 以及 `safeexec_def.h` 都将 kind 声明和 term 类型声明放入不同块。因此先实施最小分块修复；当前证据不支持把问题归因为 qualified type，也不需要加入新的 Rocq type alias。

实际改动仅在 `Task_C_Rules::expr` 的 kind 声明后结束 Extern 块，再在 OSHeap 前开始 term 声明块。33 个声明的名称、类型、顺序完全相同；9 个函数文件与已接受版本逐字节相同，所有 With/Require/Ensure、caller-local contracts、trusted contracts 和真实 C 行为保持。header 去注释后的 C tokens 也相同。正式 predicate、共享根库、源码和 skill 未改。

旧 header 和已接受 manifest/check 证据保存于 `evidence/spec-parser-extern-block-fix/`，不进入 active QCP 输入。新 annotated revision 为 `spec-r3-63d672204cb5`，manifest 为 `63d672204cb500a9bbbdced56ed2014b10a62efc9dd4f12d4b2696c2a831448f`；语义依据仍是已接受的 `spec-r2-6d54bb88379e`、`predicate-r3-16b6ee4a4e02` 和 `source-r2-0c50c37013e9`。

`evidence/spec-parser-extern-block-fix.json` 记录唯一文件变化、逐声明等价和 C tokens 保持。接口检查器已适配多个 Extern 块，重新检查 33 个类型/名字/arity、12 个复合项及 OS Assertion carrier，default coqc exit 0；生成的 Check 文件 SHA-256 与修复前完全相同，进一步确认纯接口含义未变。证据在 `evidence/spec-interface-check.json` 与 `.log`。未重跑不受影响的 C/token/布局检查，未由本作者运行 raw symexec 或 parser，也不以 coqc 成功声称 parser 成功。

分类为验证实施问题，不创建源码错误或正式语义设计变更记录。后续由主 agent 独立 delta review，并由现有 controller owner 沿既定 repair/claim/acceptance 流程进行实际重试。
