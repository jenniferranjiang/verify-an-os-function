# 本 trial 的 QCP controller

源代码复制自 `ksemaphorecreate-trial-261019-3/tools/qcp-controller` 的已使用适配器。
保留 CRTOS 扁平切片路径、Arch32/LittleEndian、只读外部依赖、冻结输入检查及原有
owner/VC 分组/编译/最终重放流程。没有复制旧 run、证明结果或编译缓存。

运行入口为 `scripts/verification-orchestrator/controller.py`，Python 3.12，
`--main-root` 指向本 trial。本轮目标只包含 `_SemaphoreCreate`、`KSemaphoreCreate`。
其他函数的 VRTOS contract 是模块化证明的外部依赖，不声称其实现已在本 trial 验证。
新增可信 ABI 前提的授权见 `../../checks/abi-authorization.json`。
