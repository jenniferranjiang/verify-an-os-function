# Event 模型布局接口独立审阅

结论：**review-passed**。候选为 `lib/abi/EventLayoutABI.v`，SHA256 `08c16548d32b2376890e1e5d3d27f965d7800a3fe51db9056c3af863c351caef`。审阅者未编写该候选，仅只读候选、已审定义、权威/适配C声明、布局fixture及检查记录。本结论认可具体ABI适配事实，不表示字节转换、VC或C实现已获证明。

## 信任边界与事实范围

只读TrustBase已有结构体布局/对齐公理、位域展开及64位到32位适配条目。这里是对已审Event位域展开模型的具体布局实例化，事实由模型声明和GCC静态断言逐项核对，并沿用现有StructFieldOffsetAxiom的size/field接口方式；没有凭宽泛类别批准任意函数合同或功能结论。因此该候选在既有ABI工具适配信任范围内，无需把它列成新的trusted C symbol，也不需要修改TrustBase。

文件确实只新增两条可信事实：

- event_size_axiom把模型Event大小固定为EVENT_MEM_SIZE，而已审EventInv将该常量定义为36。
- event_top_level_field_offset_axiom在addr_aligned p 4前提下给出五个顶层地址等式：id=p、options=p+12、events=p+16、pend_list=p+20、link=p+28。其辅助Definition仅组合这五条等式。

这里的36及偏移属于当前切片中两个普通uint32字段的模型。权威Event仍是options:3/events:29共享一个32位字，真实ILP32总长32，pend/link偏移16/24。候选及说明清楚区分两者，未把模型布局当作真实原始ABI。

两条事实均未提供p非空、地址上下界、分配成功、对象存活、ownership、初始化值、空间蕴含或抽象状态效果。对齐也仅作为字段接口前提，沿用已有动态对象布局假设，不假定任意对象自动对齐。没有把EventZero、event_zero_bytes_obligation、资源恢复或任何生成VC直接声明为Axiom。当前CNotation的eval_addr_expr及sizeof_struct_type确为抽象Parameter；GCC静态断言不能在Rocq中直接计算这些参数，补齐接口的缺口属实。

## 复用子字段事实

已读StructFieldOffsetAxiom.mutex_field_offset_ok及mutex_field_offset_axiom。后者前提为addr_aligned p ALIGN_SIZE，ALIGN_SIZE定义等于4；其结论已包含IdNode.id=p、IdNode.link=p+4，以及node∈[p+4;p+20;p+28]时DLL.next=node、DLL.prev=node+4。

这些都是按类型解释的纯字段地址等式，原公理不要求持有Mutex对象，因此可以取其中IdNode/DLL子结论用于同一基址布局。对于冻结event_byte_layout中off∈[4;20;28]，令node=p+off即得到所需成员关系；结合本候选的五个Event顶层等式即可通过普通逻辑引理推导完整event_byte_layout。无需再公理化IdNode/DLL，也不应将该组合推导或字节拆分替换成额外公理。候选目前遵守这一边界。

## 证据与冻结接口

独立重新核对候选文件SHA，与event-layout-compile.json记录一致，coqc exit0；日志仅为既有sizeof记法覆盖警告。实际ABI证据文件名是 `checks/event-layout-abi-check.json`，包含权威和适配两个fixture的GCC -m32检查，均exit0。重新计算两份fixture、当前slice_types.h及TrustBase哈希，均与记录相符；适配fixture直接包含当前切片声明，逐项检查36字节和五个顶层偏移。

EventInv、EventState、EventOps及KEventCreate共享formal文件哈希与已审迁移记录仍一致。候选未修改冻结predicate、创建抽象操作、字段含义或函数Require/Ensure，没有把布局前提塞入Create接口以收窄输入域。后续接入只应增加该ABI模块的import和普通推导证明；仍须保留真实的字节拆分、清零到typed字段、回收、ID/DLL发布及VC证明义务。

该模块新增了两个明确的可信符号，最终依赖/假设报告应列出它们及其36字节模型限制。先前“本次设计未新增Axiom”的记录仍只描述原设计revision，不能拿来声称后续证明环境不含这两个ABI实例。此处是既有信任类别的具体接口补齐，不是Rocq从C头文件证明了ABI。

未发现阻塞候选审阅的问题。本次review未运行symbolic、VC生成或实现证明，也没有修改任何formal或源码文件。
