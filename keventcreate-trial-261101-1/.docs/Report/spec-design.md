# KEventCreate 设计范围

本轮为 2026-11-01 全新实验，只设计并审阅，不进入实现证明。
正式函数合同仅位于 `annotated_C/src/*.c`；本记录不复制 With/Require/Ensure。

## 完整调用闭包与复用边界

按适配后的 active body 从 KEventCreate 逐层人工扫描：

| symbol | 分类 | 正式来源 / 依据 |
| --- | --- | --- |
| KEventCreate | 本轮新 canonical，active body | event.c:240；done.EventCreate 唯一指向 _EventCreate |
| _EventCreate | 本轮新 canonical，active body | event.c:27 |
| IdInsertObj | reused-spec | 根 annotated_C/src/headers/id_module_spec.h 中同名合同 |
| InitDoubleLinkList | reused-spec，保留已有 body | 根 annotated_C/src/InitDoubleLinkList.c |
| DoubleLinkListInsertNodeAfter | reused-spec，保留全部具名 specs/body；调用选择 dispatch_case | 根 annotated_C/src/DoubleLinkListInsertNodeAfter.c |
| x_malloc | TrustBase KERNEL_MALLOC 边界 | 采用根 m_ktask.h 的 delay_object 合同；宏映射见源码分析 |
| memset | TrustBase C 标准库边界 | 根 m_ktask.h；本场景 c=0、完整对象大小 |
| CriticalAreaLock | TrustBase 明列 symbol | 全局现有 ordinary 临界区协议，借出 os_inv |
| CriticalAreaUnLock | TrustBase 明列 symbol | 全局现有 stable 临界区协议，归还 os_inv |
| x_free | TrustBase KERNEL_FREE 边界 | 以完整 EventRaw 实例化；必须使用本次 malloc 原基址 |

KEventCreate 只有一个直接调用；_EventCreate 有八个不同直接 callee。
三个 reused-spec 及五个 TrustBase 边界停止递归，没有其他调用、未解析分派或新 trusted symbol。
Imported IdInsertObj 是 declaration-only 合法复用边界，不冒充本轮实现目标。
DLL 文件保留 body 也不构成本轮 VC/实现证明目标。

## 返回路径与资源

1. malloc 返回 NULL：未取得共享 invariant，返回 -5；caller 的 OutsideCritical 原样保留。
2. malloc 成功、ID 插入失败：零化对象的 ID 节点可能被复用合同忘记值；manager 保持不变，完整对象恢复为 EventRaw；先 unlock，再用原基址 free，返回 -5。不得断言 ID 已满或仍是全零对象。
3. 成功：返回最小空闲 ID（0..127），options 保留输入低三位，events=0，空 pending，自管理链及 ID 桶均头插，整个对象的所有权转交 os_inv。函数不保留指针或 private object。

所有路径不阻塞；环境可在入锁前推进，前态与加锁时态不能强制相等。
抽象 program 单独表达成功/失败及其他 OS 模块的 frame，外层 contract 用 safeExec 和同一个 continuation 连结。
本次不增加 options∈{0,1}、仅低三位可非零、分配必成功或 ID 必不满等前提。

## 源码适配及布局

debug 宏删除、done 固定分派解析、static-to-slice-external 采用既有规则。
位域适配明确区分：权威 ILP32 Event 为32字节，options:3/events:29共用一个32位存储单元；模型各为独立 uint32，总大小36字节，pend/link 偏移从16/24改为20/28。
这属于 TrustBase 已授权位域适配，不声称两个布局 ABI 相同。实际调用 sizeof 在各自模型中求值。
切片把 options 位域写入显式写为 `options & 7U`，保持所有 uint32 输入的截断行为。
没有未受授权的算法、返回值或路径替换。

内存访问追溯：memset 拥有 malloc 交出的全部字节；ID操作使用 store_idmanager 与 insert_ready；options 写入来自 EventZero 中 UInt cell；pending 初始化来自独立 NodeZero；管理链插入使用 store_dll、store_event payload 和独立 link 节点。padding 始终留在私有或发布对象中，不丢弃或重叠拥有。转换、发布及恢复的待证义务记录在 predicate 设计，不用公理或 Admitted 当作既证结论。

本轮只进行 Rocq 编译/接口类型检查、GCC C 结构及布局检查、人工源码及完整闭包审阅。不调用 QCP parser、closure script、symbolic、VC 或 verification-orchestrator。
