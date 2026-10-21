# Nonzero 表示修正的独立来源审计

结论：当前三条 InsertObj VC 的缺口确实在已接受 representation，不是缺一个可直接引用的官方布局 lemma。可继续设计“完整 C 对象带子对象地址有效性 metadata”的最小修正；这与用户批准的完整对象语义有直接源码依据，但**不与旧 raw-byte predicate 在 Rocq 中等价**。必须重新审阅 trusted contract 的实际含义、静态初始化来源与生命周期传播，不能只增加 conjunct 后把问题称为已解决。

本记录是来源/边界诊断，非候选最终 delta review，未授予任何新 revision `review-passed`。范围为当前 source-r2-0c50c37013e9、predicate-r5-0a139d64743c、spec-r4-9f3ebc915b99，以及官方 QCP、正式根 lib 和当前权威 C。未读取其他 trial。未修改 active formal、canonical C、VC、proof、根 lib、skills、外部 QCP 或 controller 状态。候选变化中的代码不作为结论依据。

## NZ-SOURCE-01：官方接口没有可实例化的项目布局表

分类：representation/验证接口缺口；阻塞当前三条 VC。

- 官方 `Rocq/SeparationLogic/CNotation.v:51–55` 在文件顶层声明 `eval_addr_expr`、`sizeof_struct_type`、`sizeof_alias_type` 等 Parameter。
- 同文件 `:420` 的 `CNotationSig (Arch : CArchSig)` 只参数化体系结构；`:422–465` 的 primitive-size 定义/lemma 并不实例化上述 string-indexed struct/alias 大小。改变 Arch32/字节序不会给出 IdNode 字段偏移。
- `:525–556` 提供 eval、数组算术及 dot/arrow 记号等价；`:579–582` 的 field-address injectivity/global-variable-address nonzero 也不提供 `&(p->link)=p+4`。全局非零可用于直接全局名，但 generic InsertObj 没有 htable 与具体全局名的等式；即便上层持有该等式，也没有 alias stride 的数值/正性定理。
- `SeparationLogic.v:347` 另一个 `field_address` 同样是 Parameter，并非现有已证明的布局环境。
- 官方最接近的 `Rocq/examples/Applications_human/convex_hull/convex_hull_lib.v:41` 直接声明 `Axiom sizeof_point`；后面的 `sizeof_Point_eq` 使用该公理。它说明一种示例做法，不能满足本任务禁止新增用户公理的条件。
- 根 `lib/KTaskDescriptor.v:29–44` 已有 insert-ready 非零 metadata 的复用范例；根 `lib/KTaskCreate.v:770–774` 的 rollback lemma 直接把 IdNode/link 非零作为前提，不是从 raw allocation 推出这些事实的 bridge。

因此，在已检查的现有接口中没有找到“Require 一个文件即可得到真实 offset”的机制。新增本地 layout 函数本身不能使 generated VC 中现有的全局 `eval_addr_expr` 等于新函数；必须有可审计的连接机制。没有这条连接时，把编译器 ABI probe 的结果写成新 Rocq Axiom、Parameter 或假设等式不可接受。这里不声称全逻辑不可证明性，也没有尝试利用框架公理的不一致性。

独立机器 probe：`ExistingFacts.v` 使用当前 `_CoqProject` 与指定 coqc，编译返回 0。它证明当前 arm32 `isvalidptr 0`；两条已证明 lemma 的 `Print Assumptions` 都为 `Closed under the global context`。另两个 `Fail Definition ... := eq_refl` 仅检查 alias size=8、IdNode.link=p+4 不是定义归约等式，不是不可证明性的证明。命令与输出见 `probe-build.json`、`probe-build.log`。

## NZ-SOURCE-02：语义目标允许什么，不允许什么

旧 `lib/SemaphoreRep.v:16–24` 只有 p 非零的32-byte CharArray，以及三个独立 symbolic field stores；旧 `shared-candidate/arm32le/idnode.v:473` 的 BSS bucket 只有两格零值 stores。官方 `CommonAssertion.v:313` 的 `isvalidptr` 允许零，`:317` 的 pointer value 也允许零。故旧谓词没有所需地址域信息。这是正式逻辑上的加强，不能标成 alpha-equivalent 或纯记号替换。

但用户第四节批准的 allocator 产物是“完整的32-byte未初始化 semaphore 对象”，第五节又明确要求 Cortex-M3 下结构布局、完整 lifecycle 与每字节 owner；并非批准任意32个字节和任意无关 symbolic field 地址。权威 `xs_sem.h` 的真实 struct 与 `semaphore.c:41–68` 创建路径把分配结果当作完整 Semaphore 使用：IdNode、pending-list 和 registry link 都是对象内部子对象。`evidence/source-abi.c:19–31` 及 source-check-result 的 ARM 编译记录确认 id=0、id.link=4、pending=16、registry=24，32-byte完整块覆盖全部字段。有效非空完整对象内的这些子对象不是 NULL；它们的地址不因 memset 改变。

所以，**source-grounded 的对象有效性 metadata 可以作为原批准 typed-object 语义的表示修正候选**，不会仅因新旧 Rocq 谓词不等价就必然要求用户 unfreeze。自动接受仍必须等独立 predicate/spec review，无 open blocker。审阅必须明确：新增事实来自 C 对象/已批准 allocation 边界，不是从旧 raw store 证明；不改变 malloc 失败选择、字节 ownership、零值、生命周期、IRQ 协议或任何可观察行为。

下列情况超出这个结论：metadata 放入与对象无关的任意地址约束；要求调用者另外提供子对象非零；要求 trusted memset 从旧 raw predicate 生成无来源 layout 等式；省略 NULL 分支；缩小允许的 concrete 完整对象集合；把新的纯假设伪称框架已有定理。出现这些情况必须继续修正，若确需实质改变用户约定则按停止条件处理。

## NZ-SOURCE-03：最小闭合方案与可执行通过条件

动态对象：allocation 表示在同一32-byte owner 上携带基址与被访问子对象的有效性。malloc Require 仍是 size=32/emp，NULL 返回仍是 emp；success 给出完整对象的新表示。memset Require/Ensure 使用同一份 metadata，仅改变字节内容与分解形态；不让 memset 成为隐藏的新地址有效性源。应有纯 metadata 提取和保持 lemma，以及 zeroed-private 到 detached ID 加其余字段/padding 的精确拆分、反向合并。

ID 分配失败：IdInsertObj 保留 old_id/previous/next 和 detached metadata；与保留的 value、pending、registry、padding 重新组成完整 zeroed-private 后交给 x_free。free 仅消费它而返回 emp。成功：ID-node metadata 随 ID/container representation 转交；pending/registry 子对象非零继续留给后续 InitDoubleLinkList/DoubleLinkListInsertNodeAfter，发布时可由已初始化 DLL 的非零事实恢复所需表示。不要只修复当前 IdNode.link，而把同类义务留到 `_SemaphoreCreate`。

静态对象：权威 `xs_id.h:47–57` 的 DECLARE_ID_MANAGER 声明真实连续 bucket 数组；`semaphore.c:30–31` 给 semaphore 实例及 registry 自环。BSS 值 `(0,0)` 是字段**内容**，不等于 bucket 对象地址为零。所有16个 bucket 地址有效性属于真实静态数组对象的元信息。必须写清初始 source-static resource 的 owner、所有元素的 metadata 来源、manager 指针指向这组元素，以及 registry 自环来源；再给出组装到 `store_semaphore_static_initial` 和空 `store_semaphore` 的接口/构造证明。

这里存在两个必须区分的检查层：

1. C/source 初始化对应：真实已声明数组的16个元素是有效对象，布局由权威源码/目标编译确认；这是源代码到 representation 的审阅边界，不能冒充一个 Rocq ABI 等式证明。
2. Rocq ownership 初始化：给定上述真实静态资源及其对象 metadata，构造初始 manager/registry/module invariant；该证明不得丢字节、重复 owner 或留下 unsupported premise。

仅把 `forall i, ... <> 0` 放到名为 raw 的前提里并不自动完成第1层；必须将它明示为声明数组有效性的解释并审阅 C 对应。若要求无条件从**旧** BSS 两格 stores 推出它，则现有官方接口不足。当前 active formal 只有 `store_semaphore_static_initial` 定义，active `lib` 中未找到从它建立空模块 invariant 的 lemma；这一初始化接口应随本次变更补齐，不能把 gap 单纯前移到未建模入口。

## 影响范围

三条已知失败：`InsertObj_entail_wit_2`（BSS head）、`InsertObj_entail_wit_3_1` 和 `_3_2`（detached link）。原失败报告与 annotation-attempt2 的诊断相符，不能由原样重跑解决。

谓词依赖受影响：trial 的 idnode BSS/manager 表示与相关 cases/split/merge lemma；Semaphore allocated/detached/zeroed/registered/retired/body 表示；module/OS invariant；引用这些 invariant 的 critical views。DLL 原语的字节更新本身与纯 abstract transitions 未因此变更，但所有重新编译依赖该 changed module 的产物仍须按实际依赖重建。

spec/VC 语义受影响至少包括 AllocId、InsertObj、IdInsertObj、_SemaphoreCreate、KSemaphoreCreate；trusted malloc/memset/free 的实际 caller-local contract，及经 SemaphoreOSInvariant 间接变化的 CriticalAreaLock/UnLock/IRQ 边界。需重扫 caller-local/canonical 一致性，绑定新 predicate/spec manifests，交回 controller 重生成受影响 symbolic/VC 并重证。不可沿用旧 `.vo` 或旧 goal-check 的成功作为新 revision 成功。

根正式 lib 与其他 trial 不修改，不因本地候选使其既有结论失效。纯 ABI/source manifest 在源码未变时保持；旧版本 machine proof 仍是旧版本命题的证据，新语义结论须重新绑定和检查。最终 VC 数由实际生成而非历史数字决定。

下一步：等待作者固定候选 manifest，独立检查上述来源与构造接口、compile/typecheck 和 trusted-contract semantic delta；满足条件后再给 predicate verdict，之后独立 spec delta review。当前记录不等于候选已通过，也不认定必须停止请求用户。
