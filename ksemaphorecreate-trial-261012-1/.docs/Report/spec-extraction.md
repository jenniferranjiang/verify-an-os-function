# KSemaphoreCreate 切片与行为范围

当前为 draft，正在按 predicate PR-01 修复普通嵌套入口。用户已明确授权入口 nest<65535，并明确排除更深调用。原 r1 的非嵌套 contract 不再是待接受候选；已按作者确认的 hs/list Z 接口同步变更所有依赖的 canonical/caller contracts，已绑定编译通过的 predicate-r3-16b6ee4a4e02，并完成接口类型核对，等待该 predicate 的独立 review。尚未接受 predicate revision，尚未标记 spec review-ready。没有运行 QCP parser、symbolic、VC 或 proof。正式函数契约仅放在 annotated C，不以本报告代替。

权威输入为 `Ubiquitous/XiZi_IIoT_Macro/` 下的当前源码和 `board/stm32f103-nano/config`。每个函数的来源、行号、来源文件与函数 hash、正规化后的函数 hash 及 direct callees 保存在 `evidence/spec-extraction.json`。每个 active body 位于 `annotated_C/src/<symbol>.c`。

## 递归范围与路径

| 函数 | 直接 callees | 真实路径 |
|---|---|---|
| KSemaphoreCreate | _SemaphoreCreate | 直接转交 val，返回 callee 结果 |
| _SemaphoreCreate | x_malloc, memset, CriticalAreaLock, IdInsertObj, x_free, CriticalAreaUnLock, InitDoubleLinkList, DoubleLinkListInsertNodeAfter | malloc 失败立即 -5；ID 失败先 free 再 unlock 再 -5；成功先写 value、初始化 pend、插入 registry，再 unlock 返回 ID |
| IdInsertObj | KPrintf, AllocId, InsertObj | manager/idnode 为零时输出诊断后无限循环；分配失败保持 node 原值返回 -1；成功写 id、登记 bucket、返回 ID |
| AllocId | KPrintf | manager 为零时诊断后无限循环；找不到非满 byte 返回 -1；最后 padding 中空位超 id_max 时 -1；成功取首空位并仅置该位 |
| InsertObj | KPrintf, InitDoubleLinkList, DoubleLinkListInsertNodeAfter | manager/idnode 为零时诊断后无限循环；bucket 未初始化时先初始化；将节点插到 bucket head 后 |
| InitDoubleLinkList | 无 | 将 next 与 prev 都设为 self |
| DoubleLinkListInsertNodeAfter | 无 | 四次指针写入，顺序完全保留；空环情况下 head 与 successor 可 alias |
| CriticalAreaLock | DisableLocalInterrupt | IRQ entry 后 uint16 nest 自增，再返回 handler |
| CriticalAreaUnLock | EnableLocalInterrupt | nest >= 1 才自减，随后恢复 handler |

只有用户批准的 x_malloc、x_free、memset、DisableLocalInterrupt、EnableLocalInterrupt、KPrintf 是 trusted，不验证其 body。不把其 declaration contract 称为 verified。

## 正规化依据

- `semaphore.c:24-28` 在本 translation unit 中显式把 `KDEBUG_NOT_IN_INTERRUPT` 重定义为空；可移除 wrapper 中的空展开。
- `semaphore.c:232-238` 的 source-static done 唯一 initializer 将 SemaphoreCreate 指向 _SemaphoreCreate；当前文件没有后续赋值。`KSemaphoreCreate` 的 dispatch 可唯一解析；函数参数/返回值不变。
- `xs_kdbg.h:42` 固定 KDBG_IPC 为 0，`SYS_KDEBUG_LOG` 的两个 KPrintf 仅在 if(section) 内；删除本次 create 日志死分支不删除可达 call。
- `xs_kdbg.h:96-103` 的 NULL_PARAM_CHECK 不是空宏。切片展开 do/if/while，保留格式串、真实函数名、源调用处 __LINE__ 数值、参数名字符串，以及无限循环。KPrintf 固定四参数声明是用户批准的 variadic call-site 归一，四个实参均不变。
- `id.c` 中 AllocId、InsertObj 以及 `semaphore.c` 中 _SemaphoreCreate 的 source-static 函数在单函数文件 externalize。`IdInsertObj` 的赋值条件拆为一次赋值后一次比较，执行顺序、次数与返回路径不变。
- `config:161` 为非 SMP；`CriticalArea.c:94-140` 采用 static uint16 nest 分支。`xs_isr.h:87-88` 将 IRQ macros 分别解析为 DisableLocalInterrupt / EnableLocalInterrupt。两个切片以同名 external declaration 引用同一个真实 source-static nest，保留增减及条件。
- `crtos_semaphore_layout.h` 只声明闭包访问的真实结构与标量类型，不放 contracts 或 executable code。结构字段顺序完全来自 xs_klist.h、xs_id.h、xs_sem.h。x_size_t 从 unsigned long 归一为 unsigned int：固定 ILP32 下位宽、对齐、无符号算术及 Cortex-M3 参数 ABI 相同；x_base 保持 signed long。
- NONE 与 ENOMEMORY 来自 `xs_base.h:115,103`，分别为 0 和 5。没有复制无关源码或 headers。

## 检查与待完成项

`evidence/spec-check.py` 在当前 annotated C 上去除注解并预处理，逐 token 与 source agent 从当前权威源码得到的 function bodies 比较；只应用上列正规化。9 个 body 全部一致，每个真实 call 都有完整 declaration-only contract，非 trusted caller-local 与 canonical 注解逐字一致。重新从 KSemaphoreCreate 跟随 call 得到恰好 9 个非 trusted 和获批的 6 个 trusted。

`arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -std=gnu11 -ffreestanding -fno-builtin -Wall -Wextra -fsyntax-only` 对所有切片及 `evidence/spec-layout-check.c` 通过，确认切片在真实 Cortex-M3 目标上的 C 结构和字段布局。源码/配置权威 manifest 为 `source-r2-0c50c37013e9`；r2 补入真实 dataqueue caller，目标源码行为未改。这些是 C/token/结构检查，不是 QCP parser 或证明。

当前草案为 `spec-r2-6d54bb88379e`，annotated manifest 为 `6d54bb88379e3c791407f6c1eb19190cc66680164505922ba8a0f18f4a5ece11`，详见 `evidence/spec-annotated-manifest.json` 与 `spec-check-result.json`。机械检查耗时由脚本记录，不估计人工时间。下一步等待独立 predicate review-passed revision 后绑定该 revision，完成独立 spec review。

IdInsertObj 失败按原值返还 detached ID node，故已清零对象可完整重组后 free；成功将 ID node 移交 manager，私有 value、pending、registry link 与 padding 由 caller 完成初始化和发布。顶层 spec 显式列 malloc 失败、ID 满失败、成功三条分支；成功及 ID 失败相对于 IRQ entry 后的 current 建立效果，环境推进使用 Rely，最终交还 outside。CriticalAreaLock/UnLock 显式表达 nest increment/decrement，IRQ trusted contracts 在真实关/恢复中断边界移交同一个 OS carrier 的 token/invariant。裸字段形状只出现在两个底层链表原语的 contract，没有沿 ID/container/API 层传播。

## 本次 nested 草案修订

修订前已逐文件校验 r1 annotated manifest 并保存到 `evidence/spec-r1-snapshot/`；快照仅为本次新 trial 内的审计证据，不进入 active C scope、QCP 输入或 formal load path。原候选从未通过 spec review，本次属于草案迭代，不假称撤销既有 proof。

已变更的 contract closure 为 KSemaphoreCreate、_SemaphoreCreate、CriticalAreaLock、CriticalAreaUnLock 及其真实 IRQ declarations；ID manager/list/heap allocation 生命周期和 source-normalized body 不变。新的 caller handler 栈用于表达借用已有 invariant 和原样返还 caller 层，不能制造第二份 invariant 或允许嵌套环境改写。IRQ trusted 仍只采用用户批准的 enter/exit 语义；nested handler 与环境不推进性质必须有实际 PRIMASK 源码及协议推导，不能用新增 trusted 保证绕过。

KSemaphoreCreate、_SemaphoreCreate 与 CriticalAreaLock 的 Require 显式加入用户授权的 nest<65535；IRQ Disable 的 Require 没有额外加入这个限制，因为 IRQ 原语本身不递增 nest。hs 在进入、callee 调用和所有返回路径中原样传递，Rely 接受 hs，以便 formal protocol 表达已经屏蔽 IRQ 时的环境边界。新 IRQ declaration 除显式 caller-stack 参数外，没有增加 handler==1、current==before 或额外资源保证；检查脚本去掉 hs threading 后验证与 r1 字符串完全一致。该检查只证明 declaration 表面改动受控，不能代替新 predicate 的语义审阅。

## r3 formal 接口绑定

`evidence/spec-interface-check.py` 先核对九份正式 predicate 源文件 hash 与冻结的 `predicate-r3-16b6ee4a4e02` manifest，核对当前 annotated manifest，再按 `semaphore_logic.h` 中相同 Import 顺序生成独立 `Check` 文件。33 个 Extern Coq 名称、kind/type/arity 和 12 个 contract 中实际使用的复合逻辑项全部通过 default coqc；另检查最终 `Assertion` 确实为 `Crtos_C_Rules.expr`，不会把旧 Task assertion carrier 混作 OS carrier。结果为 `evidence/spec-interface-check.json`，完整输出在同名 `.log`。该文件只有接口检查，没有复制完整函数 contracts、定义新协议或新增证明假设。

人工核对确认：Rely 绑定 CrtosOSProtocol 中的三参数定义；Guarantee 绑定 CrtosOSPure 的两参数定义；Outside/Inside 使用同一 hs:list Z；OSHeap 的输入是 Task_C_Rules.expr，输出为当前 OS carrier；ID manager 的 pure update 参数顺序及 detached old-value 参数顺序与根库和 SemaphoreRep 一致。_SemaphoreCreate 的两个 unlock 实例分别使用 increment(current) 和 increment(publish(...,current))，没有丢失嵌套 caller 的 hs。

检查发现并修正了 header 缺少根 `idnode` 和 trial `CrtosOSInv` 的直接 Coq imports；此前单靠传递依赖无法解析 IDNode / SemaphoreOSInvariant。修改仅为 C 注释中的逻辑导入，没有改正式 predicate、C executable tokens、C 声明或函数契约。当前 annotated hash 因这两条逻辑 import 更新；此前已通过的 C/token/布局/caller-contract 检查按依赖范围复用，未无故重跑。本项不是 QCP parser/symbolic 检查，也不是 spec review-passed；predicate 独立结论尚未收到，不提前标为 review-ready。
