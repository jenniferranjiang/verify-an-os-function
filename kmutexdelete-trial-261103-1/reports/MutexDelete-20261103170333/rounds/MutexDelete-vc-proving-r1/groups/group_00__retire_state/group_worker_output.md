已完成 `proof_of__MutexDelete_entail_wit_3_2` 及三个 assigned split goals。

GTrans 由既有关系闭合；safeExec continuation 从当前 guarded atomic 的 normal-execution 子句推出。空间证明利用保留的 ID/地址 NoDup，确认返回 idnode 属于当前对象，证明 unpublish 与 manager 删除一致；空 pending 保持调度所有者及 world 条件，完整 frame、剩余 DLL 和 manager 重建 os_inv，返回字段与自环重组 MutexRetired。未将任何 *_obligation 定义当作已证明引理。

`group-check` 已通过（exit code 0，JSON status passed，53.708213 秒）。禁用 lemma/tactic 扫描无命中。全部新增 helper 使用 `__retire_state` 后缀；仅修改分配的 proof spans 与 group library，seed 保持。历史适配说明见 proof_reuse.md。
