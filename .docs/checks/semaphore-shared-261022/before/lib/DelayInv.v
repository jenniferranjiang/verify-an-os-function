Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import Coq.Sorting.Permutation Coq.Sorting.Sorted Coq.micromega.Lia.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.CrtosRules.
Require Export CRTOS_Verify.lib.dll CRTOS_Verify.lib.idnode.
Require Export CRTOS_Verify.lib.KTaskDelayMem CRTOS_Verify.lib.NodeSelfLinked.
Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.

(**
  [store_inactive_delay] 是 inactive map 的 cell 空间解释，拥有 payload、
  padding 和自环的两个 link 指针槽，并保证 INACTIVE 状态。
  active 对象完全由 active DLL 拥有，不在此 map 中保存占位 cell。
*)
Definition store_inactive_delay
    (delay : addr)
    (info : TaskDelayAbs) : Assertion :=
  “ info.(tdStatus) = TASK_DELAY_INACTIVE_VALUE ” &&
  store_delay_info &(delay # "Delay" ->ₛ "link") info **
  store_node_self_linked &(delay # "Delay" ->ₛ "link").

(**
  [delay_inv sg st] 把 Delay 的纯一致性与空间所有权放在同一局部不变量中。
  map 拥有 inactive 自环对象，DLL 拥有 active 对象及其 link；
  分离合取保证两者不重叠。[delay_world_wf] 负责与任务 delay 指针的
  完整对应以及 active 链表的排序，供 KTaskSetDelay 的局部视图使用。
*)
Definition delay_inv
    (sg : StableGlobalState)
    (st : VarGlobalState) : Assertion :=
  “ delay_world_wf
      st.(os_tasks).(task_desc_map) st.(os_delays).(delay_inactive_map)
      st.(os_delays).(delay_active_nodes) ” &&
  store_map store_inactive_delay st.(os_delays).(delay_inactive_map) **
  store_dll store_delay_info sg.(delay_head_ptr) st.(os_delays).(delay_active_nodes).

