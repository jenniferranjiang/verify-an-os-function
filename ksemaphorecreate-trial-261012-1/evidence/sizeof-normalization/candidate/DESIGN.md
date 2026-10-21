本候选已完成作者检查，等待独立 spec delta review。改动把两处固定结构体的编译期大小直接写为已确认的参数值；不宣称 VC 或实现证明已通过。对应 DCHG-20261016-01。

候选为 spec-r6-ae22a04e2c95，11 文件 annotated manifest 为 ae22a04e2c951be960fddd724fae8d23a5f2034b8f65765318472ff549c79e18。source 仍为 source-r2-0c50c37013e9；predicate 仍为 review-passed predicate-nonzero-candidate-fe8c4261db5c，21 个 formal source hash 均匹配，未修改或重编译 formal 文件。

唯一 C 改动在 annotated_C/src/_SemaphoreCreate.c 的 x_malloc 第1实参与 memset 第3实参，各将 sizeof(struct Semaphore) 改为 (x_size_t)32。struct Semaphore 是完整的固定结构体，没有 VLA；sizeof 不求值任何运行时表达式，不产生读写或其他副作用。源 x_malloc 参数为 x_size_t（unsigned long）；源 memset 参数为标准 size_t。sizeof 的结果先求得32，再按各自形参类型传入。切片原有 x_size_t 是已经批准的 unsigned int 归一；32 在上述所有目标无符号32位类型中均精确可表示，参数值和调用表示保持，cast 明确保留切片参数类型。无参数、函数签名、调用次数、分支、返回、ownership 或 IRQ 行为变化。

47 个权威源/config hash 已重核；当前重新预处理四个权威 TU 后，全部9个函数体与既有源码提取逐字相等。已有 source-abi.c 对 Cortex-M3 ILP32 的 Semaphore 大小32、对齐4、字段与嵌套字段 offsets 作静态断言；source-check-result.json 和 source-abi.s 是本 trial 的原真实 ARM 编译结果。临时 ARM 编译器当前不存在，本次明确复用这组源hash和配置均未变化的证据，不声称新 ARM 编译。新增 gcc -m32 检查分别覆盖源和切片布局、无符号性、sizeof结果类型及值32的转换等价。宿主缺少32位 libc string.h 依赖，故不以宿主重编译 memset 标准声明作为证据；实际源 TU 预处理声明保存在 evidence/current-memset-prototype.txt，新的类型探针没有伪造替代声明。

从 KSemaphoreCreate 重扫得到9个非trusted与用户批准的6个trusted，所有真实调用都有完整 API，caller contract 与 canonical contract 字节一致。与 before-annotated_C 比较，全部 canonical/caller contract、proof-local 注解（含 Basics.const、节点约束）、两个 headers 与其余8个 C 文件均逐字不变。两个32参数之外整个快照逐字不变。因此现有三条返回路径、任务/调度器 frame、临界区和失败释放义务均保留。没有新增 Require、Ensure、trusted、opaque definition 或布局公理。

候选 evidence/spec-check.py 是可供激活的最小更新：新增隔离输入/输出路径环境参数；revision 编号6；固定当前 source/ABI hash；仅在权威 _SemaphoreCreate 的两条完整调用 token 模式上各匹配一次并作定向归一。候选 tokens 从不消除 sizeof，也不把任意大小或类型映射为32。已有其他归一不变。7个负例（31、64、各处保留sizeof、另一类型sizeof、额外sizeof、另一个函数的可执行改动）均被实际 checker 拒绝。evidence/spec-extraction.json 记录相应两处映射。

复现：先运行 evidence/validate-candidate.py；再以 SPEC_TRIAL_EVIDENCE 指向 trial/evidence、SPEC_ANNOTATED_ROOT 指向本候选 annotated_C、SPEC_OUTPUT_DIR 指向本候选 evidence 运行 evidence/spec-check.py。evidence/candidate-validation.json、spec-check-result.json、annotated.diff 和 checker.diff 保存检查及差异。此目录尚未激活；独立 reviewer 通过后由 main 激活、重绑 revision，再由既有 controller 重新生成并检查受影响义务。作者未调用 QCP/controller，未编辑 active annotated_C、active checker、accepted-revisions、owner 计划或报告。
