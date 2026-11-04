本组两条 KTaskWakeup 规格精化已完成，保持 assigned statements、prelude、其他 proof spans 和 library seed 不变。

- semaphore 精化先从原 os_inv 提取 os_world_wf、semaphore 地址唯一性、ID manager 唯一性及等待队首的 SUSPEND descriptor；在交还 os_inv 前保留纯事实。两次同 ID 查找结合 task_world_wf 的对齐与已有 ABI 布局事实确定同一 task。成功分支由全局调度 owner NoDup、remove_found 确定性证明精确队首摘除，其他 semaphore 对象及 mutex/event/self-owned 分量不变，返回剩余队列关联并保留 os_inv。
- detached-null 精化保留原 os_world_wf；显式 detached condition 供给 delay=0 和成功分支的 self-owned membership，推出其他等待队列无目标任务，零延时取消为恒等，构造 detached step。非 SUSPEND 分支原样保留 before 和 descriptor。
- 从只读归档 refs/remotes/origin/trial-archive:ksemaphoredelete-trial-261025-1/VC/LinklistResumeAll_lib.v 按需改写 DLL 节点唯一性和 payload 借用 helper，统一使用 __wakeup_refinements 后缀；pending descriptor 提取适配当前 KMutexDelete 导入闭包。
- 已在 controller 生成的 group_06/dev 工作区通过 Rocq MCP 交互完成两个核心 refinement helper（proof_finished=true）；其余证明以本组 controller 原生检查为准。
- group-development 返回 exit 0、status passed，编译本组 lib、goal、auto、manual。完整禁用 lemma/tactic 扫描无命中。
- 最终 group-check 返回 exit 0、status passed（64.239 秒），包含本组 wrapper 的全部五个目标均重新编译通过。
