当前仅准备 ARM32 LittleEndian 修复后的接口草案，未修改 active annotated header 或任何函数文件。新的 predicate 候选及 nest-cell view 尚待独立审阅，因此不固定新的 spec revision，不执行正式接口检查，也不启动 QCP。

已核对 `evidence/arm32le-candidate/nest-view-draft/SemaphoreCriticalViews.v` 的实际定义。最小 header 增量为一条直接 import：`CRTOS_Verify.sem.SemaphoreCriticalViews`；在已有 term Extern 块加入 `SemaphoreCriticalFrame : CrtosOSStable -> CrtosOSState -> Assertion` 和 `CrtosOSValid : CrtosOSState -> Prop`。前者表示临界计数单元之外的精确资源余项；后者是重建 OS invariant 时保留的纯有效性事实。无需新增逻辑类型，不把内部 scheduler 表示或 Rocq lemma 伪装成 C callee。

候选 header 和当前 helper hash 记录在 `evidence/spec-arm32le-interface-draft/`。正式函数 contracts、caller-local contracts、trusted contracts 均保持原文；CriticalAreaLock 的冗余 where 已由原 annotation owner 修改，本作者不再写该函数正文。该处 proof-local 差异会在后续正式 annotated manifest 中收录。

接口检查脚本已改为必须显式传入 predicate build、manifest、预期 revision、Coq project 和 coqc 路径，去掉 r3/default 编译器硬编码。后续将使用已接受的 `/home/xinra/.opam/pv-bench-8.20.1/bin/coqc` 及正式 ARM32LE config，核对 config/compiler/manifest 绑定；脚本拒绝原先 legacy framework 路径。此次只检查了 Python 脚本语法，没有运行 Rocq 或 QCP。

收到主 agent 对明确新 predicate revision 的 review-passed 通知后，才将最小接口增量写入 active header，纳入 owner 的已确认 proof-local 变化，固定新 annotated manifest，运行新 backend 的接口检查，再交独立 spec review。
