---
file_or_slice: "annotated_C/src/_SemaphoreCreate.c; annotated_C/src/KSemaphoreCreate.c"
approved_version: "spec-r24-4abdd1dcbfd1"
candidate_version: "spec-r25-4ac7a52f6b42"
status: review-passed
change_kind: breaking
approved_by: "user (standing approval for proof-discovered spec fixes)"
approved_at: "2026-10-09"
---

# 设计变更请求：`_SemaphoreCreate` 的 32 位对象大小前提

- Change kind：`breaking`。该修改给 `_SemaphoreCreate` 与公开 wrapper 的
  `Require` 增加当前批准 ABI 的结构体大小事实，因此旧 spec revision 失效；不改变
  predicate、abstract command、ownership 或 executable C。
- 原批准设计：`spec-r24-4abdd1dcbfd1` 只在 malloc 返回后的
  `store_sem_allocated`/`semaphore_layout_32_ok` 中携带布局事实；函数入口没有
  `sizeof(struct Semaphore) = 32`。
- 新源码/proof 证据：QCP 生成的
  `VC/_SemaphoreCreate_goal.v:_SemaphoreCreate_partial_solve_wit_1_pure`
  在执行 `x_malloc(sizeof(struct Semaphore))` 前要求
  `sizeof("Semaphore") = 32`。该等式不能由 r24 entry context 推出；generated auto
  中的占位此前掩盖了缺口。`.tmp/semaphore_abi_r25_check.c` 在
  `gcc -m32 -std=c11` 下以 `_Static_assert` 确认 pointer size 4、Semaphore size 32。
- 拟议修改：在 `_SemaphoreCreate` canonical contract、`KSemaphoreCreate.c` 中的
  caller-local `_SemaphoreCreate` contract、以及 `KSemaphoreCreate` canonical
  contract 三处同步加入同一个 ABI 前提。为使 standalone wrapper slice 能解析
  `sizeof(struct Semaphore)`，该 slice 同步保留 `xs_sem.h` 的完整相关 struct layout；
  它不增加对象或可执行语句。
- 对 abstract state/command 的影响：无。成功、两条失败路径、返回值、rely、
  guarantee 与 `abs_ksemaphore_create` 均不变。
- 对 ownership/predicate/spec 的影响：predicate r23 和全部 ownership transfer
  不变；只把当前配置的编译期 ABI 事实置于两个顶层函数入口，并保持 canonical 与
  caller-local alpha 等价。
- 对 trust/scope 和已完成工作的影响：九个 non-trusted、六个 trusted symbol 集合
  不变；authoritative source/config revision `source-s2-2adc70fc1afc` 不变。
  只需重新审阅上述三份同步 contract、wrapper 的 layout-only declaration、两个
  transitive callers，并重新生成 `_SemaphoreCreate`/`KSemaphoreCreate` VC；最终仍将
  对完整九函数 closure 重跑 parser/symbolic、build 与 trust scan。
- 保持不变的 formal types/statements/interfaces：七个 predicate formal files、
  `SemaphoreLastSeen`、`abs_ksemaphore_create`、critical protocol、callee specs、
  success/failure Ensure 以及 C 函数体。
- 受影响文件和已批准内容：`annotated_C/src/_SemaphoreCreate.c`、
  `annotated_C/src/KSemaphoreCreate.c`；旧 spec r24 标记 invalidated。当前九文件
  literal manifest（`sha256sum annotated_C/src/*.c | sha256sum`）为
  `4ac7a52f6b420f037e1925005bbeac89eec07731388cfe5754d8228d7ec8c781`；
  closure path-normalized manifest 为
  `d12c0e7f7ff0c8dbcfe254237a0c681295999035ddd9ed6fef0c543a6471a544`。
- 已考虑但拒绝的方案：不能把该等式作为新 `Axiom`/`Parameter` 或 proof-local
  assumption；也不能弱化 allocator 的 `size == 32` contract，因为它精确描述真实
  allocation footprint。把事实只加给 callee 而不贯穿 wrapper 会破坏 caller closure。
- 可独立继续的工作：不受影响的 87 个 generated-auto obligations 已有 `Qed`
  候选；`_SemaphoreCreate` 除最初两个 size obligations 外的其余 35 项也已完成
  无新增设计缺口的诊断证明。
- 审阅决定和新版本：独立 reviewer `spec_r25_review` 完成 affected-only review，
  结论 `review-passed`，reviewed revision 为 `spec-r25-4ac7a52f6b42`。三处
  contract 同步、ABI/source 依据、合法调用集合、closure/scope/trust 保持及九文件
  32 位 C syntax 均通过；无 open blocker。Public Require 在保持既有 predicate 与
  trusted allocator/memset contracts 不变的约束下是最小传播，未把布局事实隐藏进
  trust boundary。
