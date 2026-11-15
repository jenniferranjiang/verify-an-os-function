# InitDataqueue：源码处理完成后的重启点

用户已明确要求将当前 trial 退回到“源码处理完成、尚未开始 predicate design”的阶段，并从这里重新设计。此回退不是恢复任何已撤回的 predicate/spec 方案。

## 当前入口与状态

- 工程：`/home/xinra/crtos-verify`。
- 继续使用：`initdataqueue-trial-261115-1`。这是用户指定的现有重启点，不另建或自动改名 trial。
- Skill：`.agents/skills/verify-an-os-function/SKILL.md`，以及当前指南与 `.agents/verify-os.config.json`。必须使用最新规则，不能从旧报告恢复过时的工程组织约定。
- 源码修复与适配已完成，并通过所记录的针对性检查；尚无保留的 predicate、spec、审阅通过 revision、VC 或 QCP workflow。
- 本 trial 的 lib、设计阶段 header、callee 切片、predicate/spec/依赖设计报告均已删除；根项目与编辑器中本轮的 Rocq 映射/输入已移除，根 Makefile 已从剩余 _CoqProject 重新生成，没有编译全局库。
- 原仓库与全局 formal 文件未因此次回退改变。旧 `initdataqueue-trial-261112-1` 保持不动，禁止读取或复用其中任何设计、注解、证明和报告。

## 保留的源码与证据

1. `annotated_C/src/InitDataqueue.c`、`DeInitDataqueue.c`：已获批准的修复版本，尚未附正式 spec。
2. `annotated_C/module_context/PushDataqueue.c`、`PopDataqueue.c`、`DataqueuePeak.c`：完整模块分析所需的修复/适配版本；不因保留在此而成为 Init 的实现证明目标。
3. [source-analysis.md](source-analysis.md)：本轮独立源码分析及配置依据。
4. [source-errors.md](source-errors.md)：原始缺陷、批准的副本修复、五份文件哈希和针对性检查。
5. [source-fix-review.md](source-fix-review.md)：源码修复与适配的复核记录，不是 predicate/spec 审阅。

当前权威 data_queue.c SHA-256 为 `a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601`。此前源码发生过外部变化；继续前核对当前基线，只针对新变化补充分析，不无依据重做已经完成的修复。五份副本已在此次回退前后逐一核对哈希，内容与 source-errors.md 的检查版本完全一致。保留文件仍包含后续需要按规则处理的调试/NULL宏；它们是设计起点，不宣称已经是完整 QCP 输入。

## 持续有效的用户授权

- 只修改当前 trial 的验证副本，`/home/xinra/crtos` 原仓库只读。Init/DeInit 使用 -1 表示未取得 ID、<0 判断创建失败、>=0 判断删除；Push/Pop 统一按 timeout 获取 semaphore，失败即退出。失败字段可能保留 -5，不能假定都变为 -1。
- Peak 的检查和读取已按当前默认共享访问规则放入同一临界区，两出口解锁。
- 用户已明确批准 `DisableLocalInterrupt` / `EnableLocalInterrupt` 作为本轮非 SMP、32 位模型中的可信 IRQ 资源交接边界：Disable 从 OutsideCritical 取得 InsideCritical 与 os_inv；Enable 在恢复 os_inv 后交回 OutsideCritical；同次 Disable 返回的保存值必须原样传给 Enable。结论不包含硬件 mstatus 正确性。该授权不需要再次询问；不扩展到其他函数，不修改用户维护的 TrustBase。
- predicate/spec 的具体定义与 revisions 尚未获批准。两者独立 review-passed 后仍须提供导读并等待用户确认，之后才可进入 implement。

## 重新设计必须遵守的边界

以用户最新修订的 skill 为准：未修改的项目库及传递依赖直接 import 全局版本；仅需修改的已有库副本及新增库放进 trial/lib，不整批复制依赖闭包。QCP 等外部基础库按配置引用。直接在 trial 的原全局 state 和 os_inv 定义副本中增加模块，不建立包裹旧 state/os_inv 的外层总状态或替代 invariant。只处理本轮 trial，正式迁出后再统一解决全局依赖与编译。

源码分析覆盖整个 dataqueue 模块；实现 spec/证明范围按实际调用闭包确定。原设计阶段的“18 个目标”等分类没有保留为本次约束，必须重新核实已有 spec 来源、证明状态、当前接口适用性和必要闭包。不得因来源有 spec 就直接当作已证明，也不得因原 trial 曾列入某个目标就自动重复安排证明。

当前停在源码处理完成阶段，等待用户重新指示开始设计。恢复时先核对上述源码基线和修复记录，再按最新 skill 开展 predicate/spec 设计，不恢复本次撤回的草案或候选闭包。未经用户确认两份通过审阅的 revisions，不运行 QCP parser/symbolic、生成 VC 或启动 verification-orchestrator。

## 本次回退核对

已按用户要求撤回本次 predicate 纯状态草稿、49 份依赖副本和设计/依赖报告，移除根构建及编辑器中的本轮映射。五份源码副本哈希与 source-errors.md 一致，已批准的修复和 IRQ 授权完整保留。刚修订的 skill 库复用规则保留。没有运行 QCP parser/symbolic、生成 VC 或启动 verification-orchestrator；没有保留或批准 predicate/spec revision。

## 本次重新设计进展（2026-11-15）

已重新核对权威源码及五份起点副本，全部与上述重启基线一致。正在按用户本次指令开展 predicate/spec 设计，尚无已批准 revision。模块分析发现的 Push/Pop 锁外共享 ID 读取已按默认规则适配，main 独立复核及16例控制流检查通过；当前两份副本hash及适配限制见 source-fix-review.md 最后一节，其余三份副本基线不变。没有读取禁止的旧 trial，也没有启动 QCP。
