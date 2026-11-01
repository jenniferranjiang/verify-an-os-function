# 使用新增 Wakeup 队首契约更新 LinklistResumeAll

已按用户要求完成 spec 同步，未开始实现证明。当前 predicate 为
`KSemaphoreDelete-pred-r7`，spec 为 `KSemaphoreDelete-spec-r9`；构建和接口检查通过，
尚未进行完整设计审阅。无需用户操作。

设计变更编号：`DCHG-20261029-01`。本次是上游接口新增及本地调用适配，不是 C 源码错误。
用户明确要求使用新增接口写当前 spec；此授权覆盖设计修改，不表示已经批准或完成实现证明。

## 变更及边界

- KTaskWakeup 通用契约保持原语义，同步新增的 Semaphore、MsgQueue send/recv 队首派生契约。
  头文件、trial canonical 和 caller-local 副本一致，现有 detached 契约也保留于 canonical。
- LinklistResumeAll 的 `semaphore_waiters` 通过 `semaphore_pending_nodes` 关联对象地址、
  等待任务顺序与 DLL 节点；出口显式给出同一对象的空等待链，继续保留整体批量效果与 `os_inv`。
- 循环中的 KTaskWakeup 调用选择 `semaphore_pending_head_ic`。其 `before` 是写入
  `task->exstatus = -ERROR` 后的当前状态，不能绑定函数入口的 `before`。
  ID 查询关联和当前队首事实仍须在将来的证明中建立。
- `semaphore_resume_one` 改用 `wakeup_semaphore_head`，由它精确删除目标等待队首，
  保持自持表及其他 IPC 对象。`exstatus` 写入仍由 caller 的 `marked` 更新表达。
- 本地 SemaphoreState 为对象序列：`semaphore_pending_nodes` 使用规范节点投影，
  `wakeup_semaphore_head` 使用已有 `semaphore_set_pending` 保持对象管理次序、地址、ID/value
  和其他对象。MsgQueue 的上游 `map_unchanged_except` 按定义内联为逐点保持。
  新增关系均为纯条件，内存仍由 `os_inv` 唯一持有。

影响范围为根共享库/注解与 `ksemaphoredelete-trial-261025-1`；两处 _SemaphoreDelete 的
调用规格、Extern 声明及切片生成输入同步更新。32 位、非 SMP、小端模型、原 C 算法和已有
三个实现目标/外部契约边界不变。历史 revision 快照不修改，r6/r8 被本工作版本取代；
旧 review 不作为新 revision 的通过证据。

## 检查证据与限制

共享库构建通过；153 项 formal 名称/类型检查通过；20 个导入函数的 65 处契约与当前
VRTOS 一致，4 处 LinklistResumeAll 规格一致。23 个 trial 切片可执行 token 不变，
在临时目录重新生成的注解忽略空白后一致；23 个 trial 文件及 2 个共享调用链文件通过
GCC 32 位语法检查。`git diff --check` 通过。

检查结果保存在 [`checks/vrtos-sync-261029`](../../../checks/vrtos-sync-261029)，来源提交和文件哈希
见其中 `source-manifest.json`。来源为本地 VRTOS `162a5e7` 的干净工作树，未操作远端。
原始 CRTOS 行为见 `Ubiquitous/XiZi_IIoT_Macro/kernel/thread/linklist.c:110`。

本次没有运行 QCP parser/symbolic、生成 VC 或证明实现；上游证明未自动转移到本地表示。
`semaphore_resume_all_effect_steps_obligation` 仍只是待证命题。后续完整审阅及实现阶段
仍须检查资源拆装、写 exstatus 后重建不变量、新队首契约的前提、循环保持与整体效果连接。

复现：在仓库根执行 `make -f Makefile.coq -j2 COQBIN=/home/xinra/.opam/pv-bench-8.20.1/bin/`，
并执行 trial 的 `checks/check-spec-vocabulary.py`（将同一 Coq 目录加入 PATH）和
`checks/check-vrtos-sync.py`。新增同步检查默认使用本轮记录目录，旧记录保持不变。
