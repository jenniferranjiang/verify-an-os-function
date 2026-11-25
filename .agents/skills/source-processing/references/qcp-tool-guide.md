# QCP 工具使用与适配指南

处理 QCP 输入适配时使用本指南；设计阶段的公共定义与记法见 [公共定义与记法复用](../../predicate-and-spec-design/references/qcp-definition-guide.md#公共定义与记法复用)。源码提取、OS 特定处理和 trusted specs 见[源码处理指南](source-processing-guide.md)。用户源码处理规则的优先级、原始源码只读及未覆盖情况的处理沿用该指南。

## C 输入与工具适配

适配仅作用于验证副本，记录原源码、配置、转换依据和结论限制。以下布局、类型与目标平台条目受各自的适用条件和信任范围约束，不将它们视为无条件的源码等价或对其他配置的自动授权；新增或扩大假设须经用户批准。

- **预处理**：使用 GCC / QCP 预处理展开宏和移除未激活的条件编译分支，保持必要的最小处理，并由 agent 核对激活配置与结果。
- **结构体布局**：沿用适用的结构体对齐公理，例如 `StackRegisterContext`；记录实际采用的公理与目标 ABI。
- **结构体位域**：原适配将 task descriptor 的两个位域作为两个普通 `uint32` 处理。使用时明确对应的布局与模型假设，不宣称保持原位域物理布局。
- **布尔类型**：原适配将 GCC 内建 `_Bool` 改为 `typedef unsigned char BOOL`，并相应修改验证副本；核对相关表达式与存储语义，记录适用范围。
- **目标位宽**：原适配通过 `xsconfig.h` 选择从 64 位到 32 位的配置；只修改验证副本，结论对应选定的 32 位配置，不自动覆盖 64 位源码行为。
- **C 标准库契约**：使用实际函数的 spec；QCP 中已有证明的契约按来源复用并记录证明状态，其余契约不能仅因属于标准库而自动标记已证或 trusted。

调试输出和调试宏删除、复杂宏函数化及新旧 `NULL_PARAM_CHECK` 的区别统一见[源码处理指南](source-processing-guide.md)，不在这里重复定义。历史上部分宏已函数化并验证 spec，使用时核对具体证明来源，不能据此推定所有宏契约已证。

### 1. 函数指针调用转为直接调用

当函数指针或 `done` 表项在验证覆盖的阶段内目标固定，且调用目标可由源码和配置
确定时，可在 annotated C 副本中将间接调用改为该目标函数的直接调用。固定目标
是转换依据，不能仅因为工具不支持函数指针就任意选择一个函数。

例如原始 C 中：

```c
static SemaphoreDoneType done = {
    .SemaphoreCreate = _SemaphoreCreate,
    /* ... */
};

return done.SemaphoreCreate(val);
```

若确认表项不会在该阶段被重新赋值，可在切片中写为：

```c
return _SemaphoreCreate(val);
```

转换须保留参数求值、调用顺序、返回值和目标函数的副作用；表对象及表项定位表达式
自身若有必须保留的求值或可观察行为，也不能直接丢弃。直接调用的函数仍按普通
callee 处理，使用完整契约并遵循已有验证范围；替换调用形式不赋予 trusted 身份。
记录原表项与目标函数的对应关系、配置及不变性依据，供源码一致性审查使用。

全部相关调用已转换、且表不再被验证路径读取、写入或以其他方式使用时，切片无需
再定义仅用于该分派的 `SemaphoreDoneType` 和 `done` 表；formal 定义也同步去掉
相应的 `SemaphoreDoneAbs`、stable state 中的 `semaphore_done_addr` /
`semaphore_done_abs`、`store_semaphore_done`，以及 invariant/context 中仅服务于
这张表的引用。表项与函数的对应关系保留为转换依据，不另作为运行时内存 predicate。

如果函数指针会在运行时改变、目标无法确定，或者表仍有其他被验证的用途，就不能
套用上述整体移除方案。应按实际分派行为另行建模或适配，并按[源码处理指南](source-processing-guide.md)的未覆盖情况
处理规则解决，不能静默固定目标或删除真实路径。
