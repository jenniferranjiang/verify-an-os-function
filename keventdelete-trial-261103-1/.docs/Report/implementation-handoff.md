# Approved implementation handoff

2026-11-03 用户在 predicate/spec 均review-passed及共享迁移完成后回复“做吧”，批准开始实现证明。
冻结输入：keventdelete-predicate-r1、keventdelete-spec-r1及checks/migration.json中的语义不变共享路径版本。
原C不修改，先前 proposed-event-delete-fix.patch 不应用。TrustBase：/home/xinra/TrustBase.md（仅人可修改）。
范围限制：0 <= id < 65536；D1同一allocation从命中到注销不被他人回收/复用；D2观察/清空后的empty pending到注销保持empty。
CriticalAreaLock的event_delete_gap是该用户环境范围下的可信接口，不可当作ordinary的已证明特化，不可扩大到其他调用链。

本轮实现目标4个：FindEventById、LinklistResumeAll（Event OC场景）、_EventDelete、KEventDelete。按依赖从下向上分别运行controller。
reused-spec边界：IdGetObj、IdRemoveObj、IsDoubleLinkListEmpty、DoubleLinkListRmNode、KTaskWakeup。来源与revision：checks/source-slices/manifest.json；canonical导入合同在annotated_C/src同名文件。不要生成这5个函数的VC或重证它们的body。
模型/API边界：CriticalAreaLock、CriticalAreaUnLock、CONTAINER_OF_EVENT_ID、CONTAINER_OF_TASK_SCHED、x_free、KTASK_ASSIGN，分别依据TrustBase及源代码处理规则；不计为本轮C实现证明。

工程保持现有annotated_C和全局库引用，不复制依赖、不重命名逻辑模块；_CoqProject只新增本trial的VC输出映射。控制器已有project_layout.py原生trial适配，qcp-project.json采用它要求的32位、小端、no_crules、gcc模式。
共享lib文件的设计语义冻结。每个run允许自己的VC/<case>_lib.v作为辅助证明库，不以修改全局predicate绕过冻结输入。
OS Annotation适配：允许by local、call where、branch-control、普通Inv及multi-inv等合法注解；事实仍须证明，不能增加无依据假设、丢路径/资源或改可执行C行为。动态where参数、which implies、局部拆分及循环注解在此阶段完成。

工具配置沿用tools/rocq/toolchain.json的pv-bench-8.20.1确切core；现有QCP/Rocq成功验收可复用。本轮当前Rocq MCP已实际成功导入共享KEventDelete并查询abs_event_delete/event_delete_guard，确认本连接兼容。实际C/symbolic/编译/终检由controller统一调度。

2026-11-04 用户直接回答“明确授权继续实现证明”，所回答问题明确包含symbolic、VC、Rocq及覆盖最初仅设计限制。本次直接授权已传递给原证明owner，当前run及原spec冻结范围不变。
