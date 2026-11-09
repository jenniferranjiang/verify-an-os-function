复用了只读历史 `/home/xinra/crtos/.docs/checks/rocq-interactive-20261101-r4/VC/SemaphoreDelete_lib.v` 中 ID 投影唯一性、16 桶删除、空队列删除及空间重组的证明思路，并全部改为 `__retire_state` 后缀。

适配当前 MutexAbs 的四个标量、MutexPadding、mutex_context、mutex_create_frame、mutex_field_offset_axiom 和当前不含 msgqueue 的 os_sched_owners。地址唯一性直接使用当前 VC 保留的 NoDup，不从删除后的 heap 反推旧对象身份。guarded atomic continuation 使用当前 abs_mutex_retire 定义独立证明。
