# Spec 设计经验

这里记录从实际验证中得到、会影响 spec 设计判断的小经验。它们是带适用条件的设计
提示，不是要求所有模块采用相同接口的固定模板；最终仍以目标 C 的真实控制流、内存
变化和模块协议为准。

1. 当对象、容器或模块函数的行为可以描述成稳定的生命周期状态转换时，不要把 manager
字段、bitmap bytes、数组元素和链表指针逐项写进 canonical `Require/Ensure`。下面是
经过简化的错误形状：

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

问题不在于这些内存事实是假的，而在于它们处于错误的接口层次：

- Caller 必须复制并理解 ID manager、bitmap 和链表节点的全部布局，难以直接组合 callee
  contract。
- Reviewer 看到的是字段清单，不能直接看出函数完成的是“分配 ID”“登记节点”还是
  “发布对象”。
- 表示变化会迫使所有 caller-local specs 一起修改，模块接口与实现布局过度耦合。
- 同一组字段在多层函数间反复拆开和拼回，容易造成 ownership 重叠、遗漏 frame，或为了
  继续写 spec 而引入更多一次性 `store`。

更合适的方向是先为源码中真实存在的模块状态定义具名 predicate，再让 spec 表达状态
转换。下面只展示接口形状，名称和状态必须根据目标 C 与项目已有定义确定：

```c
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
  /*@ With (sg : SemaphoreStable) (st : SemaphoreState) (sem : Z)
      Require
        semaphore_inv(sg, st) *
        store_sem_zeroed_private(sem)
      Ensure
        (__return < 0 &&
         semaphore_inv(sg, st) *
         store_sem_zeroed_private(sem)) ||
        (exists id,
         __return == id &&
         semaphore_id_registered(sg, st, sem, id) *
         store_sem_after_id_insert_private(sem))
   */;
```

这里的 `semaphore_id_registered` 是示意名称，不是可以无依据加入项目的现成定义。设计时
应先确认源码确实存在相应中间状态，并检查项目是否已有等价 predicate；缺失时退回
`slice-design` 定义并审阅它，不能只为了缩短 spec 创建同义 wrapper。

裸 `store` 仍可用于以下位置：

- Rocq predicate 内部，用来给具名模块状态提供真实内存 ownership；
- 函数体的局部 `which implies`，为紧邻的实际字段读取或写入展开最小资源；
- 语义本身就是具体 memory shape 的底层内存原语，此时 canonical spec 也只暴露最小
  必要 shape，并优先复用透明的结构 predicate。

在 `write-spec` 展开验证时，新验证的 callee 若暴露出当前 predicate 无法表达的
对象状态、ownership view 或生命周期中间态，应暂停 spec 并退回 predicate 设计，而不是
继续增加裸 `store`。Predicate 已经 `review-passed` 时，修改后形成新 revision 并重新 review。

Task 模块的临界区状态组织可以作为方法参考：它说明如何用命名状态表达资源取得、更新和
归还。其他模块只借鉴这种分层方法；如果 semaphore 没有相同的进入/退出临界区路径，就必须
根据 semaphore 自己的 C 控制流和协议定义状态，不能照搬 Task 的 predicate 或 transition。
