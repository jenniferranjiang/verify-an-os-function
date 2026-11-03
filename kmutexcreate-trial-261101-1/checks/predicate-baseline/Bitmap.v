Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import SL.ConAssertion.

Require Import CRTOS_Verify.lib.CrtosRules.

Import ListNotations.

Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.

(**
  [bitmap_highest_priority bitmap] 表示当前 32 位 [PrioCaculate] 的纯结果：
  非零位图返回最高置位下标，空位图按 CRTOS 约定返回 0。

  该定义只描述 [bitmap.c] 的数值语义，不拥有 ready-vector 或任务内存；
  因而放在独立模块中，供临界区内、外的 Assign 规格共同复用。
*)
Definition bitmap_highest_priority (bitmap : Z) : Z :=
  if Z.eq_dec bitmap 0 then 0 else Z.log2 bitmap.

(**
  [leader_zero_count_value byte] 是 [bitmap.c] 中 8 位查找表单项的纯值：
  0 有 8 个前导零，非零字节的结果为 [7 - log2 byte]。
*)
Definition leader_zero_count_value (byte : Z) : Z :=
  if Z.eq_dec byte 0 then 8 else 7 - Z.log2 byte.

(**
  [leader_zero_count_table] 对应 C 全局只读数组 [LeaderZeroCount] 的
  256 个字节，按数组下标 0..255 排列。该列表本身不拥有 C 内存。
*)
Definition leader_zero_count_table : list Z :=
  List.map
    (fun index => leader_zero_count_value (Z.of_nat index))
    (List.seq 0 256).

(**
  [store_prio_lookup_table] 拥有 [PrioCaculate] 实际读取的全局 const 数组。
  调用规格前后原样保留该资源，避免把真实的全局内存读取错误隐藏在
  [emp] 规格中。若以后引入项目统一的只读/分数权限，应以其替换这里的
  线性数组所有权，而不是复制本谓词。
*)
Definition store_prio_lookup_table : Assertion :=
  UCharArray.full
    &("LeaderZeroCount") 256 leader_zero_count_table.

(**
  [clear_flag32 group flag] 精确表示 uint32 [CLEAR_FLAG] 的效果。对补码
  先截取低 32 位，避免 Rocq 无限长负数与 C 无符号补码混淆。
  该纯函数供所有 ready-vector 删除规格共享。
*)
Definition clear_flag32 (group flag : Z) : Z :=
  Z.land group (unsigned_last_nbits (Z.lnot flag) 32).
