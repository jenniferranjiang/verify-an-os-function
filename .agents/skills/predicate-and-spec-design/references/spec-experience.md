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

裸 `store` 通常留在 predicate 定义及函数体所需的局部资源断言中。可复用的资源展开和恢复优先用 strategy。当函数的接口
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
      (__return == NULL_PTR &&
        (exists after,
          safeExec(LastSeen(after), return(None), X) &&
          OutsideCritical(sg, after)))
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
program 的适用条件和设计见 [Predicate 指南第 5 节](predicate-lemma-design-guide.md#5-为临界区操作定义抽象-program)。

3. 仅由 C 类型或已有存储资源即可推出的取值范围，可以在函数体中用 `by local`
提取，不必为了后续证明使用它而在 `Require` 中重复增加条件。例如，当前配置中的
`uint16` 是 16 位无符号整数；若 `id` 是该类型的 C 值，可以局部推出
`0 <= id && id <= 65535`。

以下以 `_SemaphoreCreate` 的历史规格写法为例；当前文件位置以工程全局canonical输入为准：
参数为 `uint16 val`，其 `Require` 只组合 `safeExec` 和 `OutsideCritical`，
函数体开头用下面的注解取得类型范围：

```c
/*@ 0 <= val && val <= 65535 by local */
```

设计 spec 时先区分类型范围与业务约束：`id < 容量`、ID 已分配等条件不能仅由
`uint16` 推出；它们仍需来自相应契约、predicate 或控制流。若 `id` 是逻辑整数，
则须先有它与具体 C 值或 typed store 的关联，不能仅凭名字赋予类型范围。
`by local` 的范围结论仍须证明；具体注解可在 Annotation 阶段补充，见
[Annotation 阶段适配](../../vc-proof/references/implementation-and-validation-guide.md#annotation-阶段适配)。

4. 对于以对象指针等非 ID 参数直接确定操作对象、且采用 `safeExec` 与临界区
协议的函数，优先参考下面的公开 spec：直接使用真实 C 形参，由抽象 program
表达对象查找、有效域和操作行为，不在公开入口额外暴露对象描述符或内部 ID。

```c
x_err_t _DeleteMsgQueue(struct MsgQueue *mq)
/*@ msgqueue_delete_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_msgqueue_delete(sg, mq), X) &&
      OutsideCritical(sg, before)
    Ensure __return == KOK &&
      (exists after, msgqueue_deleted(mq, after) &&
        safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after))
 */;
```

`Require` 中不应出现 `exists` ，确实需要由 caller 提供的逻辑
参数应放在 `With` 中，再在 `Require` 中写它与实际 C 参数、状态和资源的关联。
如果某个对象描述符或内部 ID 只是抽象操作或函数体推理所需的 witness，就应留在
内部，不要为去掉 `Require` 中的 `exists obj` 而机械地新增 `With obj`。
上述示例中只需 `sg`、`before` 和 `X`，无需额外传入 `mq` 对应的对象描述符。

这条入口规则不禁止 `Ensure` 中量化执行后才得到的状态或结果，例如示例中的
`exists after`，也不禁止抽象 program 内部的存在量化。参考时应保持真实函数的
返回类型、返回路径、资源和效果；例如返回 `void` 的删除函数使用 `return(tt)`，
不能照搬示例的 `__return == KOK`。对象有效域必须由抽象语义及适用协议实际承担，
不能仅删除入口条件而遗漏相应调用要求。

`_MutexDelete(struct Mutex *mutex)` 的目标对象由 C 形参 `mutex`（逻辑地址
`p`）直接确定。这类 canonical spec 不应在 `With` 中额外引入 `id`，也不应在
`Require` 中写 `exists id, ...` 来描述被删除的 mutex。这里 `id` 不是应改放到
`With` 的ghost参数；公开抽象接口仍以真实指针定位对象。例如，下面的公开边界不合适：

```c
Require mutex != 0 && exists id,
  mutex_delete_live(mutex, id, before) &&
  safeExec(LastSeen(before),
           abs_mutex_delete_object_with_id(mutex, id), X) &&
  OutsideCritical(sg, before)
```

`_MutexDelete`的公开抽象行为是删除并回收地址 `p` 对应的mutex，公开predicate、transition和abstract program接口按该指针定位对象。

真实C读取或缓存的内部ID，可以从对象表示及观察状态取得，作为抽象程序内部局部值，或用来实例化 `IdRemoveObj` 等callee的契约。这与要求caller在公开入口额外提供ID不同。跨解锁需要保持对象身份时，用适用的lifetime/ownership/generation条件表达；地址或ID相等本身不足以排除ABA。

这条经验不适用于 `KMutexDelete(int32 id)` 这类真实以 `id` 为 C 形参的外层 API；
该外层 spec 可以直接使用其 C 形参 `id`。也不适用于`_SemaphoreDelete(int32 id)`等本身传入`id` 为 C 形参的函数。

5. 使用合适的谓词描述函数的操作对象。以 Dataqueue 的可信 `x_free` 接口为例，
已有 `dataqueue_buffer(q)` 描述待释放 buffer，就直接使用该谓词，不必让 caller
先把 FIFO 有效元素和空闲区重组成整块字节数组。

修改前的接口：

```c
void x_free(void *p)
/*@ With n
    Require p != 0 && 0 < n && CharArray::undef_full(p, n)
    Ensure emp
*/;
```

该接口要求 caller 将 `dataqueue_buffer(q)` 转换为
`CharArray::undef_full(q.dq_base, q.dq_max_len * 8)`，再传入长度参数。
字节数组契约本身并非错误，但本场景已有适合描述操作对象的 buffer 谓词，
这次转换给调用者增加了不必要的表示转换义务。

修改后的接口：

```c
void x_free(void *p)
/*@ dataqueue_free_buffer
    With (q : DataQueueAbs)
    Require p == q.dq_base && p != 0 && dataqueue_buffer(q)
    Ensure emp
*/;
```

调用处保留 `dataqueue_buffer(q)`，直接交给 `x_free`：

```c
x_free(p_queue->base) /*@ where (dataqueue_free_buffer) q = q */;
```

`dataqueue_buffer(q)` 拥有有效元素槽和空闲区；队列描述符留给 caller，
元素中指针所指的 payload 不属于该 buffer 谓词。这个修改保留待释放 buffer
的内存所有权，只改变接口采用的表示，不是允许遗漏资源。

本经验适用于已授权的可信释放接口；指针仍须按分配协议指向原始分配基址。
不能由此断言 `EventRaw` 等对象谓词不合适，也不能仅凭名称认为
`store_event_free_ready` 比 `EventRaw` 拥有更少资源；判断应依据实际定义。

6. 为调用方补充 `x_malloc` spec 时，应复用已有的公共分配契约。

本项目的 `InitDataqueue.c` 和 `_SemaphoreCreate.c` 的 IC 分支原来写成：

```c
void *x_malloc(x_size_t size)
/*@ Require emp
    Ensure (size == 0 && __return == 0) ||
      (size > 0 && __return == 0) ||
      (size > 0 && __return > 0 && __return <= UINT_MAX - size &&
       addr_aligned(__return, 4) && CharArray::undef_full(__return, size))
*/;
```

不应在这里只为调用方另写这样的契约，原因是：

- 它额外保证 `x_malloc(0)` 返回 NULL，并排除了零长度成功分支。调用方只需
  基本分配契约时，这会引入不必要的实现细节依赖，也增加与公共接口保持一致的
  负担。即使当前源码支持该保证，也不意味着应在各调用处自行加强契约。
- 对齐值硬编码为 `4`，没有复用项目的 `ALIGN_SIZE`；项目对齐约定变化时，
  这些分散的字面量容易漏改。
- 非空、地址范围和对齐条件在各处重复展开，容易产生不同版本的 malloc 契约，
  使调用方依赖不一致的保证。
- `Require emp` 没有显式展示长度范围。虽然当前无符号 C 参数类型提供范围约束，
  公共契约显式写出范围更便于阅读和审查；不能把这一点误说成原 spec 接受负的 C 参数。

公共分配契约使用当前工程的 `valid_malloc_addr`，将地址合法性与未初始化字节的
所有权分开表达，并统一供各调用方复用：

```c
void *x_malloc(x_size_t nbytes)
/*@ Require 0 <= nbytes && nbytes <= UINT_MAX && emp
    Ensure exists allocated, __return == allocated &&
      ((allocated == 0 && emp) ||
       (valid_malloc_addr(allocated, nbytes) &&
        CharArray::undef_full(allocated, nbytes)))
*/;
```

公共谓词只描述纯地址条件：

```coq
Record valid_malloc_addr (p size : Z) : Prop := {
  malloc_addr_positive : 0 < p;
  malloc_addr_bound : p <= Int.max_unsigned - size;
  malloc_addr_aligned : addr_aligned p ALIGN_SIZE
}.
```


7. 源码用宏表示返回码、空指针或特殊等待值时，spec 和 abstract program 使用
语义明确的公共 Rocq 常量，不把它们直接写成难以区分含义的 `-1`、`0`、`1`。
常量名全部大写，与对应 C 宏名称不同但含义相近，避免 QCP 处理时同名冲突或宏展开。
先核对当前源码和配置下的宏值、类型及返回时的正负号，再复用或补充当前工程的公共定义。

例如，公共 Rocq 常量可以定义为：

```coq
Definition KOK : Z := 0.
Definition KERROR : Z := 1.
Definition NOMEMORY : Z := 5.
Definition INVALID : Z := 10.
Definition KWAIT_FOREVER : Z := -1.
```

示例值采用前须核对当前源码与配置。源码返回负错误码时，spec 写
`__return == -KERROR`，抽象程序写 `ret (-KERROR)`；成功返回写 `KOK`。
同为 `-1` 的无限等待参数使用 `KWAIT_FOREVER`，不能因数值相同而替换成 `-KERROR`。
空指针使用相应的地址常量，例如 `NULL_PTR`，不与成功码 `KOK` 混用。
普通计数、下标和算术中的数字不必机械改成返回码常量。

沿用当前工程的公共文件组织，集中维护 Rocq 常量，不在每个函数重复定义。
在公共注解 header 中通过 `Import Coq Require Import` 导入常量库，
再用 `Extern Coq` 声明所需常量，使定义和声明在 spec 使用处可见。
本文件示例中的 `KOK`、`NULL_PTR` 等名称以相应定义和声明已引入为前提。

8. `Ensure` 按返回值区分结果分支时，将不依赖后态 witness 的返回值判断放在
该分支的 `exists after` 外面：先判断返回值，再引入该路径的后态和资源。
这样证明时可先选择返回分支，再处理后态 witness，避免先拆存在量化才能看到分支条件。

以`PopDataqueue` 验证副本的三个结果分支为例：失败返回 `-KERROR`，
队列为空和取到元素都返回 `KOK`。保留各自的抽象结果与输出槽资源，改写后的
`Ensure` 为（常量按第 7 条引入）：

```c
Ensure
  (__return == -KERROR &&
    (exists after,
      safeExec(LastSeen(after), return(DqPopFailed), X) &&
      OutsideCritical(sg, after) *
      peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length)))
  ||
  (__return == KOK &&
    (exists after,
      safeExec(LastSeen(after), return(DqPopEmpty), X) &&
      OutsideCritical(sg, after) *
      peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length)))
  ||
  (__return == KOK &&
    (exists after (e : DataqueueElem),
      safeExec(LastSeen(after), return(DqPopItem(e)), X) &&
      OutsideCritical(sg, after) *
      peak_data_slot(StartAddr, Some(e.dq_data)) *
      peak_length_slot(size, Some(e.dq_length))))
```

返回值判断提前并不保证唯一确定抽象结果：这里后两个分支都返回 `KOK`，
仍须根据实际路径区分 `DqPopEmpty` 和 `DqPopItem(e)`，不能将它们混为一个结果。

也就是把 `exists after, __return == CODE && ...` 改为
`__return == CODE && (exists after, ...)`，用括号明确每个分支的量词作用域。
此调整只适用于不引用被量化变量的判断；若返回值判断依赖量化的结果或后态，
保留其必要作用域，例如 `exists allocated, __return == allocated && ...`。
保持真实返回路径、效果、frame 和原有资源，不为套用示例增加或删除分支。
