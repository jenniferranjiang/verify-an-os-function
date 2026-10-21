当前适用状态：**invalidated（目标ABI字节编码）**。后续独立检查发现已加载typed store为大端，不能直接作为Cortex-M3小端内存解释；见 [ABI补充review](2026-10-12-4-abi-supplement-review.md)。以下保留r3当时的审阅记录及机器结果，不能继续作为未修复候选的最终通过依据。

本轮结论为 **review-passed**，仅针对用户已明确批准的 `入口 nest < 65535` 调用域。普通嵌套调用、取得current时的安全深度和单份invariant返还已在正式候选中闭合；PR-01与PR-03关闭，PR-02的r2修复保持。更深入口未验证。本结论不表示spec通过、C实现已验证或final integrity完成。

审阅者为独立 `source_analysis` agent，未编写正式predicate。对象为 **predicate-r3-16b6ee4a4e02**，manifest SHA-256 **16b6ee4a4e02383dcb7128da0c57212af2e672ccd15b15633142778e8d2d629f**。源码为 **source-r2-0c50c37013e9**，manifest **0c50c37013e9cd306791865c9deafadfa2051eaaf523ee78fdfef6b8812c4651**；配置、ARM ABI及9+6闭包不变。用户范围授权依据为 [DCHG-20261012-01](design-changes/2026-10-12-1-nesting-domain.md)。此前full review及r2 delta见 [原review记录](2026-10-12-1-predicate-review.md)。

## 审阅范围与独立检查

本次审查PR-01/03及其transitive dependency：CrtosOSPure、CrtosNestedState、CrtosOSProtocol、CrtosOSProtocolProof、CrtosOSInv、SemaphoreCritical，连同r3中文注释和设计记录。SemaphorePure、SemaphoreRep、CrtosHeapBridge的hash与已审r2相同，沿用其对象、生命周期和heap桥结论，没有重新对未改模块开展full review。

九份冻结formal文件均核对hash。独立snapshot中重编译六个受影响文件，全部exit0；重新编译PR02PendingCheck四个Qed，全部通过。对九份源中的38个定理分别Print Assumptions，依赖仅见获准的CNotation地址/sizeof接口和标准函数/命题外延性；局部去注释扫描没有新Axiom、Parameter、Admitted或admit。官方nested state record来源hash和逐字复用正文也独立核对一致。具体命令、结果和机械耗时保存在 `evidence/predicate-review-r3-check.json`，assumptions全文位于独立snapshot目录。

另独立编译 `evidence/predicate-review-r3-build/R3BoundaryCheck.v` 的七个Qed诊断：空hs来源计数必须0；dataqueue式借入；nested保存handler为1；nested rely保持完整state；入口65534内部达到65535再恢复；dataqueue式完整返还；批准域递增后的内部状态仍有效。结果绑定在 `predicate-review-r3-boundary-check.json`。这些是语义边界复核，不充当正式C目标VC。

## PR-01：普通嵌套及唯一资源返还已闭合

handler栈hs表示尚未恢复的IRQ保存值，不再把它与调度计数直接等同。该区别符合源码：裸Disable只改PRIMASK，CriticalAreaLock才另执行计数++。空hs的outside拥有协议view，heap归全局；非空hs的outside整体借入caller已经持有的完整prefix token及单份OSInvariant。Inside只带协议资源，heap单独返回。未出现保留旧token/invariant后再复制一份给callee的情形。

CrtosIRQStep要求actor拥有当前栈全部prefix；invariant拥有其补充后缀。独立核对的三个meta证明分别建立互斥、token总量保持和合法frame封闭。非空prefix不可复制，持全prefix的当前actor使环境无法执行任何一步；有限闭包因此为identity。这个结论来自正式STS定义及Qed，不是在IRQ trusted合同中假设current=before。

实际dataqueue路径可按相同资源组合：父层0→1后，borrow lemma将其Inside及increment后的heap变为内层Outside；内层IRQ保存1，计数1→2→1；返回同一caller prefix和更新heap。return lemma再恢复父层所需Inside形态及单份heap，父层最终1→0。需要的来源事实由父初态0和子调用完整scheduler保持给出。普通nest=1没有被新范围限制排除。

空hs、伪造current.nest=1的旧组合已被Inside的来源条件排除，独立诊断直接从Inside导出current.nest=0。非空hs的协议token只索引受保护投影，不是完整计数快照；这在正式注释中明示。真实计数由heap/state保留，调用者必须保留实际before并证明完整SemaphoreGuarantee，不能从projection-only token单独宣称计数保持。该接口分工不会把未恢复的物理值变成相同值。

## PR-03：授权后的精确调用域已闭合

CrtosOSValid仍允许uint16完整内部范围0..65535，原始IRQ Outside/Inside本身没有随意加cap。上界仅约束会执行++的公开入口及CriticalAreaLock调用。这样合法入口65534仍能经过真实内部65535，不会因把上界误塞进全局invariant而无法完成函数。

`semaphore_nesting_roundtrip_bounded`证明批准域内真实++/条件--往返恢复整个原state；`SemaphoreRely_preserves_create_domain`通过真实nest相等把入口上界传到IRQ取得的current。空hs时实际对外计数为0；非空hs时环境排他得到current=before，因此没有借环境推进越过安全域。Guarantee直接比较完整scheduler（含物理nest）和task，没有用归零投影隐藏65535溢出。

用户明确排除的入口65535仍不能恢复，此事实没有被撤回，也未被假装成板级不可达。PR-03关闭的依据是新增的明确范围授权与该范围内的正式规则，不是把旧诊断删除或静默加强Require。

## IRQ trusted语义与其余门禁

Cortex-M3真实Disable执行MRS PRIMASK后CPSID，Enable用MSR恢复旧值。新stack_ok编码这一已有语义：最外层保存值允许0或1，已有未恢复屏蔽层的内层保存1。没有仅从handler_ok的0/1二选一错误推出1，也没有增加第七个trusted符号、新的手写公理或把C callee body冒充verified。IRQ进入/退出的资源转移仍发生于真实Disable/Enable边界；Critical包装函数的++/--没有被当成同一个原子动作。

兼容adapter只复用官方nested state record，实际owner-aware transition、tokenview和健全性证明在本trial正式文件中。框架已安装摘要/接口不兼容的诊断有记录；没有修改根共享库或QCP工程，没有依赖旧trial。协议证明由SemaphoreCritical正式导入，位于真实dependency closure。

PR-02新增的pending=SUSPEND、task身份和ready关联没有被本轮弱化，独立正反例回归通过。对象32字节、padding、ID manager/bucket/registry/pending owner分割及分配—清零—私有—发布—退休—释放生命周期的未改结论沿用full review；新protocol未新增heap owner。当前没有影响predicate ownership、抽象语义、lifecycle、frame或后续验证的open issue。

接下来可以按用户本次一次性授权接受该明确predicate revision，进入spec工作。Spec必须把已批准的nest<65535域明示在相应入口，保持九个body及六份trusted合同的来源和一致性；该阶段仍需独立spec review。本次未执行或宣称VC、goal-check、完整coqchk和final integrity已完成。
