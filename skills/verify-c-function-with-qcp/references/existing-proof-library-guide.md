# 已有证明库的使用方式

本指南说明怎样把工程中已有的正式定义、已审阅接口和已完成证明作为当前验证的参考或依赖。示例名称都是占位符，不对应任何特定项目。

## 1. 先分类，不按文件位置推断可信度

为每个候选依赖记录 file、symbol、revision、直接 assumptions、客户端和状态：

| 状态 | 含义 | 允许用途 |
|---|---|---|
| example-only | 只展示组织方式或语法，未确认当前结论 | 只能参考结构，不能作为证明依据 |
| reviewed-interface | predicate/spec/lemma statement 已审阅，proof 尚未完成 | 可用于设计组合，不能声称已验证 |
| proved | statement 与 proof 已完成所需机器检查，assumptions 已核对 | 可作为 proof dependency |
| user-approved trusted | 用户明确批准的外部保证或边界 | 只按批准 contract 使用并记录 |

文件存在、名称相似、曾被其他 trial 引用或含有 Qed，都不足以自动判定 proved。必须核对正式 statement、实际 proof、编译结果和 assumptions。

## 2. 用占位结构理解职责

一个已有证明库可能按下列职责组织，但真实工程不需要采用这些文件名：

~~~text
ExistingPure.v
  abstract state、pure update、validity、transition relation

ExistingRep.v
  C object、field、array、container 与 heap ownership

ExistingRules.v
  synchronization protocol、resource acquire/release、allowed transition

ExistingProofAux.v
  已证明的 split/merge、update、refold 等辅助 lemma

ExistingFunction.c
  canonical With/Require/Ensure、active C body 与 caller-local APIs
~~~

读取时关注职责和依赖方向，不通过替换模块名、字段名或状态名来复制设计。

## 3. 在各阶段怎样使用

### Context

- 固定候选库的 revision、logical path 和 build configuration；
- 找出它服务的真实 C objects、clients 和生命周期；
- 记录未收录依赖、额外 assumptions、占位或未完成 proof。

### Predicate design

- 复用确实描述同一 C representation 和 ownership 的定义；
- 只借鉴文件分层、注释位置、view 与 lemma 组织方式时，将候选标为 example-only；
- 当前目标的抽象状态、地址公式和 owner 仍从当前权威 C 推导；
- 发现已有定义不满足唯一 owner、lifecycle 或 frame 要求时保持 [OPEN]，不为复用而降低门禁。

### Spec design

- Canonical spec 只引用当前工程实际导入的正式 symbols；
- reviewed-interface 可以帮助设计 caller contract，但不能冒充 proved；
- callee 的 caller-local API 必须与其 canonical contract 一致；
- 已有 spec 与当前源码/config 不一致时，停止复用并记录影响。

### Implementation

- 按 direct-callee graph 自底向上使用 proved dependencies；
- 编译实际组合后的工程，而不只相信快照单独通过；
- 核对 logical path、imports、statement identity 和 Print Assumptions 或等价证据；
- 不复制 proof 后修改 statement，也不把自动生成的占位证明计为完成。

### Review

- 记录哪些内容被直接依赖、哪些只用于示例；
- 检查 revision、status 和 assumptions 是否仍有效；
- 上游 statement、source、configuration 或 assumptions 变化时，按 dependency closure 使相关结论失效。

## 4. 参考库不能替代的工作

已有证明库不能替代：

- 当前源码/config 的路径和 memory-access 分析；
- 当前模块的 abstract-state 与 ownership 选择；
- 当前 reachable closure 和每条返回路径的 spec；
- 当前 QCP symbolic、VC 生成和 Rocq proof；
- 对当前组合工程的 trust scan 与最终完整性检查。

把参考库的角色写清楚：复用正式结论、适配接口，或只展示流程。三者不得混淆。
