本组四个 assigned witnesses 均已完成。

复用了本 trial 的 InsertObj-vc-proving-r1/groups/group_05__call_preparation 中相应证明结构。两个 pure 义务直接使用显式非零前提；初始化 aux 将两个 head 零值指针单元弱化为 undef 并保留完整 frame；插入 aux 保留全部 pure facts 并重排消去相同空间资源。未新增 helper、import 或修改语义输入。

禁用 lemma/tactic 扫描无命中。指定 controller group-check 已实际退出，exit code 0，JSON status passed；四个当前 assigned proofs 均通过本组 Rocq 检查。
