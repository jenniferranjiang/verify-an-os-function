From Coq Require Import ZArith Bool Lia.

Local Open Scope Z_scope.

(** 全局抽象状态只保存语义状态；非法状态仍表示可读取的已初始化字节。 *)
Inductive TaskStatus : Type :=
| TSK_INIT | TSK_READY | TSK_RUNNING
| TSK_SUSPEND | TSK_CLOSE | TSK_INVALID.

Definition TaskStatus_eq_dec (a b : TaskStatus) : {a = b} + {a <> b}.
Proof. decide equality. Defined.

Definition task_status_eqb (a b : TaskStatus) : bool :=
  if TaskStatus_eq_dec a b then true else false.

Lemma task_status_eqb_eq : forall a b,
  task_status_eqb a b = true <-> a = b.
Proof. intros; unfold task_status_eqb; destruct (TaskStatus_eq_dec a b); intuition discriminate. Qed.

(** 以下数值只用于具体字节的表示层，不能写入 TaskSchedMemberAbs。 *)
Definition TASK_INIT : Z := 0.
Definition TASK_READY : Z := 1.
Definition TASK_SUSPEND : Z := 2.
Definition TASK_RUNNING : Z := 3.
Definition TASK_CLOSE : Z := 4.
Definition TASK_STAT_MASK : Z := 7.

Definition decode_task_status (raw : Z) : TaskStatus :=
  match Z.land raw TASK_STAT_MASK with
  | 0 => TSK_INIT
  | 1 => TSK_READY
  | 2 => TSK_SUSPEND
  | 3 => TSK_RUNNING
  | 4 => TSK_CLOSE
  | _ => TSK_INVALID
  end.

(** 连接 C getter 的数值返回与语义状态；INVALID 不选择任意固定编码。 *)
Definition task_status_matches (status : TaskStatus) (code : Z) : Prop :=
  match status with
  | TSK_INIT => code = 0
  | TSK_READY => code = 1
  | TSK_RUNNING => code = 3
  | TSK_SUSPEND => code = 2
  | TSK_CLOSE => code = 4
  | TSK_INVALID => 5 <= code <= 7
  end.

Lemma task_status_mask_range : forall raw,
  0 <= Z.land raw TASK_STAT_MASK < 8.
Proof.
  intros. change (0 <= Z.land raw (Z.ones 3) < 2 ^ 3).
  rewrite Z.land_ones by lia. apply Z.mod_pos_bound; lia.
Qed.

Lemma decode_task_status_iff : forall raw status,
  decode_task_status raw = status <->
  task_status_matches status (Z.land raw TASK_STAT_MASK).
Proof.
  intros raw status. pose proof (task_status_mask_range raw).
  unfold decode_task_status.
  remember (Z.land raw TASK_STAT_MASK) as code.
  assert (Hcases : code = 0 \/ code = 1 \/ code = 2 \/ code = 3 \/
    code = 4 \/ code = 5 \/ code = 6 \/ code = 7) by lia.
  destruct Hcases as [-> | [-> | [-> | [-> | [-> | [-> | [-> | ->]]]]]]];
    destruct status; simpl; intuition (try discriminate; lia).
Qed.

Lemma decode_task_status_mask : forall raw,
  decode_task_status (Z.land raw TASK_STAT_MASK) = decode_task_status raw.
Proof.
  intros; unfold decode_task_status.
  rewrite <- Z.land_assoc, Z.land_diag. reflexivity.
Qed.

(** RMW 的低位语义：任意新字节的低三位决定结果，高位留在表示层。 *)
Lemma decode_task_status_update : forall new old,
  decode_task_status (Z.lor new (Z.land old 248)) = decode_task_status new.
Proof.
  intros; unfold decode_task_status, TASK_STAT_MASK.
  rewrite Z.land_lor_distr_l, <- Z.land_assoc.
  change (match Z.lor (Z.land new 7) (Z.land old 0) with
    | 0 => TSK_INIT | 1 => TSK_READY | 2 => TSK_SUSPEND
    | 3 => TSK_RUNNING | 4 => TSK_CLOSE | _ => TSK_INVALID end = decode_task_status new).
  rewrite Z.land_0_r, Z.lor_0_r. reflexivity.
Qed.

Lemma task_status_update_preserves_high : forall code old,
  0 <= code < 8 ->
  Z.land (Z.lor code (Z.land old 248)) 248 = Z.land old 248.
Proof.
  intros code old Hcode.
  assert (Hcases : code = 0 \/ code = 1 \/ code = 2 \/ code = 3 \/
    code = 4 \/ code = 5 \/ code = 6 \/ code = 7) by lia.
  rewrite Z.land_lor_distr_l, <- Z.land_assoc, Z.land_diag.
  destruct Hcases as [-> | [-> | [-> | [-> | [-> | [-> | [-> | ->]]]]]]];
    change (Z.lor 0 (Z.land old 248) = Z.land old 248); apply Z.lor_0_l.
Qed.
