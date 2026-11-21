# immediate_results 完成交付

当前分配的 5 个顶层 witness 和 12 个 split 均以 Qed 完成。仅修改固定 copied manual 的 assigned proof spans，未修改陈述、导入、注解、库、auto 或 goal。

- NULL manager 路径由既有 QCP `addr_of_LE_var_not_zero` 排除；没有增加地址假设。
- ID 不存在路径由 `id_in_ids_false_iff` 与 semaphore_manager 的 ID 映射得到不存在匹配 semaphore，构造 locked effect 的 -1 返回。
- 正计数路径构造原对象计数减一的精确全局替换及返回 0；零计数且零等待路径构造状态不变的 -2 返回。
- 三条执行路径都由入口 safeExec 的实际初态集合、assertS 和 atomic cmd 正常关系，经既有 wp_bind/wp_assertS/wp_spec 推出原 continuation；没有新造执行假设。
- ID manager/value 借出资源通过 restoration wand 归还 os_inv，临界区 token 保留。保证关系分支及 pending-head 地址分支由当前模型和定义直接闭合。
- 顶层 aggressive route 按实际生成的空间分支、执行分支调用对应 Goal_apply；原生预处理已闭合的 guarantee 分支不重复调用。

历史 r1 同组相应 proof blocks 均未完成，本轮重新证明。当前 exact group-check 已真实退出 0，JSON status passed；重编译当前 goal/auto/manual/group wrapper 四个目标。该结论仅为本组，不代替 parent/final-check。
