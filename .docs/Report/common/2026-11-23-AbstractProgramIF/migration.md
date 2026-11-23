# Abstract program 条件与顺序记法迁移

用户已授权迁移现有定义，重点覆盖 dataqueue。本轮只调整 program 控制流表示及对应证明化简，不修改 C、canonical spec、状态关系、资源 predicate 或信任假设。

## 定义变更

| 模块 | 文件 | 迁移定义 |
| --- | --- | --- |
| dataqueue | `lib/dataqueue/KInitDataqueue.v` | `abs_init_dataqueue` |
| dataqueue | `lib/dataqueue/KPushDataqueue.v` | `abs_push_dataqueue` |
| dataqueue | `lib/dataqueue/KPopDataqueue.v` | `dataqueue_pop_after_obtain` |
| semaphore | `lib/semaphore/KSemaphoreDelete.v` | `abs_semaphore_delete` |
| semaphore | `lib/semaphore/KSemaphoreAbandon.v` | `abs_semaphore_abandon` |
| semaphore | `lib/semaphore/KSemaphoreObtain.v` | `abs_semaphore_obtain` |
| event | `lib/event/KEventDelete.v` | `abs_find_event`、`abs_event_delete_at`、`abs_event_delete` |

普通条件分支改为 `IF P c1 c2`；布尔条件使用 `b = true`，整数判定使用原比较命题。显式 `MonadErr.bind` 改为 `<-` / `;;`。保留调用顺序、早返回、条件调度及临界区边界。

`DataqueueState`、`dataqueue_cleanup_effect`、`abs_dataqueue_push_ring` 的 `nrm` 状态关系等处，普通 `if` 返回数据或 Prop，而非 program，故保留。

同步调整 InitDataqueue、PopDataqueue、SemaphoreDelete、SemaphoreObtainRuntime 的手工证明。Obtain 中的局部 `obtain_if_bool` 只用于证明侧等价化简。未修改生成的 goal、proof_auto、goal_check。

## 检查与审阅

- `make -j4 lib` 通过，迁移后的库定义及库依赖已编译。
- 对修改前工作树保存的九个定义逐一构造 `ProgramPO.equiv` 比较，Rocq 编译通过；比较覆盖 `nrm` 与 `err`。每个比较沿用相同的 callee，组合等价由 bind congruence 保持。
- 独立 reviewer 对七个库文件、四个手工证明文件的迁移差异审阅通过；没有改变原 predicate/spec 的语义结论。
- 全 `lib` 扫描未发现剩余显式 `MonadErr.bind` 或 program 层普通条件分支。未新增公理或 admitted 证明。
- `SemaphoreAbandonRuntime_goal_check.vo` 编译通过。

本轮是已有定义的等价维护，不是新一轮 C 实现验证；不将库类型检查、等价检查或差异审阅称为全工程实现证明完成。

## 全量检查的限制

下列错误出现在未迁移的状态/资源接口或生成 VC 中，阻挡相应文件的完整编译；没有通过改变数据模型或生成 VC 来绕过它们：

| 文件 | 本轮检查遇到的错误 |
| --- | --- |
| `VC/event/EventCreate_lib.v:34` | `split_pure_spatial` 要求的右侧断言形状不匹配 |
| `VC/semaphore/SemaphoreDelete_lib.v:23` | `msgqueue_inv` 不在当前环境 |
| `VC/dataqueue/PopDataqueue_goal.v:135` | `Some e : option DataqueueElem`，期望 `DataqueueElem` |
| `VC/dataqueue/DataqueuePeak_goal.v:111` | 同样的 `option DataqueueElem` / `DataqueueElem` 不匹配 |
| `VC/dataqueue/InitDataqueue_proof_manual.v:88` | `None` 被用于期望 `DataqueueElem` 的位置 |
| `VC/dataqueue/DeInitDataqueue_proof_manual.v:433` | destruct pattern 与当前命题结构不匹配 |

因此 Init、Pop、Delete 的证明侧分支适配经过差异审阅，但其完整文件检查仍受上述问题阻挡；不能沿用旧编译产物宣称当前版本的这些 VC 已通过。

隔离基线复现：复制工程到本任务独立临时目录，恢复本轮修改前的七个库文件和四个手工证明，重新编译依赖及上述六个目标。六处错误均在相同文件、相同行号复现，确认不是本次 IF/bind 迁移引入。基线副本仅用于诊断，不回写正式工程。

最终结果：`make VC/semaphore/SemaphoreObtainRuntime_goal_check.vo` 返回 0，适配后的手工证明及 goal_check 编译通过；与 Abandon 的通过结果一起保留正式 `.vo`。`git diff --check` 通过。本任务临时基线副本、旧定义快照、等价检查临时文件和构建日志在结论记录后清理。
