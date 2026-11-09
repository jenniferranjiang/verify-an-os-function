本组六个指定 proof spans 已完成，并保持原 statement、声明顺序、prelude 和未分配 proof 不变。

`exstatus_borrow_update__exstatus_write_view` 从 `os_inv` 中拆出目标任务旧 exstatus 的 Int 单元，构造接受 Int -1 的恢复 wand。证明在目标处拆分并重组 descriptor store_map，保持其余字段和任务栈，分别证明 task/world/service-slot/delay/ready 的纯关联保持，并保留自持节点、zombie 与 IPC 等待队列的资源解释。没有增加原 os_inv 和 map lookup 以外的有效性前提。

局部 VC 投影已有 descriptor-map 等式，保留历史纯事实与 InsideCritical；写入前将旧 Int 单元遗忘为 undef，写入后按 retval=target 对齐字段地址。top-level which_implies_wit_5 使用 aggressive_pre_process 和对应 split lemma，其余指定目标使用 LLM_pre_process。

验证：2026-11-04 controller `coq-check --target-kind group-check --group exstatus_write_view` 返回 exit code 0、JSON status passed（116.188299 秒）。manual 和 group library 的禁用 lemma/tactic 扫描无命中。所有新增 helper 使用 __exstatus_write_view 后缀。未修改 annotation/spec；无 annotation gap。
