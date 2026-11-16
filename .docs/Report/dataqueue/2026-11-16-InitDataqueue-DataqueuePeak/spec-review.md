> 本文保留迁移前设计审阅的依据与结论。路径已更新为全局位置；原revision/hash指迁移前输入，不能直接作为当前全局编译或实现证明结论。当前整合情况见 [设计说明](design.md) 与 [整合检查](integration-review.md)。

# Dataqueue native spec 独立审阅

**review-passed**。审阅者为main agent，非spec作者；日期2026-11-16。此结论针对当前输入重新核对，不继承已撤回方案的通过结论。

Predicate：`dq-predicate-native-20261116-r1`，29份lib联合SHA-256 `36ddb2be676b077b06232a36527fa967dd248a4f6a1c082dc1fa9e62958e8842`，已独立通过，见 [predicate-review.md](predicate-review.md)。Spec：`dq-spec-native-20261116-r1`，7份canonical C及2份header，联合SHA-256 `b48685d3abfd9b3359121464f6511b23876519e718b0180671d9719ad89aa67f`。算法为C路径排序后接header路径排序，拼接“trial相对路径 空格 文件SHA-256 换行”再取SHA-256。

## 范围与依赖

Init调用闭包保留Init、DeInit及四个Semaphore函数；用户另行指定Peak。七份文件各有唯一真实body和canonical契约。八个已有spec只在caller声明，来源与条件性见 [spec-design.md](design.md)，不因证明缺失或模型差异扩大body范围，不自动标为trusted。五组本轮caller-local与canonical契约规范化后相同，共享NULL/Lock/Unlock契约一致，每个实际调用都有完整声明端spec。

_SemaphoreCreate的memset初始化sem->link两个字段，ID与pending-list初始化只触及各自资源，因而已有typed InsertAfter前置可由frame建立。InitDoubleLinkList、Empty、Rm及ID接口采用既有资源语义。LinklistResumeAll保留完整IC接口和native效果；empty-pending令该分支不可达，新增queue保持义务已显式陈述，未当作完成证明。

## 路径、ownership与frame

Init从完整私有结构开始，不排除n=0或1。成功发布结构和完整数组至os_inv，不重复返还私有资源；槽仍可未知，payload不归queue所有。n=0由当前分配器模型失败，n=1允许成功。三类失败保持真实解锁后IRQ重新进入的窗口，回滚返回-1，ID对为(-1,-1)、(-5,-1)、(-1,-5)。DeInit的init_cleanup只描述未发布对象回滚，保留原负ID与其余字段，不声称通用并发销毁。四份Semaphore IC契约保留分配、ID失败、负ID及查询失败分支。

Peak的完整说明见 [dataqueue-peak-spec.md](design.md)。入口以C指针定位共享对象；读权限来自锁内os_inv，非空front槽Some来自ready关系。空路径返回-1并保持两个输出槽原option表示；非空返回0并写入同次观察的队首指针和长度。None输出允许未初始化存储，Some保留已知旧值；两个输出槽独立拥有且与系统资源分离。不要求payload所有权，不修改front/rear、数组或semaphore。锁内效果保持整个OS状态，外层允许加锁前环境变化，未把入口和出口状态错误等同。两出口都恢复同一次lock保存值。

所有共享访问采用同一native Assertion与临界区协议；字段、padding、数组missing_i及归还资源的待证陈述已纳入predicate审阅。公开spec没有另造模型或忽略未触达资源。

## 检查及结论限制

沿用本阶段29份Rocq类型检查、header符号及native类型检查和7份ILP32 GCC语法检查。main核对原六份C逐字不变；Peak仅新增注解及既定NULL/调试适配，有效body与批准副本一致。Peak未新增semaphore调用。全局formal源码hash与阶段前一致；原源码及批准修复、IRQ授权保持。

默认白名单001适用于cleanup与Peak观察条件；宽松Rely下非真空性不作为blocker，也不声称可满足性已证明。该例外不增加信任、不免除后续VC。保存地址/ID不构成ABA世代保证。

没有已知设计blocker。此结论仅为设计审阅通过；未运行QCP注解parser、symbolic、VC、实现证明或全局统一编译。所有待证Prop及导入spec的证明条件仍有效，不能宣称依赖或完整调用链已证。本轮授权工作止于设计审阅；后续implement须按skill由用户确认两份revision后另行开展。
