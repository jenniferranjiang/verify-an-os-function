# CRTOS Spec Knowledge

开始 CRTOS spec 设计或审阅前，先读 [CRTOS 公共知识](knowledge.md) 和通用 spec 指南。本文件只补充 CRTOS 的 critical/IRQ 资源位置、调用链 contract、annotated C 切片与经验。

## Local 与 shared resources

Local 和 shared 只用于解释 CRTOS 调用链中的资源位置，不要求正式库定义同名 predicate：

- Local resources 由当前函数或 caller 直接持有，在调用链中作为 frame 保留、更新或返回；
- shared resources 由 CRTOS 全局 invariant、critical/IRQ 或 STS 协议维护。

一条取得和归还 shared invariant 的调用链通常具有：

~~~text
Local * OutsideCritical(before)
  -> Local * InsideCritical(current) * CRTOSMemory(current)
  -> Local2 * InsideCritical(current) * CRTOSMemory(after)
  -> Local2 * OutsideCritical(after)
~~~

必须遵守：

- acquire/lock 取得 shared protocol 和 memory，不把它们变成 Local；
- caller 的 Local resources 通常由 frame rule 跨 lock/unlock 保留，不写进 lock/unlock 自身 spec；
- 修改完成后按 after state 重建 shared memory；
- release/unlock 消费它并归还 CRTOS 协议；
- release 后不能继续单独持有已经归还的 shared memory；
- RTrans/GTrans 等 pure relations 不提供 heap permission。

没有这种协议的 CRTOS 函数不套用该形状，只按真实参数、内存读写、状态和返回值写 spec。

## 临界区调用链的 Contract

以下只是语义形状，正式 spec 必须使用当前 CRTOS 已审阅的真实 symbols。

外层函数入口：

~~~text
Require caller_resources * OutsideCritical(before)
        and approved abstract execution condition
~~~

Lock/acquire：

~~~text
Require OutsideCritical(before)
Ensure  exists current,
          RTrans(before, current)
        * InsideCritical(current)
        * CRTOSInvariant(current)
~~~

临界区内 helper：

~~~text
Require InsideCritical(current) * module_rep(old)
Ensure  InsideCritical(current) * module_rep(new)
        and operation_effect(old, new)
~~~

Unlock/release：

~~~text
Require GTrans(current, after)
        * InsideCritical(current)
        * CRTOSInvariant(after)
Ensure  OutsideCritical(after)
~~~

外层函数出口：

~~~text
Ensure exists after,
         result_and_effect(before, after, return)
       * returned_caller_resources
       * OutsideCritical(after)
~~~

只按真实 CRTOS 源码选择实际出现的部分。恢复中断状态不会把已经提交的共享业务状态从 new 改回 old。

## Annotated C 切片

完整源码模式下，annotated_C/src 只能增加或修改注解。默认单函数切片模式允许经过审阅的等价提取归一，例如：

- 拆开 assignment/comma expression；
- 展开 function-like macro；
- 解析由当前配置和 initializer 唯一确定的 function-table dispatch；
- 把原 translation unit 的 static 对象声明为 slice external。

每项归一必须保留路径与副作用，并在 spec review 中绑定权威源码/config 证据。不得换算法、隐藏 body、虚构函数或精简成错误 ABI 布局。

## Spec 经验

开始新写或修改 CRTOS spec 前阅读 [CRTOS spec 经验](spec-experience.md)。这些经验来自具体 semaphore trial，只采用与当前 C 形态、函数层次和控制流相符的条目。
