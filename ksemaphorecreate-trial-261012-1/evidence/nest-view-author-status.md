当前新增 nest 拆分文件仍是 draft，未通过完整 coqc，未提交为 accepted predicate revision。主代理发现当前选用的 QCP 旧字节表示为大端，与目标 ARM 小端不一致，已要求暂停 helper 扩展并先处理架构表示。

新增文件为 `lib/SemaphoreCriticalViews.v`。它保留原九个正式库文件不动，尝试给 Lock/UnLock 共用的 Assign 余项、完整 OS 余项、当前 carrier 的 UShort 单元提供拆分/重组接口。现有桥仅保持同一 heap 中原库的字节解释，不能证明该解释符合 ARM。

最初的检查包装只打印 stdout/stderr，没有验证子进程 returncode；空输出被错误报告为通过，已立即向主代理更正，不能作为编译成功证据。后续限时检查先在 existential bridge 的 `firstorder` 超时；改为直接构造后，真实 `coqc` 返回 1，停在 `OSHeap_ushort_eq` 的第二个 existential rewrite。完整日志是 `evidence/probes/nest-view-build-time.log`。后续已经写出的 increment/decrement 重组 proof 尚未获机器检查，不能按源文件中的 Qed 数量声称其已证明。

推荐处理路径是新 trial 内隔离 candidate 共享库：以根库实际依赖闭包的 `.v` 为输入保存来源 hashes，选择官方 `Rocq/SeparationLogic` 的参数化版本，将两个载体共同实例化为 `Arch32 LittleEndian`，再重编全部候选和 trial 依赖。原根目录不改，不能混入旧 `SeparationLogic/SeparationLogic` 的 `.vo`。官方可用接口：`CommonAssertion.v` 的 `DerivedPredSig`、`StoreAux.v` 的 `StoreLibSig`、ArrayLib/MapLib/StringLib 均接收 Arch/Endian，`CArch.v` 的 LittleEndian 带具体证明。当前官方目录有对应 `.vo`，但编译器兼容性和完整依赖闭包仍待实际检查；需包含 Flocq 等新依赖。其目标仍是原 ARM ILP32 语义，不是改变功能范围。

替代的同址 identity 字节桥不成立：大端16位数1的两个字节是0、1，而ARM小端是1、0。若保留大端表示，需要按字段大小的资源型字节置换及所有 load/store/memset 的关系证明；不能只给 driver 加开关，也不能用一个与访问宽度无关的地址置换支持重叠 byte/ushort/uint。因此建议先做候选库实例化兼容性探针。此分析没有实施迁移，也未读取旧 trial、改原 C/根共享库/skill/header/controller/owner文件。
