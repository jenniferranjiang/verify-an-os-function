# FindEventById annotation attempt 1

冻结规格未修改。输入0<=id<65536、abs_find_event/safeExec及OutsideCritical；返回NULL或同ID Event地址，并恢复OutsideCritical与同一continuation。无循环；可执行C顺序、分支与调用保持不变。根共享库、共享logic头和其他case未改。

case-lib只新增find_event_manager_frame，组合现有event_create_frame和Event管理DLL/payload，在借出ID manager期间保留精确frame。目标C增加本case import/Extern以及5处which implies：借出manager、未命中恢复、未命中推进safeExec、命中恢复并找回对象基址、命中推进safeExec；where绑定实际sg/前后态/manager参数。没有新增假设或更强Require。

诊断及修复：初次symexec在IdGetObj处只有os_inv，不能匹配store_idmanager；通过显式借出view修复。随后QCP报局部id权限丢失：which implies左侧读取id，而右侧未再提及它会消耗该局部cell。保留原已知的0<=id<65536在右侧，使权限和值跨该重组保留，并未增加业务条件。

检查结果：formal-case-lib-design通过；controller symexec通过且当前生成文件已发布；formal-case-lib检查通过。首次attempt没有failed_vcs，vc_comparisons为空。生成manual中的31个auto模板义务被controller提升，连同5个which-implies顶层义务共36个，仍需后续VC checking和证明；未修改或证明manual。

已检查当前return/which-implies目标的前提、资源及结果对应，没有发现需要修改冻结spec的缺口。等待main finalize-delivery；本owner从终态报告写入后停止修改。

## Same-attempt repair 1

恢复seed中原样的 `From Coq Require Import ZArith List.` 与 `Import ListNotations.`，把String/DLL/IDNode/MonadErr作为独立增量导入。之前组合导入在语义上等价，但controller冻结检查要求保留seed条目。未修改函数规格或任何formal定义。依次重跑design coq-check、symexec和case-lib检查均通过；generated VC字节哈希保持一致。

## Same-attempt repair 2

freeze按import块而非逐句比较；已将seed三句（原Require、Import ListNotations、Local Open Scope Z_scope）恢复为文件开头连续原块，新增imports在其后以新Require块开始。design/symexec/post-lib三项再次通过，VC哈希仍未改变。未解除冻结或改变规格语义。
