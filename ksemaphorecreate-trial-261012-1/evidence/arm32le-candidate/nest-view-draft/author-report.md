新增临界计数视图已完整通过现代小端配置的 coqc，等待独立 delta review。它尚未移入 active lib、被 canonical header 引用或交给 QCP；不会把 predicate proof 冒充 CriticalAreaLock 的 C 实现证明。

视图供 CriticalAreaLock 和 CriticalAreaUnLock 共用。`CrtosSchedulerViews.store_scheduler_assign` 直接列出原调度视图中 Assign 对象的全部非 nest 资源；成对拆分/合并证明保持 done 指针的存在量词及尾部 padding。`SemaphoreCriticalFrame` 保留完整 task 借用视图、Assign 视图和 semaphore 模块；真实的 UShort 计数单元独立暴露，CrtosOSValid 作为纯事实留下。两个方向的 invariant entailment 均已证明，因此没有丢弃或复制 heap 资源。

单元转换依赖已复原的两个 Arch32 LittleEndian 载体，并在字节层证明 OSHeap 的 UShort 与当前载体的实际 UShort 等价。不会把旧大端表示当成小端，也不通过 heap bridge 转移 IRQ token。

计数写入后的重组只使用拆分时已有的有效性和真实新计数范围。++ 接口使用原批准 nest<65535，允许内部写到65535；-- 接口直接覆盖 max(0,n-1)，包含0时不写的饱和分支。冻结 r4 的18个文件均未改变，不需要加强 canonical Require。

`build.json` 保存完整 coqc 命令与 exit 0；`assumptions.json` 检查全部10个公开 lemma，依赖仅为原框架的地址/类型大小参数及已有函数、命题外延性，没有新增公理或占位。`frozen-helper-r1/manifest.json` 固定源 hash、15 个 Qed 和基础 r4 manifest。最初未通过的检查及端序纠错仍保留在迁移证据中。
