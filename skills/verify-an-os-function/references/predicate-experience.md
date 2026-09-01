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
