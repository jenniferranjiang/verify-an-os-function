当前候选已达到 **review-ready**，提交针对 PR-01/03、用户批准调用域和相关依赖的独立 delta review；尚未自行标为 review-passed。PR-02 的 pending/task一致性沿用已独立确认的r2，并在新依赖下再次编译其正反例检查。九份正式源均通过适用编译，没有新手写Axiom、Parameter、Admitted或admit。

正式revision为 `predicate-r3-16b6ee4a4e02`，manifest SHA-256为 `16b6ee4a4e02383dcb7128da0c57212af2e672ccd15b15633142778e8d2d629f`。来源仍为 `source-r2-0c50c37013e9`（47文件，原46份字节、ARM ABI与9+6闭包不变）。实际文件与命令见 `evidence/predicate-manifest.json`、`predicate-build.json`；r1快照在`predicate-review-build/`，r2快照在`predicate-r2-snapshot/`，均只在本次新trial内，不依赖历史trial。

## 这次修复的范围

用户明确批准 **入口nest<65535，排除更深调用**，见 [DCHG-20261012-01](design-changes/2026-10-12-1-nesting-domain.md)。该上界放在会执行++的KSemaphoreCreate/_SemaphoreCreate/CriticalAreaLock入口；Outside/Inside和原始IRQ primitive本身不增加该上界。`semaphore_nesting_roundtrip_bounded`证明整个批准域中的真实加减恢复，`SemaphoreRely_preserves_create_domain`证明IRQ取得的current仍在此域。仍不声称65535→0→0满足原计数保持。

普通嵌套已有正式资源接口，不再把全部入口限制为nest0。`hs : list Z`表示caller尚未恢复的IRQ保存栈；它不等于物理nest计数，因为直接屏蔽IRQ并不执行CriticalAreaLock中的++。空hs的真实对外边界nest为0；非空hs允许持锁调用，包括当前dataqueue的nest1。SemaphoreObject、manager派生、32-byte owner矩阵、task/scheduler借用heap、分配/清零/发布/退休生命周期均保持r1/r2的设计；详见两份历史设计及正式`.v`注释。

## 新协议与唯一所有权

`CrtosOSProtocol.v`现在使用handler栈和QCP原有nat token。actor必须拥有当前栈全部prefix，invariant拥有其余后缀。IRQ进入取得一枚新token并压栈；IRQ退出返还这一枚并弹出同一个handler。没有把caller已有token留在frame后再复制给callee。

`CrtosInsideEnvironment_excluded`及`CrtosInsideEnvironment_reachable_identity`证明：caller栈非空并持完整prefix时，环境连一步都不能执行，任意有限闭包亦保持同一协议状态。`SemaphoreRely_nested_identity`据此得出nested的current=before；这不是在trusted Ensure中另加的假设。空栈Outside明确以before作为环境闭包起点，修复现成NestedCriticalCSL空栈分支没有使用该参数的问题。

`CrtosOSProtocolProof.v`证明框架要求的token互斥、总量守恒、合法frame封闭三项性质。`CrtosPrefixTokens_not_duplicable`排除非空caller prefix被复制。该证明文件由SemaphoreCritical显式导入，属于真实formal dependency closure，不是仅放在报告外的孤立检查。

物理nest完整保留在SchedulerState及heap中。STS只使用`CrtosOSProtected`投影，避免把IRQ进入与随后++错误当成同一个原子事件；Guarantee仍比较真实完整scheduler，不能借投影隐藏计数变化。Inside另外保留空caller栈来源的current.nest=0事实，避免仅凭去nest投影伪装一个非零原始计数。`SemaphoreIRQEnter_preserves_origin`和`SemaphoreIRQExit_outside_facts`证明原合同已有Rely/Guarantee足以恢复这些来源条件，无需给原始IRQ接口增加cap。

## 实际caller的借入与返还

`SemaphoreOutsideCritical sg hs before`在hs为空时只拥有外部协议view，OS heap仍归全局；hs非空时包含caller的协议view及它已经持有的单份OS invariant。Disable将这份资源转为新Inside并单独交出相同heap；Enable在仍有caller层时将同一heap装回Outside，最外层才交回全局。

`SemaphoreInsideCritical_borrow_for_nested_call`已证明：父CriticalAreaLock返回后，Inside与increment后的invariant能够组合成内层API需要的Outside。这直接覆盖dataqueue的0→1后调用KSemaphoreCreate，内层执行1→2→1。

`SemaphoreOutsideCritical_return_to_caller`已证明相同prefix及更新heap的返还。若父层最终将成为空栈，还需要保留真实来源条件：decrement(after).nest=0；裸IRQ父的计数0、CriticalLock父的计数1均满足，而任意丢掉来源的token不能凭空产生此事实。`SemaphoreNestedCall_preserves_caller_origin`从父初态0及子API的完整scheduler保持证明CriticalLock父的该条件。因而这里没有用无条件、实际无法成立的ghost重标记掩盖caller恢复义务。

六个trusted symbols及其声明形状保持用户批准内容。内层handler=1来自真实MRS/CPSID/MSR语义：已有IRQ保存层意味着当前已屏蔽，MRS保存1；最外层仍允许保存0或1。合法handler栈在predicate/STS中编码此意义，不能声称单凭原`handler_ok`的0/1条件就能推出内层1。新C声明仍只写handler_ok、Rely、Inside及invariant，不添加独立handler1/currenteq保证；reviewer需核对这一来源语义和资源解释。

## 框架适配与检查

`CrtosNestedState.v`逐字取用官方NestedCriticalSTS的必要state record；nat token仍是框架原类型。现成`.vo`与ArrayLib摘要不兼容，直接官方源码又有版本不同的架构functor参数，这两项诊断及可编译probe已保存在`evidence/probes/`。正式adapter只取用所需record，没有复制无关module signatures或原来的宽松transition，也未改根共享库或外部QCP。官方源hash、精确取用原文及理由见`evidence/nested-state-adapter.json`。它是新trial的CRTOS-global兼容候选，不自动晋升。

复现：`python3 ksemaphorecreate-trial-261012-1/tools/check-predicates.py --revision-number 3 --incremental`。新state adapter、owner协议、标准健全性证明及所有受影响依赖已编译；未改变的representation和桥不重复证明。九份正式源含38个Qed，局部禁用构造扫描为空，记录在`predicate-local-trust-scan.json`。这些是predicate检查，不是目标VC、coqchk或final integrity完成声明。

作者当前没有已知open blocker；PR-01/03是否关闭以及此次IRQ表达是否保持批准边界，由独立delta review决定。只有新revision通过后才按用户一次性授权自动接受，并继续spec阶段。
