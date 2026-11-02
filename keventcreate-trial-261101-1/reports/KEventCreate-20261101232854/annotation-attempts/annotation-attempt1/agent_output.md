# KEventCreate annotation

Signature: `int32 KEventCreate(uint32 options)`，调用内部 `_EventCreate(options)`。
Preconditions: 使用冻结contract的 `safeExec(LastSeen(before), abs_event_create(sg, options), X)` 和 `OutsideCritical`，不收窄uint32输入范围。
Output: 直接转发内部结果，返回-5或0..127的ID，并返还相应OutsideCritical和同一continuation；状态变化继续由已审阅的创建抽象操作描述。

本attempt保持两个冻结function contracts和所有可执行C不变，保留原有OS允许的call where。函数无循环，不加普通断言、不新增predicate。case lib只导入已审阅共享创建模块，不复制定义或添加假设。内部_EventCreate仍需由main安排其独立active-body证明；本wrapper并不代替内部证明。

正式controller检查均通过：

- formal-case-lib-design：exit0、status passed，复用188个base依赖。
- symexec：exit0、status passed，生成goal/auto/manual/goal-check。
- formal-case-lib：exit0、status passed。

本轮没有symbolic失败或annotation修正，没有failed VC comparison。生成器将4个原auto模板机械转交manual（两个return witnesses、调用前提的pure与aux witnesses），原陈述保持。生成的Admitted是待后续group owner证明的模板，没有将它们当作已证明结论；本annotation owner未编辑或证明manual。

冻结的KEventCreate和_EventCreate合同、C函数正文、公共logic.h和全局库均未修改。case lib仅新增共享模块import及中文注释，无新definition/lemma或公理。已完成当前annotation任务并停止写入，等待main finalize-delivery。
