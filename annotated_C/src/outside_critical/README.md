This `outside_ciritcal` folder contains a version of C functions that are possibly used **outside** critical area, including：

- In `ktask.c`:
  + `_SuspendKTask`

  + `GetTaskWithIdnodeInfo`

  + `GetKTaskDescriptor`

  + `KtaskSetDelay`

These C functions keep the original critical areas of source code in `../crtos/Ubiquitous/XiZi_IIoT_Macro`.

Naming conventions: The spec name and file name of functions called inside critical can use the `_ic` suffix, while those called outside critical can use the `_oc` suffix.

OC Spec 设计使用正式项目 Skill：
[crtos-oc-spec](../../../.agents/skills/crtos-oc-spec/SKILL.md)。
公开接口保留抽象操作的 `safeExec`、返回结果对应的 residual `safeExec`、
`OutsideCritical` 和调用者自有资源；加锁时的状态及 R/G 关系留在抽象程序和
函数内部证明中。`GetKTaskDescriptor` 的临界区内调用使用
`../kernel/thread/get_ktask_descriptor.c`，无需在 OC 文件中另设 `nested` Spec。

File Exclude: C functions that are called **always inside** or **always outside** critical area are **not** verified in this folder, including:

- ktask.c: `KTaskWakeup`

- ktask.c: `KTaskUnSetDelay`

- assign.c: ready vector insert/remove
```c
Assign.ready_vector_done->insert(task);
Assign.ready_vector_done->remove(task);
```
