---
kind: spec-review
status: review-passed
function: "KSemaphoreCreate"
source_revision: "source-s1-a641419bb17a"
spec_revision: "spec-r2-a86e8780034f"
predicate_review: ".docs/Report/2026-09-01-8-predicate-r14-done-layout-review.md — predicate-r14-4aac701eaf05 — review-passed"
formal_sources:
  rocq_files:
    - "lib/IdManagerPure.v"
    - "lib/SemaphorePure.v"
    - "lib/SemaphoreCritical.v"
    - "lib/DoublyLinkedList.v"
    - "lib/IdManagerRep.v"
    - "lib/SemaphoreRep.v"
  symbols:
    - "KSemaphoreCreate"
    - "_SemaphoreCreate"
    - "CriticalAreaLock"
    - "CriticalAreaUnLock"
    - "IdInsertObj"
    - "AllocId"
    - "InsertObj"
    - "InitDoubleLinkList"
    - "DoubleLinkListInsertNodeAfter"
  annotated_c_file: "annotated_C/src/KSemaphoreCreate.c"
checks:
  - "predicate-r14 manifest/build/freshness/review passed"
  - "all nine slices pass gcc -m32 C99 syntax and ABI typedef checks"
  - "min-free fact chain and caller-local alpha-equivalence self-review"
approval:
  approved_by:
  approved_at:
  predicate_revision:
  spec_revision:
---

# Spec r2 审阅：`KSemaphoreCreate`

状态：`review-passed`。Spec manifest 命令 `sha256sum annotated_C/src/*.c | sort | sha256sum`，完整 hash `a86e8780034f2780af37ab9a2efa079ed7a5cd548eb2e97edfc77f77906c134a`。Source revision 仍为 `source-s1-a641419bb17a`，10 个输入路径与完整复现命令已在 r1 spec report 的 `SPEC-R1-03` 记录中逐名补齐。

## 1. 普通话与路径

对外 contract 语义与 r1 不变：调用者提供 `uint16` value、reviewed critical/atomic context 和 done table；allocator 失败或 ID 耗尽返回 `-5` 且 semaphore state 不变；成功返回最小空闲 ID，发布给定 value/空 waiter 对象。Critical handler 栈与可再进入事实被返回，done table 原样返回。Allocator failure、ID-full failure、success 和 wrapper 四类路径详见 r1 report，r2 不增加或排除任何源码路径。

## 2. r1 issues 修复

- `SPEC-R1-01 | blocker | fixed-by-author`：`store_id_manager_allocated_unlinked` 中的 `id_manager_min_free_id(sm,before,id)` 现在由 `InsertObj` canonical Ensure 明示保留，`IdInsertObj.c` 的 caller-local `InsertObj` Ensure 与 canonical alpha-equivalent，`IdInsertObj` canonical success Ensure 又明示返回该事实，`_SemaphoreCreate.c` caller-local copy 与之 alpha-equivalent。因此事实链为 `AllocId success → InsertObj success → IdInsertObj success → semaphore_id_registered → SemaphoreCreateSuccess/SemStepCreate`。
- `SPEC-R1-02 | blocker | fixed-by-author`：新 `predicate-r14-4aac701eaf05` 已对 done-table layout 完成 affected-only `review-passed`。Wrapper slice 现含与权威匿名 typedef 同形的 tagged `SemaphoreDone`，在 m32 ABI 下编译检查 offsets `0/4/8/12/16`与 size `20`，并保留 `create = done.SemaphoreCreate` slot load；`store_semaphore_done` 拥有同一布局五个 slot，`SemaphoreStableContext` 绑定唯一 initializer，然后才解析 direct call。
- `SPEC-R1-03 | non-blocker | fixed`：r1 report 已列出 source manifest 的全部 10 个 trial-relative 路径与完整复现命令，无需带外消息。该报告修复不影响 spec revision。

## 3. Dependencies 与 review-ready 检查

- Predicate 基础固定为 `predicate-r14-4aac701eaf05 review-passed`；Rocq 8.20.1 串行重建后 `make -q real-all` 通过，forbidden-token 零匹配。
- 权威 C/config/trusted 列表/闭包未变；9 个 nontrusted active symbols 和 6 个 approved trusted symbols 与 r1 一致。空 `KDEBUG_NOT_IN_INTERRUPT`、唯一 done dispatch、`if(0)` debug、NULL macro/static externalization 归一仍有记录。
- 9 个 slice 全部通过 `/usr/bin/gcc -m32 -std=c99 -fsyntax-only -fno-builtin`，包括 done tagged ABI typedef checks；placeholder/opaque-contract 扫描零匹配。
- Direct-callee canonical/caller-local contracts 已重新逐对检查；min-free 新后置在 `InsertObj` 和 `IdInsertObj` 两层一致，其他 contracts 不变。
- 未运行 QCP parser/symbolic、closure script、VC 或 proof。作者自审无 `[OPEN]`，结论 `ready`。

## 4. Review-passed 条件

- 验证范围：`pass`；9 个 nontrusted symbols 各有唯一 canonical active body，6 个 trusted symbols 均有已批准完整 contract。
- Source/config/macro faithfulness 与 Contract 可读性：`pass`。
- Allocator failure、ID-full failure、success 和 wrapper 的返回/effect：`pass`。
- Require/Ensure 强度：`pass`；min-free 是实现保证的后置，没有用新前置排除失败。
- Old/new、heap/ID/lazy bucket/registry/critical/done ownership 与 frame：`pass`。
- Direct-callee canonical/caller-local alpha-equivalence：`pass`，包括两层 min-free postcondition。
- Formal/annotated-C 完整性：`pass`；manifests、Rocq freshness/make-q、9 个 m32 C99 slice、forbidden/placeholder 检查均通过。
- Open blocker：无。`SPEC-R1-01..03` 均为 `fixed`。

## 5. Review 记录

- 因 predicate r13 基础失效并替换为 r14，依 review lifecycle 对 r2 做新的 `full` review，不仅复审 r1 issue。
- Review ID：`SPEC-R2-FULL-01`；结论：`review-passed`。
- Review-passed spec revision：`spec-r2-a86e8780034f`。
- 用户批准 revisions：predicate/spec 均 review-passed 后在暂停报告中由用户确认。
