# Dataqueue 逐函数验证用时

快照时间：2026-11-19 12:13:22（Asia/Shanghai）。用时格式 HH:MM:SS，四舍五入至秒。后续每个函数完成后更新；未开始项不预测用时。

- **workflow 有效经过时间**：当前有效 run 的创建至 final-check done；进行中则截至本次快照；明确扣除下方用户暂停区间。包含该 run 内注解、审阅/检查、证明、重试、调度和非暂停等待；不是纯 CPU 时间。
- **VC 证明阶段经过时间**：逐个 vc-proving round，取最早记录阶段开始至最晚结束的时间跨度，再累计各轮；并行组按同一轮的实际跨度计一次。含失败轮、组间等待、接纳和 parent check，不含其间 annotation/vc-checking 返工及 final-apply/final-check。无手工 VC 的 wrapper 仍有准备和 parent 检查时间。
- **累计组工时**：日志 group-work.elapsed_seconds 之和，包含各 owner 的推理、工具调用及等待；并行部分重复计时，因此可能大于实际经过时间，不能与上一列相加。未进入手工证明阶段为“—”，确实无手工组为 00:00:00。
- 统计依据为链接的原生 timing_summary.json；进行中尚无该文件时只用 controller_state.created_at 计算 workflow 经过时间。缺失的阶段数据不编造。
- 仅统计表中当前有效 run，未累加被替代的旧实验、run 开始前设计，以及 done 后根 make/.vo 恢复和依赖一致性检查；因此不是整个历史研发总工时。函数自身 done 不代表其导入契约本体已证；Pop 的新增调用闭包尚未全部完成。

| 函数 | 当前状态 | workflow 有效经过 | VC 证明阶段经过 | 累计组工时 | proving 轮数 | 计时依据 |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| InitDataqueue | done / final-check通过 | 00:21:22 | 00:09:01 | 00:04:31 | 1 | [日志](../../../../reports/InitDataqueue-20261118165045/timing_summary.json) |
| DeInitDataqueue | done / final-check通过 | 00:13:50 | 00:05:17 | 00:03:27 | 1 | [日志](../../../../reports/DeInitDataqueue-20261118171259/timing_summary.json) |
| _SemaphoreCreate (IC) | done / final-check通过 | 04:14:34 | 03:38:11 | 06:59:14 | 1 | [日志](../../../../reports/SemaphoreCreateIC-20261118193701/timing_summary.json) |
| KSemaphoreCreate (IC) | done / final-check通过 | 00:04:48 | 00:00:31 | 00:00:00 | 1 | [日志](../../../../reports/KSemaphoreCreateIC-20261118235343/timing_summary.json) |
| _SemaphoreDelete (IC) | done / final-check通过 | 01:37:34 | 01:14:33 | 01:56:49 | 1 | [日志](../../../../reports/SemaphoreDeleteIC-20261118235913/timing_summary.json) |
| KSemaphoreDelete (IC) | done / final-check通过 | 00:04:37 | 00:00:36 | 00:00:00 | 1 | [日志](../../../../reports/KSemaphoreDeleteIC-20261119013710/timing_summary.json) |
| DataqueuePeak | done / final-check通过 | 00:28:14 | 00:18:07 | 00:27:48 | 1 | [日志](../../../../reports/DataqueuePeak-20261119014233/timing_summary.json) |
| PopDataqueue | done / final-check通过 | 00:28:03 | 00:14:20 | 00:27:05 | 1 | [日志](../../../../reports/PopDataqueue-20261119021132/timing_summary.json) |
| CalculateTickFromTimeMs | done / final-check通过 | 00:26:47 | 00:10:35 | 00:16:34 | 2 | [日志](../../../../reports/CalculateTickFromTimeMs-20261119024015/timing_summary.json) |
| LinklistSuspend | done / final-check通过 | 02:49:10 | 02:00:03 | 03:51:01 | 1 | [日志](../../../../reports/LinklistSuspendSemaphore-20261119031206/timing_summary.json) |
| _SemaphoreObtain | done / final-check通过 | 02:41:03 | 01:33:39 | 03:15:24 | 2 | [日志](../../../../reports/SemaphoreObtainRuntime-20261119060206/timing_summary.json) |
| KSemaphoreObtain | done / final-check通过 | 00:04:42 | 00:00:33 | 00:00:00 | 1 | [日志](../../../../reports/KSemaphoreObtainRuntime-20261119084641/timing_summary.json) |
| LinklistResume | done / final-check通过 | 00:48:00 | 00:25:35 | 00:26:53 | 1 | [日志](../../../../reports/LinklistResumeSemaphore-20261119085215/timing_summary.json) |
| _SemaphoreAbandon | 已暂停：vc-checking | 00:06:49 | — | — | — | [日志](../../../../reports/SemaphoreAbandonRuntime-20261119094155/timing_summary.json) |
| KSemaphoreAbandon | 未开始 | — | — | — | — | 待创建 workflow |
| PushDataqueue | 未开始 | — | — | — | — | 待创建 workflow |

当前 13 个已 done 函数的 workflow 时间逐项合计：**14:22:46**。这是所列各 run 用时之和，不含相邻 run 之间的空档及上文排除项。

| 函数 | workflow 开始（北京时间） | final-check 完成（北京时间） | 当前 run |
| --- | --- | --- | --- |
| InitDataqueue | 11-18 16:50:45 | 11-18 17:12:08 | `InitDataqueue-20261118165045` |
| DeInitDataqueue | 11-18 17:12:59 | 11-18 17:26:49 | `DeInitDataqueue-20261118171259` |
| _SemaphoreCreate (IC) | 11-18 19:37:01 | 11-18 23:51:35 | `SemaphoreCreateIC-20261118193701` |
| KSemaphoreCreate (IC) | 11-18 23:53:43 | 11-18 23:58:32 | `KSemaphoreCreateIC-20261118235343` |
| _SemaphoreDelete (IC) | 11-18 23:59:13 | 11-19 01:36:47 | `SemaphoreDeleteIC-20261118235913` |
| KSemaphoreDelete (IC) | 11-19 01:37:10 | 11-19 01:41:47 | `KSemaphoreDeleteIC-20261119013710` |
| DataqueuePeak | 11-19 01:42:33 | 11-19 02:10:47 | `DataqueuePeak-20261119014233` |
| PopDataqueue | 11-19 02:11:32 | 11-19 02:39:35 | `PopDataqueue-20261119021132` |
| CalculateTickFromTimeMs | 11-19 02:40:15 | 11-19 03:07:02 | `CalculateTickFromTimeMs-20261119024015` |
| LinklistSuspend | 11-19 03:12:06 | 11-19 06:01:16 | `LinklistSuspendSemaphore-20261119031206` |
| _SemaphoreObtain | 11-19 06:02:06 | 11-19 08:43:09 | `SemaphoreObtainRuntime-20261119060206` |
| KSemaphoreObtain | 11-19 08:46:41 | 11-19 08:51:23 | `KSemaphoreObtainRuntime-20261119084641` |
| LinklistResume | 11-19 08:52:15 | 11-19 09:40:14 | `LinklistResumeSemaphore-20261119085215` |
| _SemaphoreAbandon | 11-19 09:41:55 | 已暂停 | `SemaphoreAbandonRuntime-20261119094155` |

ID/DLL、GetKTaskDescriptor、KTaskSetDelay、KTaskWakeup、SuspendKTask 等 imported contracts，以及 IRQ/C 库/CONTAINER_OF/KTASK_ASSIGN 等模型边界，不列为本轮已证函数，也不填虚构函数体证明用时。范围与结果详见[任务总表](function-status.md)。

用户暂停区间（UTC 原始时间；开放区间在恢复时补结束时间，期间不计时）：

| run | 暂停开始 UTC | 恢复 UTC |
| --- | --- | --- |
| `SemaphoreAbandonRuntime-20261119094155` | 2026-11-19T01:48:44.065998Z | 尚未恢复 |

本次在 VC-checking owner 已领取但尚未派发 agent 时暂停，尚未进入 vc-proving；组工时不受本次暂停影响。原生 controller 计时日志保持原样，本表额外扣除用户暂停时段，不修改工具适配层。
