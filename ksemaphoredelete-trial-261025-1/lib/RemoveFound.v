From Coq Require Import List Sorting.Permutation.
Import ListNotations.

(** 摘除一个指定元素并保持其余顺序；未找到时列表不变。
    地址列表直接比较地址，侵入式节点列表比较完整节点。
    不在关系中重复要求唯一性：各容器的不变量负责排除重复元素。 *)
Definition remove_found_prop {A} (a : A) (before after : list A) : Prop :=
  (~ In a before /\ before = after) \/
  exists prefix suffix,
    before = prefix ++ a :: suffix /\ after = prefix ++ suffix.

Lemma remove_found_absent {A} (a : A) nodes :
  ~ In a nodes -> remove_found_prop a nodes nodes.
Proof. intro H; left; auto. Qed.

Lemma remove_found_at_split {A} (a : A) prefix suffix :
  remove_found_prop a (prefix ++ a :: suffix) (prefix ++ suffix).
Proof. right; exists prefix, suffix; auto. Qed.

(** 摘除节点只缩小列表，逐元素性质随之保持；不需要唯一性或排序前提。 *)
Lemma remove_found_Forall {A} (P : A -> Prop) a before after :
  remove_found_prop a before after -> Forall P before -> Forall P after.
Proof.
  intros [[_ <-]|[prefix [suffix [-> ->]]]] Hforall; [exact Hforall|].
  apply Forall_app in Hforall as [Hprefix Hsuffix].
  inversion Hsuffix; subst. apply Forall_app; auto.
Qed.

(** 唯一性使摘除位置唯一；证明直接比较两个 prefix/suffix 分解。 *)
Lemma remove_found_split_unique {A} (a : A) p q r s :
  NoDup (p ++ a :: q) -> p ++ a :: q = r ++ a :: s ->
  p ++ q = r ++ s.
Proof.
  revert r. induction p as [|x p IH]; intros [|y r] Hnd Heq; cbn in *.
  - now injection Heq as ->.
  - injection Heq as <- Heq. inversion Hnd as [|? ? Hnot Htail]; subst.
    exfalso; apply Hnot. apply in_or_app; right; now left.
  - injection Heq as -> Heq. inversion Hnd as [|? ? Hnot Htail]; subst.
    exfalso; apply Hnot. apply in_or_app; right; now left.
  - injection Heq as <- Heq. inversion Hnd; subst. f_equal. now apply IH.
Qed.

Lemma remove_found_deterministic {A} (a : A) before after1 after2 :
  NoDup before -> remove_found_prop a before after1 ->
  remove_found_prop a before after2 -> after1 = after2.
Proof.
  intros Hnd [[Habs <-]|[p [q [-> ->]]]]
    [[Habs' <-]|[r [s [Heq ->]]]]; auto.
  - exfalso; apply Habs. rewrite Heq. apply in_or_app; right; now left.
  - exfalso; apply Habs'. apply in_or_app; right; now left.
  - eapply remove_found_split_unique; eauto.
Qed.

(** 计算式 remove 仅作为构造见证；关系本身不依赖计算或相等判定。 *)
Lemma remove_found_remove {A} eq_dec (a : A) nodes :
  NoDup nodes -> remove_found_prop a nodes (remove eq_dec a nodes).
Proof.
  intro Hnd. destruct (in_dec eq_dec a nodes) as [Hin|Habs].
  - apply in_split in Hin as [p [q ->]].
    pose proof (NoDup_remove_2 _ _ _ Hnd) as Habs.
    rewrite remove_app. cbn. destruct (eq_dec a a); [|contradiction].
    rewrite !notin_remove by (rewrite in_app_iff in Habs; intuition).
    apply remove_found_at_split.
  - rewrite notin_remove by assumption. now apply remove_found_absent.
Qed.
