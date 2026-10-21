本探针证明 nested carrier 可以与当前根共享 heap 表示接合；它没有证明真实 IRQ acquire/release，也没有修复 r1 或解除审阅 blocker。

复现命令：`python3 ksemaphorecreate-trial-261012-1/evidence/probes/check-nested-carrier.py`。脚本核对官方源hash及唯一接口替换，编译adapter与probe，并检查正式predicate源没有被修改；记录见`nested-probe-reproduction.json`。

`NestedCarrierProbe.v` 已编译成功，并有三个 Qed：nest 局部递增/递减不改变去掉计数后的受保护 OS 投影，以及 nested carrier 上的 heap 分离桥。结果与命令见 `nested-carrier-check.json`。`nested-carrier-assumptions.txt` 表明两个投影结论没有公理依赖；heap桥仅依赖原 CNotation 地址/sizeof 接口及已允许的函数/命题外延性，没有新增全局逻辑假设。

现成 `NestedCriticalSTS.vo` 与所安装 ArrayLib 的编译假设不一致。直接编译官方 `Rocq/SeparationLogic/NestedCriticalSTS.v` 又遇到新版 `CArchSig/CEndianSig` 参数与已安装、已特化架构的 DerivedPredSig 接口不匹配。隔离 adapter 只删除这两个 module 参数，并把 `DerivedPredSig Arch Endian R1` 调整为已安装接口 `DerivedPredSig R1`；state、transition、token、assertion 的定义体完全未变。精确替换与两份源hash在 `framework/adapter-provenance.json`，官方源通过只读symlink保留，根库未改。官方 module type 中的 `Parameter nc_sts` 是 functor 输入，在探针中由具体 `Definition nc_sts` 实例化，不是新逻辑假设。

后续真实协议设计必须解决的两点：

1. QCP `NestedCriticalCSL.Critical hs s` 在空 hs 分支中没有使用参数 s，而是独立存在量化 s'；因此不能直接声称它绑定调用前的 LastSeen(before)。
2. 官方 NCT_enter 仅要求不持有 depth 及以上 token，没有要求持有全部外层 token；在 inside 状态，空环境token集合也满足这一进入条件。因此 IRQ-disabled 内部的环境排他性不能由类型检查推得，必须另给 owner-aware adapter/稳定性证明。

handler栈长度与真实 uint16 nest 应满足取模关系，但该关系不保证65535处的加减恢复。投影归零只是协议表达分层，不允许借此隐藏实际计数变化。主agent独立调查该API序列与用户批准frame要求的冲突。

本目录不是正式r1输入，不应加入其manifest、QCP输入或正式proof closure；它是适配方案的可复现证据。
