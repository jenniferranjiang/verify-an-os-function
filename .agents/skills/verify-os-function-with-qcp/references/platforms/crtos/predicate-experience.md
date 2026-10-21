# Predicate 设计经验

这里记录从实际验证中得到、会影响 predicate 设计判断的小经验。它们是带适用条件的
设计提示，不是要求所有模块采用相同结构的固定模板；最终仍以目标 C 的真实内存形态、
控制流和 symbolic check 结果为准，可以用于参考。

1. 当同一个逻辑对象在 C 中存在两种会被分别检查或转换的具体内存形态时，优先为每种
   形态定义具名 predicate，再由上层组合 predicate 连接状态标记和抽象内容。可以不要把两种形态的全部实现长期藏在一个带 `if` 的大 predicate 中。

   例如 semaphore ID bucket 在源码中可能是 BSS 留下的 `(NULL, NULL)`，也可能是已经
   初始化的双向链表。可以写成：

   ```coq
   Definition store_sem_initialized_bucket
       (head : addr) (objects : list SemaphoreObject) : Assertion :=
     store_dll store_sem_id_payload head (sem_id_nodes objects).

   Definition store_sem_uninitialized_bucket (head : addr) : Assertion :=
     &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0 **
     &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0.

   Definition store_sem_bucket
       (head : addr) (bucket : option (list SemaphoreObject)) : Assertion :=
     match bucket with
     | None => store_sem_uninitialized_bucket head
     | Some objects => store_sem_initialized_bucket head objects
     end.
   ```

   这样组织时注意：

   - 每个底层 predicate 只描述并拥有该 concrete shape 的字节；例如未初始化 bucket
     只拥有两个空指针。
   - concrete shape 与抽象内容之间的约束放在组合层，不应给底层 predicate 增加仅用于
     表达形态选择的参数。
   - 可以保留 `store_sem_bucket` 这样的组合 predicate；拆分具体形态不等于必须删除
     统一接口。
   - 具名形态应能对应真实 C 路径中的局部状态转换。例如 lazy initialization 可以直接
     表达为 `uninitialized -> initialized empty -> initialized nonempty`，便于为 callee spec、
     `which implies` 和局部 lemma 提供精确资源。

   只有当不同形态确实会独立出现在控制流、函数接口或证明步骤中时才值得拆分。如果分支
   只是内部计算细节、不会被单独使用，保留一个简单 predicate 通常更清楚。

2. 当一个 `list bool` 只用于记录另一组元素采用哪种 concrete shape 时，可以把 flag 和
   元素内容合并成 `option`。例如 semaphore ID bucket 原来分开传递 `flags` 和 `objects`：

   ```coq
   Definition store_sem_bucket
       (head : addr) (initialized : bool)
       (objects : list SemaphoreObject) : Assertion :=
     if initialized then
       store_sem_initialized_bucket head objects
     else
       “ objects = nil ” && store_sem_uninitialized_bucket head.

   Fixpoint store_sem_buckets_from
       (sg : SemaphoreStable) (index : Z) (flags : list bool)
       (objects : list SemaphoreObject) : Assertion :=
     match flags with
     | nil => emp
     | initialized :: rest =>
         store_sem_bucket
           (sg.(sem_buckets_addr) +
             index * sizeof("SysDoubleLinklistNode"))
           initialized (sem_objects_in_bucket sg index objects) **
         store_sem_buckets_from sg (index + 1) rest objects
     end.

   Definition semaphore_bucket_flags_ok
       (sg : SemaphoreStable) (st : SemaphoreState)
       (flags : list bool) : Prop :=
     Zlength flags = sg.(sem_bucket_count) /\
     forall index,
       0 <= index < sg.(sem_bucket_count) ->
       sem_objects_in_bucket sg index st.(sem_objects) <> nil ->
       Znth index flags false = true.
   ```

   可以改成下面这样。`None` 表示 `(NULL,NULL)`，`Some nil` 表示已初始化的空 DLL，
   `Some objects` 表示已初始化且含有这些对象的 DLL：

   ```coq
   Definition SemBucket := option (list SemaphoreObject).

   Definition store_sem_bucket
       (head : addr) (bucket : SemBucket) : Assertion :=
     match bucket with
     | None => store_sem_uninitialized_bucket head
     | Some objects => store_sem_initialized_bucket head objects
     end.

   Fixpoint semaphore_buckets_match_from
       (sg : SemaphoreStable) (index : Z)
       (buckets : list SemBucket) (objects : list SemaphoreObject) : Prop :=
     match buckets with
     | nil => True
     | bucket :: rest =>
         (match bucket with
          | None => sem_objects_in_bucket sg index objects = nil
          | Some bucket_objects =>
              bucket_objects = sem_objects_in_bucket sg index objects
          end) /\
         semaphore_buckets_match_from sg (index + 1) rest objects
     end.

   Definition semaphore_buckets_ok
       (sg : SemaphoreStable) (st : SemaphoreState)
       (buckets : list SemBucket) : Prop :=
     Zlength buckets = sg.(sem_bucket_count) /\
     semaphore_buckets_match_from sg 0 buckets st.(sem_objects).

   Fixpoint store_sem_buckets_from
       (sg : SemaphoreStable) (index : Z)
       (buckets : list SemBucket) : Assertion :=
     match buckets with
     | nil => emp
     | bucket :: rest =>
         store_sem_bucket
           (sg.(sem_buckets_addr) +
             index * sizeof("SysDoubleLinklistNode"))
           bucket **
         store_sem_buckets_from sg (index + 1) rest
     end.

   Definition store_sem_buckets
       (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
     EX buckets : list SemBucket,
       “ semaphore_buckets_ok sg st buckets ” &&
       store_sem_buckets_from sg 0 buckets.
   ```

   然后 `store_sem_id_manager` 只接收 `sg` 和 `st`，在末尾使用
   `store_sem_buckets sg st`，不再把 `flags` 传到所有上层 spec。这里应使用
   `option (list SemaphoreObject)`，不能用 `option SemaphoreObject`；一个 hash bucket
   可能因冲突包含多个对象，并且还要能用 `Some nil` 表示已初始化的空 bucket。

3. 遇到数组形态时，先分清“数组里直接放对象本体”还是“数组里放指向对象的指针”。
   如果数组元素本身就是要描述的结构体/节点/头对象，即使这个结构体内部有指针字段，
   也仍然是数组情形。代码按 `&array[i]`、`array + i` 或等价形式取得第 `i` 个元素
   本体时，适合用 QCP 的 `storearray`/`store_array` 思路组合元素 predicate。
   这样可以复用数组谓词的长度和元素 split/merge lemma，也能避免把连续数组误建模成
   外部分散对象。

   例如 semaphore 的 `DECLARE_ID_MANAGER` 会生成连续的 hash bucket 数组；其中
   `store_sem_bucket` 描述单个 `DoubleLinklistType` bucket head，`bucket` 参数只是
   这个数组元素的抽象状态，不是新的 C 对象。第 2 条中的 `store_sem_buckets_from`
   是手写数组递归：

   ```coq
   Fixpoint store_sem_buckets_from
       (base : addr) (index : Z) (buckets : list SemBucket) : Assertion :=
     match buckets with
     | nil => emp
     | bucket :: rest =>
         store_sem_bucket (base + index * sizeof("SysDoubleLinklistNode")) bucket **
         store_sem_buckets_from base (index + 1) rest
     end.
   ```

   如果 QCP 的数组谓词能表达该布局，可以改为：

   ```coq
   Definition store_sem_bucket_at
       (base : addr) (index : Z) (bucket : SemBucket) : Assertion :=
     store_sem_bucket
       (base + index * sizeof("SysDoubleLinklistNode"))
       bucket.

   Definition store_sem_bucket_array
       (base : addr) (count : Z) (buckets : list SemBucket)
       : Assertion :=
     store_array store_sem_bucket_at base count buckets.
   ```

   这里只替换数组的组织方式；`store_sem_bucket` 仍描述单个元素，
   `semaphore_buckets_ok` 仍描述数组内容与模块 abstract state 的关系。

4. 只有当 C 形态确实是“数组里放指针，指针再指向外面的对象”时，才优先考虑
   `storemap`/`store_map` 这类地址到资源的映射谓词。例如若源码是 `T *table[N]`，
   或者 manager 中维护的是一组不连续分配的 object/header 指针，那么数组本体只拥有
   各个指针槽和值，真正的对象资源位于这些指针指向的地址上；此时可以用 `storearray`
   描述指针数组，用 `storemap` 描述外部地址集合对应的对象资源。

   判断用 storearray 还是 storemap，不要只看类型里有没有 *。要看真正的对象在哪里。如果对象本体连续放在数组里，就用数组谓词；如果数组里只是放指针，真正对象在外面、地址不连续，才用 map 谓词。

5. 信号量等待队列的纯状态建议直接保存等待任务的地址，去掉只有
   `waiter_task : addr` 一个字段的 `SemaphoreWaiter` 包装，将
   `semaphore_waiters : list SemaphoreWaiter` 改为：

   ```coq
   (* pend_list 中等待任务的基址，按链表顺序排列 *)
   semaphore_pending_addrs : list addr;
   ```

   字段位于信号量对象中，所属模块已由上下文说明，名称可以简化为
   `semaphore_pending_addrs`：`pending` 表示等待关系，`address` 表示保存的是地址。
   类型 `list addr` 表明它是地址序列；注释须明确这些地址是等待任务的基址，
   不是信号量对象地址、链表头地址或链表节点地址。

   `waiter`不能直接说明这里仅保存地址，容易让读者以为元素包含独立的等待者对象或完整任务状态。当前
   `SemaphoreWaiter` 实际只有一个地址字段，没有额外等待者状态，因此这里选择
   `semaphore_pending_addrs : list addr`，让名称和保存内容一致，并去掉无额外语义的包装定义。

6. 信号量模块不要另行定义 `SemaphoreTaskView`。任务状态及其 predicate 应直接
   import 并复用 task 模块中的定义，避免在 semaphore 模块中重复维护一套任务表示。
   信号量模块只需描述等待任务与信号量之间的关系；需要任务字段或资源时，使用
   task 模块提供的定义和接口。

   原来在 `SemaphorePure.v` 中定义的任务视图如下，作为应去掉的重复定义示例：

   ```coq
   Record SemaphoreTaskView : Type := Build_SemaphoreTaskView {
     sem_task_addr : addr;
     sem_task_id : Z;
     sem_task_priority : Z;
     sem_task_name : list Z;
     sem_task_exstatus : Z;
   }.
   ```

   这些字段描述的是任务地址、ID、优先级、名称和扩展状态，应复用 task 模块中的
   对应定义，不应因为 semaphore 需要查询它们就另建一个 `SemaphoreTaskView`。

7. 根据对象特点和待验证操作选择 id 或 address 作为唯一索引，重点检查它在需要
   追踪“同一个对象”的期间是否稳定。选定的索引必须唯一，并在这段期间保持不变；
   各个状态转换都应保持这一约束，不能让同一个键对应两个不同对象。

   | 要求 | 含义 |
   | ---- | ---- |
   | 唯一性 | 同一时刻，这个键不会对应两个不同对象 |
   | 稳定性 | 操作前后，同一个对象仍然能用这个键识别 |

   某个 ID 即使始终不重复，如果操作会修改它，也不一定适合追踪对象身份。
   例如图搜索会修改顶点编号、但内存位置不变时，可用 address 索引，把编号作为
   可变属性；若编号固定，则用 ID 也合适。对象会搬迁而 ID 不变时，则可选择 ID。

   比如，semaphore 从分配到释放的生命周期适合用 address 追踪：分配后可能尚无有效 ID，
   注销 ID 后仍需释放原来的内存。已登记对象的查询接口则可通过 ID manager 用 ID
   定位。两种索引可以共存，但必须对应同一个对象，保持状态一致。

   结合 map 的键、查找与更新操作以及空间谓词检查这些要求，不能只看字段名称。
   地址和 ID 在对象删除后都可能复用，不能默认它们是跨生命周期的永久身份。

8. 特别地，使用 address 作为内部索引时，底层 predicate 和证明可以显式使用地址定位内存；
   上层抽象接口应通过存在量词隐藏具体地址（`exists address`，空间断言中写作
   `EX p : addr, ...`），不把内部地址作为上层必须传递或依赖的参数。例如示意（示例仅供参考，真实验证中命名不必一定模仿或一定使用）：

   ```coq
   Definition object_rep (id : Z) (state : ObjectState) : Assertion :=
     EX p : addr, store_object p id state.
   ```

   底层展开 `object_rep` 后取得地址 `p`，完成字段访问和证明，再封装回上层谓词。
   `store_object` 必须把该地址的真实对象与上层的 ID、抽象状态关联起来；存在量词
   只隐藏具体地址，不替代唯一性约束，也不能丢掉操作前后属于同一个对象的关系。

9. QCP 能够根据 C 结构体布局自动生成 padding 资源时，手写的对象
   predicate 中不要再重复描述 padding。

   例如 `struct Semaphore` 在 `value` 前后存在 padding 时，
   `store_semaphore_object_body` 中只需保留 `value` 和 pending-list 的表示，
   不要加入下列断言：

   ```coq
   CharArray.full (sem + 2) 2 (repeat_Z 0 2)
   CharArray.full (sem + 14) 2 (repeat_Z 0 2)
   ```

10. `done` 表里保存的是函数指针，而 QCP 目前不支持函数指针。处理
    annotated C 切片时，把 `done` 指向的函数作为切片中的全局函数，直接调用
    这个函数。这样切片不再使用 `done` 表，predicate 中也不需要定义
    `SemaphoreDoneType` 对应的 QCP struct。所有与 `done` 相关的 formal 定义都不需要，
    包括 stable state 中的 `done` 字段、`store_semaphore_done`、
    `SemaphoreStableContext` 中的 `done` 约束，以及 `semaphore_outside`、
    `semaphore_inside` 和 `store_semaphore_static_initial` 中对它的引用。

    semaphore trial 中原先为 `done` 写过下面这些定义。在 annotated C
    已改为直接调用后，这些定义都不需要：

    ```coq
    Record SemaphoreDoneAbs : Type := Build_SemaphoreDoneAbs {
      semaphore_done_create : addr;
      semaphore_done_delete : addr;
      semaphore_done_obtain : addr;
      semaphore_done_abandon : addr;
      semaphore_done_set_value : addr
    }.
    ```

    `SemaphoreStable` 中的下面两个字段也不需要：

    ```coq
    semaphore_done_addr : addr;
    semaphore_done_abs : SemaphoreDoneAbs
    ```

    下面这个对 `done` 表内存的 predicate 也不需要：

    ```coq
    Definition store_semaphore_done (stable : SemaphoreStable) : Assertion :=
      let done := stable.(semaphore_done_addr) in
      &(done # "SemaphoreDoneType" ->ₛ
          "SemaphoreCreate") # Ptr
        |-> stable.(semaphore_done_abs).(semaphore_done_create) **
      &(done # "SemaphoreDoneType" ->ₛ
          "SemaphoreDelete") # Ptr
        |-> stable.(semaphore_done_abs).(semaphore_done_delete) **
      &(done # "SemaphoreDoneType" ->ₛ
          "SemaphoreObtain") # Ptr
        |-> stable.(semaphore_done_abs).(semaphore_done_obtain) **
      &(done # "SemaphoreDoneType" ->ₛ
          "SemaphoreAbandon") # Ptr
        |-> stable.(semaphore_done_abs).(semaphore_done_abandon) **
      &(done # "SemaphoreDoneType" ->ₛ
          "SemaphoreSetValue") # Ptr
        |-> stable.(semaphore_done_abs).(semaphore_done_set_value).
    ```

    例如权威 C 中的：

    ```c
    static SemaphoreDoneType done = {
        .SemaphoreCreate = _SemaphoreCreate,
        /* ... */
    };

    return done.SemaphoreCreate(val);
    ```

    可在验证切片中归一为：

    ```c
    return _SemaphoreCreate(val);
    ```

    `done.SemaphoreCreate = _SemaphoreCreate` 只用来说明为什么可以改成直接调用，
    不需要写进 predicate。直接调用的函数仍按普通 callee 处理。如果 `done`
    会在运行时改变，就不能这样处理。

11. 不要为了匹配或复用已有 predicate 的参数形式，把本模块语义上不需要的
    dependency state 直接加入本模块的 abstract state。Abstract-state 分量仍须由
    当前模块的可观察行为、跨调用必须保存的信息或合法状态转换决定；“某个可复用
    predicate 需要这个参数”本身不是加入 state field 的依据。

    例如 semaphore 不应只因为复用
    `store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion`
    而把 `VarIdmanager` 再保存进 `SemaphoreState`：这会让对象列表和
    `VarIdmanager.idlist/idbuckets` 成为两份权威来源，并迫使每个状态转换维护额外
    一致性关系。

    这种情况下应从最小模块状态构造 dependency state，再把构造结果传给已有
    representation predicate，例如：

    ```coq
    Record SemaphoreState : Type := Build_SemaphoreState {
      semaphore_objects : list SemaphoreObject
    }.

    ```
