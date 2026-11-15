# Dataqueue 共享模块的源码依据

本记录依据更新后的 verify-an-os-function 及 predicate 指南 §6.5，分析模块归属和初始化交接。本轮仍只设计审阅 InitDataqueue 完整调用闭包；Push/Pop/Peak、串口及一般运行态 DeInit 是模块生命周期上下文，不扩大 C 实现证明范围。权威源码批准的句柄修复保持不变。

## 字段与生命周期

路径均相对 `/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/`。`kernel/include/xs_dataqueue.h:30–45` 定义 queue 的六字段及槽元素；front/rear 在正常运行时变化，max_len/base/sem_blank/sem_data 在正常运行时保持、初始化及回收时改变。槽只保存 payload 的地址与长度，不拥有 payload 本体。

`kernel/thread/data_queue.c:137–159` 的 Push 先 obtain blank，再锁内写 data/length 和 rear，最后解锁并 abandon data。`:184–210` 的 Pop 先 obtain data，再锁内读当前槽、推进 front，最后解锁并 abandon blank。Pop 不清空旧槽；已消费的槽仍可保留历史写入值。`:231–239` 的 Peak 不推进 front，且其空判断在最外层加锁前。模块 predicate 应覆盖这些字段、全部数组槽、正常范围和生命周期，不能仅描述 Init 完成时的全未初始化数组。

Semaphore 内存和 ID manager 继续由现有 semaphore invariant 唯一拥有。Dataqueue 的 ID 与对象身份用纯关系连接；不重复分离拥有 semaphore。obtain、queue 临界区操作与 abandon 之间存在真实中间阶段，不应未经分析就令 semaphore value 恒等于队列长度。

## 私有构造与共享发布

Init 入口由 caller 拥有完整20字节 struct（含padding），旧指针值不自动提供 pointee 权限。`:43` 的 memset 要求整块对象权限。数组由 `:49` 获取，槽内容尚未写入；构造期间 queue struct/数组暂为私有，新建 semaphore 已登记在 semaphore manager。

成功路径的交接边界为 `:68` 最外层 unlock 之前：把 queue 与数组资源接入模块 invariant，同时更新模块抽象状态。退出后 caller 不应另持同一份完整 dataqueue_storage；可以返回定位已登记对象的纯事实/共享接口。

失败路径在 `:72` unlock 时不发布 queue，私有资源保留到 `:73` DeInit；回收后只返还 caller struct，base=NULL。句柄精确结果依失败位置为(-1,-1)、(-5,-1)、(-1,-5)，不能误称全部规范化为-1。front/rear/max_len及padding由C实际保留。

一般运行态 DeInit 的 lifecycle 应描述在 IRQ 保护内从共享 invariant 取出同一对象，转入私有回收并归还 struct；本轮采用的 canonical 清理仍只针对 Init 私有失败对象。补齐模块生命周期不代表已证明一般运行态删除。

源码没有 queue registry 的真实 C 链表；模块集合/map 可表示共享资源的 ghost 登记，但不得发明具体 registry 写语句。不能因为初始化阶段暂由 caller 持有，就认定正常运行期间也永久私有。

## 条件串口共享示例与配置限定

`resources/serial/dev_serial.c:592–594` 将同一 queue pointer 保存到 SerialTx.serial_dma_queue.property 后 Init(...,8)。任务写路径 SerialDevDMAWrite 的 `:215` 调用 Push；SerialSetIsr 的 DMA_TX_DONE 分支 `:860–861` 对同一 property 调用 Pop/Peak。因此启用该分支时对象在任务和ISR之间持续共享。

这些 DMA 路径全部受 `SERIAL_USING_DMA` 控制。当前验证配置 `annotated_C/src/include/xsconfig.h` 只定义 BSP_USING_DMA，未定义 SERIAL_USING_DMA；Kconfig 默认y不等于当前宏已激活。因此这里是条件配置下的源码使用证据，不能写成当前已激活的ISR消费路径。当前 KERNEL_DATAQUEUE/KERNEL_SEMAPHORE 已激活；用户要求完整模块共享接口与组合设计，不依赖于打开特定应用DMA，不修改配置。

`kernel/thread/queue_manager.c:33–41` 通过同一 done 表公开 Init/Push/Pop/Peak/DeInit。g_queue_done 同时涉及其他 queue 类型，不能把整张表或其他模块资源重复塞进 dataqueue invariant；dispatch 可通过稳定上下文纯关系连接，具体所有权沿 queue_manager 原协议。

当前 NodeNumber 的 Init 输入仍为uint16完整范围，不应为运行态 modulo 便利无依据加强 Init Require。运行有效状态与忠实记录 Init 结果的状态可以区别；尚未验证 runtime 操作不应被标为已证。

## 源码版本

| 输入 | SHA256 |
|---|---|
| data_queue.c | 6ff659a97e06586b48d5a77de05ee9dfb5884659ace0f5eaa340daf57376c89e |
| xs_dataqueue.h | fb10a4ae331e8646d0cf26c3302c63d0b199e3bb6562d351a9130aa705454df8 |
| dev_serial.c | cdc1a4b2dcbf3610ab1cf8ad7ed57d828e5a6115a51010d9691b57fd5860e198 |
| dev_serial.h | 4b256de6b31ec42e82a6484803e9f441c45f401f76feaecbd94dd914ff36b4a2 |
| queue_manager.c | bedff78b9830df87973699d509226112036c20cbef7c2832cb20f8c4addf683d |
| 验证xsconfig.h | e961aea78700d6663cd040eb3caa5e4e85bd7f18858ca66ba6086c0213ad3e28 |

本次 C 分析只读；未运行 QCP parser/symbolic、VC、verification-orchestrator 或 C 实现证明。
