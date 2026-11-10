# Spec 设计经验

这里记录从实际验证中得到、会影响 spec 设计判断的小经验。它们是带适用条件的设计
提示，不是要求所有模块采用相同接口的固定模板；最终仍以目标 C 的真实控制流、内存
变化和模块协议为准。

1. 模块或容器函数的 canonical spec 不要逐项展开 manager 字段、
bitmap bytes、数组元素和链表指针等表示细节。下面这种写法不应作为
这类函数的 canonical spec：

```c
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
  /*@ With idmax hoffset id_map htable bytes
             old_next old_prev
      Require
        store(&(manager->id_max), unsigned short, idmax) *
        store(&(manager->hoffset), unsigned short, hoffset) *
        store(&(manager->id_map), unsigned char *, id_map) *
        store(&(manager->htable), struct SysDoubleLinklistNode *, htable) *
        UCharArray.full(id_map, (idmax + 7) / 8, bytes) *
        store(&(idnode->id), unsigned short, 0) *
        store(&(idnode->link.node_next),
              struct SysDoubleLinklistNode *, old_next) *
        store(&(idnode->link.node_prev),
              struct SysDoubleLinklistNode *, old_prev)
      Ensure
        exists bytes2,
          UCharArray.full(id_map, (idmax + 7) / 8, bytes2) *
          ...
   */;
```

这些内存事实可能都是真的，但它们处于错误的接口层次：caller 必须了解并
重复传递 ID manager、bitmap 和链表节点的实现布局，reviewer 也不能从
contract 直接看出函数完成的操作。

应参考 [Spec 编写指南的“保持函数层次的抽象边界”](spec-writing-guide.md#33-保持函数层次的抽象边界)：
模块和容器函数使用与当前函数层次匹配的 reviewed predicate、abstract state 和按动作
命名的 transition，把相关字段组合成真实的对象或模块状态。

裸 `store` 通常留在 predicate 定义和函数体局部 `which implies` 中。当函数的接口
语义本身就是具体 memory shape 时，canonical spec 可以暴露必要的最小 shape。若现有
predicate 不足以表达真实的对象状态、ownership view 或生命周期中间态，应回到
`slice-design` 补充接口，而不是继续向 spec 中堆叠字段级 `store`。

2. 采用 `safeExec` 和 atomic command 时，可以参考下面这个清楚展示调用条件和结果分支的 spec：

```c
inline struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ With (sg : StableGlobalState)
         (before : VarGlobalState)
         X
    Require id < 65536 &&
        safeExec(
          LastSeen(before),
          abs_get_task_with_idnode(sg, id), X) &&
        OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == KNONE &&
        safeExec(
          LastSeen(after), return(None), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        safeExec(
          LastSeen(after), return(Some(__return)), X) &&
        OutsideCritical(sg, after))
*/
```

操作语义由 `abs_get_task_with_idnode` 表达；注解直接展示调用条件、C 返回值与 `None/Some`
抽象结果的对应、同一个 continuation `X`，以及临界区资源的归还。这个示例供采用相应抽象操作
和协议的函数参考，不要求所有函数定义 program，也不要求创建函数使用 `option` 返回结果。
此例中 `id` 是 `GetTaskWithIdnodeInfo` 的真实 C 形参，不是 `With` 引入的 ghost ID；只接收对象指针的
函数应按 [Spec 指南第 2.1 节](spec-writing-guide.md#21-c-形参逻辑参数与-continuation)区分公开指针语义与内部身份 witness。
具体分工见 [Spec 指南第 4 节](spec-writing-guide.md#4-临界区内外-spec-的判断与证明方法)，
program 的适用条件和设计见 [Predicate 指南第 4 节](predicate-lemma-design-guide.md#4-为临界区操作定义抽象-program)。

3. 仅由 C 类型或已有存储资源即可推出的取值范围，可以在函数体中用 `by local`
提取，不必为了后续证明使用它而在 `Require` 中重复增加条件。例如，当前配置中的
`uint16` 是 16 位无符号整数；若 `id` 是该类型的 C 值，可以局部推出
`0 <= id && id <= 65535`。

实际例子见 [`_SemaphoreCreate`](../../../../ksemaphorecreate-trial-261022-1/annotated_C/src/_SemaphoreCreate.c)：
参数为 `uint16 val`，其 `Require` 只组合 `safeExec` 和 `OutsideCritical`，
函数体开头用下面的注解取得类型范围：

```c
/*@ 0 <= val && val <= 65535 by local */
```

设计 spec 时先区分类型范围与业务约束：`id < 容量`、ID 已分配等条件不能仅由
`uint16` 推出；它们仍需来自相应契约、predicate 或控制流。若 `id` 是逻辑整数，
则须先有它与具体 C 值或 typed store 的关联，不能仅凭名字赋予类型范围。
`by local` 的范围结论仍须证明；具体注解可在 Annotation 阶段补充，见
[Annotation 阶段适配](implementation-and-validation-guide.md#annotation-阶段适配)。

4. `_MutexDelete(struct Mutex *mutex)` 的目标对象由 C 形参 `mutex`（逻辑地址
`p`）直接确定。这类 canonical spec 不应在 `With` 中额外引入 `id`，也不应在
`Require` 中写 `exists id, ...` 来描述被删除的 mutex。这里 `id` 不是应改放到
`With` 的 ghost 参数，而是根本不应进入该函数的抽象行为描述。例如，下面的公开边界不合适：

```c
Require mutex != 0 && exists id,
  mutex_delete_live(mutex, id, before) &&
  safeExec(LastSeen(before),
           abs_mutex_delete_object_with_id(mutex, id), X) &&
  OutsideCritical(sg, before)
```

`_MutexDelete` 的抽象行为只是删除并回收地址 `p` 对应的 mutex。公开
predicate、transition 和 abstract program 都应只以 `p` 跟踪目标对象。

实现证明展开对象表示并调用 `IdRemoveObj` 时，可以从地址 `p` 对应的当前
mutex 对象中局部取得 `current.mutex_id`，用它实例化 callee contract。这只是体内的
representation/proof witness，不应进入 `_MutexDelete` 的公开 spec、abstract program
或跨 helper 的行为接口。如果需要排除解锁窗口中的回收/地址复用，应对 `p`
表达 lifetime/ownership/generation 条件；`id` 不能代替地址世代条件。

这条经验不适用于 `KMutexDelete(int32 id)` 这类真实以 `id` 为 C 形参的外层 API；
该外层 spec 可以直接使用其 C 形参 `id`。也不适用于`_SemaphoreDelete(int32 id)`等本身传入`id` 为 C 形参的函数。
