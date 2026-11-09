# 审阅后共享迁移

迁移已完成；predicate/spec 的审阅语义均未变化。对应根项目编译、trial 引用类型检查、共享C结构检查和逐字对应结果全部通过，详见 [shared-migration.json](../checks/shared-migration.json)。

| 审阅快照 | 当前正式位置 |
|---|---|
| `.docs/reviewed/lib/KMutexDelete.v` | `/home/xinra/crtos/lib/KMutexDelete.v`（逐字相同，predicate-r1） |
| `.docs/reviewed/annotated_C/src/KMutexDelete.c` | 根 `annotated_C/src/KMutexDelete.c` |
| `.docs/reviewed/annotated_C/src/_MutexDelete.c` | 根 `annotated_C/src/_MutexDelete.c` |
| `.docs/reviewed/annotated_C/src/LinklistResumeAll.c` | 根 `annotated_C/src/outside_critical/LinklistResumeAll.c`（Mutex锁外场景） |
| `.docs/reviewed/annotated_C/include/{slice_types.h,logic.h}` | 根 `annotated_C/include/{mutex_delete_types.h,mutex_delete_logic.h}` |

新 C 仅改变 include 路径，逻辑头仅把本地 KMutexDeleteTrial.lib.KMutexDelete 引用切换为全局 CRTOS_Verify.lib.KMutexDelete。正式 With/Require/Ensure 与函数体未改变；未在共享头集中放函数规格。逐字归一检查确认对应关系，故无需重审语义。

原根 `annotated_C/src/LinklistResumeAll.c` 的Semaphore锁内规格及正文完全保留。两个同名函数切片按场景独立选用，不能一起链接；本次Mutex锁外合同不是原Semaphore合同的推导特化。复用的4个trial规范文件继续保留为本实验完整输入；它们的原根规格/旧证明注解不被展平切片覆盖，trial的表示和常量等价适配见reused-spec-imports.md。

根 `_CoqProject` 与 `lib/index.md` 已登记新模块，生成Makefile配置已刷新。本模块只新增删除函数定义，不改变共享状态类型、系统不变量或任何既有函数接口；没有现存反向依赖者需要重编译。使用根项目配置重新编译新 `.v`，未拿旧trial对象文件充当结果。trial的逻辑头和接口检查改用共享库；本地lib映射与旧编译产物已移除，审阅快照不参与构建。编辑器既有CRTOS_Verify.lib映射直接覆盖当前正式位置，无需新增trial映射。

A1/A2仍是调用链专用的用户假设，未写入人工TrustBase，未将具名Lock保证推广到所有调用者。权威mutex.c/linklist.c及既有CrtosInv/KEventCreate修改、旧公共头和Semaphore输入的hash保持不变。没有应用修复补丁，没有执行QCP parser/symbolic、VC或实现证明。
