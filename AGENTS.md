# OS 验证入口

在本工程验证 OS 函数或继续已有验证任务时，使用
[os-verification-coordinator](.agents/skills/os-verification-coordinator/SKILL.md)
作为 master/orchestrator，按其阶段路由读取对应子 skill。

用户可在本文件指定其他主入口、阶段组合及 Human / AI 审阅方式。
仅请求某个阶段时使用对应子 skill；沿用已有配置、验证成果和仍适用的授权。
具体阶段规则与 QCP 交接由 skill 维护，不在此复制。
