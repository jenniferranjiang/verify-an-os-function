# Native InitDataqueue manual analysis

Outcome: current manual contains 12 top-level VCs and 6 splits. No new structural blocker. Native auto contains 51 generator-owned declarations with Admitted; these are the user-accepted QCP automatic solver boundary, not newly claimed Rocq-closed proofs. They are not reassigned to manual.

## Structural blocker scan

Checked all 12 current goals. Resource addresses retain p_queue_pre, NodeNumber_pre and observation/held-state bridges. Success publication has os_inv after_3 plus private array, fields and padding; it must use whole-goal LEFT alternative, since the right fallback expects pre-publication lookup. Four cleanup goals retain all fields, allocated bytes where applicable, current os_inv and the continuation bridge. Return goals contain retired-object resources or the published lookup and OutsideCritical. No missing resource/current-pre bridge was found.

## Annotation comparison review

There are no current annotation comparisons. This task only restores native auto/manual routing. Current goal.v is byte-identical to the pre-restoration snapshot. All 18 current manual declaration statements are identical to their same-named statements in the completed snapshot. The local memset view explicitly retains addr_aligned p_queue 4, already derived from DataqueueStorage; the prior missing-alignment issue is not present. Approved dataqueue_layout_abi supplies only layout relations.

## Split-first decisions

All six splits were assessed before choosing parent modes, in current manual order:

- safety_wit_12 split1: provable; the actual UShort store implies n<=65535, hence n-1<=INT_MAX.
- safety_wit_12 split2: provable; the same store implies n>=0, hence INT_MIN<=n-1.
- which_implies_wit_1 split1: provable; DataqueueStorage contains the 4-byte alignment pure fact.
- which_implies_wit_1 split2: provable; DataqueueStorage contains nonzero address.
- which_implies_wit_1 spatial: provable; storage owns 20 bytes, ABI gives sizeof DataQueue=20.
- which_implies_wit_2 spatial: provable; explicit alignment and 20 zero bytes split into 2/2/2/2-padding/4/4/4 byte regions; approved offsets and existing scalar-zero lemmas yield the fields with padding retained.

Therefore safety_wit_12 and both which-implies parents use aggressive_pre_process. All nine other top-level VCs have no generated splits and use LLM_pre_process on the whole entailment. Proof modes match the currently identical established statements, but later current-wrapper compilation is still required.

## Common proof patterns and strategies

The strict group plan provides strategies for every formal target. Publish: derive UShort bounds, eliminate byte-length truncation, fold complete queue, derive vacant map key from separation, combine two create effects, insert the object and establish the high-step continuation. No missing obligation Prop is treated as a theorem. Cleanup: choose the constructed private queue, exact refs and current held/after states, retain bytes, build the failed init phase, and derive the unit cleanup continuation plus return(-1) bridge. Returns: choose the existing published state or retired private object and apply the explicit final-continuation bridge. Byte views and safety splits use the premises described above.

## VC delta

Only routing changed: 51 previously promoted declarations are back in generator auto. Goal and goal_check source bytes are unchanged; no C/spec/lib/header change. The current manual is the exact remaining 18 declarations, including 6 splits, from the prior full proof. This comparison does not label generator Admitted as Rocq proof.

## Grouping

One group of 12 top-level VCs (6 attached splits), within the handoff hard maximum 12, as explicitly requested by main for this proof-preserving restoration. The usual 2–6 grouping is unnecessary here: all exact target statements and completed proof spans already exist, the task is extracting the remaining native manual subset and rechecking one current file. Splitting would multiply identical compilation and restoration work without enabling new mathematical development. No helper library exists and no helper is planned. No dependency or added declaration fields.

## Risks and checks

Canonical sources remain read-only. Only Show was inserted into the allowed debug copy. Local controller coq-debug completed with exit code 0 and JSON status passed (25.073559 seconds); Show displayed the current safety split, and current goal/auto/manual declarations loaded successfully. This is declaration/type loading, not implementation proof. A subsequent proving owner must keep the native prelude (including proof_auto import), insert only exact existing hand-written target proofs, and leave generator-owned auto untouched. Auto solver trust and existing ABI/callee assumptions remain explicit; this checking delivery is not final-check.
