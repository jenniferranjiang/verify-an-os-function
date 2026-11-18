# crtoslatest：Dataqueue当前源码与验证范围

源码根为 `/home/xinra/crtoslatest`，版本 `a07641a0b58469ae3ea19317cce2cf48974989bb`，分析对象为XiZi_IIoT_Macro。验证配置沿用工程ILP32、非SMP、TICK_PER_SECOND=100、ID_NUM_MAX=128；这是一致使用的验证配置，不声称发现了对应已生成的硬件构建配置。

## 模块与本轮输入

Dataqueue模块包含Init、DeInit、Push、Pop、Peak。当前已有正式规格的范围为Init、初始化回滚DeInit、Peak，以及调用闭包中Create/Delete的四个Semaphore函数。Push/Pop和Obtain保留源码分析副本，尚未完成其新增函数规格；已有ID/DLL/ResumeAll契约仍作为复用边界。

DataQueue结构与DataElem布局没有变化：ILP32下分别20和8字节。队列只存payload指针和长度，不复制/释放payload。初始化时结构清零、数组槽未知；Pop不清槽。调用者提供的输出cell与共享queue分开拥有。

## 新来源差异与处理

| 项目 | 新源码事实 | 当前验证处理 |
| --- | --- | --- |
| data_queue.c | 与前期原文件逐字相同 | 保留已批准sentinel/返回码检查、统一timeout、Peak同锁及ID缓存修复/适配 |
| NULL_PARAM_CHECK | 仅诊断及计数后继续 | 按规则注释移除，不保留旧NULL_PARAM_CHECK_1正常返回模型 |
| Semaphore ID范围 | SemIdInvalid拒绝负值或大于65535 | _Delete和_Obtain副本等价内联；Delete抽象效果同步高ID早返回 |
| wrapper生命周期检查 | 当前KERNEL_STATIC_OBJECTS未启用，宏为空 | 按配置归一，保留来源说明 |
| ON_WAKE调度 | 当前KERNEL_DEFER_IPC_SCHED未启用，等同DO_KTASK_ASSIGN | 继续采用既有KTASK_ASSIGN模型 |
| Obtain | 新增非法负timeout拒绝、0等待分支、SetDelay失败回滚 | 分析副本完整刷新，并最小保护末尾exstatus读取 |
| Tick/Delay | 先扩展64位再乘；半周期检查、同锁采样插入、回绕比较 | 后续等待接口设计按新实现重新核对，当前没有新增这些函数的完整规格 |

原dataqueue的ID判断、有限timeout跳过获取、无限等待忽略失败、Peak锁外条件四项仍存在，详见 [source-errors.md](source-errors.md)。这些项在本轮验证副本中已有批准修复或规则适配，授权范围不变。

## 源码对应与规格边界

Create主体在当前配置下与旧主体一致。Delete新增ID范围拒绝，实际有效范围是0..65535，而不是ID池容量128；是否分配仍由查找决定。IC quiescent仅在通过范围检查时要求空pending和无queue引用，非法ID直接保持状态。

Init/DeInit/Peak移除诊断宏后，访问权限仍由完整结构存储或锁内os_inv承担。Peak的assertS观察条件沿用默认白名单001，不新增可信非空检查。原dataqueue适配仍以对象有效性为前提，锁内缓存ID不证明跨锁保活或排除ABA。

全局原有通用OC SemaphoreDelete与已发布queue引用的生命周期兼容性尚待设计处理；它是全局模型/接口问题，未混入原C错误清单。当前Init失败回滚使用受限IC契约，不将其推广为通用删除保证。

本次没有运行QCP parser/symbolic、生成VC或重证C函数。旧生成VC保留，涉及Delete行为和NULL模型变化的旧实现检查结论不能直接套用到新输入。当前设计与审阅结果见 [design.md](design.md)、[predicate-review.md](predicate-review.md) 和 [spec-review.md](spec-review.md)。
