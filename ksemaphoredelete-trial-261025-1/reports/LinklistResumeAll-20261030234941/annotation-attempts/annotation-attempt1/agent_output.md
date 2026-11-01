# LinklistResumeAll annotation 交付

本 attempt 的 design coq-check、最终 symexec 和 post-symexec case-lib check 均通过。最终 symbolic 退出码 0，耗时 1.008s，四类目标均由 controller 生成并发布；最后 case-lib 编译退出码 0，耗时 33.129234s。仅说明注解已可交付，不表示 VC 已证明或函数体已验证。

execution-info 将原 -11 定位到主循环 invariant 之后、空 header `for(;;)` 的处理点。主线程工具侧精确归一为 `while(1)` 后，执行实际进入循环 body，崩溃已在本轮消除。此前 NULL 模型和量化封装本身均不能单独解除崩溃；保留旧 run 的真实失败记录。canonical C 仍保留原 for、NULL 检查及冻结 contract；NULL_PARAM_CHECK_1 和空 for 归一仅发生在已记录的 parser 输入。

最终注解保持这些资源步骤：借出 next 槽读取并归还当前 os_inv；非空分支由 Given 取得实际队首和 tail，取得 descriptor 的纯关联；借出 exstatus 槽写 -ERROR 并恢复 marked os_inv；借出 ID 槽读取获准的局部 int32 参数、归还后按 semaphore_pending_head_ic 调用 Wakeup；循环以 remaining 的完成 continuation 连接原 waiting 的整体效果。该 continuation 在透明 resume_remaining_effect 中保留原 forall 语义。

两项实际 annotation 修复：which implies 中统一用逻辑 list@pre/next/target 和显式 field_addr/store，使 C 局部槽完整留在 frame，避免隐式重复或丢失；进入非空分支后使用已存在 first/tail，不在局部 pre 中重复析取。自检 generated VC 后还把 head 等式和非零事实显式加入首个借出 which 的两边，确保其独立证明确有地址定位前提。冻结 predicate/spec 无语义修改，没有添加公理或手写 Admitted，没有手改 generated 文件。

最终 parser input：`evidence/parser-normalization/091d5949bfabdee474273d28120e35065652548bed08300e3e70b465894a1c2a/LinklistResumeAll.c`。最终执行 trace：`evidence/qcp-execution-traces/116b07796adf65915c9f6bef8174dd8c638a38a4aff62e8819e85b2405e4bbba.txt`。新生成 goal 未见 dup_data_at_error；无首次 retry 的 failed_vcs，因此 vc_comparisons 为空。

当前 manual worklist 共 49 个 lemma，包含 actual function witnesses/splits 以及生成器因 imported declaration 的 `<=` 标记产出的 4 项 KTaskWakeup derive witnesses（detached、semaphore、msgqueue send/recv）。这些不是本轮新证明的 callee 函数体；已提醒 main 按既定外部契约边界处理其 scope，未擅改 frozen caller spec 或删除目标。其余 VC 的数学证明交后续 checking/proving owners，尤其包含整体效果连接与 os_inv 借还/重索引。

终态报告写入后停止所有修改，由 main 执行 finalize-delivery。
