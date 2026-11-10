Require Import Coq.ZArith.ZArith Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Import CRTOS_Verify.lib.event.EventInv.
Require Import CRTOS_Verify.lib.common.StructFieldOffsetAxiom.
Import KTaskCNotation.
Local Open Scope Z_scope.
Local Open Scope string.

(** Event 位域展开模型的五个顶层字段地址。与已审 EventInv 的模型一致：
    id在0、options在12、events在16、pend_list在20、link在28。
    此纯命题不拥有内存，不提供非空、分配来源或对象生命周期权限。
    IdNode/DLL 的子字段地址复用已有布局接口，不在这里重复声明公理。 *)
Definition event_top_level_field_offset_ok (p : addr) : Prop :=
  &(p # "Event" ->ₛ "id") = p /\
  &(p # "Event" ->ₛ "options") = p + 12 /\
  &(p # "Event" ->ₛ "events") = p + 16 /\
  &(p # "Event" ->ₛ "pend_list") = p + 20 /\
  &(p # "Event" ->ₛ "link") = p + 28.

(** TrustBase 已授权的32位结构体布局/位域适配的具体可信实例。
    checks/source-abi/adapted.c 核对当前切片为36字节；EVENT_MEM_SIZE定义为36。
    原始C的 options:3/events:29 共享一个字，真实ILP32对象为32字节；
    本事实仅适用于两个uint32字段的验证模型，不声称原始ABI也是36字节。 *)
Axiom event_size_axiom : sizeof("Event") = EVENT_MEM_SIZE.

(** 已检查模型ABI的顶层偏移实例，保持现有动态对象的4字节对齐前提。
    本可信事实仅补充字段寻址；不把零字节到字段转换、资源重组或生成VC
    当作公理。那些义务仍须证明，冻结的函数契约及Event谓词不在此修改。 *)
Axiom event_top_level_field_offset_axiom :
  forall p, addr_aligned p 4 -> event_top_level_field_offset_ok p.
