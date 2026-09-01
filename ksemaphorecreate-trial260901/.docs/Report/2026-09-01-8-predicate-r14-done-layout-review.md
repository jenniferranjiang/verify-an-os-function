# Predicate r14 done-table layout affected-only review

状态：`review-passed`

Predicate revision：`predicate-r14-4aac701eaf05`。Manifest 命令 `sha256sum lib/*.v | sort | sha256sum`，完整 hash `4aac701eaf055a0e380e20b3eb18b957c249bd7bc3aef523ec48714d9500cc55`。本 revision 仅修复 spec full review 发现并使 r13 失效的 done-table C-layout blocker 及其直接依赖；其他 predicate 未改变。

- 权威 `xs_sem.h:42-48` 声明无 tag 的匿名 `SemaphoreDoneType`。`KSemaphoreCreate.c` 现以字段顺序和五个函数指针类型完全相同的 tagged `struct SemaphoreDone` 做 slice-local ABI normalization，并在 `-m32 -std=c99` 下用 5 个 `__builtin_offsetof` 与 1 个 `sizeof` typedef check 锁定 offsets `0,4,8,12,16` 与总大小 20。
- Slice 保留 `create = done.SemaphoreCreate` 的真实 slot load，然后依据权威静态 initializer/no-writer 证据将间接调用解析为直接 `_SemaphoreCreate`；不删除 memory footprint。
- `SemaphoreRep.v` 增加 `SEMAPHORE_DONE_SIZE=20` 与 `semaphore_done_field_offset_ok`，使用与 slice tag 一致的字段地址关系。`store_semaphore_done` 现在同时要求 checked layout 并拥有五个真实 pointer slots；initializer 值仍由 `SemaphoreStableContext` 逐项绑定。

机械检查：Rocq 8.20.1 `make clean && make -j2` 全量通过，`make -q` 通过；`gcc -m32 -std=c99 -fsyntax-only -fno-builtin annotated_C/src/KSemaphoreCreate.c` 通过；forbidden-token 零匹配。未运行 QCP parser/symbolic、closure、VC 或 proof。

独立 predicate reviewer 已完成 affected-only review。Done-layout/source issue 为 `fixed`：五个 slot 的 offsets/size、字段顺序/函数指针类型、唯一 initializer、spatial owner 和保留真实 load 的 direct-call resolution 均与权威 C 一致。

首次机械复审发现 `R14-FORMAL-01`：并行构建的 `DoublyLinkedList.vo` 早于其 `SemaphoreCritical.vo` 依赖，当时结论为 `needs-fix`。不修改 formal source，使用 Rocq 8.20.1 串行 `make -j1` 重建 downstream 链后，时间顺序为 `SemaphoreCritical.vo < DoublyLinkedList.vo < IdManagerRep.vo < SemaphoreRep.vo`；`make -q -f Makefile real-all` 和 `make -q -f Makefile lib/SemaphoreRep.vo` 均返回 0。Reviewer 据新机械证据将 `R14-FORMAL-01` 更新为 `fixed`。

Review-passed predicate revision：`predicate-r14-4aac701eaf05`。未运行 QCP parser/symbolic、closure、VC 或 proof。
