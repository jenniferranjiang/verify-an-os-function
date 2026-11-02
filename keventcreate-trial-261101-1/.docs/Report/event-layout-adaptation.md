# Event 模型 ABI 接口补齐

候选：`lib/abi/EventLayoutABI.v`，SHA256 `08c16548d32b2376890e1e5d3d27f965d7800a3fe51db9056c3af863c351caef`。本次由 main agent 安排补齐具体布局接口，等待独立审阅与共享迁移；未改权威 C、切片 C、函数契约或冻结 Event predicate。

Annotation attempt 1 已说明：QCP 的 `sizeof_struct_type` 和字段地址解释本身是抽象参数，既有 `EventInv.event_byte_layout` 只是命题。GCC 的布局检查不能直接成为 Rocq 已证明定理，零字节到 `EventZero` 的证明缺少具体布局事实。

可信依据为只读 `/home/xinra/TrustBase.md` 中已授权的结构体布局、位域展开及64位到32位工具适配。新文件按 `StructFieldOffsetAxiom.v` 的大小/字段分层模式，仅给出两条精确可信事实：模型 Event 大小等于已定义为36的 `EVENT_MEM_SIZE`；4字节对齐基址上的五个 Event 顶层字段偏移分别为0、12、16、20、28。`event_top_level_field_offset_ok` 只组合这些纯地址等式。

原始 `Event` 的 options:3/events:29 共用一个字，ILP32对象32字节；当前切片把位域展开为两个uint32，对象36字节。两份已有fixture `checks/source-abi/authoritative.c`、`adapted.c` 均已重新通过 GCC `-m32 -ffreestanding -fsyntax-only`；后者直接包含当前 `annotated_C/include/slice_types.h`。命令、文件hash和结果见 `checks/event-layout-abi-check.json`。这支持具体ABI适配的人工核对，不冒充其为 Rocq 布局定理。

IdNode 和 DLL 子字段不增加公理：现有 `mutex_field_offset_axiom p` 在同一 `addr_aligned p 4` 前提下，其 `mutex_field_offset_ok p` 已提供 IdNode.id=p、IdNode.link=p+4，以及节点p+4/p+20/p+28的next/prev地址关系，恰好覆盖当前 Event 模型需要的子字段地址。后续普通引理可以组合已有这些事实与新顶层偏移，推出冻结的 `event_byte_layout p`；本候选没有证明或假定整个该命题，也没有复制既有子字段公理。

新增事实不提供内存权限、非空、分配来源或生命周期保证；没有新增trusted函数。字节拆分、清零转typed字段、资源回收、ID/DLL发布一致性以及全部生成VC仍须真正证明，不能以布局接口代替。本文件未把任何上述资源转换或生成VC声明为axiom。

编译使用根 `_CoqProject` 的映射，临时增加 `-R <trial>/lib/abi KEventABI`；工程配置没有改写。结果及完整命令见 `checks/event-layout-compile.json` 和 `checks/event-layout-compile.log`。合并与正式imports由main在独立审阅后处理。
