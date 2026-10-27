# Candidate C 结构、源码适配与 ABI 检查

对象：当前 trial 的 23 个 `annotated_C/src/<symbol>.c` 和 `annotated_C/include/slice_types.h`。这是 spec review-ready 的独立 C 证据，不是正式 spec review-passed；尚不评定 Rocq predicate/contract 的语义充分性，也未运行 QCP。

检查依据沿用 [C 分析](c-analysis.md) 及 [适配清单](adapted-closure.md)。检查结果固定到 `checks/c-analysis/candidate-structure.json` 中各切片 SHA-256；若后续改动只有调用 `where`/注解，可沿用 body/ABI 结论，caller contract 文本变更需更新受影响一致性检查。

## 结果

- 23 个预计 symbol 均恰有一个同名文件和唯一 active 函数 body，无多余 active 实现。
- 从 KSemaphoreDelete 重新沿 active body 的调用扫描，恰可达上述 23 个实现与 8 个边界：CriticalAreaLock、CriticalAreaUnLock、x_free、KTASK_ASSIGN，以及 IDNODE_LINK、SEMAPHORE_ID、TASK_ID、TASK_SCHED 四个 CONTAINER_OF 接口。没有遗留 DO_KTASK_ASSIGN、未解析 done dispatch 或裸 IRQ/调度内部调用。
- 每个保留调用在 caller 自身定义前都有完整 Require/Ensure declaration-only spec；callee 的 canonical spec 与 caller-local spec 在去除无意义空白后逐字相同，8 个边界在各调用方也一致。这证明接口复制一致性，不替代对接口本身是否正确的正式审阅。
- 23 个文件均通过 GCC `-m32 -std=c11 -ffreestanding -fsyntax-only -Wall`。诊断只有原始/适配后不再使用的局部变量（lock 及 AssignPolicyInsert 的 node/tail/tmp），没有编译错误。C 编译不识别 QCP 注释语义，故不能据此声称 spec 通过 QCP parser 或实现证明。
- 原始真实 headers、仅事件位域展开后的 headers、最终 slice_types.h 三组相同 ILP32 ABI static assertions 全部通过。额外核对 Assign 的 size276、ready vector0、running task264、done268、current_priority272。详见 abi-check-results.json 与三份 abi-*.c。
- 类型头最初把 x_err_t 改成 signed int；已通知作者恢复 `typedef x_base x_err_t`，避免无必要的 C typedef 改动。最终检查使用恢复后的头文件。

## 人工逐体核对

全部 23 个 active body 已与 c-analysis.md 对应原始函数阅读对照；检查并保留以下敏感语义：

- `_SemaphoreDelete` 的负 ID 早退、uint16 参数转换、未命中解锁、等待者分支、ID 摘除/管理链摘除、解锁后 free、条件模型调度均保留，顺序未变。
- `GetObj` 的 lazy bucket 初始化和 miss、遍历命中 break、每轮清空 idnode 均保留。`IdRemoveObj` 的 miss 早退、FreeId、RemoveObj、写 id=-1 的 uint16 截断顺序保留。
- `LinklistResumeAll` 每次重新读取首节点，先写 exstatus=-ERROR 再 KTaskWakeup，链空退出；未替换为可能遗漏移除效果的指针推进遍历。
- `_KTaskWakeup` 对非 SUSPEND 的失败返回仍存在；成功才摘 sched_link、取消延时、插入 ready；`KTaskUnSetDelay` 的 null/inactive 无更新路径保留。
- `RoundRobinRemainReadyVectorInsert` 的 DOUBLE_LINKLIST_FOR_EACH 等价展开，保留 advance_cnt<1 分支、rest_timeslice 比较、首个满足条件前插、未命中尾插及 advance_cnt>=1 尾插。未反转优先级或时间片比较。
- `KTaskStateSet` 保留原 status 高位；`AssignPolicyInsert` 保留 RR_REMAINSLICE 唯一选中策略及 highest_prio 更新；ready insert 保留 bitmap OR。
- 双链表 5 个 leaf 函数保留原字段写入顺序，RmNode 最终自环。
- 原本 NULL_PARAM_CHECK 的 null 非返回路径均以 `if (p==NONE) { while(1){} }` 保留，仅删除输出。原始 RemoveObj 返回类型是 IdNode* 但落到函数末尾，切片保留原类型和行为；调用者不使用返回值，没有杜撰返回值。
- 仅删除清单中受外层锁保护的嵌套锁/IRQ；并未删除 `_SemaphoreDelete` 外层锁或任何其余字段效果。其他原始调度分支由明确获准的 KTASK_ASSIGN 模型范围覆盖，不能解释为原始硬件调度实现已证明。

## 可复核命令与边界

在项目根运行：

```
python3 ksemaphoredelete-trial-261025-1/checks/c-analysis/run-abi-check.py
python3 ksemaphoredelete-trial-261025-1/checks/c-analysis/check-candidate.py
```

ABI检查直接读真实 kernel headers，配置快照来自 annotated_C/src/include/xsconfig.h；Assign 的头依赖由当前 K210 的 arch/board include 路径解析。没有替换硬件头、抄造精简 struct 或使用不同 ARM trial 配置。编译器 -m32 在此只检查 ILP32 数据布局，不编译/执行 RISC-V 汇编，不承诺 K210 原生 LP64D 布局。

当前未发现剩余 C 切片路径/副作用/布局遗漏。Formal predicate 与 spec 的正式独立审阅仍须在 predicate 固定通过版本后完成。

## S1 修复与共享迁移后的增量确认

Spec-r2 的四类 typed container 接口及五处调用已由独立 spec reviewer 定向核对，见 spec-review.md。主 agent 在合并后按八边界更新检查清单并复跑同一结构/契约/C语法检查，结果 passed；candidate-structure.json 现在记录迁移后的活动文件哈希。未改变的 C 路径和类型布局复用本报告前述检查。此增量不重复声称 QCP 或实现证明完成。
