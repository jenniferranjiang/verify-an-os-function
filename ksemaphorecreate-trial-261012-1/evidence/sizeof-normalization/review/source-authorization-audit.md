本轮来源及授权边界审计认为：仅将 `_SemaphoreCreate` 的 x_malloc 第一个实参与 memset 第三个实参中非VLA的 `sizeof(struct Semaphore)` 精确归一为 `(x_size_t)32`，保持本次固定配置下的C行为，属于可继续准备和独立审阅的修复。此处不是最终candidate review-passed；尚须核验冻结候选、差异、检查脚本及负例。

原始权威 `kernel/thread/semaphore.c:39,43` 在这两个调用位置使用完整 `struct Semaphore` 类型；`xs_sem.h` 中该结构没有可变长度成员。sizeof该类型为编译期常量，不求值对象，没有load/store或observable side effect。原权威 `xs_base.h:65–71` 定义x_size_t为unsigned long；已批准切片header将其等价归一为unsigned int，固定ILP32下二者均4字节。32在原型参数类型中均精确可表示；使用显式 `(x_size_t)32` 也明确保留转换后的实际参数值。因此malloc分配量和memset零化量相同，调用目标、其他实参、返回值、路径、释放、critical/IRQ及frame均不需要改变。该判断不基于VC数量下降。

2026-10-16独立重新hash当前权威47个source/config输入，全部与source-r2 manifest匹配，生成config hash也匹配既有记录。原本trial source-abi.c包含Semaphore=32、所有字段offset、x_size_t=4/unsigned等静态断言；source-check-result.json记录实际ARM GCC以Cortex-M3/Thumb编译成功，保存的source-abi.s明确标出cortex-m3、armv7-m。原probe/header/config与源码身份未变，沿用的是这个已绑定ARM证据。当前临时ARM GCC路径和PATH上的ARM GCC/clang都不存在，不声称新的ARM编译。独立native gcc -m32重新编译权威header的完整ABI静态断言通过；另对切片header做sizeof常量性、原/归一参数转换后32相等的静态断言通过。证据见 source-audit.json、native-constant-checks.json；后者说明是native ILP32。reviewer自己的probe曾因相对include多一层失败，修正路径后通过，不涉及正式源码。

授权解释应保持准确。用户第三、六节明确固定32-byte布局及功能目标；第七节要求归一保留实参/行为并绑定source/config，其列举未逐字出现sizeof constant folding。主skill的单函数提取归一规则使用“例如”，并要求有来源的等价与逐项review；用户第八节进一步明确允许proof暴露问题后回退修复、保持第五/六节语义、重新独立review后自动接受。本次可依该语义保持修复授权推进，不应声称用户逐字指定了这条新写法。两处编译期常量求值未替换算法或增加第七trusted，也不需要新的Require、trusted保证或布局公理。若候选越过这两个位置或改变任一真实行为，仍须阻止并重新归因。

本次精确失败是 `proof_of__SemaphoreCreate_partial_solve_wit_1_pure` 与 `_wit_2_pure`，它们要求没有前提支持的opaque alias-size=32。该接口诊断不等于C中sizeof值错误，也不把同名unsuffixed pure→aux蕴含一并判false。归一将已知源常量交给前端，而非给Rocq增加未经证明的ABI等式。正式候选必须保留所有generated goal，交原controller重新生成并检查实际义务。

后续独立检查要求：只出现上述两处替换且各一次；所有contract、trusted集合及其他C tokens/路径不变；source等价checker按调用位置和数量精确限制，不用宽泛sizeof文本替换把错误候选归一掉；负例至少拒绝31/64、缺失归一、额外位置修改。冻结manifest后才给正式spec verdict。此审计未修改formal/canonical/controller/accepted记录，没有启动QCP或访问其他trial。
