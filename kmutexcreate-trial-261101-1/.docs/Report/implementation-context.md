# Implement 交接（用户于2026-11-01批准）

用户原话：“我通过了 你继续implement”。批准 predicate revision `038457b98a07c2fa559a7ec4ea7d63e980af6b73b4a8d8782668ffd97640e036` 与 spec revision `55bbd4bac08ceb62317b2e176f7ce83d5bc6a46314248abfd8a89f9edc497929`，含已经记录的全局迁移对应。现有源文件、contract和共享predicate语义冻结；用户批准不是扩大信任边界或授权修改权威C。

现有工程：`/home/xinra/crtos/kmutexcreate-trial-261101-1`。使用原annotated_C/src、include和_CoqProject；共享库在 `/home/xinra/crtos/lib`，逻辑前缀 CRTOS_Verify.lib。trial/lib及checks/review-inputs均为审阅快照，不参与构建，不复制整套库或依赖。新增证明产物放trial/VC，项目追加唯一 CRTOS_Verify.VC 映射。新case库可以添加辅助引理并导入共享库，但不能复制或重定义冻结predicate，不得新增Axiom/Parameter/Admitted绕过义务。

实现目标只有 `_MutexCreate`（先做，case MutexCreate）及 `KMutexCreate`（随后独立case）。这两个真实active body均必须验证。所有caller-local合同与canonical一致；改动冻结规格先停止、给出具体变更方案，经用户确认后再unfreeze。

复用边界不提交本轮VC/函数体证明：IdInsertObj（根annotated_C/src/headers/id_module_spec.h，来源commit12378745b310bfcefb150a6c0e5a5fbfdd95787c），InitDoubleLinkList、DoubleLinkListInsertNodeAfter（根同名canonical C）。采用当前trial中精确导入的合同；DLL采用dispatch_case，保留另一个原spec不意味着要证明它。来源hash见c-analysis.md/spec-review.md。

TrustBase：`/home/xinra/TrustBase.md`，只读。CriticalAreaLock/UnLock、KERNEL_MALLOC/FREE的真实x_malloc/x_free宏别名及标准库memset作为既有边界。x_free的mutex_object实例消费完整MutexRaw并只用于本次malloc原基址；不把它声称为本轮新实现证明。共享布局公理为既有信任接口，双侧ABI已核对：Arch32/LittleEndian，Mutex36字节，padding只有[2,4)。不得新增信任假设。

OS annotation适配：允许按证明需要新增/修正body中的by local、call where、branch-control、普通Inv/multi-inv等合法QCP注解；范围事实、调用前提仍需证明，不准加无据假设或遗漏路径/资源，不改可执行C算法。宏/dispatch/调试适配已经审阅，见c-analysis.md。未填proof-local注解不是要求修改冻结函数contract。

三条路径：malloc失败锁外返回-5；ID失败返回未知值insert_ready，保留private remainder，解锁后free原基址；成功初始化pend、自定义字段并发布到管理DLL，重建os_inv后Unlock并返回最小空闲ID。IdInsertObj失败不保证“满”，不能增加该保证。库中的byte转换、初始化和发布等Prop只是待证义务，不可作为已证明lemma使用。优先复用根SemaphoreInv已有转换引理和通用ID/DLL库，不猜测语法。

source-errors.md记录七项其他mutex操作问题，其中删除竞争可能破坏真实共享堆。创建证明使用已有Lock交出有效os_inv的模块化边界；不能据此宣称任意并发环境或整个mutex模块正确。若发现目标闭包中的新源码错误，立即向main报告位置、触发、证据、影响，不只写入文件。

环境：tools/rocq/toolchain.json的pv-bench-8.20.1与现有QCP依赖匹配；已有qcp-smoke-20261101-r4和rocq-interactive-20261101-r4成功记录、核心二进制hash一致。当前Rocq MCP连接可响应diag；owner实际交互仍须使用MCP，不用批量编译替代要求的交互证明。入口技能为QCP verification-orchestrator，main只按controller action推进至done或明确blocker。
