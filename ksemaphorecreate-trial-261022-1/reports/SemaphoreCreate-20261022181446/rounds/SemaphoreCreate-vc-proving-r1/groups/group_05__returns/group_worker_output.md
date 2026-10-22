# returns group delivery

Completed all three assigned return witnesses and their three aggressive split goals.

- Success selects the atomic branch and the explicit fresh-address/minimum-free-ID normal transition to the published state.
- ID exhaustion selects the atomic branch and its full-manager failure transition, returning -5 with unchanged locked abstract state.
- Allocation failure selects the direct return -5 branch, preserving the entry LastSeen state.

The only new helper, `atomic_normal_return__returns`, derives a return refinement from an existing rely transition and the atomic command normal relation using `highstependret_derive`. It introduces no axiom or helper C implementation claim. All existing spec, statement, predicate and seed declarations are unchanged.

Formal group-check finished with exit code 0 and JSON status passed, elapsed 77.898547 seconds. It recompiled this group library, goal, normalized auto, manual and wrapper; 193 base artifacts were reused. All writing has stopped for main finalization.
