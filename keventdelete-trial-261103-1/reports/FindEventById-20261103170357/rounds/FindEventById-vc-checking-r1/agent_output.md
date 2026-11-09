# FindEventById VC checking r1

Outcome: 当前36个top-level义务均有当前前提支持的证明路线，没有已确认annotation/spec/dependency blocker。这里是可证性分析与分组，不是已完成证明。只以本handoff的当前manual/goal/auto/case-lib为依据；canonical未修改，debug副本亦未修改，没有读取历史proof或做witness复用分析。

## Structural Blocker Scan

先扫描全部top-level，优先检查无split的32项。各个C局部值与逻辑快照均有桥：id实际保持id_pre；CONTAINER_OF返回retval=found；found与idnode的嵌套字段地址等式已明确；解锁后OutsideCritical仍对应同一st_lock。return_wit_1/2可选st_lock为后态。各partial_solve aux只是纯事实重述与原资源交换，没有从空资源要求新增manager、局部cell或os_inv。

最重的无split whole goal是which_implies_wit_4。其found manager内有实际桶的prefix/selected/suffix成员关系，frame内有完整Event管理DLL及全局上下文；因此可以还原匹配Event并从store_event取得基址非零，同时重组manager和os_inv。不是仅凭idnode地址就假定对象权限。which_implies_wit_1的global-manager非零使用已有CNotation全局变量地址非零事实，不需新公理。未找到P可成立而Q失败的赋值/堆反例。

## Annotation Comparison Review

交接的annotation_comparisons为空，没有旧VC变化结论需要接受。独立检查五处新which-implies的建立责任：wit_1拆manager+frame；wit_2从query=false取得未命中并重组；wit_3从已知未命中完成抽象查询提交；wit_4从found bucket恢复对象；wit_5从已知命中完成提交。后续partial_solve/return只使用这些待证VC产出的事实，不把annotation文字当作已成立证明。

## Split-first judgments

完成structural scan后，先按manual顺序检查所有8个split，没有先为父VC选策略：

| split goal | 判断 | 语义依据 |
|---|---|---|
| which_implies_wit_1_split_goal_1 | 可证 | 已有全局变量地址非零模型事实 |
| which_implies_wit_1_split_goal_spatial | 可证 | os_inv/event_inv与精确frame的展开重排 |
| which_implies_wit_2_split_goal_1 | 可证 | false查询排除map event_id中的成员 |
| which_implies_wit_2_split_goal_spatial | 可证 | manager+完整frame恢复同一os_inv，context来自os_world_wf |
| which_implies_wit_3_split_goal_1 | 可证 | GTrans自反 |
| which_implies_wit_3_split_goal_2 | 可证 | 真实st_lock是LastSeen集合内观察，lookup_result提供同状态nrm，得到ret 0 continuation |
| which_implies_wit_5_split_goal_1 | 可证 | GTrans自反 |
| which_implies_wit_5_split_goal_2 | 可证 | 同上，结果为当前event地址，沿用同一X |

## Proof-Mode Decisions

全部split判断完成后才决定父VC模式。上述which_implies_wit_1、2、3、5全部split可证，因此选择aggressive_pre_process，正式目标仅为各自两项split；没有另外分析或为它们规划whole-goal路线。

下列无split义务分别判断whole goal可证并选择LLM_pre_process，完整名字均带`proof_of_FindEventById_`前缀：

- safety_wit_1、2、3、4、5、6、7、8、9、10、11。
- return_wit_1、2。
- partial_solve_wit_1、2。
- partial_solve_wit_3_pure、3、4_pure、4、5_pure、5、6_pure、6、7_pure、7、8_pure、8、9_pure、9、10_pure、10。
- which_implies_wit_4。

共4个aggressive父VC、32个LLM父VC，精确覆盖36个top-level。

## Common Proof Patterns

这些策略在全部mode决定之后形成，具体可执行说明同时写入group_plan。

1. 常数安全及矛盾分支：pure目标是INT_MIN<=0<=INT_MAX，或输入已经具有id<0与id>=0、指针=0与<>0的直接矛盾。引入binders、投影pure facts并做常数算术/矛盾消除；不需要展开heap或抽象程序。
2. 原样资源传递：partial_solve的pure目标直接取当前假设；aux将manager+frame+InsideCritical或os_inv+InsideCritical重排并附加同一组pure facts。partial_solve_i整体为pure_i -> aux_i，aux上下文自身已提供所需事实。空间取消不能丢失/复制资源；第9组事实需先用retval=found改写lookup_result。
3. 查询借还：从os_inv拆出event_inv中的manager，并把其他模块及Event DLL保存在find_event_manager_frame。反向重组使用frame中的os_world_wf -> os_global_context -> event_context得到manager_ptr等式。未命中由id_in_ids_false_iff及event_manager.idlist=map event_id导出，不需id的额外范围条件。
4. 命中对象恢复：从store_idmanager_found的桶分解保留成员事实，沿event_manager的桶map/filter定位实际e；从Event DLL的store_event payload导出e.addr<>0。取found=e.addr，建立field地址、guard和lookup_result；使用现有store_idmanager_found_store_idmanager恢复manager并精确拼回os_inv。计划两个本组新helper，分别负责桶成员的纯反映和DLL成员基址非零；其全部前提均来自VC。
5. 原子查询提交：非负id使abs_find_event选task_atomic_cmd。safeExec提供状态集合见证及weakestpre；LastSeen将集合与RTrans before关联，给定RTrans before st_lock即允许取st_lock为执行观察。event_lookup_result给出abs_find_event_locked在相同前/后态的正常关系；后状态集合取Crtos_RTrans st_lock，normal子句给出同一X的结果。随后包装ret及LastSeen st_lock。不能假设任意continuation，也不把入口状态直接等同于锁内状态。
6. 最终返回：exists after选择st_lock，非空路径以retval=found转移非零及guard；两路径的safeExec ret已由先前提交VC建立。OutsideCritical原样返还。

## VC Deltas

| VC family | 与公共路线的实际差异 |
|---|---|
| safety 1–4、7、8、11 | 只有多余空间上下文不同，目标均为0的有符号整数界 |
| safety 5 | id_pre<0与0<=id_pre矛盾 |
| safety 6 | global-manager=0与<>0矛盾 |
| safety 9、10 | 同一个retval_2的=0/<>0矛盾 |
| partial 1 | OutsideCritical保持 |
| partial 2 | InsideCritical和os_inv交换顺序 |
| partial 3_pure/3 | IdGetObj调用的ID范围，manager+frame保持 |
| partial 4_pure/4 | 未命中query=false，manager+frame保持 |
| partial 5_pure/5 | 0结果提交前的safeExec/RTrans/lookup事实，os_inv+Inside保持 |
| partial 6_pure/6 | 0结果解锁前GTrans，空间顺序交换 |
| partial 7_pure/7 | 命中的idnode非零，found-manager资源保持 |
| partial 8_pure/8 | CONTAINER_OF字段地址等式，os_inv+Inside保持 |
| partial 9_pure/9 | retval=found改写后提交非零结果 |
| partial 10_pure/10 | 非零结果解锁前GTrans，空间顺序交换 |
| which 1/2 | 拆manager与未命中恢复，全部split独立成立 |
| which 3/5 | 同一原子提交helper分别实例化p=0及p=event |
| which 4 | 无split，整体现存对象恢复是独立的重型成员/权限路线 |
| return 1/2 | 同一后态st_lock；1额外搬运retval=found的guard与非零 |

## Grouping Decisions

计划10个独立组，均不超过上限12，实际每组1–6项。先派高风险hit_object（1个whole VC、2个局部helper、难度5），然后atomic_commit（2个父VC/4个pure split、1个helper、难度4），再manager_views（2个父VC/4个split、难度3）。hit_object单独成组是因为其桶成员映射和spatial payload提取构成独立helper家族；与简单query=false重组混在一起会延长关键路径。

其余按程序阶段分为entry_and_id_call（6）、miss_call_transports（4）、found_pointer_transports（4）、found_commit_transports（4）、initial_safety（5）、query_branch_safety（6）和return_packaging（2）。返回包装可以独立于原子提交证明，因为其VC前提已明确包含提交结果，故分开避免尾部耦合。组间不依赖、不读取sibling产物；需要的新helper均带各自精确suffix并限定local。

## Risks or Blockers

无已确认blocker。hit_object需将Znth桶成员经过map/filter反映回对象序列，并在不丢失完整DLL资源的前提下提取payload非零，属于较高证明工作量；atomic_commit需正确处理LastSeen的集合等价和safeExec的存在初态，而非随意选择/加强X。二者都有当前前提足够的明确路线，不因尚未证明helper就返回annotation gap。

没有执行额外编译或MCP证明：当前goal已完整显示所需逻辑形状，不需要向debug副本插Show。后续group worker仍必须按各自工作流证明并经controller验收，不能把本分析的“可证”当作Qed。
