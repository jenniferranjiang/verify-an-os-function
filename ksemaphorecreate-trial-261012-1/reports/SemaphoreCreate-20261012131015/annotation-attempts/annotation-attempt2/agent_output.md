# _SemaphoreCreate annotation r2

Accepted inputs are those in evidence/accepted-revisions.json: source-r2-0c50c37013e9, predicate-nonzero-candidate-fe8c4261db5c and spec-r6-ae22a04e2c95. Main activated the independently reviewed two-argument sizeof normalization before this owner resumed. This owner did not perform another C normalization or alter a frozen contract.

## Edits

IMPL-20261016-BODY-01: changed the source annotation to `Import Coq Require Coq.Program.Basics`. Actual regenerated goal/auto/manual preambles now contain `Require Coq.Program.Basics.` without Import; the body continues to reference qualified Basics.const. This avoids requesting the conflicting composition notation identified in the reviewer's exact-preamble probe.

IMPL-20261016-BODY-02: replaced the invalid bare data/ptr Extern names and all body uses with the actual getData/getPtr projections from shared-candidate/arm32le/dll_abs.v. Generated registry obligations now use map getData and getPtr/getData in the embedded Semaphore.link relation. No alias, wrapper, parameter or axiom was introduced.

The existing registry list witness still has exact ordered data correspondence, every member's actual embedded link address, dll_nodes_nonzero, and the owned DLL.dllseg_shift_rev remainder. These are conclusions of entail_wit_4, not assumed from Extern declarations. entail_wit_5 still must reconstruct the whole published invariant from those resources. The payload remains Basics.const store_semaphore_body, definitionally the existing registry payload. No ordinary C token or Require/Ensure was changed by this attempt; exact comparison against the accepted sizeof candidate found all nine contracts identical and non-annotation C identical.

## Required old/new VC comparison

Read the supplied historical manual and its sibling goal in verification_runs/SemaphoreCreate-20261012131015/annotation_history/annotation-attempt1/after/VC, and directly compared them with the regenerated current manual and goal. The two pure obligations remain in both generated goal and manual under the same names; they were neither deleted nor symbolically discharged.

1. proof_of__SemaphoreCreate_partial_solve_wit_1_pure: old conclusion was sizeof("Semaphore") = 32. Current conclusion is 32 = 32. Antecedent is unchanged: the same entry nesting bound, four scalar local cells and SemaphoreOutsideCritical(sg,hs,before). There are no existential/witness changes. Exact text comparison of the full definitions succeeds after replacing only the old size expression by 32.
2. proof_of__SemaphoreCreate_partial_solve_wit_2_pure: old conclusion was 0 = 0 and sizeof("Semaphore") = 32. Current conclusion is 0 = 0 and 32 = 32. Antecedent is unchanged: the same nonzero allocation facts, nesting bound, actual store_sem_allocated ownership, four local cells and outside resource. There are no existential/witness changes. The same exact single-expression comparison succeeds.

Thus the missing formal-size premise is resolved by the already accepted source normalization: the actual malloc and memset size arguments are both (x_size_t)32 and their unchanged contracts still require 32. This does not prove sizeof_alias_type "Semaphore" = 32 and adds no premise asserting it. The generated pure proofs remain unfinished for the proving phase. Corresponding aux definitions likewise differ only by the size expression, and the unsuffixed pure -> aux definitions retain their roles; no false classification was extended to those implications.

The normalized literal arguments also generate safety_wit_4 and safety_wit_12 with `32 <= INT_MAX` and `INT_MIN <= 32`. These new literal representability obligations remain present. The manual now has 43 top-level obligations and 13 split goals, versus 41 and 13 previously; no count was used as a deletion target.

## Semantic and resource preservation

Natural-language output and the unchanged Rocq/C Ensure still agree: allocation failure returns -5 with original outside ownership; ID exhaustion frees the complete zeroed unpublished object and returns -5 at the allowed rely state; success publishes the fresh object with the minimum free ID, requested value, empty wait queue, and exact task/scheduler/IRQ preservation. The caller entry domain remains nest < 65535.

All three return definitions are textually unchanged. entail_wit_1, entail_wit_2_1, entail_wit_2_2 and entail_wit_3 are unchanged; entail_wit_4 and entail_wit_5 are identical after the projection name correction. Their pure premises, spatial resources and witnesses were not strengthened or weakened. Failure cleanup, task views, incremented scheduler view, IRQ prefix, registry nodes and object padding retain their original obligations. There are no lexical loops or new predicates; the case library stays absent.

## Checks and limits

Executed only the two exact handoff controller invocations. The formal-case-lib-design check exited 0 with status passed and skipped=true under absent policy. Symexec exited 0 with status passed and returncode 0, and committed all four generated files. Generated files were changed only by this symexec invocation; manual proof files were not edited or proved.

The actual regenerated goal has NOT yet been compiled/typechecked by this owner. Main explicitly directed completion under the existing handoff and assigned real generated-goal compilation to the next independent VC-checking controller coq-debug / subsequent proving checks. The reviewer's successful diagnostic copy is not evidence that this actual new goal compiles. IMPL-20261016-BODY-01/02 have source fixes and regenerated outputs, but their independent machine-checked closure awaits that phase. Annotation comparison result 'resolved' concerns the precise missing-size premise, not finished Rocq proofs or final implementation verification.
