Completed only the seven assigned proof spans: three parent entailment witnesses and their four strategy split goals. All end in Qed. Statements, declaration order, prelude and unassigned proof tokens remain unchanged. No helper/library/import was introduced; accepted predicate sources were read only.

The invariant is split with SemaphoreOSInvariant_split_nest, preserving the InsideCritical token and frame. For the positive branch, validity supplies the uint16 upper bound and the guard supplies positivity, making unsigned_last_nbits(n-1,16) equal to n-1. SemaphoreOSInvariant_merge_decrement rebuilds the exact invariant. For the zero branch, validity and n<1 imply n=0, and the same merge lemma handles the source no-write path. Parent dispatch uses aggressive_pre_process followed only by corresponding Goal_apply calls, in spatial-then-pure order.

Execution audit: the first group-development exec printed only its output field, accidentally losing its live session ID. A second identical development check was started before the first finished. Both are confirmed terminated in tool_calls.jsonl. The first failed resolving the staged goal module; overlapping checks may have caused the transient staging failure, but this is not asserted as an established infrastructure defect. The second reached the proof and exposed reversed Goal_apply branch order. A parameter-instantiation retry and a debug attempt reproduced that tactic failure. After fixing dispatch order, a sequential group-development and the final group-check each exited zero with status passed. No live check remains.

Checks (controller journal):

- `f3e4681c7deb4cb6838c0b9be894eb61`: coq-check group-development, exit 1, status failed.
- `1dbbd95d850f4f0e8b3c592d0c99ec5c`: coq-check group-development, exit 1, status failed.
- `8cd3a468e0184c6db0646f98d6d30642`: coq-check group-development, exit 1, status failed.
- `5c9018034958474ca9d4c90df2e4187b`: coq-debug None, exit 1, status failed.
- `05ce045cde5f43d3afd32fc661b858b3`: coq-check group-development, exit 0, status passed.
- `ab289dfc74d2413bb5bbd470f774b312`: coq-check group-check, exit 0, status passed.

Final exact group-check passed. Proof-local screening found all seven Qed and no prohibited tactic, added axiom or admission; the exact controller check also accepted the current structure and proofs.
