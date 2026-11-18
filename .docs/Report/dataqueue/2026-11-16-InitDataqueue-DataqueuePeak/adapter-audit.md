# QCP本地适配审计与收窄

范围：对/home/xinra/qcp-binary-democases当前已跟踪文件的未提交差异，以及新增project_layout.py进行逐项审计；基准为该仓库HEAD ae9f638a。没有把未提交差异自动认定为某次会话所写；归属不可追溯的内容以实际功能分类。未触碰Contest、压缩包、MCP缓存或其他项目。

## 移除的额外行为

| 本地增补 | 原行为 | 本次处理 |
| --- | --- | --- |
| auto转manual分流 | 发现任意Admitted/Abort即搬空全部auto | 前轮已移除，Init/DeInit原生分工已恢复并重新final-check |
| annotation_design.unfreeze | 额外允许blocked任务解冻并重新派发 | 文件恢复HEAD原逻辑，仅running可解冻 |
| controller_control / controller_cli | resume-run新增resolved-attempt/resolution-reason，重开基础设施blocked组 | 恢复HEAD命令与状态转换，删除对应CLI文档增补 |
| coq_tooling_makefile.prepare_native | 原生构建成功后额外比较每个.vo与源文件时间戳，不符再次拒绝 | 删除额外门禁，沿用原生构建与原仓库检查 |
| symexec_tooling项目配置硬编码 | 只准32/little/no_crules=true/gcc的唯一组合 | 按项目显式配置转发原生参数，允许native预处理；不擅改当前项目值 |

恢复的四份文件只有上述本地改动，已先完整比对再恢复，未用整仓库reset。没有添加新的证明限制、扩大VC集合、修改原版proof mode/分组/最终检查要求。

## 保留内容及边界

用户后续明确确认：第4项涉及的架构、字节序、CRules和预处理环境适配可以保留。适配范围因此包括路径映射和必要的项目编译环境，不限定为纯路径转换；这不表示授权恢复auto/manual重分流或额外验证政策。当前qcp-project.json仍为32位、little、no_crules=true、gcc，工具按配置传递，无需再改代码或重新生成证明。

路径适配保留：annotated_C/src输入发现、VC/<module>输出、CRTOS_Verify逻辑前缀、_CoqProject的-R/-Q映射、外部QCP库路径、编译器可执行文件路径，以及staging交互环境的相同load paths。这些适配不判定一个VC是否需要手工证明，不改源码/spec/goal/auto/manual内容。

当前适配仍读取显式构建配置：qcp-project.json的arch/endian/no_crules/preprocessor，以及tools/rocq/toolchain.json的工具链。这不是纯地址映射，已单独列明；其作用是选择已有项目的模型与编译环境，不能伪装成路径规则。现有ILP32/little/手动CRules import/GCC选择保留，是为了不悄悄改变既有验证输入；适配代码不再硬性限定这一组合。默认未指定preprocessor时走QCP原生预处理。没有将原版默认big-endian/默认CRules直接套到现有项目。

工具链环境变量处理及外部依赖边界检查属于现有加载/构建环境适配；未增新的数学假设或信任授权。现有project_layout的trial命名为历史内部名称，不创建trial目录。已知现存布局限制仍为annotated_C/src、VC及模块目录；本轮不另建通用工作流或新的接口层。

## 检查结果

- 修改过的Python文件通过AST语法检查；git diff --check通过。
- 恢复后的四份workflow/CLI文件与HEAD一致。
- 对InitDataqueue-20261118165045、DeInitDataqueue-20261118171259，调用清理前后build_symexec_plan逐项比较argv、preprocessing、target_files、extra_flags、include_args、slp_args，完全一致；未运行新的symbolic或覆盖证明。
- 两个controller step均返回phase=done，无next_actions/current_blockers；当前证明/配置/.vo未改。沿用同版本已通过final-check，不为本次路径/控制器审计重复全量证明。

后续适配原则：保留路径转换及用户认可的必要编译环境适配，分别明确配置来源；不在适配中加入auto/manual重分流、额外验收、审批或重试政策。需要改QCP原工作流时作为独立改动解释依据，不以“适配”名义顺带改变。
