# KMutexCreate 包装函数 annotation

签名为无参数int32 KMutexCreate(void)。入口使用冻结的safeExec创建操作与OutsideCritical；输出原样返回内部创建结果（-5或[0,128) ID），保留同一continuation并返还OutsideCritical。Rocq语义直接复用共享KMutexCreate库，没有新predicate或循环。

当前C已有准确选择outside_critical并传入sg/before/X的call where；OS交接明确允许该注解。两个已冻结函数合同及可执行C body保持原样。case lib只追加共享库导入，不重定义已审语义。本case不编辑或证明_MutexCreate body，也不修改共享header/global library。

首次formal-case-lib-design因外部native Make需再次写Flocq/Core/Defs.glob而遇只读文件系统失败（tool-failed，exit2）。检查发现Defs.vo时间早于其Raux.vo/Zaux.vo依赖，已向main报告，等待工具/环境协调后按同一Command继续；没有通过忽略依赖检查或修改冻结合同绕过。此时未运行symexec，未写终态报告。

共享依赖刷新完成后，按同一controller Commands重试：formal-case-lib-design passed（6.883秒，190个base vo复用）；symexec passed（0.055秒）；formal-case-lib passed（4.292秒，190个base vo复用）。未额外改动C annotation；原有call where已足够。

Generated目标已核对：失败/成功两条返回分别直接复用callee post中的after见证、返回码/范围、safeExec和OutsideCritical；调用前提对应原Require。当前manual无witness，auto输出含两条return及partial pure/partial共4个生成的Admitted模板。没有手写或修改这些模板，不将本阶段完成等同Rocq证明完成；后续仍由controller的proving与final-check处理。首次attempt无历史failed VC，因此vc_comparisons为空。

两个冻结函数contract、可执行C body、共享header和根predicate未变；case lib仅增加共享import。无新predicate、无loop、无新增信任假设或源码缺陷。终态报告写入后停止一切修改，等待main finalize。

## 同attempt repair 1

Finalize报告seed import被移除，但文件原seed三行一直逐字保留。Main定位到freeze parser不识别新增Require Export为独立导入，将其并入seed import块；将新增行改为Require Import。目标C的logic.h已直接导入根创建语义，case lib不需转导出；无规格或predicate语义变化，不需unfreeze。随后按原Commands重新检查。

Repair 1验证：design passed（4.786秒）、symexec passed、post-lib passed（4.511秒）。C文件和两个合同仍原样；只将新增导入的Export改为Import以满足freeze parser。Plan继续ready，首次attempt比较列表仍为空。现重新写终态并停止修改。
