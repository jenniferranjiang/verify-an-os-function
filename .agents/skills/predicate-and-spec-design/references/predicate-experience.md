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

4. 当 C 中没有用于枚举某类对象的全局指针表或管理链，接口由 caller 给出对象地址，
   并且对象在成功初始化后才将内存资源交入 `os_inv` 时，优先用地址到抽象状态的
   partial function 描述全部已发布对象，再用 `store_map` 组织它们的内存资源。
   不要为了描述这个逻辑集合而虚构 C 中不存在的全局链表或根指针。

   例如 Dataqueue 的结构地址由 caller 提供，Init 另行分配元素数组。可以采用：

   ```coq
   dataqueue_map : addr -> option DataQueueAbs
   store_dataqueue : addr -> DataQueueAbs -> Assertion
   (* os_inv 中的模块资源项： *)
   store_map store_dataqueue dataqueue_map
   ```

   `dataqueue_map p = Some q` 表示地址 `p` 的对象已发布，抽象状态为 `q`。
   对象自身地址由 key 提供，value 不再重复保存自身地址；对象内部的数组指针等字段
   仍属于 value。lookup 是纯事实，访问字段的权限须从 `store_map` 拆出对应 cell。
   cell 应完整描述交入 `os_inv` 的结构和附属资源，避免和其他模块重复拥有内存。

   初始化前及尚未发布的中间阶段，对象资源由 caller 或初始化函数局部持有；
   成功时在旧 key 为 `None` 的位置写入 `Some q`，同时把资源交入 `os_inv`，
   其余 key 保持不变。失败时按真实路径回收已取得的资源，不发布该对象。
   `None` 只表示不在已发布集合中，不表示这个地址没有已分配的私有内存。
   对象撤回、资源释放和允许并发使用的生命周期条件须分别描述；map 本身不保证
   地址在释放后不被复用。实际存在部分发布的实现，应按其真实交接阶段建模，
   不能机械套用“整个 Init 成功后才发布”。

   而若 C 中确有 `T *table[N]` 或管理链，应描述这些结构的真实内存及其与对象 map
   的成员关系，使用 `store_array`描述指针数组，而外部分散对象可用 `store_map`；
   链表的顺序和链指针由链表谓词描述。同一对象字段不能被两者重复拥有。
   若对象本体连续存放在数组中，则直接用数组谓词组织它们。
   选择依据是对象的位置和资源交接方式，不是类型里是否有 `*`，也不是是否由 malloc 分配。

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

8. 对象地址只属于内部表示、不是公开 C 接口用来指定或返回对象的值时，
   上层抽象接口可通过存在量词隐藏它（空间断言中写作 `EX p : addr, ...`），
   不要求 caller 额外传入这个内部地址。例如按 ID 定位对象的接口可以使用：

   ```coq
   Definition object_rep (id : Z) (state : ObjectState) : Assertion :=
     EX p : addr, store_object p id state.
   ```

   底层展开 `object_rep` 后取得地址 `p`，完成字段访问和证明，再封装回上层谓词。
   `store_object` 必须把该地址的真实对象与上层的 ID、抽象状态关联起来；存在量词
   只隐藏具体地址，不替代唯一性约束，也不能丢掉操作前后属于同一个对象的关系。

   若真实 C 接口接收对象指针，例如 `DeleteObject(p)`，公开 predicate 和 program
   必须按传入的 `p` 关联操作对象，不能改成“存在某个地址的对象”。若函数返回对象
   指针，也须把返回值与对象地址关联。隐藏内部表示地址，不等于隐藏真实参数、
   返回值与操作对象的对应关系；按指针定位对象的规则见
   [Spec 指南第 2.1 节](spec-writing-guide.md#21-c-形参逻辑参数与-continuation)。

9. QCP 能够根据 C 结构体布局自动生成 padding 资源，predicate 中不要再重复描述 padding。

   例如 `struct Semaphore` 在 `value` 前后存在 padding 时，
   `store_semaphore_object_body` 中不要加入下列断言：

   ```coq
   CharArray.full (sem + 2) 2 (repeat_Z 0 2)
   CharArray.full (sem + 14) 2 (repeat_Z 0 2)
   ```

10. 涉及静态函数表适配时，按 [QCP 工具指南](../../source-processing/references/qcp-tool-guide.md#1-函数指针调用转为直接调用)同步调整 predicate 和 state。

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

12. 审阅 predicate 时，不要从一个尚未补齐或尚未检查的跨模块接口，过度推出
    “必须修改上游模块”或“存在不可消除的 blocker”。先按当前 artifact 的抽象层
    判断问题：Pure 文件缺少后续 Rules/Rep，不等于其中的 pure definition 错误；
    完整候选尚未闭合，则保持 draft 并记录待补 dependency，不把“尚未实现”冒充为
    “已经证明无法实现”。

    准备提出上游 breaking change 或停止实验前，检查并留下实际依据：

    - 已有共享定义是否已经提供所需 owner、view、transition 或 acquire/release；
    - 冲突位于哪些具体定义，哪些共享接口确实需要参数化或调整；
    - 必要接口修改与 adapter/bridge 方案各自增加哪些证明义务、阅读和维护成本；
    - 哪些依赖无需修改，哪些只需重新编译，哪些必须修改才能完成本轮集成。

    不要求先实现并否定所有 adapter/bridge，才允许修改本轮必要的共享接口；
    也不能从一次类型错误推出整个全局依赖闭包都需改造。依据具体问题选择最小必要
    调整，不以修改文件数量最少作为唯一目标。尚无依据时应报告已知缺口和待验证方案，
    不能把架构推测升级为 blocker。用户提供的既有候选应先固定内容或 revision、
    实际 compile/typecheck，并基于具体 delta 审阅；不能仅因它尚未包含后续层文件就
    丢弃候选或另起不相干设计。

    例如 semaphore 调用位于线程子系统中的 `CriticalAreaLock`，只说明它复用公共
    critical/IRQ primitive；这本身不推出 semaphore state 必须加入 Task state，
    也不推出必须修改 Task formal files。应检查实际共享接口及其类型依赖，再判断
    是否需要调整；不能仅凭调用关系增加状态分量、另建协议或复制整个任务库。

13. `SemDLNode` 和 `sem_dllseg` 重复了公共 DLL 库已有的结构，应优先复用
    `DL_Node` 和 `DLL.dllseg`。

    此前semaphore表示设计中的节点定义是（历史示例，不指定当前文件布局）：

    ```coq
    Record SemDLNode (A : Type) : Type := Build_SemDLNode {
      sem_node_data : A;
      sem_node_ptr : addr
    }.
    ```

    `lib/common/dll_abs.v` 中已有下面的节点定义，`lib/common/dll.v` 会导出它：

    ```coq
    Record DL_Node (A : Type) : Type := Build_DL_Node {
      getData : A;
      getPtr : addr
    }.
    ```

    两者都是“数据 + 节点地址”：`sem_node_data` 对应 `getData`，
    `sem_node_ptr` 对应 `getPtr`，没有额外的 semaphore 专属信息。
    公共库用 `.(data)` 和 `.(ptr)` 分别表示 `getData` 和 `getPtr`。
    因此可以直接使用 `DL_Node A`，无需重新定义 `SemDLNode A`。

    再看 `SemaphoreRep.v` 中的链表段定义：

    ```coq
    Definition sem_dllseg {A : Type}
        (store_payload : addr -> A -> Assertion)
        (first previous stop last : addr) (nodes : list (SemDLNode A))
        : Assertion :=
      (fix go current prev remaining :=
         match remaining with
         | nil => “ current = stop /\ prev = last ” && emp
         | node :: rest =>
             EX next : addr,
               “ current = node.(sem_node_ptr) ” &&
               store_payload current node.(sem_node_data) **
               &(current # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> prev **
               &(current # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next **
               go next current rest
         end) first previous nodes.
    ```

    `lib/common/dll.v` 的 `DLL` 模块中已有：

    ```coq
    Definition dllseg {A : Type}
        (storeA : addr -> A -> Assertion)
        (x px y py : addr) (l : list (DL_Node A)) : Assertion :=
      (fix dllseg x px y py l :=
         match l with
         | nil => “ x = y /\ px = py ” && emp
         | a :: l0 => EX z : addr,
             “ x = a.(ptr) ” &&
             storeA x a.(data) **
             &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
             &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
             dllseg z x y py l0
         end) x px y py l.
    ```

    两者的参数逐一对应：`store_payload` 对应 `storeA`，
    `first/previous/stop/last` 对应 `x/px/y/py`，`nodes` 对应 `l`。
    空列表时都要求当前地址等于终点、前驱等于末节点，并拥有 `emp`；
    非空时都关联节点地址，拥有 payload、prev/next 字段，再递归描述剩余节点。
    `sem_dllseg` 把 `stop/last` 固定在外层，`dllseg` 在递归时原样传递 `y/py`，
    表达的是相同的链表段结构。

    因此，节点类型改用 `DL_Node` 后，应直接复用 `DLL.dllseg` 及相关定义和
    lemma；模块只需提供自己的节点映射与 payload predicate，不必再写一套链表。

14. 定义状态良构条件（well-formedness，如 `semaphore_state_wf`）时，
    不预先机械添加 `NoDup`。应根据目标功能性质和证明中的具体用途判断是否需要；
    需要时先检查能否由已有 predicate 推导，无法推导时再补充相应条件，
    说明它用于证明什么，并证明相关状态转换保持该条件。

    地址、ID、等待任务列表的无重复条件都按上述依据逐项判断。
    分离合取能否推出相应的 `NoDup`，取决于 predicate 实际拥有的资源；
    无法推出也不等于当前验证需要额外加入该条件。
    设计阶段已能指出具体证明用途时即可加入，不必等到证明受阻；
    暂无用途时，不要仅因状态中存在列表或唯一性符合直觉就加入 `wf`。

15. Semaphore 使用系统共享的临界区协议，直接复用 `lib/common/CrtosRules.v` 中的
    `InsideCritical(sg, st)` 和 `OutsideCritical(sg, st)`，不要另定义
    `SemaphoreInsideCritical`、`SemaphoreOutsideCritical`，也不要只为增加模块前缀
    建立同义别名或重新实例化一套 STS。

    Semaphore 自己的对象、等待队列和模块内存由相应 predicate 描述，通过全局
    invariant 组织；这些模块资源不构成另一套临界区。如果现有全局定义不足以表达
    当前验证需要，直接在全局所属状态、invariant或临界区接口原文件增补，
    并同步semaphore及其他受影响使用处，不要为绕过这个缺口另建模块专用协议。
    按模块职责增补定义和全局组合，检查受影响的接口、审阅结论与编译结果。
    Predicate 和 spec 均通过审阅、经用户确认并 implement 到 `done` 后，
    按对应阶段的[全局一致性检查与收尾](../../verification-report/SKILL.md#全局一致性检查与收尾)执行收尾。

16. Predicate 的参数应当由它所描述的对象、状态关系或资源决定，不要仅因为某个
    使用点需要一条附加条件，就把这条条件做成 predicate 的参数。增加参数前应检查：
    去掉这个参数后，predicate 是否仍能完整、无歧义地表达原来的对象关系和资源？
    如果可以，而该参数只用于在某些调用点打开或关闭额外约束，就没有必要把它作为
    predicate 参数。

    例如下面的 `empty` 不影响 `id`、`p` 与已发布对象之间的对应关系，也不改变
    predicate 拥有的资源：

    ```coq
    Definition event_delete_guard (id p : Z) (empty : bool)
        (st : VarGlobalState) : Prop :=
      p <> 0 /\ exists e,
        In e st.(os_events) /\ e.(event_addr) = p /\ e.(event_id) = id /\
        (empty = true -> e.(event_pending_addrs) = nil).
    ```

    其中 `empty = false` 只是不要求 pending 为空，并不表达一个独立状态。因此
    `empty` 没有必要成为 `event_delete_guard` 的参数。guard 可以只描述对象关联：

    ```coq
    Definition event_delete_guard (id p : Z)
        (st : VarGlobalState) : Prop :=
      exists e,
        In e st.(os_events) /\ e.(event_addr) = p /\ e.(event_id) = id.
    ```

    被移出的条件按其职责放在使用处：

    - 某个函数要求 pending list 为空或非空，就在该函数的 canonical spec 中直接写
      `event_pending_at id p nil st`，或者量化 `waiting` 后写 `waiting <> nil`。
    - `p <> 0` 表示指针 `p` 非空。指针非空条件写在 monad/program 的谓词中，
      例如用 `assume!! (p <> 0)` 表达，不要把它作为对象 guard 的参数。
    - 如果空或非空还必须跨环境步骤保持，就在相应 transition、临界区 contract 或
      具名环境条件中明确写前态和后态。

    这条经验不是禁止 predicate 使用布尔参数。若布尔值确实改变 predicate 所描述的
    抽象状态、concrete shape 或资源组成，例如分别表示未初始化与已初始化内存形态，
    它就是有语义的参数，可以保留。判断标准是参数是否属于 predicate 本身的语义。


17. 对按固定槽宽存放元素的循环数组，先把逻辑内容表示为由小元素组成的
    `list`，每个元素对应一个有效槽，列表顺序就是队列顺序。再按“单元素存储 →
    连续段存储 → 两段组合成环形缓冲区”的层次定义 predicate，使有效内容与
    剩余空闲区的资源归属直接体现在定义中。

    这里的逻辑内容一般写作 `list A`，单元素类型 `A` 按实际对象选择，
    不要求单元素本身也是列表。例如 Dataqueue 使用 `list DataqueueElem`，
    一个元素就是一个 DataElem 的抽象值，单元素 predicate 描述它的 `data` 和
    `length` 字段；不需要把该元素再表示成一个 `list`。

    以下以 MsgQueue 举例：它的一条消息是字节序列，所以单元素类型才是
    `list Z`，整个队列的内容为 `msgs : list (list Z)`。每条消息占一个固定宽度
    的槽，已知消息字节之后的槽内剩余空间只保留内存权限，不要求旧值为零。
    这是 MsgQueue 的单元素表示，不是循环数组 segment 方法对元素类型的要求。

    ```coq
    Definition store_message (p : addr) (msg : list Z) (width : Z) : Assertion :=
      “ Zlength msg <= width ” &&
      (UCharArray.full p (Zlength msg) msg **
       UCharArray.undef_full (p + Zlength msg) (width - Zlength msg)).
    ```

    连续段接收起始地址、物理槽数和有效消息列表。每次递归拥有一个有效槽；
    消息用尽后，剩余空闲槽统一表示成一块未知值内存，不再由上层另列空闲区。

    ```coq
    Fixpoint store_msgbuffer_segment (p : addr) (slots width : Z)
        (msgs : list (list Z)) : Assertion :=
      match msgs with
      | [] => UCharArray.undef_full p (slots * width)
      | msg :: rest =>
          store_message p msg width **
          store_msgbuffer_segment (p + width) (slots - 1) width rest
      end.
    ```

    注意，外层 `msgs = []` 表示没有有效消息；内层 `msg = []` 仍是一条消息，
    占用一个槽，不能把它误当作空闲槽。

    整个缓冲区固定以队头 `index` 为界分成两个连续物理段。从队头到数组末端
    最多容纳 `capacity - index` 条消息，因此用 `firstn` / `skipn` 切分逻辑列表：
    前缀放在高地址段，回绕的后缀放在低地址段。

    ```coq
    Definition msgbuffer_split_at_end (b : MsgQueueBufferAbs) :=
      let m := b.(mqbMeta) in
      let cut := Z.to_nat (m.(mqMetaMaxMsgs) - m.(mqMetaIndex)) in
      (firstn cut b.(mqbMsgs), skipn cut b.(mqbMsgs)).

    Definition store_message_buffer (mb : addr) (b : MsgQueueBufferAbs) : Assertion :=
      let m := b.(mqbMeta) in
      let '(msgs_prefix, msgs_suffix) := msgbuffer_split_at_end b in
      “ valid_malloc_addr mb (m.(mqMetaEachLen) * m.(mqMetaMaxMsgs)) ” &&
      “ msgqueue_meta_range m ” &&
      “ Zlength b.(mqbMsgs) = m.(mqMetaNumMsgs) ” &&
      (store_msgbuffer_segment mb m.(mqMetaIndex) m.(mqMetaEachLen) msgs_suffix **
       store_msgbuffer_segment (mb + m.(mqMetaIndex) * m.(mqMetaEachLen))
         (m.(mqMetaMaxMsgs) - m.(mqMetaIndex)) m.(mqMetaEachLen) msgs_prefix).
    ```

    未环绕时后缀自然为空，低地址段全部为空闲区；环绕时后缀自然落在低地址段。
    两种情形使用同一个组合定义，每段中的空闲尾部由 segment 自己拥有。
    容量、队头下标、有效元素数量和槽宽的合法范围仍由相应纯条件约束，确保
    每段有效元素数不超过该段槽数；不能仅靠列表切分代替这些约束。

    用于 Dataqueue 等结构体元素数组时，小元素改为相应的元素抽象值，单元素
    predicate 描述该槽的字段，segment 的空列表分支保留剩余槽的内存权限。
