本轮独立 full spec review 结论为 **review-passed**。目标为当前 Cortex-M3/ILP32/非 SMP 配置下的 KSemaphoreCreate，调用域明确采用用户批准的 `nest < 65535`。当前没有影响源码忠实性、路径、返回值、effect、ownership 或 frame 的 open issue。这里批准的是待证明的规格，不宣称 C 实现已经验证。

审阅者为 main agent `/root`，annotated C 作者为独立 `spec_author`。固定对象是 **spec-r2-6d54bb88379e**，annotated manifest **6d54bb88379e3c791407f6c1eb19190cc66680164505922ba8a0f18f4a5ece11**；上游 predicate 为独立通过的 **predicate-r3-16b6ee4a4e02**，manifest **16b6ee4a4e02383dcb7128da0c57212af2e672ccd15b15633142778e8d2d629f**；源码为 **source-r2-0c50c37013e9**，manifest **0c50c37013e9cd306791865c9deafadfa2051eaaf523ee78fdfef6b8812c4651**。范围变更依据是 [DCHG-20261012-01](design-changes/2026-10-12-1-nesting-domain.md)，predicate 结论见 [r3 review](2026-10-12-3-predicate-review.md)。

## 范围、源码与结构

审阅了全部九个 canonical 文件及其 caller-local declarations，从 KSemaphoreCreate 重新核对当前源码预处理闭包。九个非 trusted symbol 均恰好拥有一个同名 active-body 文件：KSemaphoreCreate、_SemaphoreCreate、CriticalAreaLock、CriticalAreaUnLock、IdInsertObj、AllocId、InsertObj、InitDoubleLinkList、DoubleLinkListInsertNodeAfter。每个真实 call 前都有完整 Require/Ensure，存在逻辑参数时也有 With 及调用点实例化；没有集中模块 specs header，没有缺失 body 或裸 callee prototype。

本次审阅再次运行 `evidence/spec-check.py`：当前九个 body 经已记录正规化后与权威预处理源码逐 token 等价；全部 caller contracts 与 canonical contracts 一致；target 闭包仍为9个非 trusted 与6个 trusted；Cortex-M3 C 语法与切片布局静态断言通过。当前结果绑定完整 annotated manifest，未凭旧候选结果冒充新内容。

逐项审查的正规化包括唯一 done dispatch、source-static externalize、当前为空的 debug macro、KDBG_IPC=0 死分支、IRQ macro 展开、四参数 KPrintf、ILP32 x_size_t 以及 IdInsertObj 条件赋值拆句。依据与源位置见 [切片记录](spec-extraction.md) 和 `spec-extraction.json`。真实 NULL_PARAM_CHECK 的诊断参数、源行号和无限循环仍在 active body；未删除失败路径。底层链表 primitive 的最小字段形状符合该函数层次，ID/container/API 层使用具名 reviewed representation，没有逐层泄露 bitmap/桶字段。

## 路径与资源核对

| 路径或函数 | 审阅结论 |
|---|---|
| malloc 失败 | 在关中断前返回 -5，返还相同 hs/before 的 outside 资源；没有对象 ownership。 |
| ID 失败 | AllocId 未写 bitmap；IdInsertObj 原样返还 detached ID 的旧值。caller 可恢复完整清零32-byte对象并由 x_free 消费，随后减 nest、恢复 IRQ，返回 -5；不发布对象。 |
| 创建成功 | 取得 current 的首空闲 ID；写 value=val，建立空 pending，更新 ID manager/bitmap/bucket 和 registry，私有 ownership 转入发布态；最后返还相同 caller hs。 |
| CriticalAreaLock | 在真实 Disable 边界取得 token/invariant，随后执行源码 ++。已授权上界通过 Rely 传到 current；内部65535仍可表示。 |
| CriticalAreaUnLock | 完整保留非零才减一的分支；以真实 decrement 后状态交给 Enable，返还 outside。Require 的 Guarantee 和 Inside 来源事实足够支撑退出，而不删除零分支。 |
| ID helpers | 成功/满/尾部越界的返回与源码一致。失败返还原 ID-node 值，成功交出 manager ownership；合法 manager/node 权限排除 null 路径，但真实无限循环未从正文消失。 |
| DLL primitives | 初始化只改两个节点槽；插入只改四个对应槽。head==successor 的空环情形仍允许，未额外要求二者不同；其它资源由 frame 保留。 |

顶层成功与 ID 失败相对于真正 IRQ entry 时的 current 表述，不错误冻结取得临界区前可能被环境改变的 before。成功的 SemaphoreGuarantee 比较完整 task/scheduler，包括实际 nest；协议投影不替代该保持条件。非空 hs 的 nested rely identity、caller invariant 借入/返还和空 hs 来源计数事实均已在 r3 独立审阅中确认。所有有限返回路径均恢复 outside；本次没有把裸 IRQ 原语也限制到 nest<65535。

## 六个 trusted 边界

完整 declarations 均位于实际 caller 文件中。x_malloc 只接受32字节并返回 emp 或完整未初始化对象；memset 只接受零/32并转换为完整清零私有对象且返回 dest；x_free 消费该完整清零私有对象；KPrintf 为 emp→emp。三份内存 contracts 和 KPrintf 的正文与前版字节一致。

Disable/Enable 仍使用获批的 outside→inside+invariant 与 inside+更新后invariant→outside 形状；r2 只显式传递 caller handler 栈 hs。未在 declaration 中增添 handler=1、current=before 或额外 cap。nested handler 及环境保持的语义来自已经审阅的真实 IRQ stack 表示和 STS 证明。caller 的其它资源通过 frame 保留；trusted callee 不被标为 body-verified，也没有第七个 trusted symbol。

## 检查与接受

`spec-interface-check.json` 以 default Coq8.20.1/OCaml4.14.1 核对33个 Extern name/kind/type/arity、12个实际复合逻辑项以及统一 assertion carrier。两条缺失的直接 imports 已在当前 manifest 中补齐；没有修改 C 行为或批准的 contract 语义。predicate 的适用编译和独立检查结果均通过。

本轮未运行 QCP parser、symbolic、VC 或 proof，也未宣称 goal-check、coqchk 或 final integrity 已完成。根据用户本次一次性授权，main agent 接受上述明确 predicate/spec revisions，作为进入 verification-orchestrator 的冻结输入。后续实施若需改变 formal/spec 语义，必须按已授权的回退、重新审阅及 revision 规则处理；不得弱化目标或跳过 VC。
