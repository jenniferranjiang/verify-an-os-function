---
name: source-processing
description: 将 CRTOS 等非 SMP OS 原始源码按配置和用户规则处理为 QCP 验证切片，并记录源码对应、适配依据及调用边界。
---

# 源码处理

沿用主编排的[共用约束](../os-verification-coordinator/SKILL.md#通用验证约束)与[环境配置](../os-verification-coordinator/CONFIGURATION.md)，复用已有上下文及有效授权。

## 确认验证上下文

验证工程就是用户当前的 workspace，无需另配其路径。按[路径配置](../os-verification-coordinator/CONFIGURATION.md#路径配置)从 workspace 的 `CONFIGURE` 或 Makefile 解析 QCP 和 Rocq，缺项时提醒用户创建或补全 `CONFIGURE`。OS 原始源码位置先查 `CONFIGURE`。未指定时，结合项目线索优先在 workspace 的上层目录查找，唯一确定后写入 `CONFIGURE`，找不到或有多个候选时请用户指定。

首次使用时先向用户汇报 OS 源码、QCP 和 Rocq 三项实际路径，确认后开始验证。首次配置或迁移机器时，按[构建入口中的本机绑定规则](../os-verification-coordinator/CONFIGURATION.md#路径配置)核对完整启动链；允许增量修改 workspace 内的构建和启动配置，并验证所配路径实际生效。后续任务沿用已确认的上下文，按[工程组织与维护指南](../os-verification-coordinator/references/project-maintenance-guide.md#路径配置与目录发现)使用现有目录。

处理源码到验证切片的转换时，按照 [源代码处理](references/source-processing-guide.md) 执行，并结合当前配置与适用的工具适配及信任授权 核对适用条件。源码处理同时参考默认的 [源代码处理](references/source-processing-guide.md) 和可选配置 `source_processing` 指定的用户规则文件。两个文件分别保留，无需合并；冲突条目以用户规则为准，其余规则共同生效。未配置用户文件时使用默认文件。用户在当前任务中明确指定的规则同样优先于默认规则，具体配置见[用户源码处理规则](../os-verification-coordinator/CONFIGURATION.md#用户源码处理规则)。本 skill 各处引用《源代码处理》时均遵循此约定。

开始时读取[源码处理指南中的 Trusted specs](references/source-processing-guide.md#trusted-specs)及[QCP 工具适配](references/qcp-tool-guide.md#c-输入与工具适配)。若配置了 `trust_base`，同时读取该用户信任说明；未配置时查看项目已有说明，未获得的外部授权不得继承。信任授权由用户维护，agent 不得自行修改或扩大；已有授权核对适用条件后使用，一致性检查仍须执行。Main agent 可以建议将复杂函数设为 `trusted`，用户明确批准具体函数及采用的 contract 后才能跳过其函数体的递归验证，并记录授权。

### C 源码分析

Agent 对原始 OS 源码只有读权限。源码适配和经用户批准的缺陷修复只能修改 workspace 的 annotated C 副本。修复后的验证结论须注明对应的副本版本，具体记录与门禁见下述指南。

Main agent 将源码分析交给 C analysis agent，按 [Predicate 指南第 1 节](../predicate-and-spec-design/references/predicate-lemma-design-guide.md#1-确认源码与范围)执行，分析结果用于后续 predicate 设计。源码问题的说明与处理见[源码错误报告](../verification-report/references/reporting-guide.md#源码错误报告)。
