# FIFO 表示修改审阅

本轮为 lib / annotated C 设计修改，不恢复 2026-11-19 暂停的 QCP 实现流程。

- 源码分析：独立 dataqueue_analysis agent，核对模块五个函数及既有授权修复。
- Predicate：独立 dataqueue_review agent，review-passed。
- Spec：review-passed。独立语义审阅通过，KInit/KDeInit/KDataqueuePeak/KPop/KPush 及其依赖编译均通过。
- 实现证明：not-verified（新表示尚未重新生成和证明 VC）。

Predicate/spec revision：`dq-fifo-20261121-r1`。下列 SHA-256 汇总按表列路径顺序，以 `路径 + NUL + 文件内容 + NUL` 拼接计算；冻结输入以实际内容为准。

- Lib 汇总：`10c867584506801b6390c680a23c60c41af1141b00e2de0b7284af54ba0f6d80`
- annotated C/header 汇总：`a7c8d3ba68fb0b49bca16f6f0429a3b41013311fbd4a265a90af79ad7985d460`

## 检查与限制

五个 C 文件均通过 GCC `-m32 -std=gnu11 -fsyntax-only`；预处理后的可执行 C 与修改前基线逐字规范化比较一致。独立 reviewer 另做去注释 token 比较，结果一致。这不是 QCP 注解的机器验证；当前注解已作结构、词汇与语义人工检查，发现并修复了 header 缺少 nil/cons 声明。

新 DataqueueState、DataqueueInv、KInitDataqueue、KDeInitDataqueue、KDataqueuePeak、KPopDataqueue、KPushDataqueue 及其共享依赖通过根 Makefile 的 Rocq 编译；随后补全配置中的全部 72 个 lib 目标，增量编译退出码为 0。临时 Rocq 检查以 Qed 证明 ring_shape 下的分段计数、长度界限、列表空与 front=rear 等价、满长度与 C 满条件等价。独立有限回归检查覆盖容量 1–64 的 89,440 个索引组合，确认分段覆盖、互斥及 push/pop 顺序；有限检查不替代一般证明。

新 buffer 的 allocation/free/head/pop/push 等空间接口仍是明确的待证 Prop，不当作已证引理使用。原有 ABI 公理保留，未增加 Admitted 或公理。旧 Dataqueue VC、manual 和 controller done 不作为此 revision 的实现验证依据；旧文件保留供后续正式流程适配。

## 修改前基线与范围

基线是修改前实际工作树，不是 HEAD；其中已有未提交的 Pop continuation 和 C 注解完整保留。下表记录 lib 的本轮行数变化（含注释、空行），不计旧有改动。

| 文件 | 修改前 SHA-256 | 新增 | 删除 | 净增 |
|---|---|---:|---:|---:|
| `lib/common/DataqueueInv.v` | `64a1769d13acf1f6956e4b29a72815b86f4cf5e4a375fb37618291b1caf755aa` | 57 | 32 | 25 |
| `lib/dataqueue/DataqueueState.v` | `8fc59cade390814c85036aef81880b8dd3a708ac10c29bae62f07a6e25b888d4` | 53 | 22 | 31 |
| `lib/dataqueue/KDataqueuePeak.v` | `113f1320348d163abd24c16af87dc9c68dee77fc45d3120c688c03d8016f8c91` | 2 | 4 | -2 |
| `lib/dataqueue/KInitDataqueue.v` | `78c5baa51ca8f595bf6b13ae4ca2f49417cdc71f958f4170a38d72a2c6382c41` | 3 | 2 | 1 |
| `lib/dataqueue/KPopDataqueue.v` | `09b2b12e2d9d3579d91a76736f54ca3a98b4872c72f8638461842a78632481a8` | 5 | 6 | -1 |
| `lib/dataqueue/KPushDataqueue.v` | `7d3ba8bc8fa0146939b19b91a9a1e7af2c4962bf5c73a67fb3ae9c4b826e7c98` | 5 | 4 | 1 |

本轮检查的 lib：

- `lib/common/DataqueueInv.v`
- `lib/dataqueue/DataqueueState.v`
- `lib/dataqueue/KDataqueuePeak.v`
- `lib/dataqueue/KDeInitDataqueue.v`
- `lib/dataqueue/KInitDataqueue.v`
- `lib/dataqueue/KPopDataqueue.v`
- `lib/dataqueue/KPushDataqueue.v`

本轮检查的 annotated C/header：

- `annotated_C/src/headers/dataqueue.h`
- `annotated_C/src/kernel/dataqueue/DataqueuePeak.c`
- `annotated_C/src/kernel/dataqueue/DeInitDataqueue.c`
- `annotated_C/src/kernel/dataqueue/InitDataqueue.c`
- `annotated_C/src/kernel/dataqueue/PopDataqueue.c`
- `annotated_C/src/kernel/dataqueue/PushDataqueue.c`
