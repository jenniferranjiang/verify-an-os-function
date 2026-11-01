# VRTOS 导入同步（2026-10-28）

导入函数与本次证明目标的逐项划分见 [实现证明范围](verification-scope.md)。

按用户要求，从本地 `/home/xinra/vrtos` 的 `bc601a1` 同步已导入模块。
范围为根共享库、配套 annotated C，以及 `ksemaphoredelete-trial-261025-1`。
其他历史 trial 和既有 revision 快照保持原样；没有操作 VRTOS 的 Git 远端。

当前工作版本为 `KSemaphoreDelete-pred-r6` / `KSemaphoreDelete-spec-r8`，
状态是同步及编译检查完成，未进行独立设计审阅或 QCP 实现验证。
旧 r5/r7 的审阅结论仍对应旧快照，不自动适用于此版本。

## 同步内容

- `KTaskWakeup` 使用上游 `wakeup_by_id_ic`，`_KTaskWakeup` 使用
  `wakeup_general_ic`；入口和出口借还 `os_inv`。成功关系包含源调度节点摘除，
  覆盖自持、Semaphore、Mutex、MsgQueue 和 Event，保持其他状态分量。
- `LinklistResumeAll` 的四份定义/调用声明同步借还 `os_inv`，继续以
  `semaphore_resume_all_effect` 描述批量效果。先前删除的冗余
  `tasks_ready_with_exstatus` 后置条件没有恢复；谓词定义继续保留。
- `semaphore_resume_one` 直接采用新 Wakeup 后态，去掉旧接口需要的额外
  `set_pending` 更新。整体/逐步连接义务相应要求完整 `os_inv`，仍为待证命题。
- ID 查询、ID 删除、延时取消、RRR 就绪插入及双向链表调用规格对齐上游。
  ID 删除改用 `high_level_spec` / `low_level_spec`，相应调用选择同步更新。
- 共享定义同步上游的关系式 RRR 插入、32 位位图截断、延时取消关系、
  完整 `task_fields`、任务状态不变量和 service 生命周期定义。
- 根目录已导入的任务 C/头文件/strategy 做三方合并，补齐对应的新头、strategy
  及拆分后的 C 切片。1025 的切片生成脚本和自定义规格输入同步更新。

## 本地适配

保留 `Arch32 LittleEndian`、现有 `CriticalNest` / `LastSeen` / 调度模型，
以及按模块拆分的 `CRTOS_Verify.lib` 路径。上游未使用的 `NestedCriticalSTS`
导入和另一套信号量 ABI 公理不重新引入。

本工程的 `SemaphoreState` 是对象序列，与 VRTOS 的 map/manager 分量表示不同。
`semaphore_remove_waiter_step` 用 `Forall2` 逐对象对应，保留管理顺序、地址、ID
和 value，仅以原样导入的 `remove_found_prop` 描述等待任务摘除。
现有信号量状态、创建/回收引理及已批准的 ABI 假设保留。

QCP 的 `Mapping.v` 在当前依赖目录没有编译产物，故将其原样保存到
`vendor/qcp_strategy/Mapping.v`，使用 `QCPCompat` 路径构建。未改写其定义或证明。
本次未增加公理、Admitted 或实现验证结论。

## 检查结果

- 根 `_CoqProject` 的共享库完整构建通过。
- 147 项形式符号、类型和投影检查通过。
- 20 个导入函数的 65 处规格与 VRTOS 一致；空指针常量 `KNONE` 仅规范化为 `0`。
- 4 处 `LinklistResumeAll` 规格一致。
- 1025 的 23 个 C 切片可执行 token 与同步前一致，全部通过 GCC 32 位语法检查。
- 共享目录本次同步的 33 个 C 文件通过 GCC 32 位语法检查；其中更新的函数体
  token 与 VRTOS 对应切片一致。
- 在临时目录重新生成 23 个切片，注解与当前工作副本一致。
- `git diff --check` 通过；Git 工作区检查未发现其他 trial 的修改。

这些检查不等于 QCP 符号执行、VC 或实现证明。根 annotated C 中的上游证明注解
仍引用 VRTOS 的 `libai` / VC 模块；本轮没有迁移那些实现证明到本地小端模型。
1025 当前使用的形式接口及其共享定义已完成上述类型和构建检查。

## 复现与证据

在根目录执行：

```sh
make -f Makefile.coq -j2 COQBIN=/home/xinra/.opam/pv-bench-8.20.1/bin/
PATH=/home/xinra/.opam/pv-bench-8.20.1/bin:$PATH python3 ksemaphoredelete-trial-261025-1/checks/check-spec-vocabulary.py
python3 ksemaphoredelete-trial-261025-1/checks/check-vrtos-sync.py
```

来源提交、哈希、保留的适配、检查输出及构建日志见
[`checks/vrtos-sync-261028`](../../checks/vrtos-sync-261028)。
同步前的未提交工作保存在 `/tmp/vrtos-sync-261028/before`。
