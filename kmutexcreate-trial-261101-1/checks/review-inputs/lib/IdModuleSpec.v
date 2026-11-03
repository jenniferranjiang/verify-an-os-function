Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
From AUXLib Require Import ListLib.
Require Import KMutexCreateTrial.lib.idnode.

Import IDNode.
Local Open Scope Z_scope.

(** 原样同步 ../crtosverify-id 的 idnode 分支（1237874）中的查询成员关系。
    当前 OS 模型已使用相同的带地址 ID 节点；无需旧分支的地址擦除模型。
    本文件不增强函数契约，也不引入任何公理。 *)
Definition idmanager_contains
  (sm: StableIdmanager) (m: VarIdmanager) (id p: Z): Prop :=
  In (Build_IdNodeAbs id p)
    (Znth (id mod sm.(hoffset)) m.(idbuckets) nil).

