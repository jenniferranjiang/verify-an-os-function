# KEventDelete annotation r1

Signature: void KEventDelete(int32 id).
Preconditions: 冻结的0 <= id < 65536、safeExec(LastSeen(before), abs_event_delete(id), X)和OutsideCritical，以及已批准D1/D2调用链范围。
Output: 查询未命中直接返回；命中后执行冻结的abs_event_delete_at；归还某after的OutsideCritical与unit返回continuation。公开Require/Ensure不变。

在本case库添加kevent_delete_lookup_cont，复用weakestpre及冻结抽象操作，将查询结果类型addr与最终unit结果正确衔接。两个which implies各自产生必须证明的VC，分别拆分bind与恢复命中后的删除操作；未命中路径由return_wit_1连接。无新假设、无新公理、未使用设计obligation作为已证事实。无循环，不需要loop invariant。

首次design coq-check发现case库addr名称不在直接导入作用域；改用其实际类型Z，未修改任何语义。重跑后formal-case-lib-design、symexec、formal-case-lib全部exit 0且status passed。symexec完整保留两条返回路径，生成16项顶层VC；已阅读当前goal/manual确认命中guard、范围、OutsideCritical与continuation均在对应前提中。首次attempt无历史失败VC对比。

只修改本target C注解与VC/KEventDelete_lib.v及本attempt报告；generated files完全由controller symexec发布。未修改manual proofs。continuation转换证明留给后续proving阶段，其核心可通过wp_bind/wp_ret展开完成。

Repair1: finalize反馈lib.imports seed block发生改变。seed三句保持原样，新增共享库的Require Export改为Require Import，作为freeze parser可识别的独立import block边界；无语义变化，无需unfreeze。按handoff重新运行design coq-check、symexec及formal-case-lib，三者再次exit 0且passed；生成的VC命题和原始manual hash保持不变。
