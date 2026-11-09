# KMutexDelete predicate/spec r2 设计记录

本轮只修改 trial 内的函数级抽象与注解，不修改权威 C，也不写回全局库。未修改依赖来自目录被并发删除前保存的分层库 checkpoint；当前 trial 通过独立逻辑路径 `KMutexDeleteTrial.lib` 使用本地 `lib/KMutexDelete.v`。

Predicate revision 为 `kmutexdelete-predicate-r2-8e89a963fced`，对象是 `lib/KMutexDelete.v`。原内部操作改名为 `abs_mutex_delete_object_with_id`；登记 ID 由公开 contract 从入口 reviewed mutex state 中存在量化一次，之后由这个内部 program 作为同一 witness 贯穿 drain 与 retire 两个解锁窗口。模块状态、`mutex_inv`、退休对象 ownership 与 manager/DLL 操作没有改变。

Spec revision 为 `kmutexdelete-spec-r2-da69d36af730`。`_MutexDelete` 的 canonical contract 与 `KMutexDelete` 中的 caller-local contract 均删除了公开 `With id`；`Require` 直接存在量化一次 ID，并同时给出 `mutex_delete_live` 与同一 witness 的内部 program。函数体入口取得该 witness 后继续复用原两阶段抽象。`KMutexDelete(int32 id)` 仍直接使用它真实接收的 ID。Mutex 场景 `LinklistResumeAll` 的 `id` 仍是 high-level ghost context：它通过 `mutex_delete_live(p,id,before)` 与真实 `list == mutex_pending_head(p)` 关联，并非额外 C 输入。所有 executable C 语句保持不变。

Active implementation closure 仅保留 `KMutexDelete`、`_MutexDelete`、Mutex 场景 `LinklistResumeAll` 三个文件。`IdGetObj`、`IdRemoveObj`、`DoubleLinkListRmNode`、`KTaskWakeup` 的旧独立 `.c` 已移动到 `.docs/reused-spec-snapshots/annotated_C/src/`，只作来源快照；实际完整合同仍在各 caller 定义前。

结论仍受旧报告中用户已批准的 A1/A2 限制：A1 查询命中的同一 allocation 到注销前不被竞争删除、释放或复用；A2 排空后到注销前没有新 waiter。权威源码缺陷未修复。

设计检查：Rocq MCP 已用当前 QCP 8.20 工具链成功编译本地 `KMutexDelete.v` 和 `.docs/checks/LogicInterfaces.v`；三个 active C 目标通过 `gcc -m32 -std=gnu11 -Wall -Werror -fsyntax-only`。本阶段未运行 QCP symbolic、未生成 VC，旧 VC 只作为后续证明参考。

独立 reviewer `/root/mutex_r2_review` 对冻结 revision 完成只读审阅：predicate `review-passed`，spec `review-passed`，无 blocker。审阅复核了内部 existential ID 的固定传递、caller/canonical contract、LinklistResumeAll high-level ghost context、3 active/4 reused closure、可执行 token 一致性、Rocq MCP 与 GCC 结果。旧 r1 VC 仅作证明参考，不能作为 r2 实现证据。
