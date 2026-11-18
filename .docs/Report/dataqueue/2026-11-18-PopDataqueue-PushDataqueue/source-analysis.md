# PopDataqueue / PushDataqueue 新实验源码分析

本轮只设计审阅。依据 `.agents/verify-os.config.json`、TrustBase、默认源码处理规则和 predicate guide 第 1 节；未运行 symbolic、VC 或实现证明。源为 `/home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/`，`thread/data_queue.c` 和 `include/xs_dataqueue.h`。沿用验证配置 ILP32、非 SMP、100Hz，无 STATIC_OBJECTS/DEFER_IPC_SCHED。源码只读；旧报告不是本轮审阅通过证据。

## 模块生命周期与资源

模块全部函数已读：Init 对调用者结构清零、分配 max_len 个未初始化 DataElem，创建 blank/data semaphore 并发布；失败调用 DeInit。原源码用零检测 semaphore 创建/删除，与合法 ID 0 冲突；现存 canonical 有历史批准的 sentinel 修复，不能称为原源码证明。DeInit 释放 base 数组并删除两个 semaphore，不释放结构。Peak 只读 front 元素，原源码判空与读取不在同锁，有竞态，现存 canonical 已修复。Pop 推进 front 不清槽；Push 写 rear 槽后推进 rear。payload 地址只是借用值，无解引用、复制或释放。

现有 `DataqueueState.v` 已以地址 map 建模结构、base、capacity、front/rear、两个 ID 和所有槽；`dataqueue_ready` 只要求 FIFO 内槽初始化，允许容量 1；`dataqueue_semaphores` 连接权威 semaphore 状态，不把计数等同 FIFO 长度。`DataqueueInv.v`/`CrtosInv.v` 已集成。新增模型应复用这些定义。

## 目标原始路径（不得遗漏）

两函数先诊断 NULL 宏/打印（规则允许移除）。timeout=-1：Obtain 对应 semaphore，忽略其结果，之后继续。timeout=0：Obtain 成功继续，失败立即返回 -ERROR（并非原错误码）。其他所有 timeout（正数和其他负数）完全跳过 Obtain。do/while(0) 仅执行一次。

Push 锁内比较 `(rear+1)%max_len != front`；成立写 rear 槽的 data/length、推进 rear；否则保持队列。解锁后无条件 Abandon sem_data、忽略返回，返回 EOK。Pop 锁内判断 front!=rear；成立读取 front 槽写两个输出并推进 front；否则输出和队列均不变。解锁后无条件 Abandon sem_blank、忽略返回，返回 EOK。模运算需要正容量；输出权限只在实际写路径必要。各 semaphore 字段原始读取在临界区外，须依据源码处理规则作最小保护或说明 caller 资源。

timeout 非零非 -1 被忽略、永久等待的错误结果被忽略、满/空后仍发布计数，都是实际行为，不能用无依据 Require 排除。旧实验 source-changes.md 曾记录统一 Obtain/check-error 及锁内缓存 ID 的批准副本修复；若本轮采用须由 main 明确授权继承依据，明确与原始路径的差异。

## 调用闭包与复用边界

根 -> KSemaphoreObtain -> 静态 done.SemaphoreObtain 唯一解析 _SemaphoreObtain；根 -> KSemaphoreAbandon -> done.SemaphoreAbandon 唯一解析 _SemaphoreAbandon。根及底层 lock/unlock 是既有 TrustBase 边界。这四个 semaphore 函数当前全局及参考项目未发现既有完整 spec，需新写。

_Obtain：SemIdInvalid 可按实际宏内联；非法 ID 或负且非 -1 timeout 返回 -ERROR；0 不转 tick，-1 不转 tick，其他调用 CalculateTickFromTimeMs。锁内 IdGetObj 失败返回 -ERROR；CONTAINER_OF 依 TrustBase；value>0 减一成功；value=0 且 wait=0 返回 -ETIMEOUT；否则 GetKTaskDescriptor、写 exstatus=0、LinklistSuspend(PRIO)，有限 wait 调 KTaskSetDelay，失败 KTaskWakeup 回滚并返回 -ENOMEMORY；解锁 KTASK_ASSIGN 后返回 task->exstatus。返回 exstatus 读取须最小加锁。无限等待可能不返回，亦可能删除/取消唤醒而返回错误，不能承诺必成功。

_Abandon：非法 ID/查找不到返回 -ERROR；pending 非空 LinklistResume 首任务，之后调度；pending 空且 value=65535 返回 -EFULL，否则 value++；成功 EOK。LinklistResume 当前无完整 canonical，需要新写；其 body 取 pending 首节点容器、task ID 后调用 KTaskWakeup，不自行改 exstatus。

可复用而不递归函数体的边界（须作者核对并记录来源 revision）：

- 全局 `kernel/id/IdGetObj.c`、`kernel/list/IsDoubleLinkListEmpty.c`；CONTAINER_OF 与 critical/KTASK_ASSIGN 使用规则边界。
- 全局 `kernel/semaphore/LinklistResumeAll.c` 内 KTaskWakeup 的完整 `wakeup_by_id_ic` 和 `semaphore_pending_head_ic` 声明，可用于回滚/Resume；须满足 ID 注册和状态前提。
- VRTOS `annotated_C/src/kernel/pendlist/linklist_suspend.c`（完整入口在 headers/linklist_suspend.h），`kernel/delay/ktask_set_delay.c`，`kernel/common/tick.c`，`kernel/task/get_ktask_descriptor.c`。这些已有契约可导入 caller-local，复用不等于本轮已证。
- VRTOS LinklistSuspend 老源码先 suspend 再 switch，新源码先拒绝非法 flag；Obtain 固定 PRIO，合法路径一致，复用时保持此适用范围。其 priority loop 按 cur_prio 降序插入，已有 list 顺序和 task 可挂起前提须检查。
- VRTOS SetDelay 正常契约限定 null/inactive delay，超半范围另有契约；不能假称覆盖 active delay 的正常执行。若调用场景不能建立此条件，应扩展设计或追踪源码，不能任意加强根 Require。

若采用以上复用边界，新写 canonical 集合为 Pop、Push、KSemaphoreObtain、_SemaphoreObtain、KSemaphoreAbandon、_SemaphoreAbandon、LinklistResume；复用接口适用性如失败，需继续闭包而非假标 trusted。全部调用无未解析 function pointer；仅 done 两个分派已由 semaphore.c 静态初始化解析。

## 草案落地后的闭包修订与自检

main 已确认继承旧修复授权，因此本轮目标 canonical 使用统一 Obtain(timeout) 并检查结果的修复副本、锁内读取待调用 semaphore ID；正 timeout 路径实际可达。原始路径仍保留在上文及 canonical 注释，不声称修复副本等价于原源码。

进一步核对发现 VRTOS LinklistSuspend 的目标仅 Msg/Event，不能直接覆盖 Semaphore；当前源码 tick 转换在乘法前扩宽，VRTOS 旧关系有32位回绕，也不适用。因此新增 canonical 扩至九个：Pop、Push、KSemaphoreObtain、_SemaphoreObtain、KSemaphoreAbandon、_SemaphoreAbandon、LinklistResume、LinklistSuspend、CalculateTickFromTimeMs。

人工沿 active body 重扫：两根只调用 lock/unlock、两个 semaphore wrapper；两个 wrapper 分别只调用底层；Obtain 调 lock/unlock、IdGetObj、CONTAINER_OF、GetKTaskDescriptor、LinklistSuspend、CalculateTickFromTimeMs、KTaskSetDelay、KTaskWakeup、KTASK_ASSIGN；Abandon 调 lock/unlock、IdGetObj、CONTAINER_OF、IsDoubleLinkListEmpty、LinklistResume、KTASK_ASSIGN；Resume 调 CONTAINER_OF_TASK_SCHED、KTaskWakeup；Suspend 调 SuspendKTask、CONTAINER_OF_TASK_SCHED、两个 list 插入叶子；tick 转换无调用。无新增未解析分派。

声明自检：两个wrapper与根/底层的 OC合同相同；Resume与Abandon内声明相同；Suspend通用及prio特化已从本轮canonical复制至Obtain。其余callee均有完整caller-local契约。SuspendKTask来自VRTOS已存在的suspend_by_id_ic：源wrapper通过GetTaskWithIdnodeInfo定位，再由固定Done.suspend=_SuspendKTask派发；本轮调用使用已登记task真实ID，诊断NULL宏差异在该调用场景不影响访问。仅复用契约，不递归该实现证明，也不宣称对任意不存在ID安全。

待独立审阅重点：复用SetDelay前置在Obtain assertS中显式检查；调度后缓存task生存条件由assertS承担；这些条件使用白名单001，不变成已证明的环境保活保证。新增符号和所有caller-local声明仍需Rocq检查与独立review，本段自检不授予review-passed。

复用来源内容版本（SHA-256，本次人工读取）：

- `annotated_C/src/kernel/id/IdGetObj.c`：`6f5447b61e00e565c578815331e1b9c4d777a6b70e17f6a653a73dc6f9349cae`
- `annotated_C/src/kernel/list/IsDoubleLinkListEmpty.c`：`4b22b601357f81ec24f89cdcfd28a186b27fc7d9db2c7930811c5cc9b14ef1ca`
- `annotated_C/src/kernel/semaphore/LinklistResumeAll.c`：`29ca9f354357150f450eed11198bff152a258c1611f8a3e3d153330f70a13b05`
- `/home/xinra/vrtos/annotated_C/src/kernel/delay/ktask_set_delay.c`：`3edf51a7eb9687e5e26167ae88498d15a106c6ad26c1622be64cd76e80c16dbd`
- `/home/xinra/vrtos/annotated_C/src/kernel/task/get_ktask_descriptor.c`：`0882837652a96e8b72fccf22ceb0db461c7502c157393ec591eee283c1fa329f`
- `/home/xinra/vrtos/annotated_C/src/kernel/pendlist/linklist_suspend.c`：`a6f3ce2b2c72d1731d0500399e714b4f7058e4ccb1a0271143c1e31725b20034`
- `annotated_C/src/kernel/list/DoubleLinkListInsertNodeBefore.c`：`220655e04c17a94dc341e899e53fc9752a79e9e1e2431f568d0bf735be45bc22`
- `annotated_C/src/kernel/list/DoubleLinkListInsertNodeAfter.c`：`9b27c23929a553aacb58221941b18f37ac08b5e8433cbe2a68c398da9eab6a81`

`semaphore_runtime_logic.h` 新增的 12 个 Extern Coq 词汇已按声明逐一生成 `Check (symbol : signature)`，仅导入正式 `KSemaphoreObtain`（及其正式依赖）并使用根 `_CoqProject` 映射、配置 Coq 8.20.1，独立类型检查退出码 0。包括 KTICK_HALF_RANGE、tick_inv、delay_list_window、suspend/obtain/abandon/SetDelay 关系，未用 QCP parser。临时检查文件已在结果写入后清理。
