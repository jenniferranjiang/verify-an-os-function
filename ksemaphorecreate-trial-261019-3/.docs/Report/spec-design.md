# KSemaphoreCreate spec 设计

本次只设计与审阅；canonical 约定写在 `annotated_C/src/<symbol>.c`，每个直接 callee 的完整声明约定在 caller 文件中。本文不复制正式约定。所有判断来自本次权威源码、board/stm32f103-nano/config、当前共享库与本 trial 的分析；没有使用历史实验；本次临界区接口按用户要求参考当前 VRTOS 的 spec。

指定入口仅允许尚未进入 CRTOS 临界区协议且不持有协议保护资源的调用者。硬件中断状态及其保存、恢复不在本次验证范围；前后只要求处于抽象临界区协议外。`_SemaphoreCreate` 继承这个真实调用状态；ID/链表辅助函数只接收自身操作所需的内存，不要求调用者在临界区外。

2026-10-21 按用户要求，两个创建函数及 caller-local 副本不再将 `val` 的 uint16 数值范围列入 Require；两个函数入口以 `by local` 注解从参数存储信息提取该范围，生成脚本同步调整。该推导的依据是 `store_ushort` 的范围约束，后续仍需完成对应 QCP/Rocq 证明；本次修改不恢复旧审阅结论。

从入口展开得到七个非 trusted 函数：KSemaphoreCreate、_SemaphoreCreate、IdInsertObj、AllocId、InsertObj、InitDoubleLinkList、DoubleLinkListInsertNodeAfter。六个 trusted 符号为 x_malloc、x_free、memset、CriticalAreaLock、CriticalAreaUnLock、KPrintf。静态 done.SemaphoreCreate 唯一指向 _SemaphoreCreate。详细源位置、预处理和归一证据见 `checks/source-bodies.json` 及 C 分析报告。

返回路径如下。

- x_malloc 返回 NULL：立即返回 -5，没有进入临界区，没有发布对象。
- 分配成功，32 字节完整清零后进入临界区；ID 耗尽：IdInsertObj 返回 -1，完整零对象仍由当前执行私有持有，先 x_free 再解锁，返回 -5。共享 ID 管理集合与 semaphore 列表不变；环境在取得临界区前的合法推进不混同于本次操作的 effect。
- ID 分配成功：写入 ID 并接入 ID hash bucket，私有剩余字段继续留在创建者手中；写 value、初始化空 pend_list，再接入全局 semaphore 列表，完成发布。归还共享 invariant 并回到 OutsideCritical，返回分配的 ID。

AllocId 按 bitmap 字节及位从小到大选择第一个空闲 ID；全部字节 255 返回 -1。源码另有尾字节越界保护；当前 id_max=128，末字节无 padding 位，该条件不会产生额外可达失败。InsertObj 对尚为零的空 bucket 先初始化，然后插入；对已初始化的空或非空 bucket 直接插入。链表 primitive 覆盖空链表 head==next 的字段别名情形。

NULL_PARAM_CHECK 在当前头文件强制 KERNEL_DEBUG 的条件下仍有 KPrintf 和无限循环，不能因为 config 关闭 KERNEL_DEBUG 就删去。所有这些宏检查的输入来自已拥有的非零 manager/node，故该入口闭包中不会执行失败分支；切片仍完整保存分支。成功日志的 KDBG_IPC=0，两个 KPrintf 调用保留在 if(0) 分支，并提供 trusted caller-local contract。KDEBUG_NOT_IN_INTERRUPT 在 semaphore.c 被局部重定义为空，不引入 ISR 或硬件中断开启假设。

预计后续实现证明需从已审阅对象谓词提取字段视图并重组发布 invariant；本次不生成或运行这些实现证明。loop invariant 和局部 entailment 的证明不作为本次已完成结果。

`logic.h` 只声明经 Rocq 检查的语义组件，不集中存放函数约定。`checks/write_specs.py` 从本 trial 的源码证据生成切片，并把 canonical 文本原样同步到各 caller；它是同步辅助工具，正式审阅对象仍是七份 `.c`。`checks/caller-map.json` 给出要逐项核对的直接依赖。七份切片已通过 `gcc -m32 -std=gnu11 -fsyntax-only -Wall -Wextra -Werror`，输出在 `checks/spec-c-syntax.log`。

各有逻辑参数的调用已给出 `where`：wrapper 传同一 sg/before/X；lock 返回的当前观察命名为 locked；ID 管理操作使用当前 semaphore manager 状态；创建失败解锁归还 locked，成功则归还只替换 semaphore 模块的发布后状态。两个 DLL 插入点分别通过 `idbucket_first_link` 和 `semaphore_first_link` 指定原 first link，两个新节点的旧指针槽均为真实清零所得 0。空 bucket 首先自环初始化，因此同一 first-link 公式覆盖惰性初始化及已初始化路径。这些实参只是设计约定的组合，不声称局部 entailment 或 C 实现已证明。

AllocId 的 canonical 使用已有通用 manager 表示，不额外加强为 id_max=128。源码按 `(id_max+7)/8` 扫描，尾字节的空位若超过 id_max 会返回 -1；因此通用 `idmanager_full` 仍准确，指定入口自然由配置实例化为 128。所有 NULL 检查所需非零条件来自合法 manager/私有节点的表示，没有额外 ISR、任务状态或硬件中断开启假设。

当前状态：2026-10-21 按用户要求删除中断状态约束；同步修改 canonical 与 caller-local contract、trusted Disable/Enable 接口及生成脚本。旧 `spec-r1-7f4d155c90f7` 审阅结论对当前版本失效。本次不宣称新的独立审阅或 C 实现证明，见 [DCHG-20261021-01](design-changes/2026-10-21-1-remove-irq-state.md)。


## Trusted 临界区接口调整

2026-10-21 用户明确要求移除本 trial 的 CriticalAreaLock/UnLock 实现，仅保留 spec；这也符合 `/home/xinra/TrustBase.md` 的 Trust Specs。删除 `annotated_C/src/CriticalAreaLock.c` 与 `CriticalAreaUnLock.c`，在 `_SemaphoreCreate.c` 保留两个 declaration-only contract 和原有调用。

参考 `/home/xinra/vrtos/annotated_C/src/headers/m_ktask.h` 中 Lock 的 ordinary 与 Unlock 的 stable spec，沿用本 trial 的参数命名和同名协议接口。Lock 取得临界区 token 与 os_inv，Unlock 在满足 guarantee 关系后交还更新的 os_inv；两个 contract 不再暴露 CriticalNest(1)。VRTOS 的 nested spec 带有 RISC-V MIE 位约束，本 trial 入口只覆盖临界区外调用且不建模硬件中断状态，因此没有引入 nested 接口。实际 lock 返回值仍传给 Unlock，但本抽象不证明其硬件保存/恢复语义。

Rocq predicate 定义未改；现存 CriticalNest 定义不再被这两个调用规格使用，锁计数器及 Disable/Enable 的实现由 trusted 边界覆盖。生成脚本只生成七个非 trusted 函数，审计脚本在这两个原语处停止递归。`checks/source-bodies.json` 中两函数的源码提取证据保留用于参考，不代表当前证明目标；旧 revision 清单及已有审阅记录仍为历史证据。

自检通过：七份切片均通过 GCC ILP32 语法和告警检查；结构审计核对当前源码指纹、保留的完整 C 函数体、全部调用和 caller-local contract 一致性。生成前后逐字比较，除 `_SemaphoreCreate.c` 的两个 trusted spec 和说明外，其余六份切片未改变；caller 函数体未改变。两份 spec 与 VRTOS ordinary/stable 规格在逻辑参数改名后相同。

本次完成接口修改与自检，未运行 QCP parser、symbolic、VC 或 C 实现证明。此前移除中断状态后的 predicate/spec 尚未重新独立审阅，本次不恢复旧 review-passed，也不声称实现已验证。
