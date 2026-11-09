# KMutexDelete LinklistResumeAll predicate/spec r3 设计记录

本次只修正 Mutex trial 中 `LinklistResumeAll` 的共享抽象和 spec，没有修改 Event trial，也没有同步到全局库。旧 r2 的 Mutex 专用 `mutex_waiters_oc` 及其独立 effect/program 已被本 revision 取代，因此 r2 predicate/spec 状态记为 `invalidated`。

Predicate revision 为 `kmutexdelete-predicate-r3-2f93718dada8`。trial 新增平铺文件 `lib/Pendlist.v`，未来全局目标为 `lib/pendlist/Pendlist.v`。该文件以 `PendlistTarget` 统一描述当前 CRTOS 已建模的 Semaphore、Mutex、Event 等待链，并提供 `pendlist_head`、`pendlist_nodes`、`linklist_resume_all_step`、`linklist_resume_all_entry_condition` 与 `abs_linklist_resume_all`。`lib/KMutexDelete.v` 中的 Mutex 名称仅保留为兼容 adapter，直接实例化 `PendMutex p id`，不再复制一套 Mutex ResumeAll 效果或 OC program。

Spec revision 为 `kmutexdelete-spec-r3-80bf19fe04c7`。canonical contract 位于 `annotated_C/src/LinklistResumeAll.c` 的 `outside_critical`；`annotated_C/src/_MutexDelete.c` 中的 caller-local declaration 与其一致，调用点用 `PendMutex(mutex,id)` 实例化同一个 contract。active C 和 logic header 中已无 `mutex_waiters_oc`。Lock 前提使用与 abstract program 相同的 checked entry condition，不从普通 `Crtos_RTrans` 假定对象无条件保活。

验证结果：Rocq MCP 已重新编译 `lib/Pendlist.v` 与 `lib/KMutexDelete.v`；`.docs/checks/LogicInterfaces.v` 类型检查通过；三个 active C 文件通过 `gcc -m32 -std=gnu11 -Wall -Werror -fsyntax-only`。独立 reviewer `/root/mutex_linklist_spec_review_r3` 最终结论为 predicate/spec `review-passed`，无 blocker。

本阶段没有调用 QCP symbolic、没有生成新 VC，也没有开始 implement。通用循环 invariant、`KTaskWakeup` spec 选择和 Unlock 恢复注解将在用户确认本 revision 后重新实现；旧 r1/r2 VC 只能作为证明参考，不能作为 r3 证据。按用户要求，当前所有变化只留在 `kmutexdelete-trial-261103-1`。
