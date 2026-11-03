# publish_invariant 完成交付

当前 assigned top-level witness 及全部五个 split goals 均已证明。成功路径用真实锁内观察与创建关系见证导出 safeExec；派生 manager 的等式由 id mod 16 的全部十六种可能逐一计算证明，保持 ID 列表及每个哈希桶顺序；空等待列表保持全局调度拥有者和服务任务约束。最终将未变化模块资源与发布后的 mutex 模块合并为精确的 os_inv。

两个新增辅助 lemma 均以 __publish_invariant 为后缀且有完整 Qed。未改 predicate、spec、C 或 seed。top-level aggressive_pre_process 自动解决 guarantee 纯关系，剩余四分支仅使用对应 Goal_apply；该 guarantee split 自身也以 LLM_pre_process 独立证明。

所有 split/top-level 和两个 helper 均通过 Rocq MCP 交互证明。MCP 对已更新依赖库存在热缓存问题：重新 rocq_start 后仍不可见新增 helper，因此在 scratch session 中重放 helper 的完整真实证明，再完成精确 generated VC；没有注入 helper 假设，也未 force_restart 共享后端。

最终交接指定 group-check 实际编译 group lib、goal、auto、manual 与 group wrapper，退出码 0、JSON status passed，耗时 24.348389 秒。assigned proofs 与 group lib 的禁用 lemma/tactic 扫描无命中。
