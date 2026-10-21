本轮**限定 spec/source 归一 delta review 为 review-passed**：两个固定结构体尺寸实参的归一保持C行为、全部canonical契约及trusted边界，没有剩余spec设计或源码等价blocker。用户现有语义保持修复授权允许接受这一归一。独立审计另外发现两项候选继承的proof-local导入/名字解析问题，必须由原annotation owner修复；本结论不表示所有body Extern、generated goals或VC已经编译/证明通过，不能跳过这些失败。

对象为冻结候选 `evidence/sizeof-normalization/candidate/`，**spec-r6-ae22a04e2c95**。11文件annotated manifest的canonical JSON digest为 **ae22a04e2c951be960fddd724fae8d23a5f2034b8f65765318472ff549c79e18**；`evidence/delivery-manifest.json`文件SHA-256为 **4e7a946348b00ad00bd14b3fd54d36889f3f8748c536095b180ebae2bd5d89ad**。设计说明`DESIGN.md`绑定hash **ef2e1552f4fab0af9a7fa143ae6f3f8c0e30e551b4227067670f0ce75e9c73fe**。作者`sizeof_spec_author`，独立reviewer`nonzero_source_review`。predicate仍为已通过的predicate-nonzero-candidate-fe8c4261db5c，manifest **fe8c4261db5cff754395f3d9038769b3e50420d542347262a831aa3ce6a422b3**，21文件无变化；本轮不重新审阅未变predicate。设计变更为 [DCHG-20261016-01](design-changes/2026-10-16-1-sizeof-normalization.md)。

**来源及授权。** 权威`kernel/thread/semaphore.c:39,43`的两处操作数都是完整、非VLA的`struct Semaphore`，类型内无运行时求值表达式。已固定Cortex-M3 ILP32布局使其sizeof为32。x_malloc原形参x_size_t为unsigned long，memset原形参为标准size_t；切片已有经批准的x_size_t=unsigned int归一。32在这些目标无符号32位类型中均精确可表示。原sizeof结果按原型转换后，与新`(x_size_t)32`经相同调用原型转换后的值和ABI表示一致。没有读取对象、参数求值副作用、额外call或不同分配/零化字节数；其他实参、调用目标和返回值完全不动。

独立重核47个权威source/config hash全部匹配source-r2-0c50c37013e9；重新预处理四个真实TU，九个函数体与本trial保存的当前source提取逐字一致。原source-abi.c含Semaphore大小32/对齐4/全部相关offset、x_size_t宽度与无符号性断言；source-check-result.json记录真实ARM GCC成功，source-abi.s明确标Cortex-M3 ARMv7-M。当前ARM编译器缺失，本轮没有fresh ARM编译。对未变source/config复用这组已绑定证据，另独立运行native gcc -m32的源/切片类型及布局断言，全部成功。源TU预处理的memset声明用于确认标准size_t形参，不能把宿主预处理中的size_t具体宽度误称为目标ABI；目标宽度由已绑定目标证据及本轮ILP32检查分别说明。

用户第三、六节已固定32-byte语义；第七节要求每项提取归一保持实参、路径及副作用并有source/config依据。该节没有逐字列出sizeof constant folding，因此不作这种声称。主skill的单函数等价提取规则为举例说明，用户第八节又明确允许保持第五/六节目标的修复经独立review后自动接受。本次精确编译期常量求值符合这个边界，不改变算法、调用域、可观察行为或trust。完整先行依据见 `evidence/sizeof-normalization/review/source-authorization-audit.md`。

**精确差异与scope。** reviewer逐字从before快照构造“仅替换x_malloc第1实参与memset第3实参、各一次”的期望文本，再与候选11文件比较。完全一致：唯一变化是`_SemaphoreCreate.c`这两个表达式，其余8个C文件、2个header及全部comments/contract/body注解逐字不变，active仍与before一致。所有canonical/caller-local契约完整且相互一致，闭包仍为九个非trusted与六个批准trusted；没有新增或隐藏callee。malloc失败、ID失败释放、成功发布三路及所有有限返回outside均保留，value/pending/manager/registry效果、task/scheduler frame、IRQ/临界协议和已批准nest<65535域不变。x_malloc、memset的Require仍要求32，free仍消费同一完整零私有对象，另两IRQ和KPrintf契约亦未动。

**检查脚本与提取记录。** 候选`evidence/spec-check.py` SHA-256 **4552ac330b87264a5cc32851b9d7bbc7600e42eb0d9e00cb33867ff4605d139b**。reviewer检查其全部diff：新逻辑只在authoritative `_SemaphoreCreate` 的两个完整调用token模式上各匹配一次，再作32归一；candidate不做这条归一。不存在把任意sizeof、任意数字或其他函数表达式一并擦除的规则。新增隔离路径参数、revision编号及固定source/ABI hash guards不改变已有契约比较要求。`spec-extraction.json` SHA-256 **cee093ce8f9b66d4342d054cd79fee0915ae890d45fcd186bb8e9c54355ee5ea**，明确记载两处callee/实参编号/数量、源表达式、新表达式、类型转换、ABI与guard。其旧body hash字段由body_hash_note明确标成extraction-time历史证据；本轮当前文本身份由11文件manifest、精确diff与新的token检查绑定，不把旧normalized_function_sha256当作新body hash。

独立运行实际候选checker时仅使用reviewer的隔离工作副本和输出目录，没有执行会写候选目录的作者validator。正例通过并生成同一manifest；12个实际错误候选全部以source token mismatch拒绝：31、64、两处分别保留sizeof、另类型sizeof、额外sizeof、另一个函数改动、memset错误value、错误dest、尺寸实参增加副作用、value赋值改动及额外memset调用。检查范围大于作者7负例，说明新增归一未掩盖这些实际C变化。四TU重提取、源/切片类型检查、正例及12负例机械耗时 **4.384秒**，见 `evidence/sizeof-normalization/review/check-candidate.py`、`independent-candidate-checks.json`和`independent-work/evidence/spec-check-result.json`。执行前后所有delivery hashes一致。

**body接口审计的未完成实施事项。** 这些注解由先前controller annotation轮引入，此size候选逐字保留；它们不在canonical Require/Ensure中，故不改变本轮归一及spec语义结论，但阻塞后续实现的完整Rocq检查：

- **IMPL-20261016-BODY-01**：精确复制当前generated goal的preamble到reviewer probe，`Require Import Coq.Program.Basics`触发`_ ∘ _`记号level12/40冲突。证据`exact-preamble-check.json`，不是一个通过的body接口检查。
- **IMPL-20261016-BODY-02**：body声明及generated goal使用裸`data`/`ptr`；已冻结dll_abs真正提供getData/getPtr以及`x.(data)`/`x.(ptr)`记号，没有这两个裸函数。最小probe在Check data失败。仅在诊断副本避免Basics Import后，两个Fail Check确认名字缺失，而getData/getPtr、Basics.const和List.map的期望类型成立。证据`body-extern-check.json`、`body-interface-diagnosis.json`。

诊断证明`Basics.const store_semaphore_body`按定义只忽略额外link地址，没有制造新的payload保证；map/data及逐节点link约束仍须从registry的真实mapped nodes导出。诊断副本的成功不是候选body已修复，也没有创建alias、公理或改动generated文件。完整问题和最小修复方向见 `evidence/sizeof-normalization/review/body-interface-issues.md`；必须随本轮handoff交回原annotation owner，用真实已存在projection、无冲突导入修正，再由原controller生成和检查。

**结果边界。** 此修复没有证明Rocq抽象`sizeof_alias_type "Semaphore" = 32`；没有新增布局Axiom、Parameter、Require或trusted保证。它把已检查的C编译期值精确写入切片，须由controller重新生成实际义务。原失败的精确目标仍是`proof_of__SemaphoreCreate_partial_solve_wit_1_pure`及`_wit_2_pure`；不把相应pure→aux目标一并判false，不删除原义务。此刻不宣称这些VC已经消失、已证明或全部generated goals可编译。

main可按现有授权接受限定spec归一revision，再恢复同一`_SemaphoreCreate-annotation-r2` owner，同时处理上述两项proof-local问题。_SemaphoreCreate及其transitive caller KSemaphoreCreate的结果必须绑定新修订，七个已有done case/99个parent VC仅保留其原真实绑定，后续由controller执行适用重绑和完整性检查。本review没有调用QCP/controller、改candidate/active/formal/proof或访问任何其他trial；没有C source或spec设计blocker，仍有明确列出的implementation必修项。
