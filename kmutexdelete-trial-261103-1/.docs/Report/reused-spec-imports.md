# 本次复用规格的规范文件与适配

> r2 延续本文固定的来源 revision 与合同语义，但不再把这些依赖放在 active `annotated_C/src`。四个旧文件仅在 `.docs/reused-spec-snapshots/` 留存证据；本轮不为它们生成 VC，完整 declaration-only contract 位于三个 active caller 定义前。

这四个文件是根 annotated_C 的 `reused-spec` 边界。本轮不验证它们的 C 实现；内部调用由复用边界覆盖，不扩张本轮实现闭包。导入保持所有原有具名合同语义，不宣称新增证明。本文只是来源/适配记录，正式一致性与适用性仍由 spec review 检查。

| Trial 文件 | 根来源与处理 |
|---|---|
| `IdGetObj.c` | 原样复制 `annotated_C/src/IdGetObj.c`，包括 GetObj 完整 caller-local 合同与 active body。 |
| `IdRemoveObj.c` | 原样复制 `annotated_C/src/IdRemoveObj.c`；保留 high_level_spec/low_level_spec，IdGetObj/FreeId/RemoveObj 完整 caller-local 合同与 active body。调用者通常采用 low_level_spec。 |
| `DoubleLinkListRmNode.c` | 从 `annotated_C/src/headers/m_double_linklist.h` 提取原有五个具名合同（remove_ready_member/remove_sched_self/remove_self/remove_member/remove_from_head），附唯一真实定义；四条执行赋值与 `kernel/thread/double_link_remove_member.c` 及权威 double_link.c 相同。原 strategy/Extern view/正文证明注解不导入。 |
| `KTaskWakeup.c` | 从 `annotated_C/src/headers/ktask_wakeup.h` 提取三个原有具名合同（wakeup_by_id_ic/detached_sched_null_delay/semaphore_pending_head_ic）；从 `kernel/thread/ktask_wakeup.c` 提取唯一 KTaskWakeup 定义及 GetTaskWithIdnodeInfo、_KTaskWakeup 原完整 caller-local 合同。NULL_PARAM_CHECK_1 等价展开为 NULL 死循环，按 TrustBase 去掉调试输出；去掉旧 libai/VC imports、strategy 与正文证明注解。既有锁内调用的 nested-critical 适配保持。 |

四个文件统一包含 `../include/slice_types.h` 和 `../include/logic.h`，由主 agent 维护 ABI 声明和逻辑依赖。不集中建立 callee spec 头文件。下面是这些导入的必要语义 vocabulary，按职责从现有全局库导入即可：

- ID：`CRTOS_Verify.lib.IdModuleSpec`（其依赖含 idnode/idnode_abs），`Import IDNode`；StableIdmanager/VarIdmanager、store_idmanager/found/remove_ready/removeobj_post、idmanager_query/contains/remove/link/add。
- DLL：`CRTOS_Verify.lib.DoubleLinkListSpec`、`NodeSelfLinked`、`OsAssignReadyVector`、`KTaskSchedMember`；`Import DLL`；DL_Node、store_dll、store_node_self_linked、store_priority_ready_bucket、sched_link_of/node、store_task_sched_member。
- Wakeup：`CRTOS_Verify.lib.CrtosInv`、`KTaskWakeup`；StableGlobalState/VarGlobalState/TaskDescriptorAbs、os_inv、task_world_wf、KNONE/TSK_SUSPEND、get_task_with_idnode_success、ktask_wakeup_step、detached-null 与 semaphore-head 原特化词汇。GetTaskWithIdnodeInfo caller-local 还引用 `task_stable_ids`、task ID-manager 存储。
- 不导入失效的 `CRTOS_Verify.libai.KTaskWakeupProof`、`CRTOS_Verify.libai.GetTaskWithIdnodeInside` 或旧 VC 路径。它们服务旧正文证明注解，本次保留的正式合同词汇均有共享 lib 定义。

新 `LinklistResumeAll` 的 mutex 锁外场景不在这四个复用接口之中。它必须保留自身 CriticalAreaLock/UnLock，并独立设计；不能以 semaphore_waiters 的替换命名或派生特化冒充复用。

未运行 QCP parser、closure 脚本、symbolic、VC 或实现证明；仅人工源码结构核对。

## 源文件 SHA-256

- `annotated_C/src/IdGetObj.c`: `e3c81f38bc18cd95671d64d50bc5454c0b506a8c85a7aff4034c1f52da44e3d8`
- `annotated_C/src/IdRemoveObj.c`: `690d8789967fa4f704153597ea79f0741e839dc47dbe39c0869ee44a2c1bbbe3`
- `annotated_C/src/headers/m_double_linklist.h`: `d19be381da9f4adc98563bac6890d794550a6f29a916c1ba692e53bf654a1681`
- `annotated_C/src/kernel/thread/double_link_remove_member.c`: `de6b677d837aff8ad14bc3ac26a29080f0fbe3eb756082567958529c2e9d3071`
- `annotated_C/src/headers/ktask_wakeup.h`: `11bc6b4eb91287f2240ca333ec4f423bda945df002b5d7afced3a8b77e9ecb2b`
- `annotated_C/src/kernel/thread/ktask_wakeup.c`: `79eb94bfd95f0cf257d369840dbc51a0b2277c29ea98b7691981f9f734c1d7b4`

接口编译检查发现旧 `libai` 注解使用的 `KNONE` 在当前共享库不存在。trial 的 `KTaskWakeup.c` 中 GetTaskWithIdnodeInfo 本地合同将 `KNONE` 规范为 `0`，对应权威 C 的 `NONE` 零指针；这是常量等价适配，不改变未命中分支。未在 Rocq 中新增假常量或信任声明。
