---
kind: spec-review
status: review-passed
function: "_SemaphoreCreate / KSemaphoreCreate"
predicate_revision: "b94f379135fae7f859cdcd716dbdec0cd489d3be291f2da45451d55ad7ec0840"
spec_revision: "406797f561797866ca97c686d73572632314ba7d709d2bb83d92977b6f706e3f"
source_revision: "d5b41c3bde69e0416431d2425c61e35453778ae4b1569747f2c2258f3dfe16ec"
checks: ["make lib", "make source-syntax", "QCP-MCP", "trust scan", "source SHA256", "VC=0"]
approval:
  approved_by:
  approved_at:
---

# KSemaphoreCreate spec full review

## 文件结构

`annotated_C/src/`扁平放置10个C文件：两个create目标和八个direct callees。每个callee恰有一个文件，包含自己的canonical spec和active body。

| 文件 | canonical function | body内API状态 |
|---|---|---|
| `x_malloc.c` | `x_malloc` | lock、align、capacity、debug、static/dynamic allocator、legality均在函数前带完整spec |
| `memset.c` | `memset` | 无callee；保留musl optimized active body |
| `critical_area_lock.c` | `CriticalAreaLock` | `DisableLocalInterrupt`带raw-IRQ中间态spec；原宏已拆为直接API调用 |
| `id_insert_obj.c` | `IdInsertObj` | NullCheck、AllocId、InsertObj均带完整spec |
| `x_free.c` | `x_free` | lock、legality、classification、debug、release均带完整spec |
| `critical_area_unlock.c` | `CriticalAreaUnLock` | `EnableLocalInterrupt`带raw-IRQ中间态spec；原宏已拆为直接API调用 |
| `init_double_link_list.c` | `InitDoubleLinkList` | 无callee |
| `double_link_list_insert_node_after.c` | `DoubleLinkListInsertNodeAfter` | 无callee |

不存在裸callee prototype、`#if 0` body或集中式`*_specs.h`。Caller中的八份declaration-only copies与callee canonical specs alpha/typedef等价。

## Predicate变化

- `SemaphoreCriticalCore`只拥有STS/tokens；完整`SemaphoreCritical`唯一追加物理nest counter。
- `semaphore_irq_disabled_acquire_post`表示Disable之后、counter `++`之前。
- `semaphore_irq_disabled_release_pre`表示counter `--`之后、Enable之前。
- `store_sem_id_manager_reserved`精确表示AllocId置bitmap但InsertObj尚未链接的中间态；reserved ID必须in-range且fresh。

Predicate full/delta review已通过，revision为`b94f3791…0840`。

## Create路径

| 路径 | 返回 | Abstract effect |
|---|---|---|
| allocator失败 | `-ENOMEMORY` | state stutter / `SEM_CREATE_NO_MEMORY` |
| ID耗尽 | `-ENOMEMORY` | free fresh block，state stutter |
| 成功 | 最小空闲ID `0..127` | publish 64-byte semaphore、value、empty pend-list、global-head insertion |
| wrapper | 同private | function-pointer转发并frame done-rest |

## Formal evidence

- `make lib`：PASS；`make -q lib = 0`
- `make source-syntax`：10个flat C files全部PASS
- QCP-MCP整文件symbolic/close：
  - Critical Lock `3 auto / 3 manual`
  - Critical Unlock `5 / 3`
  - IdInsertObj `11 / 4`
  - x_malloc `54 / 0`
  - x_free `18 / 0`
  - InitDoubleLinkList `3 / 2`
  - DoubleLinkListInsertNodeAfter `3 / 2`
  - `_SemaphoreCreate` `37 / 14`
  - `KSemaphoreCreate` `2 / 1`
- musl `memset`：QCP load/close成功；implementation body proof pending，不在selected implementation closure
- source/config SHA256：PASS
- trust scan：PASS
- VC：0；未调用`qcp.proof`

## Grounded normalizations

- function-like lock/debug/allocator macros或done-table dispatch在单函数slice中改为文件前部具名API，并附完整spec。
- Id assignment expression拆为顺序assignment与branch。
- musl loop comma-update拆为两条顺序语句；optimized algorithm本身未替换。
- wrapper中authority-static函数在split slice声明为external APIs。
- `x_malloc` contract专门化为`0 < size <= 64`；本closure唯一调用参数为`sizeof(struct Semaphore)=64`。

## Review记录

- 旧`b151…`：invalidated，原因是callee body被`#if 0`隐藏。
- 旧`93bf…`：invalidated，原因是整棵source tree不符合用户要求的一函数一文件结构。
- 当前FULL review：`review-passed`。
- Spec revision：`406797f561797866ca97c686d73572632314ba7d709d2bb83d92977b6f706e3f`。
- Open blocker：无。
- 当前停在implement gate。
