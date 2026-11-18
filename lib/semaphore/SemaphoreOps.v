Require Import Coq.ZArith.ZArith Coq.Lists.List.
From SimpleC.SL Require Import Mem.
Require Export CRTOS_Verify.lib.semaphore.SemaphoreState.
Import ListNotations.
Local Open Scope Z_scope.

(** uint16形参的通用转换仍按65536取模。crtoslatest的公开semaphore入口
    先检查下述SemIdInvalid范围，Delete仅对通过检查的值调用此转换。
    128..65535仍属合法表示范围，是否登记由ID manager查找决定。 *)
Definition semaphore_query_id (id : Z) : Z := id mod 65536.

(** 对应crtoslatest semaphore.c中的SemIdInvalid；检查发生在Delete加锁前。
    高于UINT16_MAX的int32输入直接返回，不能再别名到低16位的其他对象。 *)
Definition semaphore_id_invalid (id : Z) : bool :=
  orb (Z.ltb id 0) (Z.ltb 65535 id).

(** 只更新这个已发布对象的等待序列；基址、ID、value 和其他对象均保持。
    地址用于追踪同一个仍存活的对象；不声称跨释放后的地址永久唯一。 *)
Definition semaphore_set_pending (p : addr) (pending : list addr)
    (sems : SemaphoreState) : SemaphoreState :=
  map (fun s => if Z.eq_dec s.(semaphore_addr) p then
    {| semaphore_addr := s.(semaphore_addr); semaphore_id := s.(semaphore_id);
       semaphore_value := s.(semaphore_value); semaphore_pending_addrs := pending |}
    else s) sems.

(** 已注销的对象从管理顺序中移除，其余对象次序不变。
    此纯更新不释放内存；原对象的私有字段资源必须由调用者带到 x_free。 *)
Definition semaphore_unpublish (p : addr) (sems : SemaphoreState) : SemaphoreState :=
  filter (fun s => negb (Z.eqb s.(semaphore_addr) p)) sems.
