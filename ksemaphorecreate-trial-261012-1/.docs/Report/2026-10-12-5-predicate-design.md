候选 `predicate-r5-0a139d64743c` 已完成机器编译，当前为 **review-passed，已按用户授权接受**。它修复r4唯一复用issue，并补齐临界计数的局部资源view；不改变已批准的函数目标或canonical contract。

Manifest为 `0a139d64743cce8000b0910d7880d6c5a0bf89147b730665aa6ebefbfb45585a`，完整20源码、配置、构建记录和作者说明冻结在 `evidence/arm32le-candidate/frozen-r5-format/`。源码/config仍为 `source-r2-0c50c37013e9`，`nest<65535`域和六个trusted保持。r4设计记录中ARM32小端candidate、来源、ownership、生命周期及隔离路径的说明继续适用。

相对r4只有三个正式文件变化。`framework-candidate/NestedCriticalSTS.v` 是官方当前源码的完整逐字副本，以唯一 `CRTOS_Verify.framework` namespace编译；它解决外部缺少.vo的问题，不修改官方文件或遮盖 `SimpleC.SL`。`CrtosNestedState.v` 改为转出该官方模块，唯一兼容alias仅保留已有qualified projection名字。实际record类型身份已用reflexivity检查；本地owner-aware `CrtosIRQStep`仍为原定义，不采用官方较宽的transition。

新增 `lib/SemaphoreCriticalViews.v` 把原 invariant 拆成实际全局UShort计数单元、原有效性纯事实与唯一的 `SemaphoreCriticalFrame`。Frame精确组合原task借用字段、除nest外的完整scheduler资源和semaphore representation，没有隐藏、复制或新建heap ownership。它不依赖nest值；原invariant与该拆分双向可证。内部scheduler拆合及跨carrier UShort等价证明只服务这个view，不需要沿调用链泄露所有scheduler布局。

重组lemma在持有实际写后单元和原frame时建立新invariant。递增接口沿用已批准的 `<65535`入口域，允许65534写到内部65535；递减接口采用原饱和定义，覆盖0时不写的源码分支。原有效性保留为纯事实，新计数范围来自真实UShort写入及相应算术证明，没有额外C precondition。这个局部接口将供annotation owner产生实际entailment VC，不能以helper证明代替C实现证明。

完整20文件coqc均退出0。helper包含15个Qed，官方record身份、两carrier32位小端以及10个公开lemma assumptions检查成功；作者报告没有新增用户公理。独立review将检查R4-REUSE-01关闭、helper的精确cell/frame与更新路径，以及改动的dependency closure，沿用r4未变部分已经闭合的审阅证据。

独立审阅已通过，本revision已接受并同步active配置。Predicate通过独立审阅后，spec作者只需在逻辑header增加helper import和必要term声明，重新检查接口并固定spec；随后原controller annotation owner继续原attempt的repair流程。实际frontend的32字节Semaphore和字段offset仍须在controller产物中核对，最终完整coqchk和C/VC/proof/trust检查仍为完成条件。

最终组织整理仅将外层Frame Definition整块移到外层lemma之前；定义、statement和proof正文均未变化，旧snapshot保留，move-only.json保存逐字对照。仅重编helper并核对其余19源hash。
