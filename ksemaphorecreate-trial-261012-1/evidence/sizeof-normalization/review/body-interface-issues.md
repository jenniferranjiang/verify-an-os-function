本记录给出sizeof候选继承的两项proof-local接口问题，不归因于两处常量归一，也不把它们当作已解决。candidate所有body注解与before逐字相同，canonical契约不使用这些名字。未修改candidate、active或generated文件。

IMPL-20261016-BODY-01：`_SemaphoreCreate.c` 新增于先前annotation轮的 `Require Import Coq.Program.Basics` 在当前实际generated goal的完整preamble中有记号冲突。reviewer复制该preamble到 `ExactPreambleCheck.v`（不复制VC），指定coqc及当前_CoqProject编译在Require Import处失败：既有 `_ ∘ _` 为level12，新导入要求level40。证据 `exact-preamble-check.json`。这是实际Rocq导入错误，不是sizeof义务的逻辑反例。候选必须保留这条失败的可见性，不能宣称其完整body接口已typecheck。

IMPL-20261016-BODY-02：同一body Extern声明裸 `data`/`ptr`，注解的map及逐节点地址关系也使用裸名字，当前generated goal照此输出。已冻结trial `shared-candidate/arm32le/dll_abs.v` 真正定义的是 `getData`、`getPtr`，另有 `x.(data)`、`x.(ptr)`投影记号；投影记号不会创建可传给map的裸函数。reviewer初始 `BodyExternCheck.v` 在 `Check data` 失败，见 `body-extern-check.json`。之后仅在诊断preamble中把Basics改为Require而不Import，`Fail Check data`及`Fail Check ptr`成功确认两者缺失；实际getData/getPtr及Basics.const、List.map的期望类型成立，见 `BodyInterfaceDiagnosis.v` / `body-interface-diagnosis.json`。

诊断仅说明可能的最小方向：原annotation owner使用既有真正projection名称，避免引入冲突记号；需按既有controller边界修改注解并重新生成检查。不能通过新Axiom/Parameter/未审阅alias掩盖这些错误。`Basics.const store_semaphore_body`本身只忽略额外link地址，类型和定义归约不是新的payload保证；map/data和node.ptr约束仍必须从registry中实际mapped nodes导出，不能从Extern声明推定。

归类：verification implementation/name-resolution，当前spec的canonical和两处size参数含义不变。它们是否阻塞本轮限定spec delta结论与controller下一阶段安排由main按设计/实施边界处理；不论该安排如何，C实现完成、完整generated goal compile或final integrity都必须等待这两项及原全部VC处理完成。
