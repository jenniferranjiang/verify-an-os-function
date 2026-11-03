# invariant_open_failure 证明说明

完成本组 6 个 top-level VC 与 8 个 aggressive split proof；未修改 statement、prelude、未分配 proof span、冻结 predicate/spec 或共享 lib。

- 新对象 freshness：按 `In` 提取管理 DLL 中匹配的 mutex，使用 `dllseg_split` 暴露 payload。其 holder 指针单元与 `MutexZero` 的 holder 单元位于同一地址，借助已证明的 `dup_undef_store_ptr` 得到分离所有权矛盾。这里采用 holder 单元，代替计划提示的 val 单元；不增加 allocator provenance 前提。
- 打开 invariant：保留所有其他模块资源与 `os_world_wf`，利用 `mutex_context` 对齐 C 全局根，复用 `zero_idnode_insert_ready` 忘记私有 ID 节点的零值。
- ID 失败路径：由 `abs_mutex_create` 的 atomic choice 和 locked command 的 `(-5, unchanged state)` 正常关系推出 `LastSeen st` 上返回 -5 的 continuation。没有推断 manager 已满。
- 恢复 invariant：从 frame 的 `os_world_wf.os_wf_context` 提取 mutex context，以原状态重组 `os_inv`；私有对象按字段遗忘值与 padding 内容，构造 `MutexRaw`。保留未知 ID 字段，未声称 ID 插入失败后对象仍全零。

Rocq MCP：使用 controller 的 group_01/dev staged workspace，从实际 manual theorem 起步，所有 assigned statement 均互动证明至 Qed；两项 aggressive top-level 仅以对应 split lemma 的 Goal_apply 结束。该 tactic 已自动关闭 GTrans 自反分支，wit_3 只剩 spatial 和 safeExec 两分支。新增 helper 又在 group_01/src 的真实 MutexCreate_lib.v 环境互动检查至 Qed（state 218 → 229）。

本组只新增 `mutex_payload_conflict__invariant_open_failure` helper 和官方 Coq.Strings.String import。字符串采用局部 `%string` 标记，无新 top-level scope 命令。禁用 lemma/tactic 扫描无命中。最终 controller group-check 结果见 controller 生成的检查记录。

最终 group-check：`status: passed`，`returncode: 0`，实际编译本组 lib、goal、auto、manual 和 group wrapper；耗时 75.945907 秒，复用 198 个基础 vo。
