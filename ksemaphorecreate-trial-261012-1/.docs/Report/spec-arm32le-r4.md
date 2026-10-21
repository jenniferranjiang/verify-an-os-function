当前 spec 候选已达到 **review-ready**，等待主 agent 独立 delta review。此次保持九个函数的 canonical/caller contracts、六个 trusted contracts 及真实 C 行为不变；仅补齐已审阅的临界计数 view 接口，并纳入原 annotation owner 已完成的冗余 where 删除。本作者没有写函数正文，也没有运行 QCP。

候选为 `spec-r4-9f3ebc915b99`，annotated manifest 为 `9f3ebc915b995fc8655bab8014878df4648f3dca6602cef7d65b936714274c48`。它绑定独立 review-passed 且已接受的 `predicate-r5-0a139d64743c`，predicate manifest 为 `0a139d64743cce8000b0910d7880d6c5a0bf89147b730665aa6ebefbfb45585a`，来源仍为 `source-r2-0c50c37013e9`。Predicate 审阅依据是 [r5 review](2026-10-12-5-predicate-review.md)。旧 backend 结论不作为当前 Rocq 检查的依据。

header 只新增 `CRTOS_Verify.sem.SemaphoreCriticalViews` 的直接 import，以及 `SemaphoreCriticalFrame` 和 `CrtosOSValid` 的 term Extern 声明。前者是单个 nest UShort 单元以外的真实资源余项；后者是重建时的纯有效性事实。两者都已存在于接受的 formal revision，不新增定义、ownership 或 trusted 假设。新增接口只服务函数体局部的表示展开，不改变对外函数层次。

相对上一 annotated manifest，另一个文件差异来自 annotation owner：CriticalAreaLock 调用 DisableLocalInterrupt 的显式 where 被删除，由实际 parser 支持的自动参数实例化替代。其 With/Require/Ensure、call 参数和 executable tokens 没有改变。本作者进入任务时记录了该文件 hash，并在写 header 后重新确认九份函数文件均未被本作者改动。

检查结果如下：

- 重新核对全部 47 份当前权威源码/config 文件 hash，全部匹配 source r2。九个 body 经批准正规化后仍与权威预处理结果逐 token 一致；从目标重扫的闭包恰为九个非 trusted 和六个获批 trusted。所有实际 call 都有完整 API，caller-local 与 canonical contracts 逐字一致。
- 当前 C 语法及 slice layout 以现有 `gcc -m32` 检查通过。原 ARM cross-compiler 在临时目录中已不可用；因源码、物理 layout header 和 executable tokens 均未改变，复用此前实际 Cortex-M3 编译产生的 ABI 证据。这两项作用不同：native 检查不被称为新的 ARM 编译。原 `source-abi.s`、真实 ARM command record 均未覆盖。
- Rocq 接口检查使用 `/home/xinra/.opam/pv-bench-8.20.1/bin/coqc` 和当前已接受的 `_CoqProject`，config SHA-256 为 `31614155daad904f4bb2411acc60639d7c99aaf3749eb967d185d7b56d930f15`。35 个 Extern 名称/type/arity、12 个复合项及最终 OS Assertion carrier 全部通过，exit 0；所有 20 个 formal sources 在检查前与 predicate r5 manifest 校验一致。没有复用旧 framework 的类型检查结果。

完整证据为 `evidence/spec-check-result.json`、`spec-interface-check.json`、`spec-r4-readiness.json`；候选 annotated 快照与检查记录位于 `evidence/spec-arm32le-r4/`。机械检查耗时分别由脚本记录；没有估算人工耗时。接口检查不是 parser/symbolic 成功记录，也不是 C proof 结论。

本作者没有剩余 open blocker。下一步仅为主 agent 的独立 spec delta review；通过后由现有 controller 的 annotation owner 按原流程继续。
