# 共享依赖迁移（2026-11-10）

按用户要求，将原 `.provider/crtos-8a16/lib` 的完整任务模型恢复到根
`lib/*.v`，保留 `CRTOS_Verify.lib.*` 导入路径。试验通过 `-R ../lib
CRTOS_Verify.lib` 直接引用共享库；QCP 改用已有的
`../../qcp-binary-democases/Rocq`，删除本地 `.provider` 整个目录。

`lib/common` 等模块化目录的精简模型保持独立，不与完整任务模型混用。
恢复来源及接口适配说明见根 `lib/TASK_MODEL.md`。迁移未添加 Axiom 或
Admitted；字节存储及地址有效性接口随当前 QCP 适配。

按用户最新要求，已停止编译，不再编译验证。历史设计文档中的 pinned
provider 构建及审阅记录对应旧输入，不是当前配置已通过的证明结论。
本次刷新 manifest 仅记录迁移后的文件路径与哈希，不构成新的审阅通过。
