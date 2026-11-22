From Coq Require Import ZArith.
From SimpleC.SL Require Import Mem IntLib.
From compcert.lib Require Import Integers.
Require Export CRTOS_Verify.lib.common.StructFieldOffsetAxiom.
Local Open Scope Z_scope.

(** malloc 成功地址的公共纯条件，原为 msgqueue_block_address。
    保留当前 32 位 ABI 的非空、块范围和对齐条件；不拥有内存，不描述
    allocator 元数据，也不单独保证 size 非负或内容已初始化。
    使用者须另外持有对应字节/对象资源；NULL 只属于分配失败或 free 的空分支。 *)
Record valid_malloc_addr (p size : Z) : Prop := {
  malloc_addr_positive : 0 < p;
  malloc_addr_bound : p <= Int.max_unsigned - size;
  malloc_addr_aligned : addr_aligned p ALIGN_SIZE
}.
