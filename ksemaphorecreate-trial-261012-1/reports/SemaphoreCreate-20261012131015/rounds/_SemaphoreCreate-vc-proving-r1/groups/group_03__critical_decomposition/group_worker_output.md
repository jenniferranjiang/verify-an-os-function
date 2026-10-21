# critical_decomposition completed

全部 7 个 assigned proof spans 已完成，声明、prelude 与未分配 proof tokens 保持不变；未新增 helper、import 或 library。

- entail_wit_1 的三个纯 split 分别投影 OS invariant 有效性、零对象的 sem.id 地址元数据，以及使用命名全局地址非零定理。
- 空间 split 用既有 OSHeap pure/sep 等式分解 heap，从同一 InsideCritical 取得 manager 全局地址，按定义相等保留 nest_increment 的 task/semaphore 投影，重排并保留全部 heap 与同一 IRQ 资源。
- top-level 按 aggressive_pre_process 实际顺序，以 Goal_apply 分派 spatial、pure 1、pure 2、pure 3。
- partial_solve_wit_4_pure 与 partial_solve_wit_4 使用 whole-goal LLM_pre_process；包装层显式展开 aux 后保留纯前提并重排相同资源。

验证：禁用 lemma/tactic 扫描通过；group-development exit 0/status passed；最终 group-check exit 0/status passed（124.556601 秒）。无 annotation/spec 缺口。

已停止全部写入，等待 main finalize-delivery。
