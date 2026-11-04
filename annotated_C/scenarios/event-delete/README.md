# Event 删除规格场景

此目录保存 `keventdelete-spec-r1` 的共享版本，predicate 为 `keventdelete-predicate-r1`，二者均已独立设计审阅通过。来源与审阅、源码哈希、编译记录见 [实验记录](../../../keventdelete-trial-261103-1/.docs/Report/status.md)；文件与revision的迁移对应见 [migration.json](../../../keventdelete-trial-261103-1/checks/migration.json)。

公开入口为 `src/KEventDelete.c`，参数规格限制为 `0 <= id < 65536`。C仍使用int32，不修改源码算法；128..65535允许未命中返回。D1要求查询命中的同一分配对象直到本次注销不被他人删除、回收或复用；D2要求本次观察/清空的空pending直到注销保持为空。这些是用户批准的运行条件，不是内核锁已经实现的保证，原源码缺陷仍存在。

`src/LinklistResumeAll.c` 是Event锁外调用场景，保留其实际加锁/解锁，与根目录Semaphore锁内场景、Mutex锁外场景分别选择，不共同链接同名函数。4个新设计目标为KEventDelete、FindEventById、_EventDelete、LinklistResumeAll；其他11个文件是完整callee合同边界，声明文件不代表新的实现证明。

`include/logic.h` 引用根 `_CoqProject` 管理的 `CRTOS_Verify.lib.KEventDelete`。该目录不依赖trial逻辑路径，不包含模块级spec头文件。设计阶段已完成C语法/布局和Rocq类型检查。用户批准相应revision后，trial内四个实现目标均已完成QCP工作流并通过final-check（2026-11-04）。完成状态、证明位置及条件限制见上述实验记录；共享spec文件本身不替代实现证明。

实现适配中，`IdRemoveObj` 的字段缩写已在canonical与`_EventDelete`调用接口中同步改为显式typed store/field_addr，语义及资源不变。与trial合同逐字一致性、ILP32语法检查及文件hash见 [适配记录](../../../keventdelete-trial-261103-1/checks/idremoveobj-syntax-adaptation.json)；原migration.json保留设计首次合并时的快照。
