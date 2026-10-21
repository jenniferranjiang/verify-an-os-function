# Return refinement completed

Proved all three assigned return witnesses and their split goals using the required aggressive / LLM preprocessing routes.

- Success: select the atomic branch; choose the observed state `locked` using `Crtos_RTrans before locked`; instantiate the success relation with `sem`, its nonzero/alignment/freshness facts, and the minimum-free-ID premise; return from the published state's rely closure.
- ID exhaustion: select the atomic branch and the full-ID normal transition, return `-5` while preserving `locked`.
- Allocation failure: select the immediate `ret (-5)` choice branch, retaining `LastSeen before`.

Used the existing `highstependret_derive` normal-transition rule. Added no helpers and preserved the group library seed and all unassigned proof spans. No annotation or semantic input changes were needed.

Validation: controller `coq-check --target-kind group-check --group return_refinement` exited 0 with JSON `status: passed` (72.905668 seconds). Forbidden lemma / tactic scan passed.
