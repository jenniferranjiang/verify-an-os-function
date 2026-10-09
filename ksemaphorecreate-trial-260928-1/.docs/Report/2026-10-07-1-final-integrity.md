---
kind: final-integrity
status: verified
target_function: "KSemaphoreCreate"
source_revision: "source-s2-2adc70fc1afc"
approved_predicate: ".docs/Report/2026-09-28-2-predicate-design.md — predicate-r23-1845f34ef435 — review-passed"
approved_spec: ".docs/Report/2026-09-28-3-spec-review.md — spec-r25-4ac7a52f6b42 — review-passed"
checked_by: "main-agent"
---

# 最终完整性检查：`KSemaphoreCreate`

> 本记录只汇总实际命令和结果，不重新解释 predicate/spec 设计。本次在
> proof-discovered `SPEC-IMPL-10` 完成 r25 回退审阅、重新生成受影响 VC，并为全部
> QCP auto obligations 建立无占位 `Qed` 实现后执行 full check。

## 1. Annotated C

- 与权威 C 相比的注解/等价归一：`pass`。17-file source/config manifest 以
  `sha256sum <files> | sort | sha256sum` 复算为
  `2adc70fc1afc9adc12e575002801d20894672db63764e7fdc7825754648893c2`，即
  `source-s2-2adc70fc1afc`。配置仍为 `board/stm32f103-nano/config`、Cortex-M3
  ILP32、非 SMP。函数指针 dispatch、debug macro、static 外置、IRQ macro 与
  parser-only normalizations 仍与 spec review ledger 一致；C executable 未改变。
- 当前配置下可执行路径一致：`pass`。九个 annotated C 均通过
  `gcc -m32 -std=c99 -fsyntax-only -fno-builtin`；独立 C11 `_Static_assert`
  probe 确认 pointer=4、Semaphore=32，并与权威 `xs_sem.h` 的
  `IdNode/value/pend_list/link` 布局一致。
- Annotated manifest：literal
  `4ac7a52f6b420f037e1925005bbeac89eec07731388cfe5754d8228d7ec8c781`；
  closure path-normalized
  `d12c0e7f7ff0c8dbcfe254237a0c681295999035ddd9ed6fef0c543a6471a544`。
- Trusted C symbols 精确保持为 `x_malloc`、`x_free`、`memset`、
  `DisableLocalInterrupt`、`EnableLocalInterrupt`、`KPrintf`；未新增或扩大 trust
  symbol 集合。

## 2. QCP 与 VC

- Review gate：predicate `predicate-r23-1845f34ef435` 的七文件 manifest 为
  `1845f34ef4351d7cb9e97b241d242c8e5295323530c1428066c2f1f273852bfc`；
  spec `spec-r25-4ac7a52f6b42` 经独立 reviewer `spec_r25_review`
  affected-only `review-passed`。用户已对 proof-discovered spec 修复完成 review 后
  直接恢复 implement 给出 standing approval。
- Full closure：最终 run `20261009T234235-2`，`CLOSURE_KIND full`、
  `REVIEW_EVIDENCE_READY yes`；九文件 C syntax、symbolic dry-run 与 lib trust scan
  全部 `PASS`。记录位于 `.docs/Report/check-timings-final-r25.tsv`。
- QCP MCP parser/symbolic：九个文件均 `Finish Parsing` 且执行到最后一行，结果均为
  `success/unproved`；manual obligation counts 依次为
  `12,2,2,2,3,1,9,1,16`，合计 48。`qcp.proof` 对两个 r25 affected functions
  重新导出当前 witness record；正式 Rocq artifacts 由同一 QCP binary 的
  `symexec --coq-output-dir VC --coq-logic-path CRTOS_Verify.VC --no-CRules`
  生成。`--no-CRules` 是因为 annotated units 已按正确顺序导入并选择
  `CrtosOS_C_Rules`。
- VC generation：`_SemaphoreCreate` 与 `KSemaphoreCreate` 在 r25 后由 QCP 重生成；
  其余七函数输入未变，保留同一 QCP outputs。Generated goal/auto/manual/check
  manifests 分别为：
  `1dfd907be3b497e6d4098679927e510d0938a7b0d45bd6812a9fb9e027b3b3f4`、
  `d0c56c85ba21085c44fdeec8593c7d4b7cee1bc31669e990747ca1e1fc2ed1f5`、
  `cc65606c2b723e6753ea1c9a294c1e004d36d5fbd46635965e9ffbce33cf3cb3`、
  `b084975c61952a7a59880d9dd3e9056bfa9329460752e75db1b24c72204a7ff7`。
  Goal/auto/check 文件没有手工修改；manual 文件只保存人工 `Qed` 并移除对原
  generated-auto 的非必要 import。
- Generated / proved / remaining VC：QCP `VC_Correct` interface 恰有 172 项；
  generated-auto 分类 124 项，manual 分类 48 项。正式
  `*_proof_auto_verified.v` 对同一 124 个 theorem statement 全部给出 `Qed`，九个
  manual 文件对全部 48 个 direct manual obligations 给出 `Qed`，另含 47 个 split
  helper proofs。集合检查结果：`provided_required=172`、`missing=0`、
  `duplicate_required=0`、generated-auto 与 verified-auto name delta 为 0。
- Goal 完整、未删除/弱化/隐藏：`pass`。九个 `*_goal_check_verified.v` 直接实现原
  generated goal 中同一个 `VC_Correct` Module Type，只 Include verified-auto 与
  manual proofs。Verified-auto/check manifests 分别为
  `b2d602df1b1c4fde72baf1364043a4aed86253f28cb6bbee64138e0390fdd3d5`、
  `e3480422b5f788c508a4fd883aaff96063b0a4725031bd8ac6ac859c63efa59a`。

## 3. Rocq 与可信性

- 调用依赖按 leaf 到 wrapper 完成：`InitDoubleLinkList`、
  `DoubleLinkListInsertNodeAfter`、`CriticalAreaLock`、`CriticalAreaUnLock`、
  `AllocId`、`InsertObj`、`IdInsertObj`、`_SemaphoreCreate`、
  `KSemaphoreCreate`。
- Rocq compilation：`pass`。Coq/Rocq 8.20.1、OCaml 4.14.1；
  `coq_makefile -f _CoqProject -o Makefile.coq` 后执行
  `make -B -f Makefile.coq -j2 COQBIN=/home/xinra/.opam/default/bin/
  COQC=/home/xinra/crtos/StartupKTask/tools/qcp-coqc-wrapper`，完整 62 个 project
  `.v` 强制重编通过。`_CoqProject` hash 为
  `ea3fbdbd41e860ba42fcc9fbfc662a1772b28b02b4368262e7ee6b641bae5b8a`；
  全部 formal source manifest 为
  `df9204df9d79f157169abc2c0e3959a38ae76d63e142475ba667eb833c58defc`。
- Rocq MCP：`pass`。交互证明用于完成 value-cell 到两个 embedded list-head
  non-null 的 helper 及 `_SemaphoreCreate` auto parents；最终
  `rocq_compile_file(keep_vo=true)` 对九个 `*_goal_check_verified.v` 全部返回
  `success=true`。对修复 size blocker 的 auto theorem、`_SemaphoreCreate` success
  manual theorem 与 wrapper auto theorem 运行 `rocq_assumptions`，三者均只列
  `sizeof_front_end_type`、`eval_addr_expr` 两个既有 C front-end interpretation
  assumptions，没有 generated proof constant。`SemaphoreProofLocal.v` hash 为
  `2e984277c5f078fd8bad0c07f24337c4b59503b35c2088cb82698c25fead730b`。
- `coqchk`：`pass`。`make -f Makefile.coq validate` 对 `_CoqProject` 全部 formal、
  generated、manual、verified-auto 与 verified-check modules 以 exit 0 完成。
  另对九个 verified goal-check 联合运行 `coqchk -silent -o`；context 中没有
  `proof_of_*`、原 `_proof_auto` 或 `CRTOS_Verify.VC.*` axiom dependency，且
  type-in-type、unsafe (co)fixpoints、assumed positivity 均为 `<none>`。
- Assumptions/`Parameter/Axiom/Admitted/admit` scan：`pass`。`lib/*.v`、
  `SemaphoreProofLocal.v`、全部 manual、verified-auto 与 verified-check 的
  `Admitted|admit|Abort|Axiom|Parameter` declaration 匹配为 0；verified chain 对
  原 generated-auto 的 import 为 0。联合 `coqchk -o` 只列既有 QCP/Coq framework
  assumptions（C front-end 地址/`sizeof` 解释、GlobalStrings、经典逻辑与外延性），
  没有本项目新增 proof gap。
- Generated-file 分类：九个 generated goal 的 172 个 `Axiom proof_of_*` 仅是
  QCP Module Type 接口；九个 generated-auto 文件按 skill 要求原样保留 124 个
  工具 `Admitted`，只作为生成记录，既不被 manual/verified modules import，也不
  作为验证证据。对应 124 项已由独立 verified-auto `Qed` 全覆盖。因此最终
  certified chain 本身无占位。
- Approved statement/spec 与 proof 对应：`pass`。r25 的
  `sizeof(struct Semaphore) == 32` 在 `_SemaphoreCreate` canonical、caller-local 与
  wrapper canonical 三处同步；新 generated goals 把该事实作为 entry `PreH`，原
  `SPEC-IMPL-10` malloc 前义务由该 approved precondition 闭合。其余 abstract
  effect、ownership、critical protocol 与 r23/r24 结论保持。

## 4. 失败项

- 无剩余失败项。
- `SPEC-IMPL-10` 已按流程回退 spec，形成并独立审阅
  `spec-r25-4ac7a52f6b42`，随后重跑 closure/QCP/VC/proof/full integrity，状态
  `fixed-and-passed-in-r25`。
- 首次 final build 命令曾把 `COQBIN` 写成无尾斜杠的路径，`coqdep` 未执行且该次
  make 输出作废；随后使用 `/home/xinra/.opam/default/bin/` 完整 `make -B`，实际
  逐文件输出 `COQC` 并 exit 0。首次 direct generation 的冗余 `--CRules` 也因导入
  顺序错误作废，正式 artifacts 已用 `--no-CRules` 重新生成并通过全部检查。

## 5. 结论

- `verified`：当前批准 source/config、predicate r23 与 spec r25 下，九函数完整
  closure、9/9 QCP parser/symbolic、172/172 VC 的无占位 `Qed` 覆盖、全项目强制
  编译、九个 verified goal-check 的 Rocq MCP compile、全项目 `coqchk`、精确计数
  与 trust scan 全部通过。
- 未运行检查及原因：无必需检查未运行。
- 剩余问题：无。
- 本次是 `full`；触发原因为 completion audit 发现旧结论依赖 124 个 QCP auto
  placeholders，并进一步暴露 `SPEC-IMPL-10`。本次已完成 spec 回退和完整证明链
  重建，旧的 generated-auto placeholders 不在 certified dependency chain 中。
