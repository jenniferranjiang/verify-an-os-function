# KMutexDelete 设计实验完成（2026-11-03）

**Predicate 与完整调用闭包 spec 均为 review-passed。** 本轮目标已完成于设计、编译和独立审阅，没有进入实现验证。

- Predicate：`kmutexdelete-predicate-r1`，SHA-256 `7a4fe9106548d5f07aca0fa278e182b37535b9d346654e7c4d30ae041da63d50`，见 [predicate-review.md](predicate-review.md)。当前正式定义在 [共享 KMutexDelete.v](/home/xinra/crtos/lib/KMutexDelete.v)。
- Spec：`S2-19632ed3e5482b4086f38e90555d504a40f14a9eb89a23fc04ccf5d377ad4271`，固定上述predicate，见 [spec-review.md](spec-review.md)。闭包为12个symbol：3个新设计函数、4个reused-spec边界、5个模型/信任边界；7个active单函数文件保存在 trial `annotated_C/src/`。
- Rocq predicate编译、100个逻辑接口签名及KOK=0的类型检查、C的ILP32语法及36字节Mutex布局检查全部通过。审阅后共享迁移及根配置重新编译/引用检查也通过，见 [shared-migration.md](shared-migration.md)。

## 结论的明确限制

用户明确批准“假设这两种情况不会发生”，本轮采用：A1，同一分配对象从查找命中到本次注销不被其他执行删除、回收或复用；A2，排空等待链到本次注销不加入新waiter。它们不冻结其他OS状态、任务、holder或mutex标量。具名环境Lock合同和受限观察操作只适用于这一调用链，不能从普通Lock合同推导或当作无条件通用接口。

**源码缺陷仍存在，源码未修复。** 反例、批准后的处理及适用范围见 [source-review.md](source-review.md)。修复建议补丁没有应用，人工TrustBase没有修改。原有CrtosInv.v、KEventCreate.v及用户skill修改均保留。

没有运行verification-orchestrator、QCP parser/symbolic、closure工具或VC生成，没有做C实现证明。新增资源桥和循环连接是已类型检查、已审阅的待证陈述；复用合同和trusted边界不计为本轮新证明。本轮不会请求或启动implement。

## 产物与追溯

源码/闭包分析：[c-analysis.md](c-analysis.md)；独立源码一致性检查：[source-consistency.md](source-consistency.md)；predicate设计：[predicate-design.md](predicate-design.md)；spec设计：[spec-design.md](spec-design.md)；复用来源：[reused-spec-imports.md](reused-spec-imports.md)。

`.docs/reviewed/` 固定原审阅快照，`../checks/spec-revision.json` 的hash对应该快照。当前trial仅切换逻辑库引用，合同语义不变；审阅版到共享版的逐文件hash与纯路径迁移对应关系在 `../checks/shared-migration.json`。根库不依赖trial，审阅副本不参与构建。
