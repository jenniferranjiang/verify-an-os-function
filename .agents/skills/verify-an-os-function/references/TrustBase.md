

<!-- This file is readonly and only human-editable! -->

# The Trust Base of Verified CRTOS Code

## Trust 1 QCP工具适配
  - GCC / QCP **Preprocessing** (unfold macro definitions, remove inactive conditional-compilation directives) is minimal and checked by AI agent;

  - Axioms for the alignement of **C structures** (e.g., StackRegisterContext);

  - Specifications for the functions from **C standard library**; Some of functions from C stdlib are proved in QCP and the spec of these functions are reproduced.

  - Debug info removeing, such as KPrintf( ... ). KPrintf声明与使用均被注释掉；

  - 结构体位域；例如，现在task descriptor的两个位域当作正常的两个uint32处理。

  - GCC built-int type _Bool: 重新定义了typedef unsigned char BOOL，并据此修改代码。

  - 64-bit  -->  32 bit by changing xsconfig.h;

  - 一些宏定义处理为了函数，并验证了其spec，如NULL_PARAM_CHECK；也可按宏展开验证，但冗余重复。


## Trust 2 检查一致性

  - 函数声明端（供调用者使用）和实现端必须使用相同的Spec，禁止不一致；

  - 验证函数实现的Spec时，禁止直接使用其头文件声明的Spec，也即，必须对每个函数的函数体进行实际验证；


## Trust Specs

  - Specs for `CriticalAreaLock`, `CriticalAreaUnLock`;

  - Specs for `KERNEL_MALLOC`, `KERNEL_FREE`;

  - Debug macro removing (such as KDEBUG_NOT_IN_INTERRUPT);

  - CONTAINER_OF被当作特定函数处理，且人工Spec未作验证；