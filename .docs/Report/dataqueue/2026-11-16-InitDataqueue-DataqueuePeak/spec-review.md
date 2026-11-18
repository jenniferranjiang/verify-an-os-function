> 当前恢复说明：用户已授权具体DataQueue/DataElem布局事实，已接入dataqueue_layout_abi；下文旧ABI缺失记录是历史阻塞。当前正在map版本重编译与验证，尚无新的实现完成结论。

> **2026-11-17 当前变更：** 用户已授权地址map改造，本文r1列表版本及旧Init VC适用性已invalidated；历史证据保留。当前设计与迁移检查见 [map-refactor.md](map-refactor.md)。ABI布局连接缺口仍待解决。

# 当前 Spec 审阅

> 2026-11-17：按用户要求删除Push/Pop/_SemaphoreObtain三个分析副本。下文涉及这些副本的同步与测试是删除前的历史记录；修复及适配代码保留在[source-changes.md](source-changes.md)，不表示当前仍有对应实现文件。七份canonical、lib和VC不受此次删除影响。

**review-passed（当前七函数实验的设计范围）**。日期2026-11-16，reviewer为main，非本轮C/spec同步作者。本次复查源码变化及受影响规格，不是实现证明。

Predicate固定为已独立通过的 `dq-predicate-crtoslatest-20261116-r1`，输入与hash见[predicate-review.md](predicate-review.md)。Spec revision为 `dq-spec-crtoslatest-20261116-r1`；七份canonical C按工程相对路径排序，再接两个dataqueue header按路径排序，将各项 `path sha256\n` 拼接后取SHA-256：`ac42f2c9be1295424d2e941866aa08c4c78b3a31ea0cd535d6bd986a86c985fb`。具体文件与人需重点确认的条件见[设计说明](design.md)。原native revision已被本次输入替代。

## 源码变化与契约对应

本次检查以crtoslatest `a07641a0b58469ae3ea19317cce2cf48974989bb`及当前ILP32、非SMP配置为依据。STATIC_OBJECTS和DEFER_IPC_SCHED未启用，因此生命周期检查宏为空，ON_WAKE沿用当前调度模型；不推广至其他配置。

新版NULL检查只记录诊断，不提供正常返回时非空的保证。三个Dataqueue文件已删除旧NULL模型声明与调用；访问权限仍由Init私有完整结构、DeInit cleanup对象、Peak锁内os_inv及两个独立输出槽提供，没有为此加强Require。

Delete先判断id<0或id>65535，再查表。同步后的OC抽象入口及本轮IC effect均保留非法输入直接返回、状态不变的路径；有效ID查找失败仍返回且不释放任何对象。128..65535未被错误地排除。合法命中路径的quiescent条件仍要求没有等待者且没有已发布queue引用，适用于Init失败清理，不把该接口解释为任意并发销毁。

Init的三类失败与发布成功、DeInit的未发布对象回滚、Peak空/非空两出口及资源交接均保持原设计。Init不排除n=0/1；成功交出完整对象和数组至os_inv，失败返还私有对象并保留真实负错误码。Peak同锁检查与读槽，空路径不改两个输出，非空路径写出同次观察值，不取得payload所有权。两条路径均恢复原保存值。

## 闭包与输入检查

七个canonical位置及IC切片选择方法沿用[设计说明](design.md)：Init、DeInit、Peak及Create/Delete四个Semaphore函数。本轮审阅四个Semaphore的dataqueue IC场景；当前canonical中的OC body需按既定规则去除嵌套锁并选择具名IC callee契约，不能直接把OC body宣称为IC证明。

Main逐项比较修改前后七份C及两个header的正式注解，除删除旧NULL契约外全部保持。caller-local/canonical配对及复用边界未新增或改变；移除NULL模型后没有遗留调用。ID、DLL、LinklistResumeAll仍为记录了来源的reused-spec，分配、临界区、IRQ等沿用原授权接口。Push/Pop/_Obtain仅为分析上下文，没有因此增加完整spec或实现目标。

Main重新执行源码对照：十一份已有C/header有效语句仅有规定的NULL移除和Delete范围检查变化；_Obtain逆向撤去三项已记录适配后与新版原函数逐字相同。22个实际body受控测试经main重编译并运行通过。作者的七份ILP32 GCC检查、63项header词汇和native类型检查、64份lib类型检查通过；检查范围与限制见[source-fix-review.md](source-fix-review.md)。

## 结论边界

默认白名单001仍适用，未新增信任或把待证Prop视为定理。通用OC Delete与已发布queue的生命周期兼容问题仍未解决，不在此次受限IC通过结论内。既有46份VC源码保持不变，其历史编译问题和新body所需证明均未在本轮解决；不以旧VC证明新版Delete。

本次未运行QCP parser、symbolic、生成VC或实现证明。进入实现阶段仍需用户确认上述predicate/spec revisions。当前任务所要求的源码同步和现存错误整理已完成。

2026-11-17 实现注解适配复核：Main核对两份header差异只有Extern Coq分块分隔符插入，声明未变；Init链式赋值按原求值顺序拆分，正式契约经controller冻结检查保持。原设计语义结论仍适用；当前7份C+2header摘要为 `30eaeacd0a2912c59a48f7781ccf2ce53184b2d49446688be2cad3e165daeb49`。新增断言的可证性仍待VC检查，annotation接纳不表示实现证明通过。详见design及source-changes。

本轮map改造已分别独立审阅通过：`dq-predicate-map-20261117-r1` / `dq-spec-map-20261117-r1`。64份lib依赖编译通过、.vo保留；无新实现证明。当前正式输入与检查见[map-refactor.md](map-refactor.md)。
