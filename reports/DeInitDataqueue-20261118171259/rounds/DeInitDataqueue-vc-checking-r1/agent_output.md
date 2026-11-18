# Native DeInit manual checking

Outcome: current manual has 10 top-level goals and 12 split declarations. The complete goal file is byte-identical to the pre-restoration completed snapshot; all 22 current manual declaration statements match the same names in that snapshot after whitespace normalization. Native auto has 35 generated results, retaining generator Admitted per the user's requested QCP solver boundary. They are not claimed as Rocq-closed manual proofs and are not added to this plan.

## Structural blocker scan

All current addresses and scalar bridges are present. The owned-buffer view preserves fields and padding while splitting null/non-null allocation. IRQ observation keeps os_inv in its whole left alternative. Delete transitions retain original q/field identities and the intermediate state. Four cleanup refinements retain both conditional delete effects, structure fields, alignment and the original continuation. No whole-goal missing-resource countermodel was identified.

## Annotation comparison review

There are no supplied annotation comparisons. This task changes only native auto/manual partition: current goal and goal-check are byte-identical to the snapshot; C/spec/lib are unchanged. No new premise has been introduced. The auto results remain generated solver results rather than hand-written proofs.

## Split-first decisions

In manual declaration order:

- `proof_of_DeInitDataqueue_entail_wit_1_split_goal_1`: not provable as a pure split. It omits os_inv, while cleanup_entry only yields the quiescent condition through an entailment from os_inv. The safeExec/RTrans facts alone do not supply that resource.
- `proof_of_DeInitDataqueue_entail_wit_1_split_goal_2`: not provable as a pure split. It omits os_inv, while cleanup_entry only yields the quiescent condition through an entailment from os_inv. The safeExec/RTrans facts alone do not supply that resource.
- `proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_1`: provable. Delete removes semaphore members by filtering and preserves the dataqueue map, so existing quiescence for the other ID is preserved.
- `proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_2`: provable. Saved field equality and the sign guard reduce the retired blank-ID projection by Z.leb.
- `proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_3`: provable. Saved field equality and the sign guard reduce the retired blank-ID projection by Z.leb.
- `proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_1`: provable. Delete removes semaphore members by filtering and preserves the dataqueue map, so existing quiescence for the other ID is preserved.
- `proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_2`: provable. Saved field equality and the sign guard reduce the retired blank-ID projection by Z.leb.
- `proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_3`: provable. Saved field equality and the sign guard reduce the retired blank-ID projection by Z.leb.
- `proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_1`: provable. Saved field equality and the sign guard reduce the retired blank-ID projection by Z.leb.
- `proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_2`: provable. Saved field equality and the sign guard reduce the retired blank-ID projection by Z.leb.
- `proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_1`: provable. Saved field equality and the sign guard reduce the retired blank-ID projection by Z.leb.
- `proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_2`: provable. Saved field equality and the sign guard reduce the retired blank-ID projection by Z.leb.

## Proof modes and common patterns

The four entail_wit_4 parents use aggressive_pre_process because all their splits are provable. Entail_wit_1 uses LLM_pre_process and the whole left alternative; retain os_inv and extract cleanup_entry from safeExec/assertS at the observed state. Its unused two pure split blocks remain Abort. The four entail_wit_5 goals have no splits and use whole LLM: select final=after on nonnegative data branches and final=middle otherwise, construct the actual conditional delete effect, fold the retired structure with empty buffer, and apply atomic/high-step refinement. The which-implies whole goal uses LLM: forget slot values, convert pointer/uint cells into two four-byte blocks, merge and induct on the array; preserve the structure frame. Existing concrete ABI facts justify sizes/offsets, not memory ownership. The statement-only obligation Props are not assumed.

## VC deltas and grouping

No goal statement changed. Previously generated auto declarations are simply no longer in manual. The plan precisely covers all 10 current top-level witnesses in manual order with their established proof modes; it has no helper or group dependency. One group of 10 is within the hard limit 12. This narrow restoration has exact existing complete proofs for every selected target, so splitting by former exploratory proof patterns would only repeat compilation and acceptance, without reducing mathematical discovery risk. No new heavy helper is planned; formal_case_lib is absent.

## Risks and checks

The native automatic results retain the QCP solver trust boundary explicitly requested by the user. Coq compilation with auto Admitted is not evidence that those results have Rocq proof terms. Actual current manual proofs still require group check, parent check and final-check. Canonical files were read-only. Only Show was inserted into the designated debug copy. The prescribed controller coq-debug result will be recorded below.

Prescribed local controller coq-debug completed with exit code 0 and JSON status passed; elapsed_seconds 26.078811. The current generated declarations and Show overlay loaded successfully. This is checking evidence, not completed manual proof acceptance.
