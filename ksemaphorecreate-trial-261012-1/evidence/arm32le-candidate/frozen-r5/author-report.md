候选已完整编译，等待独立 delta review；尚未宣称 C 实现已验证，也未改变 accepted revisions 或运行 QCP。

相对 r4，本轮只有三份源码变化：增加逐字未改的官方 NestedCriticalSTS.v；将 CrtosNestedState 改为官方源的 Require Export 与一个必要的透明 projection 别名；增加 SemaphoreCriticalViews.v。官方源独占 CRTOS_Verify.framework 命名空间，未遮盖 SimpleC.SL。原 owner-aware CrtosIRQStep、OS invariant、有效性和 canonical spec 全部保持；类型身份检查以 reflexivity 确认已直接使用官方 record，而非复制一个同形类型。官方 Module Type 中原有的 nc_sts 参数没有实例化为当前 OS 的假设，当前 STS 不使用官方宽松 transition。

新增 helper 对真实 UShort nest cell 和完整非 nest 资源提供双向拆合；原调度 tail 中 done 的存在量词与 padding 都保留。nest 更新后的恢复使用既有 CrtosOSValid，++ 使用已批准的 nest<65535，-- 包含饱和0分支。15 个 lemma 均 Qed，10个公开 lemma 已检查 assumptions，仅依赖原框架地址/大小参数及已有外延性。

20 文件闭包的 coqc 全部 exit 0，两 carrier 的32位指针、16/32位小端及反大端探针均通过。`build.json`、`predicate-manifest.json` 和 `delta-from-r4.patch` 固定完整命令、来源与实际变化；根9个输入源 hash保持原样。r4冻结snapshot不变，active配置、header、controller和权威C没有由本作者修改。
