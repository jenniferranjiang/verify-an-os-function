# 实现阶段等义适配复核

2026-10-30，独立定向复核：以下 parser 规范化与两处参数拆句的等义性检查通过，未发现改变契约含义或 C 行为的问题。
第二处拆句在检查时尚未写入活动文件，其结果是对拟议转换及逆映射的检查，见末节。
本次只读正式代码，执行了 Python 内存规范化及冻结输入比较；没有运行 QCP、生成 VC 或证明函数。

## Parser 输入规范化

检查对象为 `tools/qcp-controller/scripts/verification-orchestrator/crtos_parser_input.py`
（SHA-256 `c1aa0c918c2b7b9df57af981ff24886221d3415b05c128c9b48c7b8559ea7e23`）。

- IdRemoveObj 的两个契约中，`idnode->id` 的字段存储断言改写为 unsigned short 的显式 store；
  link.node_prev/node_next 改写为嵌套 field_addr 上的节点指针 store，自环目标仍为该 IdNode 的 link。
  原纯非零地址条件仅将取址 sugar 改成 field_addr。字段类型和地址对应当前 slice_types.h，
  与根 `annotated_C/src/kernel/thread/ktask_id_delete.c:19–29` 的现有表示一致；分离连接、分支及量词未变。
- DoubleLinkListRmNode 的 remove_from_head 块将绑定类型 A 及其三处使用一致改为 A_from_head；
  改名前检查新名字未出现，避免捕获。当前块无其他同名嵌套绑定，逆改名得到原契约。
  实际选用的 remove_member 完全不变。
- 对当前 `_SemaphoreDelete.c` 在内存中执行规范化后，契约差异恰为上述三个具名块。
  代码自检确认去注释后的 C 和换行数不变；parser_argv 写单独 evidence 输入及映射记录，
  不覆写 canonical 文件。此结论限于当前文件及转换规则，不把 parser 绕过本身当作证明。

## LinklistResumeAll 参数拆句

`task->exstatus = -ERROR` 后，将 `KTaskWakeup(task->id.id)` 拆为读取到新鲜块内变量
`int32 resume_task_id`，再调用 KTaskWakeup(resume_task_id)。字段仍只读一次；两步之间仅有证明注释，
没有 C 副作用或调度点。uint16 的完整值域可由当前 ILP32 signed int32 表示，赋值转换与原形参转换相同。
变量地址不逃逸，不影响循环中下一次队首读取，契约未修改。

检查的 `crtos_frozen_inputs.py` SHA-256 为
`d62f6c63fccf66fa0d6df46998899052b66f057c64a6b652ff510b8e44366f85`。
其例外只针对该文件；要求新变量在可执行 token 中恰出现两次、完整新序列恰出现一次，
然后精确逆映射回原调用并比较冻结 token 哈希。额外使用、插入 C 语句或其他可执行改动仍会失败。
匹配使用当前 tokenizer 实际产生的 `- >` 两个 token，与 C 的 `->` 运算符对应。
同一次检查继续独立比较所有 caller/canonical contracts，不能通过逆映射放宽契约。

本次实际调用 `check_frozen_inputs` 通过。被检查 ResumeAll 文件 SHA-256 为
`668871fbc24dbef937f7378a846f8f185abc36f50253bd589776f39619c47eff`；后续纯证明注释修改
无需重复源码等义审阅，若可执行映射或契约变化则需重新检查受影响部分。

## _SemaphoreDelete 的拟议参数拆句

`checks/implementation-source-adaptations.json` 的 second_split 将 IdRemoveObj 的第二实参
先读入新鲜 `uint16 delete_sem_id`，再调用。该类型与字段、形参均相同，读值不变；原第一实参
仅为全局对象取址，没有求值副作用。因此将字段读取移到紧邻调用的上一条声明不改变实参间的
求值依赖，也不改变 ResumeAll、注销、摘链、解锁和释放的顺序。

冻结检查器为此单独限定 `_SemaphoreDelete.c` 的精确 token 映射，要求变量仅出现两次且序列唯一，
再逆映射并校验原冻结哈希；机制与上一项相同。内存中对当前源码应用该拟议拆句后，契约比较和
逆映射后的冻结 token 哈希均通过。实际活动文件此刻仍是原调用，SHA-256 为
`9f8d5933fd8ce52f2c9a89e9a1019e4c13d594b27708fd3d6ff20efb78698c19`；落盘后仍应由 controller
照常执行冻结检查。本次没有代替 annotation owner 修改它。

## NULL_PARAM_CHECK 的既定 API 替换方案

独立只读复核结论：可将 ResumeAll 的精确空指针检查段在记录的 parser 输入中替换为
NULL_PARAM_CHECK_1(list)，并添加与现成接口一致的 declaration-only contract。
《源代码处理》明确列出这一宏替代函数；本 trial 的 adapted-closure.md:25、48 已允许在
最终选择后登记它。既有 8 个边界是此前实际采用的清单，不构成禁止这项已许可适配的范围限制。
因此这不需要新增用户授权，但须将有效 parser 输入的模型/API 边界更新为 9 项，并保留 3 个实现目标。

已读 VRTOS `annotated_C/src/kernel/common/null_paramter_check.c` 的实际 helper：空指针分支
无限循环，非空正常返回，没有内存访问或写入。其接口与 `headers/m_ktask.h:494` 一致，
仅在正常返回时保证参数非空；不保证任意输入终止，也不将空指针路径变成正常返回。
参数 list 是无副作用的局部指针值，转为 void* 不改变空指针性；调用通过 frame 保留 os_inv
及其他 caller 资源。多个现有调用点（如 kernel/delay/ktask_unset_delay.c）提供同一接口用法，
但本检查未核验其任何证明产物，也不把 helper 计为本轮已证明实现。

适配器必须精确定位该原宏检查，不可泛化删除其他无限循环；canonical/source 及目标
predicate/spec 保持原样。新 parser 输入、额外 API 声明、来源版本/哈希及映射均须留证，
最终检查须使用相同适配路径。这是已规定的模型/API 抽象，不再属于纯 token 不变的
parser 拼写改写，不能沿用后者的“可执行代码完全未变”标志。当前结论是方案适用性审阅，
没有执行该替换或运行 QCP；工具实现仍应检查实际产物符合此范围。
