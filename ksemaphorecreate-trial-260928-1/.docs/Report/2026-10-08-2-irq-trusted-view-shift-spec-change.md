---
file_or_slice: "annotated_C/src/CriticalAreaLock.c and CriticalAreaUnLock.c trusted IRQ contracts"
approved_version: "spec-r18-4fda6049bd92"
status: review-passed
change_kind: breaking
approved_by: "user (standing approval for parser-only fallback fixes)"
approved_at: "2026-10-08"
current_candidate: "spec-r18-4fda6049bd92"
reviewed_candidate: "spec-r18-4fda6049bd92"
reviewed_by: "spec_reviewer"
review_conclusion: "review-passed"
---

# 设计变更请求：IRQ trusted boundary 承担 critical view-shift

- Change kind：`breaking`。两个已批准 trusted symbols 不变，但其局部 formal contract 从 `emp` frame 改为 ordinary critical enter/exit，因此必须形成新 spec revision 并重新审阅、批准。
- 原批准设计：`DisableLocalInterrupt` 只保证返回 PRIMASK 为 0/1，`EnableLocalInterrupt` 只要求该值并使用 `emp -> emp`；`CriticalAreaLock/UnLock` 的 C body 被要求通过普通 entailment自行把统一 OS protocol 从 outside 切换到 inside、再切回 outside。
- 新源码/proof 证据：r16 生成的 `CriticalAreaLock_return_wit_1` 左侧仍拥有 `SemaphoreOutsideCritical`，右侧要求带 depth token 的 `SemaphoreInsideCritical`；`coqc` 在该空间目标上失败。`CrtosOSProtocolView` 精确记录当前 STS state set/token，普通 separation entailment不能执行 `crtos_os_enter_core` 或 `crtos_os_exit_core`。现有 Task proof 的 `TaskFinalizeCriticalRule.v` 也明确记录普通 entailment不能改变唯一 low-state carrier。
- 拟议修改：在 `CriticalAreaLock.c` 中，先把 `SemaphoreCriticalOutside` 拆为 base outside view 与 counter=0，再调用 trusted `DisableLocalInterrupt /*@ irq_enter */`；该 trusted contract执行 outside→inside+invariant，并保留实际返回的 PRIMASK、rely/current。`CriticalAreaUnLock.c` 的 trusted `EnableLocalInterrupt /*@ irq_exit */` 消费 inside+updated invariant 与 guarantee，产生 base outside view；C body的counter decrement前后不变，并在函数返回处重新折叠 `SemaphoreCriticalOutside`。
- 对 abstract state/command 的影响：无；`CrtosOSWorld`、rely/guarantee、semaphore create command和全部成功/失败结果不变。现有 `crtos_os_enter_core`、`crtos_os_exit_core` 提供所需协议动作的已证明依据。
- 对 ownership/predicate/spec 的影响：predicate revision r20不变；`CriticalAreaLock/UnLock` canonical contracts及其callers均不变。只有两个trusted IRQ declaration-only contracts和对应调用标签改变；counter ownership仍由两个C wrapper维护，OS invariant只在IRQ-disable/restore原子边界转移。
- 对 trust/scope 和已完成工作的影响：trusted symbol集合仍为 `x_malloc`、`x_free`、`memset`、`DisableLocalInterrupt`、`EnableLocalInterrupt`、`KPrintf`，九函数闭包不变；IRQ trusted guarantee增强，需要新批准。r16生成文件已移入 `.tmp/stale-r16-generated-vc-20261008/`，不得复用或手改。
- 保持不变的 formal types/statements/interfaces：七个predicate文件、proof-local helper、所有九个non-trusted canonical contracts、public `KSemaphoreCreate` footprint/effect、全部executable C statements。
- 受影响文件和已批准内容：`annotated_C/src/CriticalAreaLock.c`的trusted disable contract、focus位置和call tag；`annotated_C/src/CriticalAreaUnLock.c`的trusted enable contract与call tag；spec report的trusted guarantee记录。
- 已考虑但拒绝的方案：不加入假设普通entailment可改变STS token；不以proof-local Axiom/Parameter/Admitted伪造view-shift；不把`CriticalAreaLock/UnLock`新增为trusted；不修改public semaphore contract或弱化统一OS invariant。
- 可独立继续的工作：无；critical helpers是`_SemaphoreCreate`的直接依赖，受影响proof全部暂停。
- 作者检查：权威C/config/source、predicate/helper hashes未变；九文件`gcc -m32 -std=c99 -fsyntax-only -fno-builtin`通过；formal project在移除陈旧生成VC后编译通过；`.tmp/IRQTransitionReview.v`已从正式`crtos_os_enter_core/exit_core`构造无frame的ordinary enter/exit protocol transitions，并通过Coq 8.20.1编译、`coqchk`及trust scan。r17设计manifest为`3cd0c5e3e9bad3f13e6cd1b8bf175463384a13a553fc8e3541f2812bb3d036f8`；parser-only r18 literal manifest为`4fda6049bd925cee126fc44a882d1406f3c3e2cbf40aa4b6be1f6cf7de738c1c`。
- 独立审阅证据：普通entailment不能改变`CrtosOSProtocolView`精确绑定的STS state set/token，也不能取得或归还OS invariant；`.tmp/IRQTransitionReview.v`从正式`crtos_os_enter_core/exit_core`构造无frame ordinary enter/exit transition，SHA-256为`8662f4aa47526daf18892e0c73fc4e024df74f31c0e015b585cfe941f7961f0f`，Coq 8.20.1 compile/coqchk/trust scan通过。对照权威`CriticalArea.c`、`xs_isr.h`和Cortex-M3 PRIMASK实现，disable/restore确为协议acquire/release的真实原子边界；counter不进入trusted footprint。
- r18 parser-only回退：Disable call使用`where (irq_enter) stable=stable,before=before`并以`Given handler current`命名既有post existentials；Enable call使用`where (irq_exit) stable=stable,before=before,after=after`。两个name与declaration标签一致，全部`With` binders完整实例化，contracts、trust、C executable和资源语义不变。作者记录的full closure run `20261008T143604-2` 9/9 syntax+symbolic dry-run通过；reviewer按门禁未重跑。
- 审阅决定和新版本：`spec-r18-4fda6049bd92` minimal affected-only review为`review-passed`。用户已明确授权此类parser-only等价回退修复无需再次等待批准，可直接继续proof。

## Independent review issue

- `SPEC-IMPL-08` | `blocker` | r16 `CriticalAreaLock_return_wit_1`/`CriticalAreaUnLock_return_wit_1`; `CrtosOSProtocolView`; `crtos_os_enter_core/exit_core`; 两个r17 trusted IRQ contracts | r16错误要求普通entailment改变唯一STS carrier；r17把同一protocol动作移至真实IRQ acquire/release边界 | 若不修复则critical wrapper无法证明；若以普通cut伪造则破坏trust边界 | trusted disable消费base Outside并以rely/current产生Inside+当前invariant；trusted restore消费Inside+更新后invariant并以guarantee产生Outside；counter始终由wrapper frame | 权威源码/宏/PRIMASK线性化点一致，handler/world/rely/guarantee索引精确，两个protocol transitions机器检查，non-trusted contracts/public API/C executable与formal hashes不变 | `fixed-in-r17-reviewed`.
- `SPEC-IMPL-09` | `blocker` | r17 named-call parser failure；两个r18 call annotations；run `20261008T143604-2` | 裸call标签未按parser grammar实例化named contract | r17设计无法进入后续VC/proof | 补齐`where (irq_enter/irq_exit)`、全部ghost binders及Lock post `Given` | literal manifest精确为`4fda6049...38c1c`，两处仅为等价instantiation，作者full closure 9/9通过 | `fixed-in-r18-reviewed`.
