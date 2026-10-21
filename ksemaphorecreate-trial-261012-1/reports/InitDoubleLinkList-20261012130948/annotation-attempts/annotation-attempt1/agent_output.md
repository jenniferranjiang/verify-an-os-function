# InitDoubleLinkList annotation 检查

Signature: `void InitDoubleLinkList(DoubleLinklistType *linklist_head)`。

Preconditions: 参数等于非零逻辑地址 head，拥有 node_next 和 node_prev 两个未初始化指针字段；其他资源由 frame 保留。

Output: 两个字段都保存 head，完整归还这两个字段的 ownership，构成空双向循环链表头。

Rocq 输出关系直接采用现有 Ptr store 的分离合取，两个字段值均为 head，与冻结 C Ensure 同义；无需新增 predicate 或 case lib。

保持冻结函数 contract 和 C body 原样。函数没有循环，不需要循环不变量或普通 Assert。不存在 failed VC comparison。

指定 formal-case-lib-design 检查 exit 0、status passed（按 absent policy skipped）；指定 symexec exit 0、status passed，生成文件成功发布。检查生成的唯一返回义务 InitDoubleLinkList_return_wit_1：入口地址等式足以把两个字段值从 linklist_head_pre 对齐为 head。该证明交由后续 proving 阶段完成；本 attempt 没有编辑 proof。
