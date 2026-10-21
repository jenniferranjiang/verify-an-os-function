# 当前 CRTOS trial 的 controller 适配

入口为 `scripts/verification-orchestrator/controller.py`，使用 Python 3.12，
`--main-root` 指向当前 trial。用户于 2026-10-21 要求适配 controller，并继续
`_SemaphoreCreate` 与 `KSemaphoreCreate` 的实现证明。

本地脚本从当前 QCP controller 复制，参考旧 trial 的基础设施适配。
外部 QCP 工具及技能、当前 C 函数规约和共享 predicate 不因适配改变。
上游源文件指纹保存在 `../../checks/controller-upstream-manifest.json`。

适配范围：

- `annotated_C/src/<function>.c` 对应 `VC/<case>_*.v`，逻辑目录为 `CRTOS_Verify.VC`。
- 相对头文件在 `annotated_C` 内解析；保留越界、符号链接和非普通文件拒绝检查。
- QCP driver 和角色技能只读引用 `/home/xinra/qcp-binary-democases` 的实际安装。
- QCP 使用 32 位、小端配置；`--no-CRules` 配合当前 predicate 已定义的 CRTOS
  CriticalSTS Assertion 实例，避免导入另一套默认断言实例。
- Coq 构建读取当前 `_CoqProject`，固定使用已安装的 Coq 8.20.1；本地
  `shared_candidates`、`vendor`、`lib` 和 `VC` 按各自逻辑路径编译。
- 外部库节点仅作为只读输入，固定源文件与编译对象指纹；其内核检查可按
  未变指纹复用，禁止把外部库当作本 trial 的编译输出。
- `checks/implement-frozen-inputs.json` 固定当前共享语义输入；每次执行
  controller 的相关命令前检查，函数规约仍由原有 `--freeze-spec` 检查。
  固定清单不声称旧设计审阅对当前版本仍然有效。
- 原有 owner 交接、接纳、分组证明、合并、发布与 fresh symbolic 终检保持不变。

实际 wrapper 运行发现 driver 将 4 个义务写入 auto 文件，但证明体仍为
`Admitted`。适配器因此将这些原始 witness 的精确 statement 加入 manual
任务；原始 goal 和 auto 文件字节不变，并以内容 hash 留档。原 controller
的 staging 去掉 auto/manual 重叠项后，编译必须使用 manual 中完成的证明。
该转换也用于最终独立重放；`check_auto_coverage.py` 在真实输出副本上检查
statement 完整覆盖、原始字节不变、重复冲突拒绝和 staging 后无占位 auto
证明。它不提供任何 witness 的证明。

没有迁移旧 trial 专用的九函数闭包调度、revision 重验证或故障恢复状态。
当前两个 run 各自使用标准 `init-run` / `step`，之后执行返回的 invocation。
两函数整体结论还要求 `_SemaphoreCreate` 的实现和实际复用的 callee 证明匹配。

路径与真实输入计划检查：

```sh
python3.12 tools/qcp-controller/check_adapter.py
python3.12 tools/qcp-controller/check_auto_coverage.py
```

结果保存在 `checks/controller-adapter-check.json`。该检查及 controller 接受
输入均不代表 C 函数已验证；实现证明以各 run 的最终状态与完整性证据为准。

2026-10-21 实际完成结果：

- `SemaphoreCreate-20261021190017`：41 个顶层 VC，9 个分组，最终状态 `done`。
- `KSemaphoreCreate-20261021190059`：4 个顶层 VC，最终状态 `done`。
- 两者均通过合并编译、正式写回和独立 symbolic 重放的 `final-check`。

证明文件在 `../../VC/`，汇总见
`../../checks/controller-implementation-status.json`，原始结果见各 run 的
`controller_state.json`。这是基于当前 `261019-3` callee contracts 和既有
TrustBase 的模块化实现证明；没有重复证明 helper C，也不把尚未定位的 helper
实现完成记录算作本次验证结果。
