# 实现输入与权威源码的一致性

本次检查不重复QCP final-check；它只确认实现阶段注解/等价适配未改变原C算法及原审阅范围。当前三个active切片的可执行tokens（移除注释后）与 `.docs/reviewed/` 审阅快照比较，仅归一以下已明确授权的转换后完全一致，结果见 `../checks/implementation-source-correspondence.json`。

- `KMutexDelete`：可执行body未改；原debug宏移除、固定done分派和container API模型保持审阅版处理。
- `_MutexDelete`：把一次 `mutex->id.id` 读取保存到紧接同一调用前的uint16局部量，仍在原注销临界区，随后以该值调用同一IdRemoveObj。中间只有ghost注解，无新C副作用；不改变调用顺序或转换值。
- `LinklistResumeAll`：无初始化/增量/条件的for(;;)改为while(1)，body/break和原lock/unlock位置相同；一次task->id.id读取保存为int32局部量再传给同一KTaskWakeup。ushort值到int32的原提升保持，没有重复读取。

其它增补是by-local、where、which-implies、Given和循环不变式等验证注解。用户批准的IdRemoveObj字段规范化只改两份contract的表示，独立等价审阅见 idnode-spec-normalization-review.md；DoubleLinkListRmNode原多态spec按重复同签名prototype分开组织，保留原spec正文token，不改变C符号、定义或执行。以上均不移动临界区、不新增调度、不限制原合法返回路径。

权威mutex.c、linklist.c、当前xsconfig及人工TrustBase的hash均与原记录一致。故原 source-consistency.md 的源码/配置依据继续有效，加上本记录中的明确等价转换。本结论仍受原32位非SMP适配与用户A1/A2条件限制；原并发缺陷没有修复。若后续annotation retry改变实际body或config，需要只重查受影响部分。

这份记录不是C实现证明。各函数是否完成以各自controller的done/final-check为准，完整闭包只有所有三个新目标均完成后才可报告完成。
