# Outcome

Current goal/prelude actually loaded through controller coq-debug: exit 0, status passed, elapsed 21.622548s. All eight Show points (five top-level and three splits) loaded. This establishes typing/loadability, not proof completion. Five top-level obligations are suitable for proving; no known semantic blocker.

# Structural Blocker Scan

Scanned all five top-levels, prioritizing the no-split which_implies 1 and 3. The former has nonempty waiting, concrete pending relation, list_pre=head and os_inv; its first/rest witnesses and head cell are present through the actual semaphore DLL. The latter has exact head task identity in the pending relation and os_inv, which supplies task publication, descriptor/ID memory and ID registration. Neither requires an unsupported current/@pre equality. The two restoration goals already hold the exact cell and same-value wand. Return receives the concrete wakeup transition, task lookup and unchanged before pending relation. No countermodel or missing resource found.

# Annotation Comparison Review

The reported r1 gap was a malformed generated binder, not an absent semantic premise. In the current first view all occurrences use list_pre, with Coq list remaining a type. The local bridge refers to the unchanged C parameter; generated antecedents retain the original list_pre=pending_head equality and nonempty/pending facts. No extra logical premise appears. Actual coq-debug now compiles goal and auto and loads the complete debug manual, independently confirming the claimed name repair. Related restoration and call facts use that same head address. The new resource-extraction conclusions remain unproved obligations assigned below.

# Full Split-First Decisions

Before selecting any top-level mode, all generated splits were inspected in declaration order:

1. return_wit_1_split_goal_1: provable. The explicit pending relation yields the object and projected pending sequence; the actual callee postcondition supplies task lookup and wakeup_semaphore_head. These are exactly the existential components of semaphore_resume_head_effect.
2. which_implies_wit_2_split_goal_spatial: provable. Exact head-next pointer cell and wand eliminate to os_inv.
3. which_implies_wit_4_split_goal_spatial: provable. Exact UShort ID cell and wand eliminate to os_inv.

# Proof-Mode Decisions

In canonical manual order: return_wit_1 is aggressive; which_implies_wit_1 has no split and is whole LLM; which_implies_wit_2 is aggressive; which_implies_wit_3 has no split and is whole LLM; which_implies_wit_4 is aggressive. No top-level proofability fallback was needed for a failed split.

# Common Proof Patterns

Read-only borrow: focus one actual owned object/cell under os_inv, retain all remainder as frame, and introduce a wand that folds the exact original state after receiving the same cell value. ID registration and alignment come from existing task/ID representations and invariant facts, not arbitrary pointer assumptions. Restoration is direct wand elimination after representation normalization. Pure effect packaging projects getData through map sched_link_node, then uses actual transition premises; it does not need os_inv as an extra premise.

# VC Deltas

which_implies_wit_1 uses the read-only borrow pattern at the semaphore pending head and selects first/rest by destructing nonempty waiting. which_implies_wit_3 uses it at the published task ID and selects desc.tdId, retaining ID-manager correspondence. which_implies_wit_2/4 are the corresponding direct restores. return_wit_1 uses pure effect packaging with the callee's exact before/after. No library helper is planned because formal_case_lib is absent.

# Grouping Decisions

pending_head_view contains comparison current plus its related restore (2 tops, 1 split), goes first and retains the coupled semaphore/task alignment extraction context. task_id_view contains ID registration/borrow and restore (2 tops, 1 split), independently uses the same unchanged invariant. resume_result is a deliberately independent final-result group (1 top, 1 split), pure existential effect packaging; it need not share heavy spatial reasoning. Difficulty 4/4/2 reflects representation work rather than a missing lemma. All groups are independent and cover each top-level exactly once; no sibling output or reuse plan was used.

# Risks or Blockers

No blocker. Spatial focus/reassembly and task ID correspondence are the main proof effort; precise typed-cell normalization and map projections may require explicit steps. No new assumption, public contract change, native generated edit or helper declaration is proposed. Canonical sources remain read-only. Only Show was inserted into the authorized debug manual; current plan/notes/report are the remaining writes.
