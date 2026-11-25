# 默认审阅白名单

本文件随 skill 维护，默认读取。用户可通过 `review_whitelist` 指定补充文件；
两份文件分别保留、同时使用，冲突条目以用户规则为准，其余共同生效。
维护与使用规则见[用户审阅白名单](../CONFIGURATION.md#用户审阅白名单)。

## 001：assertS 描述临界区观察条件

适用范围：非 SMP OS 验证沿用 `Rely=True` 的共享 critical protocol，抽象程序使用原生
`assertS` 检查随后进入临界区可能观察到的 global state 应满足的条件，并由 `safeExec`
承担该 checked 条件。条件形如对候选观察集合中的每个 `observed`，要求
`os_inv sg observed` 蕴含目标对象存在、pending 为空等操作条件。

本项目接受这种建模妥协：宽松 rely 使候选观察集合可能成为全集，检查因而比实际执行轨迹上的
条件更强。Predicate/spec reviewer 不得仅因无法从正常调用的实际入口状态或轨迹限制
建立上述全称条件，或尚未给出该条件在正常调用上的可满足性、非真空性依据，而阻塞审阅。
不得要求仅为消除这一审阅问题而修改现有 rely/Lock 契约，或把对象 witness 加回公开接口。

例子：使用assertS描述入临界区时观察到的global state满足的条件，由于Rely=True, 所以是全称量化的，类似（forall observed, (states observed /\ os_inv sg observed) ==> satisfied-condition(args, observed)）；
