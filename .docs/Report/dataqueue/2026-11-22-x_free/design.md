# x_free 的操作对象描述调整

状态：spec 设计修改，尚未重新生成或证明 VC。

`DeInitDataqueue.c` 的可信 `x_free` 接口由完整字节数组改为已有的
`dataqueue_buffer(q)`，要求实际指针等于 `q.dq_base` 且非空。该谓词直接描述
FIFO 有效元素及空闲区，不拥有队列描述符或元素指针指向的 payload。
调用处保留这个 buffer 谓词交给 `x_free`，不再先重组成整块字节数组；
描述符字段和 padding 仍留给调用者。`dataqueue.h` 补充对应逻辑声明。

本次不修改 buffer 谓词定义，不新增信任范围，不改变 C 执行语句。
已有 `dataqueue_buffer_free_obligation` 不再是此调用的前提；保留该表示转换
陈述供其他用途，不宣称其已证明。旧 DeInitDataqueue VC 和完成记录不能作为
新契约的证明，需在后续获准的验证流程中重新生成并核验受影响 VC。

检查：GCC ILP32 C 语法检查与 git diff 格式检查通过；这些检查不验证 QCP
注解语法或分离逻辑推导。
