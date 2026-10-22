# entry_calls 完成说明

6 个 assigned top-level VC 均已按 LLM_pre_process whole-goal 路线完成；两个 protected split blocks 保留生成的 Proof/Abort。入口值范围通过 store_ushort_range 从原有 UShort 局部变量资源导出，原资源与 OutsideCritical 保留。分配、清零及加锁调用前提使用既有纯前提、常量边界和相同资源完成。两个 pure→aux 包装命题分两次展开。

未添加 helper，未修改 library seed、spec、predicate、ABI 假设或 annotation。

正式 group-check 返回 exit code 0、status passed，耗时 75.533528 秒；当前 manual、library、goal、auto 与本组 check wrapper 均重新编译。停止写入，等待 main finalize-delivery。
