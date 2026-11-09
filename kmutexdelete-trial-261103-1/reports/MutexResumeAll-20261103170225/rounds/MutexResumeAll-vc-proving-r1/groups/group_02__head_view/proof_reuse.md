本组参考本地历史 refs/remotes/origin/trial-archive 中 ksemaphoredelete-trial-261025-1/VC/LinklistResumeAll_lib.v 的 DLL payload、pending borrow、pending descriptor 与 task alignment helper，以及对应 manual 的 head read、wand restore、descriptor proof。

将 Semaphore 模块、对象投影、等待链头、payload 与全局不变量成员全部适配为当前 Mutex 定义；Mutex payload 归还增加空间结合重排。所有新增 helper 使用 __head_view 后缀。历史证明仅作为起点；交付依据当前 controller group-development 和 group-check。
