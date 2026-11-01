# LinklistResumeAll 的 QCP 工具阻塞

以下是2026-10-30的历史阻塞记录；2026-10-31已解除工具崩溃，见文末。三个正式 run 均由 controller 接纳 infrastructure blocker，尚未生成函数 VC。
这不表示函数规格不成立，也不表示函数体已经证明。冻结 predicate/spec 未改。

证据清单及 binary/input SHA-256 见 [linklist-qcp-crash.json](../../checks/linklist-qcp-crash.json)。
最小对照：原始切片没有循环不变式时，工具正常报告缺少 invariant；只给 NULL 分支的
`while(1){}` 加 `Inv os_inv(sg,before)`，工具稳定退出 `-11`，没有 stderr。
在既定 `NULL_PARAM_CHECK_1` 模型适配下，移除全部 body 注解仍会同样崩溃。
因此不能把原因确定为某个新 view、循环不变量写法或 NULL 空循环体。

NONE 按冻结宏定义精确展开修复了此前的 token269 预处理错误；该有效适配保留。
空复合循环体改为空语句、显式 invariant 分支映射、透明一阶 map alias 均未修复崩溃；
无效的空循环体改写和 alias 已撤销，原诊断输入及日志保留。
NULL_PARAM_CHECK_1 是源码处理指南既有的模型/API 规则，已独立复核并登记为第9个有效边界，
但它也没有解除当前阻塞；其契约只描述正常返回，不承诺空指针路径终止，未声称 helper 本地已证明。

当前 driver 为 stripped binary，环境没有 gdb/lldb。后续需要 QCP 工具维护者提供可诊断版本或修复，
然后通过正式 workflow 重新验证。不能凭设计检查、模型替换、崩溃前输出或手写证明跳过缺失 VC。

正式报告：

- [原 run](../../reports/LinklistResumeAll-20261030135714/annotation-attempts/annotation-attempt1/agent_report.json)
- [适配后 run](../../reports/LinklistResumeAll-20261030144041/annotation-attempts/annotation-attempt1/agent_report.json)

完整候选函数体注解及局部资源视图保留，可供工具修复后继续。其他目标的进度见
[逐目标结果](../../checks/implementation-results.json)，不把本阻塞扩大为已通过证明的失效。

## 内置 SMT 诊断的补充结果

Run `LinklistResumeAll-20261030172855` 使用 driver 内置 `--dump-smt-vc-file` 选项，
C/库输入未改，design 检查通过；symexec 仍退出 `-11`。诊断文件实际创建但为0字节，
未给出新的修复依据，仍无函数VC。该run也已由controller记录为infrastructure blocker，
[报告](../../reports/LinklistResumeAll-20261030172855/annotation-attempts/annotation-attempt1/agent_report.json)保留实际结果。

## 2026-10-31：空头 for 兼容适配后恢复 VC 生成

用户提供的 `/home/xinra/qcp-binary-democases/` 含工作流与库源码，但 engine 二进制仍为 stripped。
启用完整 execution trace 后，最后位置落在主循环的 Get Invariant；将唯一的 `for(;;)` 精确替换为 `while (1)` 后，
同一 driver 不再退出 -11，`LinklistResumeAll-20261030234941` 能完成 symexec。
循环体及 break/continue/return 不变，canonical 已同步这一等价改写。
证据见 `checks/visible-empty-for-normalization.json` 与 `evidence/qcp-execution-traces/`。

已按独立来源复核，将四个原有 KTaskWakeup 具名外部契约的上游派生责任留在外部边界；
只在 parser 输入移除派生标记，完整契约及调用选择不变，并重新生成 VC。
这不是单纯拼写变换，也不是这些上游推导已在本地证明。详见 `checks/imported-wakeup-spec-boundary.json`。
函数体仍需完成独立 VC 审查、全部证明和 final-check；解除工具崩溃不等于验证完成。
