# IdRemoveObj 冻结规格表示规范化审阅

结论：**语义等价审阅通过，补丁未应用**。审阅者 `/root/source_review`，日期 2026-11-03。对象为同目录 `proposed-idnode-spec-normalization.patch`，SHA-256 `fb1b185e23ce7e6aaf9a81e90c6579fd81d7d6622715266489ebb3104fc6283d`。

已只读核对补丁、当前 trial `_MutexDelete.c` 与 `IdRemoveObj.c`、实际 IdNode/链节点类型，以及 `reports/MutexDelete-20261103170333/annotation-attempts/annotation-attempt1/agent_output.md` 的失败记录。报告显示 QCP 在进入目标正文前，把逻辑地址 `idnode` 上的重名 `id` 字段误推为 RecordIdNode，随后无法与整数 65535 统一；本审阅没有重跑工具确认修复效果。

四个 hunk 同步修改 caller-local 和 canonical 的 high_level_spec/low_level_spec，改动仅有：

- 把 ID link 的地址写成显式 `field_addr(idnode, struct IdNode, link)`，保留原非零条件。
- 把 ID 值的 owned-field 断言写成该 IdNode.id 地址上的 `unsigned short` store，值仍为 65535。
- 把 node_prev/node_next 的 owned-field 断言写成嵌套 field_addr 上的链节点指针 store，两者仍指向同一 ID link，自环语义不变。

这些原表达式位于分离合取中，是拥有字段内存的断言，不是可以删去空间资源的纯等式。显式写法保留同样三个存储单元、类型和值；不额外拥有 ID padding 或其他节点资源。所有 With/Require、存在量词、未命中/命中分支、ID-manager 更新、纯条件、分离合取和其余 frame 均保持不变。补丁不修改执行语句、函数签名或布局，也不引入新假设、trusted symbol、Axiom 或占位证明。两端同名合同仍一致。

已有同项目先例：`annotated_C/src/kernel/thread/ktask_id_delete.c:24–28` 对同一 IdRemoveObj 返回资源使用完全相同的显式 IdNode/链节点 field_addr 和 typed store；`annotated_C/src/kernel/thread/ktask_create.c:385–392` 的失败回收资源也采用此表示。这些先例支持表示选择，不替代后续 QCP 对本次输入的实际解析检查。

本次检查时 `_MutexDelete.c` SHA-256 为 `16a478384d55ae96f0eeba4f22d6f48c78715d4c53cdc58ddf0d5d8c54f70922`，`IdRemoveObj.c` 为 `690d8789967fa4f704153597ea79f0741e839dc47dbe39c0869ee44a2c1bbbe3`；两份正式规格仍为原 sugar，未应用规范化。此次通过仅说明该补丁保持已审阅合同的语义，不表示解除 controller 的冻结授权或证明阻塞已经消失。待用户批准这项冻结 token 变更后，才由主 agent 同步应用、记录新 revision，并交由 controller 继续实际检查；本审阅没有启动任何 controller 动作。
