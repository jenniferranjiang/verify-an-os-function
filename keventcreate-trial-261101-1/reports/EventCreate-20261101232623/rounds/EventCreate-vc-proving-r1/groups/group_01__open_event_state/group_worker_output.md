# open_event_state delivery

全部 3 个 assigned top-level witnesses 与 5 个 aggressive split goals 已完成。所有 proof mode 与 declaration、seed、unassigned tokens 保持不变。

- `dll_event_fresh__open_event_state` 对事件 DLL 归纳；当新对象地址等于已有事件地址时，两个分离资源都拥有该地址的 options UInt 字，展开为同址 4 字节存储后应用 `dup_store_4bytes` 排除该情形。任意链表前缀及尾段均在归纳中处理。
- `event_fresh__open_event_state` 从系统不变量提取上述 DLL，并以独立 EventZero 所有权推出地址新鲜性。没有引入 malloc 新鲜性假设。
- 拆分保留全部 OS frame；ZeroIdNode 通过已有 `zero_idnode_insert_ready` 转成 ID 插入输入，event_context 将抽象 manager/head 对应到 C 全局地址。
- ID 失败/成功分支分别选择原析取左/右支；lock 的有符号界限来自 Int 存储，最小 ID 界限来自已冻结 manager 定义及 event_context。

使用 Rocq MCP 的 start/check 完成 helper、各类 split/entail 与最终 aggressive 分派的交互证明。最初 native 检查发现 aggressive 的实际次序为 spatial 后接 1/2/3/4；已按交互显示更正。最后顶层交互检查 `proof_finished=true`。

最终 handoff 原样 `coq-check --target-kind group-check --group open_event_state`：exit 0，JSON status passed，elapsed_seconds 65.633881。编译了当前 lib、goal、auto、manual 与本组 wrapper；复用基础依赖 198 项。

本组新增 helper 全部使用 `__open_event_state` 后缀，未增加 import、axiom、admit、spec、VC 或 C 修改；未使用禁用 lemma/tactic。不存在 annotation gap。
