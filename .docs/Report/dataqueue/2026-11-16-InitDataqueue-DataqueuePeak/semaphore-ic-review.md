# Semaphore IC调用闭包实现输入复核

最新结果：`SemaphoreCreateIC-20261118193701`已由controller返回`done`，final-check passed。9个手工顶层VC及13个split全部Qed，manual无Admitted/Abort；原生auto保留26个生成器求解结果（Admitted形式），不宣称为完整Rocq证明项。没有增加helper/lib/import/公理或修改冻结规格。实现证明覆盖零对象转换、新地址、失败完整回收和成功发布；ID/DLL仍是导入契约，malloc/memset/free依原模型。直接比较去注释但未预处理的文本发现新增空注解条件块，不能据此声明指令token不变；随后分别以IC=1/0进行同参数GCC预处理，实际可执行token均与审阅后annotation初始输入一致，源码适配结论仍适用。四份VC已登记根_CoqProject，根构建到goal_check已通过，四份.vo保留。

用户原任务要求四个本轮新增IC契约的函数体证明，本轮继续执行；不能将其标为reused-spec或因Init/DeInit已done而跳过。顺序：_SemaphoreCreate、KSemaphoreCreate、_SemaphoreDelete、KSemaphoreDelete。原生auto/manual分工保持，VC时间上限已被用户取消。

Revision：dq-semaphore-ic-canonical-20261118-r1。独立reviewer semaphore_ic_review只读复核：predicate适用性review-passed（原mapABI/global lib未改），spec/source适配review-passed。Main和reviewer分别重跑双模式检查；默认IC及宏0的OC各唯一activebody，旧OC合同/body/注解相对真实基线保持；IC业务语句仅移除批准nested Lock/Unlock，Delete等待/调度分支保留。四个IC target与原批准声明及Init/DeInit、wrapper caller一致。原crtoslatest按既有归一规则逐语句匹配，原仓库未改；双模式gcc-m32和sizeof/offset静态断言通过。

本轮没有增加lib定义、公理或trusted边界；已有库/词汇沿用已编译版本。源码准备不等于实现证明。新workflow [SemaphoreCreateIC-20261118193701](../../../../reports/SemaphoreCreateIC-20261118193701/controller_state.json)已接纳annotation并通过依赖构建，进入独立VC checking，当前不存在IC final-check完成结论。目标formal stem单独使用SemaphoreCreateIC，以保留旧OC VC而不覆盖其文件。

Annotation增加四处IC资源断言，分别支持零初始化对象拆解、ID分配失败时回收、pending链表初始化及全局发布；断言保留完整dataqueue frame，并生成实际待证VC。DLL调用明确实例化`A = SemaphoreAbs`。冻结契约及业务语句未变；IC/OC语法检查通过。这些检查不代替断言蕴含及函数效果证明。

当前实现进度：r1独立VC检查发现资源转换丢失参数范围事实；r2删除资源转换中无来源的冗余范围要求，实际参数cell及写入后的value字段仍保留。重新符号执行、接纳、独立VC checking均通过。9个manual顶层VC分为4组；zero_object已获controller接纳，1个顶层及6个split均Qed，包含32字节零对象转换和通过DLL所有权冲突证明新地址。其余failed_create、initialized_payload、publish_result正在证明。尚无整个函数final-check完成结论。

设计组织见[design.md](design.md)第Semaphore IC节。模式宏为CRTOS_DATAQUEUE_SEMAPHORE_IC，默认1；0保持原OC实现输入。当前同一canonical无需另存临时body，工具侧不增加切片/证明规则。

| canonical | 审阅时SHA256 |
| --- | --- |
| [_SemaphoreCreate](../../../../annotated_C/src/kernel/semaphore/_SemaphoreCreate.c) | `bba1c03a0e8acf4d16bf39b4b512f85c917a52414f480f7c57de856515bb2119` |
| [KSemaphoreCreate](../../../../annotated_C/src/kernel/semaphore/KSemaphoreCreate.c) | `ce668d0544a25b41493da75920fc702ac3fdeb40d971dbedc373eab80ce80e72` |
| [_SemaphoreDelete](../../../../annotated_C/src/kernel/semaphore/_SemaphoreDelete.c) | `4b4dcb06411aa099300ad20c5f77cf4c0ecf46bfb560f446db44466332f138f1` |
| [KSemaphoreDelete](../../../../annotated_C/src/kernel/semaphore/KSemaphoreDelete.c) | `43adb798d9287b812db6587b978c71e5cc665b97a7c3db7d41470d1190b711e6` |

后续wrapper run：[KSemaphoreCreateIC-20261118235343](../../../../reports/KSemaphoreCreateIC-20261118235343/controller_state.json)，已done，final-check通过；3个原生auto VC，manual无待证义务，canonical未改。四份.vo已登记根构建并恢复。

当前Delete run：[SemaphoreDeleteIC-20261118235913](../../../../reports/SemaphoreDeleteIC-20261118235913/controller_state.json)，annotation进行中。

Delete IC annotation已接纳、依赖构建通过，独立VC checking通过；14个手工顶层/11个split分为retire_object、borrow_fields、select_object、early_returns四组，正在证明。IdRemoveObj的显式IdNode字段和typed store写法由独立checker核对与原low_level_spec等价，仅解决解析类型歧义；冻结目标合同未变。双模式预处理业务token与annotation初始输入一致，OC连注释保持。此阶段无Delete final-check结论。

Delete当前3/4组接纳：select_object 4顶层/5split、early_returns 5顶层/2split、borrow_fields 4顶层/4split均Qed并获controller accepted。剩retire_object单一整体VC仍在证明，不能将其已通过的局部等式/回收检查计为函数完成。

## Delete IC当前完成结论

`SemaphoreDeleteIC-20261118235913`已done/final-check passed。14手工顶层与11split全部Qed，manual无Admitted/Abort；35原生auto结果保留生成器形式。实际证明对象选择、字段借还、非法/未命中返回和完整退役；包括地址排他、IdNode识别、16桶manager移除等式、world/dataqueue保持和32字节含padding回收。无新增lib/helper声明/import/公理或冻结规格修改。Main独立复核IC/OC预处理业务token均与annotation初始审阅输入一致。四VC已登记根构建，.vo恢复通过。后续wrapper run为[KSemaphoreDeleteIC-20261119013710](../../../../reports/KSemaphoreDeleteIC-20261119013710/controller_state.json)，annotation进行中。

## 四函数闭包完成

`KSemaphoreDeleteIC-20261119013710`已done/final-check passed，3个原生auto VC，manual无义务，canonical未改。四份.vo根构建恢复通过，Init/DeInit当前goal_check.vo检查为up to date。四个Semaphore IC函数至此均完成本轮workflow；保持各自导入ID/DLL合同、C库模型和既有ABI/IRQ依赖，不把这些边界算作本轮新证函数。Delete内部四份.vo也已恢复，默认保留。后续进入DataqueuePeak。
