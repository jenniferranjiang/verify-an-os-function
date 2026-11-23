# Dataqueue 连续段表示

按用户已讨论并确认的 MsgQueue segment 组织方式，重构 `lib/dataqueue/DataqueueInv.v` 的 `dataqueue_buffer`。初版完成 segment 组织后，按用户要求继续收紧 buffer 边界并同步相关局部注解。当前修改涉及这个 lib 文件及 DeInit/Pop/Peak 的资源展开注解；不恢复旧 QCP 实现流程，不修改可执行 C、生成 VC 或手工证明。

## Lib

原 buffer 按 `front <= rear` 区分未环绕和环绕，分别展开有效数组和空闲区；环绕分支还存在量化两段内容。现在按以下层次组织：

- `dataqueue_slot`：沿用原单元素谓词，一个元素为 `DataqueueElem`，拥有 `data` 和 `length` 字段，不拥有 payload。segment 用 `dataqueue_slot p 0 e` 表示从当前槽地址 p 开始的单元素；原有按 base/index 取槽的 C 注解接口保持不变。
- `store_dataqueue_segment p slots elements`：从 p 开始的连续 slots 个槽。每个有效元素递归消耗一个 8 字节槽；列表为空时，剩余 slots 个槽以 `CharArray.undef_full p (slots * 8)` 保留字节权限。调用处须保证列表长度不超过段容量，不要求空闲字节清零。
- `dataqueue_split_at_end`：以 `max_len-front` 为切分位置，使用 `firstn` / `skipn` 得到 FIFO 前缀和后缀。
- `dataqueue_buffer`：只描述非零基址的已分配数组，不再含 `if`。低地址段 `[0,front)` 存后缀，高地址段 `[front,max_len)` 存前缀；各段自己拥有剩余空闲区。未环绕时后缀为空，不再需要单独的环绕判断。

`dataqueue_ring_shape` 仍将 `rear`、`front`、容量和有效列表长度关联，保证两段内容都不超出物理容量，仍保留一个空槽。无 buffer 的情形移到 `store_dataqueue`：本体字段始终存在，附属资源为 `(base=0 /\ slots=nil && emp) || dataqueue_buffer q`。有 buffer 时非零条件由 buffer 自己给出。整体对象表示、对齐条件、结构字段和 padding、信号量关联、map / os_inv 接口保持；不另建 buffer map。没有新增或修改 `assert` / `assertS`，本轮分段容量依据来自现有 `dataqueue_ring_shape`，不是额外环境假设；没有新增公理、trusted contract 或 Admitted。

设容量 n、队头 f、队尾 r。未环绕时有效数量为 r-f，全部内容位于高地址段的前缀，空闲资源为 `[0,f)` 和 `[r,n)`；环绕时有效数量为 n-f+r，高地址段放 n-f 个元素，低地址段放 r 个元素，空闲资源为 `[r,f)`。两种情况与原布局相符。空队列且 f 非零、容量 1、r=0 恰到数组末端及空基址的情形都已检查。

## Spec 与证明状态

当前函数契约和局部注解仍引用同名谓词，无需新增 QCP 外部声明。需要注意 `dataqueue_buffer` 不再适用于 base=0 的对象；这类对象通过 `store_dataqueue` 的无数组分支表示。

- DeInit 的 `which implies` 在无 buffer 分支保留 `dq_slots=nil`，非零分支仍提供 buffer 给 x_free。
- Pop 两处、Peak 一处 `which implies` 在前后显式携带已有 `dataqueue_ready`。该事实来自前面的锁内 Assert；其依据是 `os_inv` 中 `dataqueue_inv` 对已发布对象的 ready 约束。ready 包含 base<>0，从而能选出 buffer 分支。这不是额外的 caller 假设，也没有新加 assertS。
- Init 的失败后置及 DeInit 的前后置继续使用 `store_dataqueue`，可覆盖未分配及退役状态；Init 中的 DeInit 声明与实际 canonical contract 保持一致，无需改写。
- x_free 原契约已有 `p==q.dq_base && p!=0`，在这个域上新旧 buffer 等价，其契约原文保留；只更新注释，明确它消费已分配数组。
- Push 的公开契约不直接展开 buffer，无需改动。上述修改未加强任何公开调用要求。

初版分支数组与 segment 的完整空间等价定理仍未另证；本次有无 buffer 的边界调整则单独检查对象整体及非零数组域的等价。

原有 allocation/free/head/pop/push 等 `*_obligation : Prop` 仍是待证陈述。2026-11-21 有效序列改动已经使旧 Dataqueue VC 的物理 `option` 槽表示失效，本轮不消除那些既有问题，也不使用旧编译产物声明 C 实现已通过。参见[原 FIFO 表示说明](../2026-11-21-FifoRepresentation/design.md)及[此前构建问题的基线复现](../../common/2026-11-23-AbstractProgramIF/migration.md)。后续证明应针对本轮新定义展开 segment，按底层引理到上层 VC 的依赖顺序推进。

## 检查与审阅

- `make -j4 lib` 返回 0，库及受影响依赖重新编译通过，正式 `.vo` 保留。
- 独立 reviewer 对实际改动与修改前工作树进行只读审阅：predicate 设计差异通过，未发现遗漏、重复资源或 FIFO 次序变化。
- 临时 Rocq 检查以 `Qed` 证明：列表切分重组恒等；ring_shape 下两段长度分别不超过 `max_len-front` 和 `front`；单槽基址换算与原接口相等；base=0 分支定义保持。
- 有限布局检查覆盖容量 1–64 的全部 89,440 组 front/rear，核对新旧槽内容、FIFO 顺序、完整覆盖及无重叠。有限检查不替代空间逻辑等价证明。
- `git diff --check` 通过。未运行符号执行、重新生成 VC 或恢复实现 controller。

初版 lib revision：`dq-segment-20261123-r1`（已由下述 r2 替代）。修改前实际工作树 `DataqueueInv.v` SHA-256 为 `2cc11cef366c8098415045d977d16c4757128c0dd54e78d540ed995db9197768`；修改后为 `efc9d4afe3719822455a5af2aed5d3163baf110a08605e4b79fe4e22015d1ef5`。相对该基线新增 27 行、删除 17 行、净增 10 行（含注释和空行），VC 增量为 0；不计入其他会话已存在的改动。本轮检查完成后清理临时快照和检查文件，保留本说明与正式库文件。


## r2：已分配 buffer 与无 buffer 对象的边界

当前 revision 为 `dq-segment-20261123-r2`。`DataqueueInv.v` SHA-256：`9364f4c81059f3b2a2074218efbc0f030aa60938360c074eda5ab5de8a77fbaa`。r2 基线为 r1 的实际工作树，并保留所有其他任务改动。

独立 reviewer 对 r2 predicate 和 spec 差异审阅通过。`make -j4 lib` 返回 0。五个 Dataqueue C 文件的去注释 token 与 r2 修改前完全一致，且均通过 GCC ILP32 语法检查；GCC 不检查 QCP 注解。旧 VC 未重新生成或证明，原有未证义务状态不变。

r2 的临时 Rocq 检查以 `Qed` 完成三个空间性质：`allocated_buffer_equiv`（base<>0 时 buffer 与 r1 等价）、`object_equiv`（整体 store_dataqueue 与 r1 等价）、`ready_extract`（ready 对象可拆出本体字段和 buffer）。它们检查本次资源边界调整，不替代初版 segment 重构的完整等价定理，也不替代 C VC 实现证明。检查完成后清理临时基线和检查文件，保留正式 `.vo`。

## 模块目录归档

按用户要求，正式定义从 `lib/common/DataqueueInv.v` 移至 `lib/dataqueue/DataqueueInv.v`，逻辑模块名改为 `CRTOS_Verify.lib.dataqueue.DataqueueInv`。移动前后 `.v` 内容逐字节相同，所以上述 r2 源码摘要不变。`SKILL.md` 的目录树与职责说明同步规定模块 invariant 归属各自模块，`common/CrtosInv.v` 只负责系统组合。

根 Makefile、生成的 `_CoqProject` / `.depend`、库 imports、C header 的 Printing Coq Name 以及四份旧 Dataqueue goal 文件的限定名均已同步。七个源码引用文件经反向替换比较，确认本次只变更模块路径；未改变 VC 命题、证明步骤或函数契约。旧 VC 的既有未证/失效状态保持。历史报告中的旧路径及冻结记录保留为历史依据。

旧逻辑模块名的编译缓存已移除，仅重建新模块及受影响依赖，避免同时加载两套同名定义。

归档检查：`make -j4 lib` 返回 0；正式 lib、annotated C、VC 源码及根构建清单中已无旧模块路径引用，`git diff --check` 通过。未重复运行已有基线错误的完整 VC 证明，也未将本次库编译解释为 C 实现验证完成。归档检查完成后删除临时比较副本，保留新路径下的正式编译结果。
