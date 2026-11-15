Require Import Coq.ZArith.ZArith Coq.Lists.List.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require CRTOS_Verify.lib.common.CrtosInv.
Require Export InitDataqueueTrial.lib.CrtosRules InitDataqueueTrial.lib.DataqueueInv.
Local Open Scope sac.
Module CoreInv := CRTOS_Verify.lib.common.CrtosInv.

(** 全部未修改模块通过根os_inv直接复用，数据queue模块在同一Assertion
    carrier内以分离合取加入。本文件实际被Init/DeInit和Lock/IRQ接口引用，
    不是只Import未参与资源交接的外壳，也不复制任何未修改模块定义。 *)
Definition os_inv (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  CoreInv.os_inv sg (project_core st) ** dataqueue_inv st.(os_dataqueues).
Definition core_os_inv := CoreInv.os_inv.

(** 同一trusted primitive的protected-invariant schema实例：原core索引下
    保护某个实际存在的queue map。Lock返回的扩展state witness必须描述这份
    heap；它不是由旧固定合同凭空多借出queue资源的推导。empty/publish/
    withdraw义务明确负责资源建立与转交；不新增硬件或更强rely信任。 *)
Definition protected_os_inv (sg : StableGlobalState) (core : CoreVarGlobalState)
    : Assertion :=
  EX queues : DataqueueState, os_inv sg (restore_core core queues).

(** 启动没有已发布queue，dataqueue部分由emp建立。以下是待证资源连接，
    不作为已证引理，也不能代替后续具体primitive调用及C实现证明。 *)
Definition os_dataqueue_initial_obligation : Prop :=
  forall sg core, core_os_inv sg core |--
    os_inv sg (restore_core core dataqueue_initial).
Definition os_dataqueue_core_frame_obligation : Prop :=
  forall sg core queues,
    core_os_inv sg core ** dataqueue_inv queues |--
    os_inv sg (restore_core core queues).
