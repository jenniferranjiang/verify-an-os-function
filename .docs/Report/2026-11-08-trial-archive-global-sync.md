# 已完成 trial 的 canonical annotated C 同步

2026-11-09 复查发现，`annotated_C` 从旧的扁平目录和 `scenarios/` 迁移到
`annotated_C/src/kernel/<module>/` 时，只落下了 `common`、`id`、`list`；已经通过
QCP `final-check` 的 semaphore、mutex、event spec 仍在旧路径删除列表或
`origin/trial-archive` 中，新模块目录却没有对应文件。此前本报告声称已经同步三个
create 场景，但工作区实际也不存在那些文件；该结论不正确。

本次按当前工程目录约定修复漏迁移。所有 C 文件均逐字复制已完成实现证明时的
canonical 输入，没有采用当前 event/mutex trial 中尚未重新完成 final-check 的
predicate/spec r2/r3 修改。

## 恢复结果

| 模块 | 全局目录 | 恢复的已证明目标 |
| --- | --- | --- |
| semaphore | `annotated_C/src/kernel/semaphore/` | `KSemaphoreCreate.c`、`_SemaphoreCreate.c`、`KSemaphoreDelete.c`、`_SemaphoreDelete.c`、`LinklistResumeAll.c` |
| mutex | `annotated_C/src/kernel/mutex/` | `KMutexCreate.c`、`_MutexCreate.c`、`KMutexDelete.c`、`_MutexDelete.c`、`LinklistResumeAll.c` |
| event | `annotated_C/src/kernel/event/` | `KEventCreate.c`、`_EventCreate.c`、`KEventDelete.c`、`_EventDelete.c`、`FindEventById.c`、`LinklistResumeAll.c` |

共恢复 16 个 canonical C 文件。三个 `LinklistResumeAll.c` 是分别经 semaphore、
mutex、event 删除实验实现证明的上下文特化版本，合同并不 alpha 等价，因此保留在
各自模块目录中，未擅自合并成一个未经审阅的新 contract。

## 来源与版本

- Create：`origin/trial-archive` 提交
  `764bd5919b1b8b301de7c94755cde510bed60d9b` 中的
  `ksemaphorecreate-trial-261022-1`、`kmutexcreate-trial-261101-1`、
  `keventcreate-trial-261101-1` canonical 输入。
- Semaphore delete：当前主线已合并的
  `annotated_C/src/{KSemaphoreDelete,_SemaphoreDelete,LinklistResumeAll}.c`。
- Mutex delete：当前主线已合并的
  `annotated_C/src/{KMutexDelete,_MutexDelete}.c` 及
  `annotated_C/src/outside_critical/LinklistResumeAll.c`。
- Event delete：当前主线已合并的
  `annotated_C/scenarios/event-delete/src/` 中四个实现证明目标。

Delete 来源固定为主线提交
`9a211c61e96bfcd3ca447ecbfa4e5e7d94fe4b8e`。对应实验记录表明 controller 均已
返回 `done` 且 final-check 通过；这里只做路径迁移，不改变 contract、函数体或证明
结论。

## 一致性检查

16 个目标逐一计算 SHA-256，并与上述 Git object 的内容比较，结果全部 byte-for-byte
一致。机器可读映射及哈希见
`.docs/checks/trial-archive-global-sync-20261108.json`。

本次没有把 `gen/`、`dep/` 或整个旧 `scenarios/` 复制回来，也没有把失败候选、旧
revision 或当前未重新 implement 的设计修改追认为全局 canonical spec。Rocq 库的
模块目录迁移由原有检查记录单独覆盖；本修复未改动 `.v` 定义。
