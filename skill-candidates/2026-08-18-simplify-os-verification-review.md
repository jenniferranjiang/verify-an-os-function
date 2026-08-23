# 简化 OS 函数验证的设计审阅

- 触发问题：Predicate/spec explanation 过于抽象，两个大型 manifest 难以阅读，review round 没有上限。
- 方法：Predicate 直接以带自然语言 `(** ... *)` 中文文档注释的 `.v` 为设计和审阅来源；baseline/module-baseline 收缩为主 skill 中的简短验证上下文；删除 L0–L3 表和强制标签，直接按 direct-callee graph 从 leaf 向目标函数推进。
- 适用条件：使用 formal predicate、annotated C spec、QCP VC 和 Rocq proof 的函数验证任务。
- 限制：Breaking design change 仍需重新审阅；用户未批准设计前仍不得运行 QCP/VC/proof。
- 受影响文件：`SKILL.md`、predicate/spec/implementation guides、`agents/openai.yaml` 和 review assets。
- 保留模板：`assets/spec-review-template.md`、`assets/final-integrity-template.md`、`assets/design-change-request-template.md`；predicate、OS baseline 和 module baseline templates 已删除。
- 验证证据：`quick_validate.py` 返回 `Skill is valid!`；predicate template 文件及引用均已清除，spec template 保留；
  独立 forward test 只生成带中文文档注释的 `.v` 代码，没有生成 Markdown manifest；简单 helper 使用一句自然语言说明
  作用和保持关系，没有机械生成 ownership/effect 清单。Baseline/module-baseline 的四个 guide/template 及过期引用已清除；
  独立上下文测试在没有 baseline 文件时只确认源码/config/dependencies/critical/trust 事实，并从 spec guide 正确选择 L0，
  没有要求创建任何 baseline 文档。依赖顺序测试能从通用 link leaf 沿 ready queue、模块操作回到带 IRQ/返回码的
  外层 API，并把 Init 按其自身 callees 处理；删除分层表后再次测试，能够直接按 direct-callee graph 给出 leaf-to-caller
  顺序，没有分配 L0–L3 标签或补造中间 wrapper。
