# 本 trial 的 QCP controller

复用 261022 SemaphoreCreate 工具侧适配代码，保留 upstream schema 4 workflow、owner/acceptance/final-check。正式输入继续使用现有 annotated_C、_CoqProject 与外部 CRTOS_Verify.lib；输出映射为 VC/CRTOS_Verify.VC。没有复制旧 run、证明或依赖库。

本轮仅 KSemaphoreDelete、_SemaphoreDelete、LinklistResumeAll 三个函数体；其余依赖按 checks/verification-scope.json。冻结内容和批准依据见 checks/implement-frozen-inputs.json。
