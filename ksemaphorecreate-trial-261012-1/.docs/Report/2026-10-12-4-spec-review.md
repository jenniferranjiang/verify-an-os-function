本轮独立 spec delta review 结论为 **review-passed**。新 predicate 已补齐完整对象及静态 bucket 的地址有效性来源，现有函数契约无需增加额外 caller 条件即可保持原行为目标；失败释放、成功发布和临界区返还的接口闭合。没有剩余 spec blocker。按用户第八节一次性授权可以接受本 revision 并恢复原 controller；这不表示现有 annotation 或实际 VC 已经完成证明。

审阅绑定 **spec-r5-480669e8557a**，11文件 `evidence/spec-annotated-manifest.json` 的 canonical JSON digest 为 **480669e8557a5f09a7683b69c5de2b087857f93649ef9c6729096df1c6a8b3cf**；快照为 `evidence/nonzero-activation/frozen-annotated_C/`。唯一 predicate 为已独立通过且已激活的 **predicate-nonzero-candidate-fe8c4261db5c**，21文件manifest SHA-256 **fe8c4261db5cff754395f3d9038769b3e50420d542347262a831aa3ce6a422b3**。predicate结论见 [本轮独立predicate review](2026-10-12-6-predicate-review.md)，设计见 `2026-10-12-6-predicate-design.md`；本记录是后续单独spec结论。源码仍为source-r2-0c50c37013e9，配置为Cortex-M3 ILP32 little-endian、非SMP。spec作者为 `spec_author`，局部实施注解来自各controller owner；reviewer为 `nonzero_source_review`，未参与这些产物的撰写。

**Delta及scope。** 独立逐项核对manifest与active文件、predicate与已接受manifest。相对本trial中r4冻结切片，只有AllocId、CriticalAreaLock、CriticalAreaUnLock、InsertObj四文件变化，全部属于局部Extern、Assert/Inv/Given及调用处where调整。九个canonical及所有caller-local With/Require/Ensure逐字不变；去注释后全部可执行C tokens一致，两份header逐字不变。新spec revision真实语义变化来自绑定的predicate，不把“contract文字未变”当作语义未变的证明。

从KSemaphoreCreate的真实body calls独立遍历仍得到九个唯一active body和恰好六个trusted symbol。非trusted为KSemaphoreCreate、_SemaphoreCreate、CriticalAreaLock、CriticalAreaUnLock、IdInsertObj、AllocId、InsertObj、InitDoubleLinkList、DoubleLinkListInsertNodeAfter。trusted恰为x_malloc、memset、x_free、DisableLocalInterrupt、EnableLocalInterrupt、KPrintf。每个真实callee都有完整caller-local契约，非trusted与其canonical逐字相同；没有集中spec header、裸API、隐藏body、未解析dispatch或第七trusted。done dispatch、空debug、常量死logging、IRQ宏、固定四参数KPrintf、x_size_t及拆句归一仍沿用已批准且source/config对应不变的版本。

独立source/config审计确认47份权威输入hash不变；main本轮source/spec检查重新对九个body执行批准归一后的逐token匹配并通过，独立delta检查又确认当前C与r4的可执行tokens不变。当前gcc -m32语法和layout检查独立exit0。物理header与权威输入未变，继续采用已绑定的Cortex-M3实际编译ABI证据；没有把本轮native ILP32检查称作新ARM编译。

**Require/Ensure及路径。** AllocId的manager表示仍完整拥有字段、bitmap与全部bucket。新增bucket纯metadata作为未写frame随两条bitmap扫描保存。成功仍只置首个空闲合法ID的位并返回allocated-unlinked；全满或末尾超出id_max时返回-1并保留manager，未改变ID选择或失败定义。

IdInsertObj在AllocId失败前尚未写idnode，失败Ensure保留old_id/previous/next及其detached资源；成功先写同一节点id再交给InsertObj。新detached表示携带IdNode及link非零，与真实完整对象域一致。InsertObj从allocated-unlinked manager选择同一模桶，BSS分支初始化同一bucket，自环/已初始化分支均把新节点转交manager。两条link原语仍只描述其直接读写的最小shape，callee Require没有新增无依据条件。容器层canonical继续使用具名manager/detached表示，没有把数组/指针细节沿API传播。

_SemaphoreCreate及外层KSemaphoreCreate保持三类结果：malloc失败在进入临界区前返回-5并保留原outside；ID失败返回-5、保持current semaphore状态、消费完整零私有对象，再正确退出临界区；成功返回current状态中首个空闲ID，value为val、pending为空、manager/bitmap/bucket/registry一致发布。失败路径用predicate阶段已检查的zeroed split/rejoin精确恢复value、pending、registry、ID和padding，交给x_free；没有只保留字段子集却声称已释放完整对象。成功后ID归manager、registry link归registry、pending和value/padding归body，task及完整scheduler通过既定Guarantee保持。

新metadata从x_malloc成功的完整32-byte对象起携带，memset保持同一地址信息并完成原零化，x_free只消费完整zeroed-private；NULL/emp、size=32、value=0、返回dest及ownership transfer不变。它是对用户已批准typed-object语义的表示修正，不是旧raw store推导出的事实，也没有把额外layout等式加入trusted契约。两IRQ trusted接口的handler、Rely/Guarantee、outside/inside转换和资源取得/交还未变；KPrintf仍emp到emp。本轮没有新增用户公理、trusted guarantee或Require的实际C对象调用域限制。

CriticalAreaLock/UnLock继续只更新实际uint16 nest单元并保留同一SemaphoreCriticalFrame；新semaphore表示随frame保存。公开create/lock入口仍明确要求用户已批准的 `nest < 65535`，current计数受Rely保持，支持0及普通嵌套1，也允许65534进入内部65535；Unlock的0不写与正值减一两路都保留。没有恢复更强的非嵌套限制，也未声称入口65535可往返。IRQ handler栈与物理nest不混淆，borrow/return同一caller prefix和invariant，所有有限返回恢复对应outside。

原NULL_PARAM_CHECK的打印与无限循环仍保留在真实body；所审计helper契约明确要求非零，所以这些分支在其批准调用域不可达，局部False invariant不删除C路径或掩盖域内可达阻塞。位扫描有限路径、malloc失败、ID失败和成功路径均未删除或弱化。调用者只把callee contract当作后续需证明的接口，本review不把callee状态冒充verified。

**机器与接口证据。** 独立脚本 `evidence/nonzero-review/spec_independent_checks.py` 及结果 `spec-independent-checks.json` 保存11文件绑定、四文件delta、契约逐字比较、C tokens、完整9+6遍历及gcc检查；注解diff见 `spec-annotation-delta.patch`，本批机械检查耗时0.046秒。predicate阶段的独立22文件编译已通过；激活后main的21个正式源全量重编再次全部通过，见 `evidence/predicate-recheck.json`。本轮 `evidence/spec-interface-check.json` 使用指定现代coqc及唯一32位小端路径，绑定同一predicate/spec/header/project hashes，35个Extern、12个复合项和默认OS assertion carrier检查exit0。没有并发重编active文件，没有启动QCP parser/symbolic、生成VC或改proof。

**实施边界。** DCHG-20261012-03的predicate/spec设计缺口在本次独立两轮review后闭合；历史r5 predicate与r4 spec invalidated记录仍保留。当前InsertObj的前两处局部Assert尚未显式传播新detached link非零事实，原annotation owner必须在恢复后利用已接受predicate修正并重新检查三条实际失败VC。这属于局部实施工作，不要求再加强canonical Require；本review不声称原三VC已解决，也不允许跳过它们。后续所有受影响函数的VC/proof/goal-check及final integrity必须绑定新revision，旧成功机器结果不得直接当成新revision证明。
