# KSemaphoreCreate predicate/spec设计完成报告

- Predicate：`b94f379135fae7f859cdcd716dbdec0cd489d3be291f2da45451d55ad7ec0840`
- Spec：`406797f561797866ca97c686d73572632314ba7d709d2bb83d92977b6f706e3f`
- 状态：两者均`review-passed`
- Open blocker：无
- Proof/implement：未进入；`qcp.proof`未调用；VC=0

## 最终组织

`annotated_C/src/`只有10个扁平C文件：

- `semaphore_create_internal.c`
- `ksemaphore_create.c`
- `x_malloc.c`
- `memset.c`
- `critical_area_lock.c`
- `id_insert_obj.c`
- `x_free.c`
- `critical_area_unlock.c`
- `init_double_link_list.c`
- `double_link_list_insert_node_after.c`

每个direct callee一函数一文件。大函数正文调用的嵌套操作全部在该文件前部写成带`With/Require/Ensure`的API；function-like宏不再作为裸宏调用留在body。

`KTaskCreate`不属于本任务；predicate只拥有semaphore manager、bitmap、buckets、global list、Semaphore对象和pend DLL。

## 门禁

等待用户明确确认上述最终predicate/spec revisions。确认前不得生成VC、调用`qcp.proof`或进入implement/Rocq proof。
