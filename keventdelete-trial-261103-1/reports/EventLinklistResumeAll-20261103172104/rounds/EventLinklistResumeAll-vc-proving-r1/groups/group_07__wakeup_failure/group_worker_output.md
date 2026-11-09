# wakeup_failure 完成交付

已完成 `proof_of_LinklistResumeAll_entail_wit_4_1`，采用指定的 `LLM_pre_process` whole-goal route。

从 `after = marked` 和 `os_inv marked` 提取 task ID manager 的 `idbuckets_ok`，其桶内 ID 的 NoDup 保证两个相同 task_id 查询取得同一 ID node 地址。既有 `addr_of_arrow_field_inv` 推出 task = target。化简 marked 的描述符更新得到 desc_2 = set_task_desc_exstatus desc (-1)，该更新保持调度状态为 SUSPEND，与失败分支的非 SUSPEND 前提矛盾。

组库新增已证明 helper `idnode_address_unique__wakeup_failure`；保留 seed、所有 statements 和未分配 proof tokens。未修改 C annotation 或 canonical library。

完整 `group-check` 已通过：进程 exit code 0，JSON status passed，耗时 49.442544 秒。禁用 lemma/tactic 扫描无命中。
