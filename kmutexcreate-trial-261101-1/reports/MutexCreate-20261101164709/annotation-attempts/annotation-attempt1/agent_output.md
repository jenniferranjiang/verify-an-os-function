# Annotation attempt 1

采用用户冻结的创建规格及现有系统协议。Signature为无参数返回int32的_MutexCreate；入口是safeExec和OutsideCritical；出口为分配/登记失败-5或成功ID[0,128)，返还OutsideCritical并保持同一continuation。没有循环。

当前修改只涉及目标C中的新增声明和body注解，以及case lib。全部九个冻结函数合同保持；可执行C body不变；没有修改公共predicate或manual VC。

case-lib导入共享KMutexCreate、DoubleLinkListSpec和SemaphoreInv，仅新增mutex_create_frame：拆出mutex模块时保留其余系统资源与原全局一致性，以便发布前后重组os_inv。没有新增基础内存模型、Axiom或Admitted。

body注解使用OS交接允许的which implies、call where、Given和by local。覆盖完整零字节到MutexZero、os_inv拆出ID/DLL、ID失败的未知值节点与私有frame回收、pend初始化、payload头插和成功发布；临界区token始终保留，解锁前恢复os_inv。ID成功范围的by local会生成证明义务，不作为额外可信假设。

执行诊断与修正：

- 原生预处理在嵌套include guard后误报#if表达式，已交main工具侧修正。当前controller统一采用保留注释和宏环境的GCC预处理，并保持Arch32/LittleEndian及共享CrtosRules。
- 首个byte转换左侧的常量36不能与symbolic中的sizeof(Mutex)直接空间匹配；改为原sizeof表达式，实际尺寸关系留给已存在的布局依据及Rocq义务。
- 新增Extern中MutexState必须按实际定义声明为list MutexAbs别名，不能声明成opaque type。
- DLL调用前payload转换仅在右侧使用局部id会丢失其前后连接；已在两侧保留已有idmanager_min_free_id事实，call where现在可求值。没有改变返回保证或callee合同。

formal-case-lib-design已通过：实际刷新外部库并编译case-lib，复用191个base产物，exit0。controller symexec现已passed并正式发布goal/auto/manual/goal-check四个文件。manual为工具生成模板，尚未证明，未手工修改。

当前manual的主要义务为sizeof/布局下的36字节转换、精确资源拆分与freshness、失败回收与safeExec连接、pending自环、payload封装、manager与管理链发布的一致性和成功continuation。已读取当前命题，未发现需要修改冻结规格的缺口。首次attempt无failed_vcs，vc_comparisons为空。

post-symexec formal-case-lib检查已passed，exit0，用时247.671138秒，191个base产物，当前case-lib重新编译成功。所有本阶段检查通过，待main finalize；不把symexec通过称为manual VC已证明。

本次完成后Flocq产物时间（UTC）：{"Zaux": "2026-11-01T08:55:45.677125+00:00", "Raux": "2026-11-01T08:55:46.708459+00:00", "Defs": "2026-11-01T09:03:48.260482+00:00"}。controller只返回native进度摘要与最终JSON，没有公开成功路径完整Make stdout；未为补日志额外重跑。

## Repair 1

freeze比较把seed的Require与随后Import ListNotations/Local Scope作为一个块。首行并未删除，但新增Require插入该块中间导致token不同。已恢复seed三行连续前缀，新增imports置后；不涉及冻结模型或C合同变化。按handoff重新检查当前case lib与symexec。

Repair 1 检查完成：design passed（135.295秒，仅CRTOS增量）、symexec passed（2.541秒）、post-lib passed（5.304秒，191个base产物复用）。导入块的原seed token已恢复；没有需要unfreeze的变更。终态报告重新写入，停止修改交main接纳。

## Repair 2

冻结提取器不把新增Require Export识别为新import块，导致seed块仍被拼接。仅将新增共享库导入改为Require Import；原seed三行和全部冻结合同不变。目标C原logic.h已直接导入同一根模型，无需case-lib重新导出。

额外核对：generated auto仍可能含工具模板Admitted；它们不是已完成证明，不能只因文件名auto而忽略。没有手改generated文件，将由controller后续真实编译/证明门禁处理。

Repair 2 当前检查：design passed（4.852秒）、symexec passed（0.841秒）；源文件冻结contract保持，实际case-lib imports不再使用Require Export。auto中有45个Admitted模板（0个Qed），manual有10个顶层Admitted，均非已完成证明。

Repair 2 post-lib passed（4.816秒），本阶段三个检查均通过。现停止文件修改，交main finalize；auto模板义务留给后续证明流程，不计为已证明。
