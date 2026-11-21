# DataqueuePeak VC checking r1

## Outcome

Completed the independent structural scan and split-first analysis for the current canonical manual. Seven top-level VCs and ten split goals are covered by three independent groups. No definite annotation/spec/dependency countermodel was found. This is a proof plan, not an implementation proof or final-check result. No canonical or debug source was modified; no raw compiler or MCP call was made.

## Structural Blocker Scan

All seven top-level statements were scanned, with the three no-split whole goals checked first. The lock-return obligation retains Crtos_RTrans(before,observed), the original safeExec, os_inv, the lock token and the two output slots. Its q existential can be obtained from the assertS entry property applied to the actual observed state and its os_inv, rather than from an unsupported pointer fact. The map resource can be split and restored with the same value.

The nonempty-slot obligation contains both dataqueue_ready and front<>rear. Ready provides positive capacity, in-range indices, exact slot length and the initialized current FIFO interval. These facts support a Some entry at front; this needs real modulo/list reasoning. The output conversion has a valid first disjunct: both Some and None predicates imply unknown storage. It is unnecessary to prove the alternative known-value disjunct.

The two exit obligations retain all six queue fields, explicit padding, output cells/predicates, the buffer or its slot-and-wand representation, and the store_dataqueue-to-os_inv wand. Current field values are explicitly equated to q projections. The success DataElem address uses sizeof(DataElem), while the slot definition uses stride 8; the existing authorized layout equation supplies this bridge. No alignment or local-address premise has been silently discarded. Both exits restore exactly observed; no post-state mutation is invented.

## Annotation Comparison Review

The handoff lists no prior annotation comparisons. Independently checked the current assertions' premise chain: entry lookup/ready are obligations of entail_wit_1; field nonzero/alignment and equalities are established by which_implies_wit_1; front Some and slot ownership are established by which_implies_wit_2; concrete element fields by which_implies_wit_3; output ownership conversion by which_implies_wit_4. The exits consume those facts and return both nested wands. None of the `*_obligation : Prop` definitions is treated as an assumed lemma. No new model assumption is planned.

## Split-first judgments and proof modes

All split judgments were completed before selecting any top-level mode. In manual order:

| Parent | Split suffix | Judgment |
| --- | --- | --- |
| entail_wit_2 | split_goal_1 | provable: reflexive guarantee |
| entail_wit_2 | split_goal_2 | provable: nonempty atomic return refinement |
| entail_wit_2 | split_goal_spatial | provable: slot/buffer/object wand restoration |
| entail_wit_3 | split_goal_1 | provable: reflexive guarantee |
| entail_wit_3 | split_goal_2 | provable: empty atomic return refinement |
| entail_wit_3 | split_goal_spatial | provable: unchanged object/output restoration |
| which_implies_wit_1 | split_goal_1 | provable: stored object alignment |
| which_implies_wit_1 | split_goal_2 | provable: stored object nonzero |
| which_implies_wit_1 | split_goal_spatial | provable: definition expansion with padding |
| which_implies_wit_3 | split_goal_spatial | provable: slot expansion and authorized stride equation |

Consequently entail_wit_2, entail_wit_3, which_implies_wit_1 and which_implies_wit_3 select aggressive_pre_process. Their detailed strategies target only the ten splits. The remaining no-split whole goals entail_wit_1, which_implies_wit_2 and which_implies_wit_4 are provable and select LLM_pre_process. No split is individually dispatched.

## Common Proof Patterns

1. **Borrow and restore:** split the authoritative store_map or store_array at the known key/index, retain the missing-key/index resource and all pure facts, introduce a wand whose antecedent is exactly the extracted resource, then merge it unchanged. This is an inline proof, not use of an unproved focus/slot obligation.
2. **Read-only atomic refinement:** consume the original assertS/atomic safeExec, choose observed using the existing rely relation, witness the locked command with after=observed and the map q, then derive the final return at LastSeen(observed). Empty chooses None; nonempty chooses the already observed Some e.
3. **Field views:** definitions preserve every field and the [6,8) padding. Only the existing sizeof(DataElem)=8 ABI equation bridges element pointer arithmetic. Some caller output values may be forgotten for stores; empty-branch output ownership is unchanged.

## VC Deltas

- entail_wit_1 establishes map existence/ready and a whole-object wand while preserving the initial safeExec and output frame; it is the only map extraction entry.
- entail_wit_2 restores the extra front-slot wand before the object wand, then packages fresh output Some values. Its pure transition witnesses a nonempty result.
- entail_wit_3 has no slot extraction; the buffer and optional outputs stay unchanged, and its transition witnesses None.
- which_implies_wit_1 is only the queue-field definition view, including alignment, nonzero and padding.
- which_implies_wit_2 needs the substantive nonempty FIFO arithmetic/list proof before array borrowing. For capacity one the nonempty premises are inconsistent, not a special assumed initialized slot.
- which_implies_wit_3 has a single spatial stride/field bridge.
- which_implies_wit_4 chooses its first disjunct and destructs the two option predicates; no concrete value is invented for None.

## Grouping Decisions

`observation_focus` (difficulty 4, two top-level/three splits) keeps assertS/map borrowing and queue fields together. `slot_views` (difficulty 4, three top-level/one split) owns nonempty FIFO reasoning, array borrowing, element and caller-output views. `return_restore` (difficulty 3, two top-level/six splits) owns the shared abstract return derivation and nested wand restoration. This avoids combining all map/list/refinement work into one tail group. All groups are independent and have no helper declarations, because case-lib policy is absent. Any local auxiliary fact must be proved within the assigned manual spans.

## Risks or Blockers

No definite blocker. Higher-risk proof work is the positive modulo/FIFO head argument in which_implies_wit_2 and spatial-preserving extraction of the assertS entry property in entail_wit_1. The return refinement must use the actual nrm relation, retaining the environment observation, rather than treating before and observed as equal. Difficulty or an unproved inline fact does not make these obligations a blocker. Native auto remains untouched; the 18 generator auto lemmas are not counted as handwritten Rocq proofs.
