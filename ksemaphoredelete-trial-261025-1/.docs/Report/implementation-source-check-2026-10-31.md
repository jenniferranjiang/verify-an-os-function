# 实现阶段源码与输入适配审计

2026-10-31，独立只读检查。结论：所检查快照的源码与适配一致性通过，未发现未经记录的可执行行为改变、
目标契约改变或 predicate 改变。此结论不代表实现证明完成，也不替代 controller 的 final-check。
本次只读取文件、比较指纹、在内存中重建 parser 输入并运行只读冻结输入检查；未运行 QCP、Rocq、编译器或证明检查。
唯一写入为本报告。

## 批准输入及源码指纹

- 固定版本仍为 `KSemaphoreDelete-pred-r7` / `KSemaphoreDelete-spec-r9`。两个 revision 清单的 aggregate
  分别重算为 `9a204245814625aade45188ff92e1cc911bc1aad78fee08d7f2f5dfab8b9d786` 和
  `00bad529f9b7b9f5a29415d443d27d7e6a7875e9ffc798acefdd6e3285a4c17b`，与 implement 冻结记录一致。
- Predicate 清单的 15 个实际文件全部匹配批准哈希。原 `checks/c-analysis/source-sha256.json`
  的 31 个原始源码、配置、头文件、架构依据及 TrustBase 输入全部未变，因此沿用先前配置/ABI 源码一致性结论，未重复 ABI 检查。
- `check_frozen_inputs` 对 5 个工程输入、16 个外部输入、23 个 C 文件全部通过。23 个 C 的 caller/canonical
  contract 均与冻结内容一致；可执行 token 经限定逆映射后匹配原冻结指纹。
- Spec revision 的 25 个文件中，仅 `LinklistResumeAll.c` 和 `_SemaphoreDelete.c` 的整文件哈希改变，
  原因是证明注释及下述已记录适配；不能把 revision 清单的 aggregate 等同于当前这两个整文件的哈希。
  其余 23 个文件仍逐字匹配。当前目标函数的公开 contract 与批准版本一致。

审计时实现冻结清单 SHA-256 为 `957e6cec8f4a51c308ba44c0de133569c9202b9f32cf2c14cf962b99d5710f00`；
适配说明 `checks/implementation-source-adaptations.json` 为
`83b623aa9a4e9b8708223e080f2abb37d0e8df9c90cd06e1fa15df86e20140ab`。

## 当前实际可执行代码

`KSemaphoreDelete.c` 仍逐字匹配批准输入，SHA-256 为
`ea52a061a542e98280a5c3f2088d54d6f9cc6b3573181055ca30510c596cc264`；parser 无需为它产生规范化副本。

`_SemaphoreDelete.c` 的当前 SHA-256 为
`b5dfa4f90871da6053fd95a7407b3479f20fd0204262c151663051e79074e820`。
实际已采用 `uint16 delete_sem_id` 拆出 ID 读取。字段在 ResumeAll 之后、IdRemoveObj 之前读取一次，
局部变量类型与字段/形参一致，期间只有注释，地址不逃逸。负 ID、未命中、等待者分支、注销、摘链、解锁后释放及条件调度的顺序保持。

`LinklistResumeAll.c` 的当前 SHA-256 为
`0b504f5064b5e0fd0b0e9e0acde9431f709bda5a8ba1b19e5624a925c9f6139e`。
实际包含以下已记录变化：

- 三个可执行 NONE 使用点已展开为冻结头文件中的 `((void *)0)`，没有改宏值或契约文本。
- 主循环的空 `for(;;)` 已落盘为 `while (1)`。无初始化/更新副作用，缺省条件为真；循环体、break/continue/return 行为保持。
- KTaskWakeup 实参读取拆到新鲜 `int32 resume_task_id`。uint16 全范围可表示，字段仍在 exstatus 写入之后、唤醒之前读取一次。

冻结检查逐文件限定这几种形状，再逆映射到原 token 指纹；变量仅出现声明及调用两处。当前两个 `while(1)`
分别是 NULL 失败循环和主循环，检查器逆映射的最后一个循环确为主循环，没有误改 NULL 分支。
Canonical 中 NULL 分支仍为不返回循环，主循环仍逐次读取新队首。

## 当前 recorded parser 输入

对下面两份 mapping，检查 canonical 哈希、parser 文件哈希及换行数，并从当前 canonical 在内存中独立重建；
重建结果与 recorded parser 文件逐字一致，没有调用写入型 parser 工具。

- `_SemaphoreDelete`：[mapping](../../evidence/parser-normalization/048fb4a8299f7b7d08399f801b2e0fcf8aafee8cfab4c3f603e626830f3d9aca/mapping.json)。
  Parser SHA-256 为 `048fb4a8299f7b7d08399f801b2e0fcf8aafee8cfab4c3f603e626830f3d9aca`。
  仅包含已审阅的 IdRemoveObj 字段断言显式化、remove_from_head 的绑定类型 alpha 改名及三个 NONE 精确展开。
  被选用的 remove_member 不变，C 字段类型、地址、分离连接及自环语义保持。
- `LinklistResumeAll`：[mapping](../../evidence/parser-normalization/3c4c85a9c81b5371c6542951e08e4fd0dc2ea41b4005dcaa19a8cd2531224081/mapping.json)。
  Parser SHA-256 为 `3c4c85a9c81b5371c6542951e08e4fd0dc2ea41b4005dcaa19a8cd2531224081`。
  NONE 与空 for 已在 canonical 中落实，当前 mapping 不需要再次改写；实际额外变化为下述两个边界处理。

NULL 检查只替换精确的宏展开段并加入 NULL_PARAM_CHECK_1 声明；其接口沿用已许可的正常返回非空保证，
不承诺 NULL 路径终止。该模型/API 边界已经登记为第 9 项；mapping 正确将
`preprocessed_executable_code_unchanged` 记为 false，不把这个抽象替代说成 token 恒等。

四个 KTaskWakeup 特化的 `<= wakeup_by_id_ic` 仅从 parser 输入移除。再次读取固定 VRTOS 提交
`162a5e7f06c8dca8946f2e44c50bd7fe75b74d49` 的 `annotated_C/src/headers/ktask_wakeup.h`，
确认 detached、semaphore head、msgqueue send/recv head 四个完整契约均已在上游存在，且与当前 canonical/caller 一致。
Parser 保留原 spec 名及 With/Require/Ensure；ResumeAll 仍选择 semaphore_pending_head_ic。
这是依据已批准完整外部契约调整证明责任，不是本轮新特化，也不声称在本地证明了四个推导。
映射记录保留原派生来源、提交及 `local_derivation_proved=false`。

所读工具版本：`crtos_parser_input.py` SHA-256 为
`8edcb07aa0538b2b1b4586922c30624239df9f8caaac4026ffb46dc3523c038d`；
`crtos_frozen_inputs.py` 为 `24c100d58465d8d5af00540bec16f0624fad56c2c2a67a13c32ace9f2e43afd0`。
读取 controller 接入代码确认执行入口和 final-check 调用冻结检查，symbolic driver 通过 parser_argv 使用记录输入；
这只是代码接线核对，不表示本次运行或验证了这些阶段。

## 限制与后续输入

审计时 `target != 0` 仍存在于 ResumeAll 函数体证明注释中。计划删除这一冗余注释事实不会修改 C、函数契约或
predicate；本报告不预先判断其证明效果。落盘后整文件和 parser 哈希会改变，controller retry 应生成新的对应 mapping
并照常执行冻结检查，不应继续把上述旧哈希称为最新输入。

`checks/implementation-source-adaptations-applied.json` 和早先适配审阅中的整文件哈希属于历史快照；
本次以当前源码、当前冻结检查和上述逐字匹配 mapping 为证据。所有结论限定于这组输入及现有 non-SMP、32 位验证适配，
不扩展到原生 64 位/SMP 配置，也不将外部契约、NULL helper 或调度模型计为本地已证明实现。
