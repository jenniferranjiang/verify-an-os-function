> 2026-10-21 更新：用户已要求移除中断状态建模。以下为修改前 r1 的历史记录，其中审阅通过和检查结论不适用于当前版本。当前修改及检查见 [DCHG-20261021-01](design-changes/2026-10-21-1-remove-irq-state.md)。

# 独立 Predicate Review

结论：**review-passed**。

固定 revision：`predicate-r1-8a944cddeb13`。完整 SHA256：`8a944cddeb13c9ec07474185e09cfd8bd8f592e849e9a7d79afd50dcc2b14ff1`。正式文件清单以 `checks/predicate-r1-manifest.json` 为准；独立逐项计算29个源/配置文件的SHA256，全部匹配。

Reviewer：C analysis agent，与 predicate 作者分离。阅读当前权威 C 与指定配置、本轮 source-analysis、完整 predicate guide/experience、正式 `.v` 与设计报告；未读取历史trial。审阅仅针对设计，不表示 C 实现已验证。

## 编译与依赖核查

检查 `checks/predicate-compile.log` 最终成功状态，28个本trial `.v` 均存在晚于对应源文件的编译产物。早期报错均已有后续成功编译，不把失败日志误作最终结果。配置只映射当前trial、当前共享库/vendor及QCP依赖，不引用历史trial。主agent另完成 `checks/SpecVocabulary.v` 的实际类型检查，41个正式接口可解析。

逐文件与当前共享库比较，除 `CrtosGlobState`、`CrtosRules`、`CrtosInv` 外，17个既有候选完全等同于原文件的namespace改写；没有隐蔽语义修改。`SemaphoreState`、`SemaphoreInv` 与函数程序是新增设计。五个trial MonadLib依赖逐字等于当前根vendor/QCP源；safeExec确为已有库定义。去注释扫描全部本trial正式 `.v`，无新增 Axiom、Parameter、Admitted 或 admit。当前共享基础库既有假设未被声称为本次新证明。

## 与实际源码一致的结论

- ABI按真实header的ILP32静态断言通过：Semaphore32字节，IdNode12字节，双链节点8字节。审阅明确承认GCC `-m32` 是简单自然对齐结构的布局替代核对，不声称运行ARM交叉编译器。统一store carrier为Arch32 LittleEndian。
- 完整私有对象的32字节归属闭合：ID字段2、ID link8、value2、pend head8、global link8、padding4。QCP `CommonAssertion.v:761` 当前 `struct_padding=emp`，显式padding没有与自动资源重复。Raw所有字段未知但有ownership，Zero全部清零；失败尚未修改这些字节，完整资源足以交给批准的x_free契约。
- 发布后ID manager唯一拥有ID字段和ID links；global DLL拥有global links，其payload拥有value、padding、pend head及等待sched links。等待任务描述符仍由task_inv唯一持有。空DLL时head与next可相等，cut按不同字段分离，未添加错误的非别名条件。
- Semaphore状态保存对象与等待任务地址顺序；ID bitmap和每桶内容从对象序列派生。源码create在ID桶和global list均头插、delete两处摘同一对象，故过滤global顺序得到hash顺序有源码依据。零桶与初始化空桶均由复用的store_idbucket覆盖，不要求预先初始化全部桶。
- 新建对象value取实参、pend为空；旧对象允许非空等待链。全局sched ownership计数加入semaphore waiters，并复用pure_suspend_sched_link关联真实TaskDescriptor状态。没有为创建方便把旧对象/等待链清空，也没有重复task字段ownership。
- 统一临界区仍只有一份QCP CriticalSTS/token；没有semaphore专用STS或伪硬件emp token。Outside对应尚未进入该协议且无其token，实际PRIMASK允许0或1；Inside保存入口mask、实际已关闭。CriticalNest单独持有真实uint16计数单元，外层进入路径0→1、退出1→0。资源转移及硬件解释由已批准Disable/Enable契约连接，其他非trusted函数仍需后续证明。
- Crtos_RTrans/LastSeen允许锁前环境改变共享状态，保持保存的mask，不偷换为入口状态不变。replace_semaphores只改semaphore分量，所有旧模块、waiting task map、mask逐项保留；其他既有更新补充保存新分量。
- 抽象程序覆盖malloc提前失败（无加锁观察）、ID满失败（锁内状态不变）、最小空闲ID成功发布。没有凭空增加容量未满、IRQ开启或task-context前提。成功p存在量化且未发布，实际freshness/有效地址来自分离对象ownership。纯程序不额外限定完整机器地址范围是可接受的地址抽象；它不作为独立内存权限，外层解锁后状态集合也不把私有地址ownership返还调用者。
- 初始化接口列出真实BSS bitmap、零pointer桶、manager常量和静态自环头，无新启动token。ID先入桶而对象尚未完成发布的阶段由既有allocated-unlinked manager、AssignedIdNode和局部剩余字段描述，允许在临界区内暂时不折叠稳定系统不变量；无提前释放已发布对象的路径。

`SemaphoreLayout` 是明确列出的布局义务，尚非已证引理；对应C侧布局已检查，后续证明若使用Rocq布局等式仍须由前端元数据/合法推导提供。此点不被用作公理跳过设计检查。

没有需要修复的predicate设计阻塞项。可直接在此revision上开展完整调用闭包spec review。此结论不授权symbolic、VC、verification-orchestrator或C实现证明。
