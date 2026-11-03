# EventCreate annotation attempt 1：注解交付完成

本次只修改目标C的body注解和case-lib imports；九个冻结function contracts及可执行C正文保持。完整读取annotation角色文档，并按OS交接中明确允许的by local/where/which implies适配执行。复用共享EventZero/EventRaw/event_create_frame/store_event/ID/DLL，不创建同义predicate。

自然语言目标沿用冻结规格：输入uint32全域，失败返回-5；成功返回最小空闲ID，发布options低3位、events=0及空pending的完整对象，保持其他OS模块。Require/Ensure未收窄或改写。没有循环。

## 初次交付检查

- controller formal-case-lib-design：passed，active lib为导入共享定义的最小文件。
- controller symexec：最终passed，四份generated文件已由controller发布；42个生成auto占位义务保持陈述并按工具既有规则转交manual。
- controller formal-case-lib：passed。

prefill修正只涉及局部annotation：payload折回保留DLL调用需要的ID/地址事实；参数值使用options@pre并明确保留options参数槽，解决which-implies后局部权限丢失。没有假定options值变化或改函数契约。

## 初次交付时的布局缺口（现已补齐依赖）

`VC/EventCreate_goal.v:1289` 的 `_EventCreate_which_implies_wit_1` 及其 `_split_goal_spatial` 要求：对aligned p4且0<p<=UINT_MAX-sizeof(Event)，从sizeof(Event)字节的全零CharArray推出EventZero p，并导出pend/link非NULL。

现有前提没有 `sizeof("Event") = 36`，也没有 `event_byte_layout p`。`/home/xinra/crtos/lib/EventInv.v:18` 只把event_byte_layout定义为Prop；第102行的event_zero_bytes_obligation又显式要求该条件。它们不是已证明lemma。生成goal的imports及前提中没有自动生成的Event布局接口。

实际QCP库 `Rocq/SeparationLogic/CNotation.v:51` 的eval_addr_expr和sizeof_struct_type是Parameter，Rocq不能仅凭C头文件的struct声明计算其值。当前共享 `lib/StructFieldOffsetAxiom.v` 已无Event大小/偏移事实。因此这个缺口不是改tactic或补一个无前提helper便可消除；也不能把ABI的GCC检查冒充Rocq已证明的布局定理。

## 初次建议及布局依据（保留供审计）

建议沿用共享 `lib/StructFieldOffsetAxiom.v` 的可信ABI接口模式：该文件的mutex_size_axiom（第359行）以及mutex_field_offset_axiom（第361行）分别提供类型大小和aligned基址下的字段关系，注释明确这些属于显式可信基、不授予内存权限。

Event需要的大小事实为模型sizeof(Event)=36；aligned p4时需要的完整地址关系如下。

| 模型字段 | 地址/字节范围 |
| --- | --- |
| Event.id | p |
| IdNode.id | p，2字节 |
| ID padding | [p+2,p+4) |
| IdNode.link | p+4；next=p+4，prev=p+8 |
| Event.options | p+12，UInt四字节 |
| Event.events | p+16，UInt四字节 |
| Event.pend_list | p+20；next=p+20，prev=p+24 |
| Event.link | p+28；next=p+28，prev=p+32 |

最小新增可信内容可只覆盖Event大小和五个Event顶层字段地址（id/options/events/pend/link）；IdNode与DLL槽关系应优先从已有ABI接口推导，避免重复信任。也可在职责明确的Event ABI模块提供 `forall p, addr_aligned p 4 -> event_byte_layout p`，但必须说明哪些子事实复用、哪些为新增可信接口。

权威ILP32 Event是32字节：options:3/events:29共享[p+12,p+16)，pend从p+16开始，link从p+24开始。36字节及上表仅适用于本trial经批准的位域展开模型。检查证据已有 `checks/source-abi/authoritative.c`、`adapted.c` 和相应结果；不能把两份布局说成相同ABI。

此方案不需要改变函数With/Require/Ensure、抽象创建操作或Event内存字段含义，也不需要改C；它会补充当前证明环境缺少的具体可信布局事实，故需要main确认是否在已批准TrustBase范围内，若属于新信任假设则先取得用户批准。owner当前禁止新增Axiom/Parameter，且无权修改共享文件，因此没有实施该方案。若决定将布局作为新前提加入冻结Require/os_inv，则会改变批准接口，必须另外走用户确认和unfreeze/重审；不建议用该方式偷偷收窄契约。

修正后的普通字节拆分、zero到typed fields、ID与DLL发布一致性仍须完成真正的证明；提供布局接口不能把整个event_zero_bytes_obligation或生成VC直接当作axiom。不要为绕过缺口更换冻结EventZero定义或把承诺的字段资源删掉。

初次交付以dependency-gap暂停；以下记录main补齐依赖后的同attempt继续结果。


## 同attempt恢复：布局依赖已接入

main已依TrustBase既有结构体布局/位域适配范围组织独立设计、GCC ABI检查、Rocq编译和独立审阅，共享模块 `CRTOS_Verify.lib.EventLayoutABI` 已review-passed。审阅依据为 `.docs/Report/event-layout-review.md`，共享迁移记录为 `checks/event-layout-migration.json`，源SHA256为 `08c16548d32b2376890e1e5d3d27f965d7800a3fe51db9056c3af863c351caef`。

本次恢复只在 `VC/EventCreate_lib.v` 增加该共享模块的 `Require Export` 并澄清注释。该接口提供 `event_size_axiom` 和 `event_top_level_field_offset_axiom` 两条已审可信事实，限定36字节展开模型。IdNode及DLL子偏移复用既有 `mutex_field_offset_axiom` 在同一对齐基址的纯子结论；不另加公理。没有改变冻结predicate、函数合同、C执行代码或body注解，没有增加Require前提。

读取当前generated goal确认 `_EventCreate_which_implies_wit_1` 及其split仍要求真实CharArray到EventZero空间转换，前提、资源及结论未被削弱。现在goal通过EventCreate_lib导入所需具体ABI接口，原来的未解释大小/地址依赖缺口已消除；字节拆分与typed字段转换尚须由后续证明owner完成，未宣称这条VC已证明。本次handoff的failed_vcs为空，所以plan的vc_comparisons仍为空。

按handoff顺序重新运行并保留会话至终态：

- `formal-case-lib-design`：exit 0 / JSON passed，4.590672秒，复用190份base vo。
- `symexec`：exit 0 / JSON passed，1.056秒，四份generated产物完整发布；42条auto占位义务按controller既有规则保留陈述转交manual。
- `formal-case-lib`：exit 0 / JSON passed，4.500159秒，复用190份base vo。

plan已置ready；annotation阶段完成，不等同于完整C实现证明完成。未修改manual proof或控制器状态。终态report写入后停止一切写入，由main执行finalize并派发后续VC检查/证明。


## Finalize反馈修复：恢复初始化导入

finalize发现case-lib初始化模板的 `From Coq Require Import ZArith List.` 被初次替换imports时遗漏。已读取annotation_history的before快照，将完整三行初始化前缀原样恢复：基础Coq导入、ListNotations及Z_scope；核对当前文件以该完整快照为前缀。所有后加共享导入（含已审ABI）继续保留。没有改函数合同、predicate、C正文、body注解或manual证明。

按当前handoff再次顺序运行三项检查，全部exit0且JSON passed：formal-case-lib-design 5.049578秒、symexec 1.347秒、formal-case-lib 5.014153秒。生成器auto/manual SHA均与上次相同，VC陈述未变。plan维持ready，failed_vcs仍为空。终态completed写入后停止修改，交main再次finalize。


## 第二次Finalize反馈修复：import块解析兼容性

原seed全文恢复后仍被误报移除，原因是controller的case-lib声明解析器不将 `Require Export` 识别为新的import块；这两行因而并入原seed块，改变用于freeze比较的整块token。已把新增的两行改为标准 `Require Import`，保持完整原seed，并保留全部所需共享依赖。没有添加dummy定义、修改controller或unfreeze。

使用controller自身 `spec_freeze.extract_lib` 只读提取before快照及当前case-lib：原baseline所有条目逐一相等，当前解析为4个独立import块。三项controller检查再按顺序通过：formal-case-lib-design 5.654207秒、symexec 1.182秒、formal-case-lib 5.763631秒；全部exit0 / JSON passed。生成器auto/manual hash仍与上次一致，实际VC与冻结合同未变。后续证明需要ABI名时可直接使用完整限定名或普通Require Import，不依赖re-export的短名传播。

本次只改变case-lib导入写法；plan维持ready。completed报告写入后停止修改，由main执行finalize。
