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
[Annotation 阶段适配](implementation-and-validation-guide.md#annotation-阶段适配)。

4. 对于以对象指针等非 ID 参数直接确定操作对象、且采用 `safeExec` 与临界区
协议的函数，优先参考下面的公开 spec：直接使用真实 C 形参，由抽象 program
表达对象查找、有效域和操作行为，不在公开入口额外暴露对象描述符或内部 ID。

```c
x_err_t _DeleteMsgQueue(struct MsgQueue *mq)
/*@ msgqueue_delete_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_msgqueue_delete(sg, mq), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      __return == 0 && msgqueue_deleted(mq, after) &&
      safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after)
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
不能照搬示例的 `__return == 0`。对象有效域必须由抽象语义及适用协议实际承担，
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

5. QCP 的断言标注和 C spec 中，Record 变量的字段引用优先使用
    `record_name.field_name`，嵌套字段使用连续的点号，避免多层投影函数调用影响阅读。
    例如，使用 `sg.os_msgqueue_stable.msgqueue_done_ptr`，而不是
    `msgqueue_done_ptr(os_msgqueue_stable(sg))`。

    使用点号语法前，必须在 QCP 的 C 标注中通过 `Extern Coq Record ...` 引入相关
    Record 及所用字段；嵌套访问涉及的各层 Record 都须有相应声明，并在使用处可见。
    只有 Rocq 中的 Record 定义或普通投影函数声明不足以支持该语法，缺少 Record
    声明会导致 QCP 符号执行报错。声明格式参考项目已有 C spec 或逻辑 header 中的
    `/*@ Extern Coq Record ... { ... } */`，字段名和类型须与实际 Rocq 定义一致。

    编写或修改这类字段引用时，应先复用或补齐相应 Record 声明，再使用点号写法，
    不要为了避开声明问题退回难读的嵌套投影调用。这条经验针对 QCP 的 C 标注语法，
    不要求将 Rocq `.v` 文件中的投影语法改成 C 标注写法。

6. 根据函数的实际操作，使用合适的谓词描述其操作对象。不要仅因参数指向某个结构体，就要求完整结构体谓词；也不要仅因函数操作内存，就强制改用字节数组。
以下以已授权的
`KERNEL_FREE/x_free` 可信接口为例，对照错误写法和合适的写法。对于释放内存的函数，caller 交出合适的、描述待释放内存的 predicate
即可，不应该先重组成完整对象 predicate 或完整字节数组。

错误示例一：强制 caller 为释放事件描述符拼出完整 `EventRaw`。

```c
void x_free(void *ptr)
/*@ event_object
    Require EventRaw(ptr)
    Ensure emp
 */;
```

这里的设计错误是增加了不必要的完整对象交接要求。`x_free` 只是释放内存，
不执行事件模块的业务操作；不应为了调用它，要求 caller 补齐事件全部字段、
链表存储和 padding，再组装成完整 `EventRaw`。

错误示例二：强制 caller 为释放 buffer 重组成完整字节数组。

```c
void x_free(void *p)
/*@ With n
    Require p != 0 && 0 < n && CharArray::undef_full(p, n)
    Ensure emp
 */;
```

这里的设计错误是强制使用完整字节布局，给 caller 增加不必要的长度参数
和字节重组义务。已有合适的、描述待释放 buffer 内存的 predicate 时，
直接交出该 predicate 描述的资源即可。

当前应采用的示例：

```c
void x_free(void *ptr)
/*@ msgqueue_free_buffer
    With (mq : Z) (buffer : MsgQueueBufferAbs)
    Require ptr == mqbAddress(buffer) && store_msgqueue_buffer(mq, buffer)
    Ensure emp
 */;

void x_free(void *ptr)
/*@ event_free_descriptor
    Require store_event_free_ready(ptr) || (ptr == 0 && emp)
    Ensure emp
 */;
```

这两个示例分别用合适的 predicate 描述待释放的 buffer 和事件描述符内存。不能把 `store_event_free_ready` 当成换名后的完整
`EventRaw`，继续要求它覆盖事件对象的每个字节。也不应仅因 predicate 没有
表示 padding，就要求补齐完整对象或增加字节重组证明。上述错误指本场景中
不必要的接口要求，不是说 `EventRaw` 或字节数组断言在所有场景都不可使用。

适用边界是：指针须按分配与回收协议指向可释放的原始分配基址；释放后，不能
把同一分配块内已经建模的其他字段资源 frame 出去，继续作为有效内存使用。
未建模的 padding 不必补齐，已存在的对象内存资源则须由回收协议妥善处理。
`Ensure emp` 表示交给该调用的资源不再返还，不表示调用者其他独立资源也被释放。
空指针分支适用于实现确实支持 `x_free(NULL)` 的情形。

本经验针对模块调用者使用可信回收接口，不将这些 spec 宣称为分配器实现的
已证契约；若目标改为验证分配器本身，应按其实际实现处理分配来源、元数据及
分配器状态，不能直接用上述模块视图代替实现证明。
