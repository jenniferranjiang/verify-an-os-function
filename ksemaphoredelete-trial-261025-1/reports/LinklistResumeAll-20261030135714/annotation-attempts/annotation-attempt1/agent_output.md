# LinklistResumeAll annotation 当前工作

冻结的 semaphore_waiters、KTaskWakeup 及 typed-container contract 保持不变。输出仍是原等待任务的整体唤醒效果、同一对象空等待链及完整 os_inv。

循环保存 remaining、当前状态和继续完成 remaining 后得到原整体效果的纯 continuation，避免把完整 os_inv 与其字段重复拥有。按 next 只读、exstatus 写入、ID 参数读取三次借还安排 which implies；局部 wand view 仅定义空间归还条件，构造和消费都会产生实际 VC，没有借此加入假设或占位证明。

依主线程批准的源码等价适配，将原 KTaskWakeup(task->id.id) 仅拆为同型 int32 局部变量读取和原函数调用，在二者之间恢复完整 os_inv。该拆句由工具按原调用反向归一检查，原 store/read/call 顺序保持。

当前尚在开发检查，未声明 annotation 完成或函数体已证明。

首次 design coq-check 在共享外部 kernel check 完成后，当前 case-lib 编译剩余总预算耗尽，返回 tooling/tool-timeout（900.067508s）；原 controller 结果保留。共享 kernel receipt 已为 passed 并包含 KSemaphoreDelete 依赖，按原命令在同一 attempt 重试，不跳过检查。

缓存重试进入实际 coqc，发现本地 view 文件未显式导入 Strings.String（Scope string is not declared）；已补该导入，不改 frozen 语义。

补显式字符串导入后的 design check passed（88.422745s）。首次 canonical symexec 在 body 初始化附近报 `Unsupported token <token 269> in #if expression`，尚未生成目标。最近的正式 Require 为冻结 semaphore_waiters，body 的 task/node 以 NONE 初始化；当前头定义 NONE=((void *)0)。此时尚无 symbolic state，归类为 parser/preprocessor 适配疑点，不是资源或 spec 缺口；已把原宏精确展开的工具侧诊断交 main，canonical 宏保持不变。

NONE 精确宏展开已实证消除 token269 错误：原始 before C 现在到 NULL while 正常报告缺 invariant。当前进一步遇到 symexec returncode -11：移除所有其它 body 注解后，只给原 NULL while 加 `Inv os_inv(sg,before)` 或带显式局部 store 的完整 `Inv Assert` 即崩溃，无 stderr。对照试验只有 `os_inv which implies os_inv` 可通过到缺循环不变式；从原入口纯 pending/map 关联推出非零哨兵的非平凡 which implies 也崩溃。直接 Assert false 则被正常拒绝，不可用作规避。

最小失败输入（controller 留存）：`evidence/parser-normalization/78dcfab7e8625b1f0f518cc21869718751e5a97020d66bf15095f1fad72b6dca/LinklistResumeAll.c`；显式局部 store 版本为 `711cd879771b04120702b0c9ec047c2bd37162cf8c8a3cac8b3be650cbd7ddbc`。对照原始未注解版本为 `c90fb0ca4704ba1ab4fae72d323509cf57edbce6597e351caad90a5f568dd066`。已恢复完整首版注解（NULL loop 保存资源，而不以 false invariant 消去）；待工具崩溃定位，未写终态报告。

更小对照：完全原始 before C（无新增 Extern/import、无辅助 view、无局部拆句）仅在 NULL while 前增加 `Inv os_inv(sg,before)`，仍 -11，耗时 0.178s。最小记录为 `evidence/parser-normalization/c7d709917496756bcdb0f6050fed5436913197495dd1043aaabfd8af7ccc7dff/LinklistResumeAll.c`。完整注解版已恢复。

## 本次交付的工具阻塞

经主线程工具侧精确 NONE 展开后，原始 body 可以正常报告缺 loop invariant；这验证了预处理修复生效。随后 returncode=-11 可由完全原始 before C 加一条 NULL while 的 `Inv os_inv(sg,before)` 重现。工具侧把 `while(1){}` 等义归一为空语句后仍 -11，输入记录为 `97e98587930328f01b27538c73a9279f81377b10f89e5977f70eb4d3de6e14ac`。显式命名 invariant 并以 `with all ==> null_wait` 覆盖所有进入分支仍 -11，记录为 `466d26fe738603090afb71ac9aa7b1849f1396d83f0f343db3b87965c5ade1b4`。这些记录均在 evidence/parser-normalization 下，controller 日志保留真实退出码，无 stderr。

当前 canonical 已恢复完整候选注解：NULL loop 保留资源并不返回，主 loop 使用 continuation，字段读写用三个 wand restore view；没有保留诊断用的 false assertion，没有删除分支，没有改冻结契约。case lib design 检查已 passed，但 full symexec 未通过，故后续资源步骤的实际 VC 尚未生成，也没有 post-symexec lib check 或实现证明完成结论。

修复边界是 QCP driver/其 parser 或 entailment 对该最小模式的崩溃，或有严格语义依据的工具输入适配。不能用加强 Require、改为 trusted API、删 NULL 分支或假设 false 规避。已停止写入，交 main finalize-delivery；工具恢复后继续同一 owner/attempt。
