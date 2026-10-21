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

应参考 [通用 Spec 编写指南的“固定模型和函数层次”](../../../../verify-c-function-with-qcp/references/spec-writing-guide.md#2-先固定模型和函数层次)：
模块和容器函数使用与当前函数层次匹配的 reviewed predicate、abstract state 和按动作
命名的 transition，把相关字段组合成真实的对象或模块状态。

裸 `store` 通常留在 predicate 定义和函数体局部 `which implies` 中。当函数的接口
语义本身就是具体 memory shape 时，canonical spec 可以暴露必要的最小 shape。若现有
predicate 不足以表达真实的对象状态、ownership view 或生命周期中间态，应回到
`slice-design` 补充接口，而不是继续向 spec 中堆叠字段级 `store`。
