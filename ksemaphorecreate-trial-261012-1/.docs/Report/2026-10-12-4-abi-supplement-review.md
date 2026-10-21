当前结论为 **needs-fix；原r3 predicate review-passed的目标ABI适用性 invalidated**。指针宽度与对齐检查通过，但实际已加载的Rocq typed store使用大端字节编码，与Cortex-M3目标的小端解释不一致。单独增加QCP命令行flag不能改变既有自定义carrier和根heap谓词。此问题属于formal表示与工具配置边界，不是CRTOS权威C缺陷，也不是要求修改根共享库的证据；已找到可在新trial内推进的官方小端库路线。

## ABI-01：实际已加载heap编码与目标不一致

本补充审阅绑定此前接受的 `predicate-r3-16b6ee4a4e02`，其manifest为 `16b6ee4a4e02383dcb7128da0c57212af2e672ccd15b15633142778e8d2d629f`。受影响的是它的目标ABI解释，以及依赖它的spec/正在生成的目标VC及proof适用结论；既有Qed仍是其已加载模型内的定理，不把模型不符误说成Rocq内核拒绝证明。源/config/ARM字段布局证据和9+6调用闭包没有改变。

独立用原兼容工具链Coq8.20.1/OCaml4.14.1，从当前实际load path加载根CrtosRules及trial CrtosOSProtocol，现场Print得到：

- `Task_C_Rules.store_ptr` 与 `Crtos_C_Rules.store_ptr` 均使用 `store_4byte`，地址4字节对齐、值域0..Int.max_unsigned；指针宽度符合ILP32。
- `store_ushort` 使用2字节 `store_2byte`。
- 实际 `merge_short x1 x2 y` 规定 `y mod 65536 = (x1 mod256)*256 + (x2 mod256)`；地址较小的字节是高位。
- 实际 `merge_int x1 x2 x3 x4 y` 的权重依次是2^24、2^16、2^8、1。
- `Eval cbv in merge_short 0 1 1` 得 `1=1`；`merge_short 1 0 1` 得 `1=256`。例如sem.value=1的旧模型字节为`[0,1]`，目标小端为`[1,0]`，不是同一个实际字节谓词。

这不是根据较新`.v`猜测旧`.vo`。命令、stdin、stdout/stderr和binary/库hash全部保存于 `evidence/abi-supplement/result.json` 及 `loaded-legacy-stores.*`，复现入口为 `evidence/abi-supplement-check.py`。旧CommonAssertion的DerivedPredSig接口已经specialized，不接受当前源码中的Arch/Endian参数。现有OSHeap是保持同一memory的桥，不能在不增加正式解释的情况下把根BE heap自动视为LE heap。

此前ARM静态断言只验证真实C类型宽度、大小和offset，未验证Rocq字节编码；因此没有再次运行已通过的ARM布局编译。此前review遗漏了该模型兼容项，现明确撤销其作为最终ARM证明依据的通过状态，直至新候选修复并重审。

## driver支持与long/布局待核项

实际 `/home/xinra/qcp-binary-democases/linux-binary/symexec --help` exit0，支持 `--arch <32|64>`（默认32）、`--endian <big|little>`（默认big）、`--CRules <module>` 和 `--no-CRules`。这里只运行帮助查询，没有启动另一路symbolic execution。官方 `docs/qcp-cli.md` 进一步说明CRules选项只生成Import，不添加依赖，也不重定义用户自定义carrier。

Controller修复路线应同时固定 `--arch=32 --endian=little` 与真正采用的小端自定义Crtos rules，不能只把默认Import换成Snaive后仍混用旧根heap。配置变化须由现有controller处理并对其产物检查，不在本审阅之外另跑raw symexec。

关于x_base=long：官方C示例 `QCP_examples/LLM_bench/Engineering/glibc_slist/glibc_slist_rel/glibc_slist_iter_rel.c` 的long sum，在对应官方 `Rocq/examples/.../glibc_slist_iter_rel_goal.v` 中生成`# Int`和INT_MAX；unsigned long的mpz_add_ui示例生成`# UInt`。这提供了32位映射依据，但最终仍应核对本controller实际生成的lock/handler局部为32位Int而非Int64。不得仅凭外部ARM编译推断QCP前端映射。

Struct字段地址及sizeof由框架的eval_addr_expr/sizeof接口承接；本次只读检查不声称已核对尚未生成的全部实际VC。现有controller后续应确认malloc/memset的尺寸为32、pointer为4，以及规范切片的IdNode/IdManager/Semaphore声明与既定offset一致；不要以新增手写layout公理补齐疑点。

## 无需修改根文件的最小可行方向

已经独立成功加载官方现代库：使用 `/home/xinra/.opam/pv-bench-8.20.1/bin/coqtop`（Coq8.20.1/OCaml4.14.2），仅映射官方`Rocq/_CoqProject`中非`../_build`项到绝对路径。`Snaive_C_Rules.ptr_size_Z` 实算4，`Snaive_C_Rules.merge_short 1 0 1` 实算`1=1`；无Coq错误。完整命令与输出见 `modern-little-endian-load.*`。官方现代CommonAssertion支持 `DerivedPredSig Arch32 LittleEndian`，Store/Array/Map/String相应接口同样带Arch/Endian参数。

随后只读尝试把旧root `.vo`混装，现场报出OCaml4.14.1与4.14.2不兼容，见 `modern-root-binary-mix.stderr`。因此应建立明确隔离的trial candidate依赖闭包，而非把新旧`.vo`放在同一逻辑路径里赌摘要兼容。

建议优先路线：保留旧正式revision快照；从权威根`.v`复用实际需要的source闭包，建立明确命名空间的兼容candidate，机械调整imports及两套carrier的官方Arch32 LittleEndian实例。Pure record/状态概念沿用现有定义来源，不另起语义设计；heap实例变化必须明示、编译并独立审阅，旧根heap符号不可静默换义。可能需要的根source闭包起点为dll_abs、idnode_abs、KTaskPure、CrtosGlobState、TaskProtocolSTS、CrtosRules、dll、idnode、KTaskSchedMember，实际范围由candidate依赖检查确定。根文件及其既有`.vo`保持不变，不自动晋升candidate。

这一路线已有“小端官方模型实际可加载”的证据，尚未在本只读审阅中声称整个root兼容candidate已经编译通过。若迁移出现诊断，按当前授权在trial内修复；不能仅因其工作量较大就要求用户扩大权限或停止。

另一可能方向是正式BE编码heap到目标LE memory的表示桥或针对闭包的字节编码等价证明。但旧identity bridge不具备这种性质；一般BE→LE转换依赖每个typed字段的宽度、分区和frame，不能用一个无条件same-memory entailment替代。当前闭包仅零memset等事实有利于这种证明，却不是证明本身。相较之下，统一使用已可加载的官方LittleEndian实例更直接，应优先尝试。

通过条件：新的正式candidate和全部依赖采用一致的32位小端store解释；必要兼容修改有root/source依据且没有根库静默改动或新假设；controller实际target与rules相符；受影响predicate/spec经delta review并绑定新manifest，已受影响生成物按controller规则重建和重检。当前未发现必须修改权威C、根共享文件或用户功能目标的不可消除blocker。
