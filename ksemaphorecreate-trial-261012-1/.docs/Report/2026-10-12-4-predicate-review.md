本轮结论为 **needs-fix**。r4的32位小端表示、两端heap桥、协议证明和18文件编译均通过独立检查；唯一未闭合项是仍重新声明官方已有的nested state record。现代框架下官方原文可以直接编译复用，原兼容障碍已不成立，应完成这一最小复用修复后固定新revision。不修改权威C或根共享文件，也不需要改变已批准语义。

对象为 **predicate-r4-1b07e9068830**，manifest SHA-256 **1b07e9068830369255a3a49aa90c66581e9845b7a74c618d35219ed9282bb105**。来源为source-r2-0c50c37013e9，调用域仍为用户批准的入口nest<65535。冻结的18份源码、manifest与配置位于 `evidence/arm32le-candidate/frozen-r4/`；本次开始及结束均检查当前18文件与冻结hash一致。设计记录 `2026-10-12-4-predicate-design.md` 已补齐并绑定该revision，纳入此次review。

## 独立检查及已通过部分

本次按框架/字节语义变化审查整个受影响dependency closure。独立复制冻结源到 `evidence/predicate-review-r4-build/`，使用现代pv-bench Coq8.20.1/OCaml4.14.2，在该snapshot内逐一重编9份共享候选和9份trial文件，18/18 exit0。随后独立编译两carrier的8个ABI Qed、PR-02四个正反例Qed、r3七个边界Qed，均通过。全部命令、21项检查、输入hash及122.436秒机械耗时见 `predicate-review-r4-check.json`。没有运行另一条QCP symbolic路径或重复全量coqchk。

根9份原source hash仍与迁移清单一致。差异逐项核查结果：KTaskPure只增加Arch32记号导入；CrtosRules和CrtosOSProtocol各有五个Arch32 LittleEndian实例参数；idnode只有store_idbuckets_replace证明中一个定义等价的change替换simpl，statement与representation原样；NestedState只有说明文字改变。其余源逐字相同。没有把callee合同、抽象状态、生命周期或nest域趁迁移改变。

两个实际加载carrier现在均为小端32位。Ptr footprint/对齐为4，UInt footprint为4，UShort footprint为2；非对称字节例 `[2,1]→258`、`[4,3,2,1]→16909060` 在两端成立，对应大端例被拒绝。这修正了ABI-01发现的实际编码问题。新版primitive sizeof从Arch32实例取得；struct/union/enum/alias大小及字段地址仍通过官方前端接口解释，未补写用户layout公理。后续controller必须继续核对实际C产物中的Semaphore32字节/field offset和x_base的32位映射，不能把predicate检查代替前端产物检查。

OSHeap两端均解释同一小端memory，原bridge保持同址字节和分离组合的证明重新编译通过；它不再被当作BE→LE转换。现代两个struct_padding仍现场Print为emp，因此原Semaphore的两段显式padding没有产生双重owner。DLL/IDNode/container与body分工、完整私有32字节、lazy bucket以及task/scheduler借用的footprint保持；变化只是多字节值的正确编码。

owner-aware IRQStep、三个STS meta性质、nested caller借入/返还、Rely排他性、current安全深度与批准上界的原statement保持，并已在新依赖下重新编译及回归。PR-02的pending=SUSPEND及合法非空pending/ready端点保持，未重新引入nest0-only范围。

对38个trial定理及ID bucket修复证明、DLL组合、TaskRTrans和Task协议meta定理独立Print Assumptions，未发现本实验新公理。新版框架把旧的opaque sizeof_front_end_type拆成透明primitive尺寸与sizeof_struct_type/sizeof_union_type/sizeof_enum_type/sizeof_alias_type接口；这些来源于官方CNotation，与eval_addr_expr及标准函数/命题外延性一同明确记录，不能误报为本次手写axiom。18份源去注释扫描无Axiom、Parameter、Admitted、admit。详情见snapshot中的assumptions输出。

## R4-REUSE-01：移除可避免的第二份nested state声明

**blocking / formal复用问题 / open。** `lib/CrtosNestedState.v`仍以Record重新声明官方 `NestedCriticalSTS.nested_critical_state`。它在旧框架接口不兼容时有明确来源，但当前已迁移到现代框架，不能继续仅靠过时的不兼容理由保留第二份类型。

本次不是假定官方.vo一定可用：直接Require现代官方NestedCriticalSTS先报“找不到物理路径”，即该单元尚未构建；随后reviewer把94行官方源码逐字复制到隔离review目录，以现代配置编译，exit0，原/副本hash完全相同。证据为 `evidence/abi-candidate-preliminary/framework/compile.json`。这排除了新的签名不兼容推测，也提供了无需改QCP安装或根库的具体复用路线。

最小修复：将未改官方源作为trial的framework-candidate输入，用独立logical prefix编译，不遮盖SimpleC.SL；CrtosNestedState只转出官方record，保留必要透明别名或调整唯一明确qualified的projection引用。必须保留 `{C : critical_STS}` 类型参数、constructor的显式C及两个projection的隐式C；不得再次Record/Inductive该类型。当前自定义owner-aware CrtosIRQStep及其证明仍使用官方state类型，不改用官方较宽松的transition或Critical view。

通过条件：正式manifest包含精确官方来源及其hash；本地adapter没有第二份record；新的imports/别名及所有受影响协议/表示文件重新编译；rely、借入/返还和唯一token/heap性质保持。完整官方文件的Module Type参数是既有框架输入，须按来源区分，不能包装成新用户公理，也不能用通配trust豁免本地手写内容。下一revision对该issue及dependency closure作delta，不重复已通过的全部设计分析。

## 当前状态

ABI-01的编码修复在r4技术层已验证；r4尚因R4-REUSE-01未获接受，旧r3的invalidated状态不撤回。nest-view草案不在这18文件范围，未审阅也未用来支撑结论。后续把官方复用修复和正式nest-view纳入新revision时，分别核对来源/类型依赖与新增view的精确分解/重组。当前没有需要用户改变行为目标、扩大trusted集合或修改根库的blocker。
