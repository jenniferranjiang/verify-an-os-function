> 2026-11-23：本文的分支式 buffer 内存组织已由[连续段表示](../2026-11-23-SegmentRepresentation/design.md)替代；有效 FIFO 列表设计继续沿用，当前表示及检查结论见该说明。

# Dataqueue 有效序列表示

本轮按用户要求修改现有 lib 和 annotated C：`dq_slots : list DataqueueElem` 只表示从队首到队尾的有效元素，不再记录物理空闲槽。此次不恢复此前暂停的 QCP 实现流程，不修改 C 可执行语句或生成的 VC。

## 定义与内存

`DataqueueState.v` 中，初始化、回收后的内容均为 `[]`，入队为 `dq_slots ++ [e]`，出队为 `tl dq_slots`，Peak 为 `hd_error dq_slots`。`dataqueue_count` 是列表长度；`dataqueue_ring_shape` 将其与 `(rear-front+n) mod n` 联系起来。已有 base、front/rear、容量、信号量 ID 字段保留；空闲槽的值不再进入 record。

`DataqueueInv.v` 使用已有 `store_array_rec` 描述有效元素，`dataqueue_slot` 接收单个 `DataqueueElem`。未环绕时拥有有效 `[front,rear)` 及前后两个空闲区；环绕时存在尾段和头段，FIFO 等于尾段接头段，分别存于 `[front,n)`、`[0,rear)`，空闲区为 `[rear,front)`。空闲区用 `CharArray.undef_full` 拥有全部字节。Pop 只忘掉出队槽的旧值，C 不清除内存；Push 借出 rear 槽的写权限。完整对象仍包含结构字段与 padding，不拥有 payload 指针所指内存。

数组分配、释放、队首拆合、出队忘值及入队归还接口用明确的 `*_obligation : Prop` 记录，尚非已证引理，不新增信任假设。原有 ILP32 ABI 公理保留。

## 规格与真实分支

Peak 锁内返回逻辑队首且不改状态。Pop 非空分支返回 `e`，将 `e :: rest` 改为 `rest`；Push 非满分支在末尾追加元素。外层仍采用既有 safeExec 与临界区协议，Obtain、ring 操作和 Abandon 不合并成一个原子操作。

必须保留现有 C 行为：Obtain 成功后，Pop 仍可能遇到空 ring，保持输出并返回 0；Push 仍可能遇到满 ring，不入队但返回 0。不能将所有返回 0 都声明为已修改队列。容量 n=1 仍允许、有效容量为 0；n=0 按既有 allocator contract 失败。DeInit 仍仅覆盖初始化失败时未发布对象的清理，不扩展共享销毁范围。

annotated C 中同步有效元素 view、`dq_slots` 词汇、Init 空序列保证，以及 Pop 读取后忘掉旧队首的 buffer 转换。所有函数调用的顺序、错误分支和已有授权修复保持。源依据及修复记录沿用前轮 source-changes.md；原源码只读。

## 受影响的旧证明

旧 Init、DeInit、Peak、Pop 的 VC/manual 使用物理 `option` 槽列表与旧 ready 定义。本轮接口修改后，这些旧版本的审阅/实现结果不能用于新输入，须由后续 QCP 流程重新生成并适配证明。其文件和历史 controller 状态保留，不手改 goal/auto/check，也不把保留的旧 `.vo` 当作新版本验证证据。其他模块经共享 OS 状态依赖此类型，需要重新编译；不因此扩大本轮函数体证明范围。

检查结果和本轮 revision 见同目录 review.md。
