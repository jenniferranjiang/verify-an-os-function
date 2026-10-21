DCHG-20261016-01：固定结构体 sizeof 的编译期归一

当前 _SemaphoreCreate 有两个无法由已批准前提推出的尺寸义务，spec-r5-480669e8557a 的受影响实现依据标记为 invalidated，暂停相关证明并回到切片归一审阅。predicate-nonzero-candidate-fe8c4261db5c 不变且仍为 review-passed；没有权威 C 缺陷证据。

独立 VC checker 的精确目标为 proof_of__SemaphoreCreate_partial_solve_wit_1_pure 与 proof_of__SemaphoreCreate_partial_solve_wit_2_pure，分别来自 x_malloc 与 memset 的 size=32 契约。官方 CNotation.v 把 sizeof("Semaphore") 解释为抽象 sizeof_alias_type；取该参数为64可保持当前前提而使结论为假。此论证不把对应 pure -> aux 蕴含整体判为假。原报告和生成义务保留在当前 trial 的 SemaphoreCreate-20261012131015 / _SemaphoreCreate-vc-checking-r1 中。

拟议修复只将这两个调用实参的非VLA sizeof(struct Semaphore) 按固定 Cortex-M3 ILP32 布局作精确编译期常量归一。权威源码、源编译期布局断言及已保存的真实ARM编译证据均确认值为32；sizeof该固定结构体没有求值副作用。必须独立检查实参类型转换、调用参数值、全部路径和副作用相同，并把新增归一纳入 source/spec 等价检查。不得新增 sizeof 公理、Require、trusted symbol，或编辑 generated goal 以删除义务。

用户第三、六节明确批准32字节布局，第七节允许skill支持且有源码/config依据的必要等价切片归一，第八节授权语义保持修复经独立审阅后自动接受。第七节未逐字列出sizeof常量折叠；主skill的单函数等价提取归一采用举例规则。这里结合第八节语义保持修复授权，将固定、无副作用的编译期常量求值视作同一C行为的提取归一，不能声称用户逐字批准了新写法。该判断须由独立 reviewer 核验，不能仅靠消除VC失败来接受。若检查发现实质改变已批准语义，则仍按第十四节请求明确决定。

候选须在 evidence/sizeof-normalization 内准备、绑定新 annotated manifest，并完成单独 spec delta review 后才能激活。旧输入快照已保存为该目录的 before-*；当前 canonical 尚未改写。原七个done结果保持其真实绑定，不把它们自动变成新修订证明。恢复后由原controller annotation-r2、独立VC检查与proof/final流程验证新义务；controller依其修订绑定规则处理既有完成结果。

当前状态：上述两处精确归一已由独立 spec/source delta review-passed，见 ../2026-10-16-1-spec-review.md；按用户既有授权接受 spec-r6-ae22a04e2c95 并激活三个审阅文件，active source/spec checker重跑得到相同manifest。predicate及真实源码不变。另有两个继承的body注解接口错误 IMPL-20261016-BODY-01/02，仍须原annotation owner修复并经controller实际编译；不宣称原sizeof VC或整个函数已验证。

后续接口检查：原 annotation owner 已在 r2 修复上述两个 body 问题。独立 VC-checking-r2 的实际 controller coq-debug 以 exit 0/status passed 完成，当前 56 个主/拆分目标均成功加载；两项接口问题在实际目标类型检查层面关闭。43 个主 VC 的证明仍须后续分组与 final-check 完成。

最终状态（2026-10-16）：本决定已落实到当前接受的 predicate/spec revisions，完整九函数闭包已重验，全部机器终检通过；当前结论与边界见 [final integrity](../2026-10-16-1-final-integrity.md)。本记录所述原诊断保留，不改变权威源码。
