From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

(** 本case导入已审阅共享定义与Event模型ABI接口；不另增公理或占位证明。
    ABI接口只固定36字节展开模型的大小及顶层字段偏移，字节转换仍须证明。 *)
Require Import CRTOS_Verify.lib.KEventCreate CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.EventLayoutABI.
Require Import CRTOS_Verify.lib.SemaphoreInv.
