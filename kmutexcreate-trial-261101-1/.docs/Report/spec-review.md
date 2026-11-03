# 完整创建调用闭包的 spec 独立审阅

结论：**review-passed（创建设计范围）**。审阅者为独立 `design_review` agent，spec作者为main agent。先完成 [predicate审阅](predicate-review.md)，再审本规格；没有修改正式定义或C实现。

本次spec revision为 `55bbd4bac08ceb62317b2e176f7ce83d5bc6a46314248abfd8a89f9edc497929`，逐文件哈希见 [spec-manifest.json](../../checks/spec-manifest.json)，审阅时重新核对一致。固定使用predicate revision `038457b98a07c2fa559a7ec4ea7d63e980af6b73b4a8d8782668ffd97640e036`。补齐的addr/list外部声明只完善类型接口，未改变函数contract、真实body或已审predicate。

## 闭包和源码对应

人工从适配后的KMutexCreate重新沿调用检查，完整闭包为10个symbol：

| Symbol | 本轮归类与核对结果 |
| --- | --- |
| KMutexCreate、_MutexCreate | 各有唯一同名active canonical文件；前者解析固定done分派并删除获准debug宏，后者保留原函数全部body，仅static外部化 |
| IdInsertObj | reused-spec；从根id_module_spec.h精确导入，caller与canonical相同；不把内部AllocId/InsertObj重复列为本轮实现目标 |
| InitDoubleLinkList、DoubleLinkListInsertNodeAfter | reused-spec；原body及所有原具名spec保留；创建调用选择通用dispatch_case，与caller声明相同 |
| x_malloc、x_free | TrustBase的KERNEL_MALLOC/KERNEL_FREE实际宏别名；malloc沿用原字节接口，free对本次分配原基址及完整MutexRaw资源实例化，不引入新分配器保证 |
| memset | 既有标准库字节接口；c=0、n=36处于其参数范围 |
| CriticalAreaLock、CriticalAreaUnLock | TrustBase明确的原语；沿用ordinary/stable接口和唯一系统临界区协议 |

没有残留未解析dispatch、裸prototype调用、重复active目标函数或没有分类的边。ID及allocator边界内部调用不据此声称已被本轮证明。每个callee完整规格放在caller定义之前，未通过模块spec头文件隐藏合同。[design-audit.json](../../checks/design-audit.json) 的逐字比较和原body比较与人工检查一致。类型布局与权威头的双侧ILP32检查见 [C分析](c-analysis.md)；sizeof、字段顺序、条件分支、调用顺序和返回值保持。

## 路径、资源和保证

已逐条检查两目标canonical规格及所有caller-local合同：

- malloc失败在锁外直接返回-5，不凭空执行临界区观察。没有分配对象遗留给调用者。
- ID失败时原manager返还，ID节点值允许未知；对象其余部分作为frame保留，解锁后以原malloc基址回收完整36字节，返回-5。抽象操作不附加复用spec没有给出的“ID已满”结论。
- 成功时最小空闲ID由ID接口给出，固定容量给出返回范围 `[0,128)`。新对象的ID字段与链转交manager，空pend和四个业务字段按源码初始化，管理节点及payload一同头插。旧对象、旧等待者和其他OS模块在本次原子操作中保持。解锁返还`OutsideCritical`，不能同时继续拥有已并入`os_inv`的新对象。

这些路径无本地循环或阻塞操作。调用入口与加锁时观察按已有环境关系区分，不额外断言全局入口/出口相等。上层合同显式展示返回分支、同一continuation及临界区资源；对象内部地址和布局由模块表示封装。每个load/store均可追溯至已审predicate或低层字节/DLL合同。proof-local展开、字节转换和publication重组尚未证明，本审阅只确认设计中的资源来源、结果和frame可对应源码。

## 源码错误及依赖限制

本次不能仅以“不在闭包”为由跳过源码问题。已对 [source-errors.md](source-errors.md) 的七项逐一复查其对创建前提、效果和依赖的影响；具体分析补入 [predicate审阅](predicate-review.md#源码缺陷影响复查)。M1/M5的原函数体fixture分别证实递归计数提前释放和ID窄化别名；其他项的静态路径与条件已注明，未当作真实OS运行结果。

创建合同没有承诺整个mutex模块提供正确互斥、超时、优先级或生命周期管理，也不依赖这些错误API满足此类承诺。其临界区内直接闭包未经过上述错误路径，且初始化与发布同处一个临界区。M2/M3仍可破坏任意并发环境中的共享heap；因此这里采用既有Lock交出有效`os_inv`的模块化边界，**不声称当前全部OS代码已经维护该边界**。若目标扩大到这些并发API的全模块保持性，已发现的源码缺陷将构成阻塞，当前审阅不能作为通过证据。

先前记录只讨论了回绕可被状态表示等事实，没有清楚报告它造成的功能错误，属于分析和报告遗漏。此次补充未通过加强Require、弱化已有callee合同或增加trusted函数来掩盖缺陷；已审创建设计语义没有变化。

## 检查与停止位置

36个predicate/适配模块编译通过；[SpecInterfaceCheck.v](../../checks/SpecInterfaceCheck.v) 对规格引用的Rocq符号完成类型检查，结果见 [spec-interface.log](../../checks/spec-interface.log)。全部C切片通过ILP32 GCC `-Wall -Wextra -Werror -fsyntax-only`；GCC不解析QCP注解，不能把此结果称作QCP检查通过。注解的结构、接口及语义由本次人工审阅核对。

本结论是设计审阅通过，不是C实现证明或全模块正确性结论。未启动verification-orchestrator、QCP parser/symbolic，未生成VC；没有实施C实现证明。用户所要求的本轮停止点已到达。
