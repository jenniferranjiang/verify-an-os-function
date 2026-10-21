# 本次设计范围

本 trial 为 2026-10-19 当天第 3 次新实验，独立从当前权威源码、board/stm32f103-nano/config、当前共享 lib、annotated_C 与 skill/guides/experience 开始。旧 trial 仅查看根目录名称用于计算序号，未进入、读取或复用。所有本次源码搜索限定至允许的目录；构建映射不得包含其他 trial 或根目录递归映射。

目标为 KSemaphoreCreate 设计及独立审阅；仅入口调用者处于共享协议临界区外、未持有协议保护资源。2026-10-21 用户明确要求不建模硬件中断状态及其保存、恢复；保留抽象临界区资源协议。没有假设硬件中断开启。调用闭包按函数实际调用状态设计。

2026-10-21 用户要求将 CriticalAreaLock、CriticalAreaUnLock 改为仅保留 spec 的 trusted 接口，并参考 VRTOS。当前调用闭包中的 trusted 为 x_malloc、x_free、memset、CriticalAreaLock、CriticalAreaUnLock、KPrintf；DisableLocalInterrupt、EnableLocalInterrupt 位于 trusted 原语内部，不再递归展开。完整 caller-local contract 仍须纳入审阅，具体调整见 [spec 设计](spec-design.md#trusted-临界区接口调整)。

用户授权 predicate 审阅通过后直接设计并审阅完整 spec，修复和重审无需中途确认。停止位置为两份 review-passed revision 及设计编译/类型/源码等价性检查通过。不得运行 QCP parser、symbolic、VC、verification-orchestrator 或 C 实现证明。

本次使用 verify-an-os-function；按 skill 将 C analysis、predicate author、spec author 分开，审阅者不审阅自己编写的设计。所有共享库变更先保存在 trial 候选内，根共享库保留现状。
