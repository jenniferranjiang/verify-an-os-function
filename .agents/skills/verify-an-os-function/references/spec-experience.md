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
具体分工见 [Spec 指南第 4 节](spec-writing-guide.md#4-临界区调用链中的函数-spec)，
program 的适用条件和设计见 [Predicate 指南第 4 节](predicate-lemma-design-guide.md#4-为临界区操作定义抽象-program)。
