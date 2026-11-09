# KEventDelete predicate/spec r2 设计记录

本轮只修改 trial 内的函数级抽象与注解，不修改权威 C，也不写回全局库。未修改依赖固定为目录被并发删除前保存的分层库 checkpoint；其 `lib/common/EventInv.v` SHA-256 为 `c62ddc563ed2b3daf1f9241d806c20acd445f500f6c44a5626cd81befce618b7`。当前 trial 通过独立逻辑路径 `KEventDeleteTrial.lib` 使用本地 `lib/KEventDelete.v`。

Predicate revision 为 `keventdelete-predicate-r2-65a2bb90f38a`，对象是 `lib/KEventDelete.v`。`event_delete_guard` 现在只描述 ID、地址与已发布事件的身份关系，不再使用 `empty` 开关，也不把指针非空混入对象关系。普通存活观察和最终空等待队列观察分别由 `event_delete_gap` 与 `event_delete_empty_gap` 表达；空队列条件位于最终注销 acquisition 的真实使用点。内部 `abs_event_delete_at(id,p)` 仍固定一个 ID witness 贯穿所有解锁窗口。

Spec revision 为 `keventdelete-spec-r2-11db06d3cde5`。`_EventDelete` 的 canonical contract 不再在 `With` 中量化 C 接口没有接收的 ghost ID；它在 `Require` 中存在量化一次内部 ID，并把同一 witness 交给 `abs_event_delete_at`。`FindEventById` 返回命中对象时给出新的身份关系；`LinklistResumeAll` 返回时直接给出 `event_pending_at(..., nil, ...)`；两个受限 lock contract 分别对应 D1 的对象存活与 D1+D2 的对象存活且等待队列为空。`KEventDelete` caller-local `_EventDelete` contract 与 canonical contract 同步。所有 executable C 语句保持不变。

Active implementation closure 仅保留 `FindEventById`、Event 场景 `LinklistResumeAll`、`_EventDelete`、`KEventDelete` 四个文件。历史上为 reused/model/trusted 边界建立的独立 `.c` 已移动到 `.docs/reused-spec-snapshots/annotated_C/src/`，只作来源快照；实际完整合同仍在各 caller 定义前。

结论仍受旧报告中用户已批准的条件限制：`0 <= id < 65536`；D1 从查询命中到注销期间同一 allocation 不被竞争删除、释放或复用；D2 排空或观察为空后到注销期间没有新 waiter。权威源码缺陷未修复，这些条件不是普通锁语义自动保证的结论。

设计检查：Rocq MCP 已用当前 QCP 8.20 工具链成功编译本地 `KEventDelete.v` 和 `checks/DesignInterface.v`；四个 active C 目标通过 `gcc -m32 -std=gnu11 -Wall -Werror -fsyntax-only`。本阶段未运行 QCP symbolic、未生成 VC，旧 VC 只作为后续证明参考。

独立 reviewer `/root/event_r2_review` 对冻结 revision 完成只读审阅：predicate `review-passed`，spec `review-passed`，无 blocker。审阅复核了 guard/gap 语义、内部 ID witness、caller-local contract、4 active/5 reused/6 model-trusted closure、可执行 token 一致性、Rocq MCP 与 GCC 结果。旧 r1 VC 仅作证明参考，不能作为 r2 实现证据。
