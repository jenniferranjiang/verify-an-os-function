本次语法修复的独立 delta review 为 **review-passed**。可以按用户的一次性授权接受 `spec-r3-63d672204cb5`，交回原 controller annotation owner 重跑 parser。这里不声称 parser、符号执行或任何 C 的 VC 已通过。

作者为 `spec_author`，审阅者为 `/root`。新 annotated manifest 为 `63d672204cb500a9bbbdced56ed2014b10a62efc9dd4f12d4b2696c2a831448f`。源码仍为 `source-r2-0c50c37013e9`，predicate 仍为 `predicate-r3-16b6ee4a4e02`。此前完整 spec review 的语义结论继续适用。

实施问题 SPEC-PARSER-01：QCP 在混合 kind 与 term 声明的 Extern 块中，读到 OSHeap 声明的冒号时期待 `::`。修复仅在最后一个 kind 声明后插入结束注释和新的 Extern Coq 块。独立比对确认这就是完整的 header 差异；33 个声明的名称、类型和次序没有变化，九个函数文件逐字节相同。官方当前 `Applications_human/minisat/solver_qcp.h` 第 49–64 行提供了相同分块写法依据。

已检查完整新 manifest 与实际文件、旧 manifest 的唯一差异，以及受影响接口检查器对多个 Extern 块的提取。重新生成的 Coq 接口检查文件与修复前 hash 相同，33 个接口和 12 个复合项的 coqc 检查成功。无需重复不受影响的 predicate、C body、ABI 和 caller contract 检查。证据见 `evidence/spec-parser-extern-block-fix.json`、其同名 snapshot 目录和 `evidence/spec-interface-check.json`。

这是验证实施中的 annotation 语法修复，无 predicate/spec 语义变更；`nest<65535` 域、六个 trusted、各返回路径与 ownership 保持原审阅结论。没有未解决的语义 blocker；是否还存在其他 parser 问题由 controller 的下一次实际执行判定。
