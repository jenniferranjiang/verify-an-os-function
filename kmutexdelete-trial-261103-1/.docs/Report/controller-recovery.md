# 用户批准后的 controller 恢复修复

用户已明确批准 `.docs/Report/proposed-idnode-spec-normalization.patch`。旧 controller 的 `unfreeze` 只接受 running annotation，已正常交付 blocked 的同一attempt无法按原流程恢复。原始失败已保留在检查记录中；没有通过手改controller_state.json绕过它。

对 QCP 工具 `annotation_design.py` 的最小修复允许当前blocked annotation在显式unfreeze命令下进入既有repair/claim流程。原owner与attempt保持，移除的仅是该旧blocker的调度障碍；实际解析、冻结新baseline、VC、proof和acceptance检查没有跳过。running原行为不变，accepted/其他phase/无用户spec仍拒绝。

原/新代码、具体补丁和六项回归结果在 `../checks/controller-unfreeze-recovery/`。工具目录写入的第一次自动审批超时，按返回提示重试后获准执行。随后真实unfreeze返回append action，经正常claim交回原annotation owner；不是直接标accepted。用户批准的等价规格修改由原owner实施，controller之后重新symexec、编译并接纳annotation。

这一修复仅是工具恢复路径，不是C或Rocq规格的新假设。
