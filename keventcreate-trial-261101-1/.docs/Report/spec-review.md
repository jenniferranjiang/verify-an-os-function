# KEventCreate 完整调用闭包 spec 独立审阅

结论：**review-passed**。日期2026-11-01。Spec revision 为 `1c4a7b5920e164a40891b6d64dc6f18be0debede36a1c79946dd82dad5138f00`，其算法为 `checks/spec-manifest.json` 文件本身的SHA256；该manifest逐项固定10个C文件和3个公共声明头。Predicate固定使用已独立审阅通过的 `bc9e9bde2236e66d076beac531d82c6ad1175d71225e1f8477f0f46e6c2c61ca`，见 predicate-review.md。审阅者未编写本轮predicate/spec，先完成predicate审阅，再开始本报告的spec审阅。没有未解决的设计阻塞项；本结论不表示C实现已证明。

## 独立手工闭包重扫

从适配后的KEventCreate函数体开始，只有 `_EventCreate(options)`；后者按执行顺序出现 x_malloc、memset、CriticalAreaLock、IdInsertObj、失败分支CriticalAreaUnLock/x_free，以及成功分支InitDoubleLinkList、DoubleLinkListInsertNodeAfter、CriticalAreaUnLock。所有分支及return均已读过，没有额外可执行宏或未解析调用。sizeof不是函数调用。权威event.c静态done初始化唯一指向_EventCreate且没有后续写入，debug宏按TrustBase移除后不保留其内部调用。

| symbol | 唯一分类及审阅结果 |
|---|---|
| KEventCreate | 新canonical；唯一同名文件有完整active body；仅解析固定done分派、移除获准debug宏 |
| _EventCreate | 新canonical；唯一同名文件有完整active body；static-to-slice-external、位域赋值显式截断有依据 |
| IdInsertObj | reused-spec；来自根headers/id_module_spec.h，同名合同原样导入，declaration-only边界合法；停止递归AllocId/InsertObj等内部调用 |
| InitDoubleLinkList | reused-spec；根同名C文件内容原样导入，包括active body；两个指针写与原函数一致；本轮不重证body |
| DoubleLinkListInsertNodeAfter | reused-spec；根同名文件保留全部具名规格及active body；本caller明确选dispatch_case；四次指针写一致；本轮不重证body |
| x_malloc | TrustBase KERNEL_MALLOC宏对应的具体API边界；采用已有delay_object契约，NULL或完整未知字节数组 |
| memset | TrustBase C标准库API；采用已有字节数组契约；本调用c=0、长度36满足参数域 |
| CriticalAreaLock | TrustBase明列trusted symbol；ordinary接口借出InsideCritical和os_inv，允许RTrans环境推进 |
| CriticalAreaUnLock | TrustBase明列trusted symbol；stable接口消费InsideCritical、恢复后的os_inv和GTrans，交回OutsideCritical |
| x_free | TrustBase KERNEL_FREE宏对应API边界；EventRaw为完整对象的当前实例，调用使用本次malloc原始基址 |

合计10个symbol，2个新实现目标、3个复用规格边界、5个已授权API/trusted边界，分类互斥且无缺失。两个保留body的复用边界也没有额外callee。没有新增未经授权的trusted symbol，不递归已批准/复用边界内部。

## 合同、路径和资源

逐项核对caller-local与canonical：KEventCreate中的_EventCreate合同与其定义一致；_EventCreate中的八个callee合同分别与各文件相同；IdInsertObj与根来源一致，两个DLL文件原样保留。通用DLL合同以EventAbs/store_event实例化，head锚点产生实际管理链头插。没有caller私有且不受canonical管理的语义变体。

外层两个函数均直接展示OutsideCritical、safeExec、同一continuation及-5/0..127两个结果分支，功能效果由已审阅abs_event_create给出。没有opaque pre/post包住整份接口，也没有把模块函数变成bitmap/字段级公共接口。输入是uint32全域，不增加options低三位必须为0/1、只允许小于8、必分配成功或必有空闲ID的限制。

三个实际返回路径均覆盖：malloc=NULL直接-5，不进入锁；ID失败时原manager归还，未知ID字段与其余私有字段恢复EventRaw，先解锁再free，返回-5；成功时最小空闲ID登记，options低3位、events0、空pend、自管理链及ID桶头插，归还整个对象资源到os_inv后返回ID。复用ID失败接口不提供“已满”，本设计也未断言该事实。目标代码无循环或阻塞路径；抽象失败行为始终存在，不以不可能前提获得真空规格。

每次实际访问均有已审阅predicate来源：memset消费malloc完整字节数组；ID操作借出模块manager和私有insert_ready；options写使用EventZero的UInt字段；pend初始化使用独立节点槽；管理链写使用store_dll、payload和新link槽。ID、管理link、pendinglink分别转交唯一容器，不重复保留；padding随完整对象保存。未修改的任务、调度、时钟、延时、信号量、互斥量等由event_create_frame及replace_events保持，Unlock前恢复完整os_inv。内存/容器转换的待证义务已明确陈述，未偷作已证明定理使用。

锁外只持有OutsideCritical，锁内借出InsideCritical/os_inv，两个Unlock均归还正确状态；malloc/free私有资源按frame跨锁调用保持。返回时不承诺对象仍存在或全局状态等于调用入口。IRQ保存/恢复的机器语义仍是既有协议的明确边界，没有本轮扩大证明结论。

## 源码及类型证据

对照权威event.c、double_link.c、xs_event/xs_id/xs_klist/xs_base/xs_memory/xs_kdbg头和既有xsconfig核对适配；保存来源hash的source-manifest逐项重新计算一致。真实位域对象ILP32为32字节，拆位域后的验证对象36字节，两个ABI fixture分别检查；不能把后者说成真实布局。`options & 7U`在整个uint32范围与3位赋值截断一致。sizeof按适配模型求值属于TrustBase位域规则的限制，不是无条件ABI等价。size_t使用已复用头的unsigned long写法，当前ILP32与权威unsigned int具有同为32位无符号值域和传参布局；目标只传常量对象长度，无类型分派或其他差别。

独立重新核对13个spec文件hash及manifest文件hash，均与候选revision一致。检查证据包括29个predicate模块的成功编译、checks/interface.v所有typed Check成功（含With/where使用的接口）、10个切片和适配ABI的GCC结构检查。固定输入文本比较结果支持9条caller边、3个复用合同及4个保留body一致；本报告的闭包结论来自重新阅读active body，不以该文本比较替代闭包分析。

当前仅完成设计审阅；没有运行QCP parser、QCP closure脚本、symbolic、VC、verification-orchestrator或C实现证明。后续生成器布局与字节转换、各局部蕴含及整个C证明仍未完成。源错误报告中的Process/等待选项/查找生命周期问题位于本次创建闭包之外，仍须对未来全模块验证单独处理，未通过缩窄Create规格掩盖。


主 agent 后续处置：此前因源码问题暂停推进。E2的延时建立失败路径已完成候选修复、故障注入及独立增量复查；按用户最新要求，候选仅保存在trial/source_fixes/_EventProcess.c，权威源码已恢复原样；E1/E2非法输入按本轮接口使用范围说明，E3按用户不并发删除约束排除。当前原formal revision保持不变，创建函数正文及闭包未变化；本报告的设计结论继续适用。最新范围、源码revision和检查限制以[e2-fix-review.md](e2-fix-review.md)、[source-errors.md](source-errors.md)及[status.md](status.md)为准。后续实现已获用户批准，最终结果见[status.md](status.md)。
