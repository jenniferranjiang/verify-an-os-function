# safety_2 delivery

All six assigned top-level witnesses and the two aggressive-route split witnesses were proved independently in Rocq MCP using current goal source definitions, not stale canonical .vo. MCP states 9 -> 32 -> 37 -> 51 finish with proof_finished=true.

Witnesses 7/8 use constant bounds; 9/10/11 use explicit contradictory branch facts. Each split of witness12 extracts the actual UShort cell range using store_ushort_range, then proves NodeNumber_pre-1 within signed INT bounds by lia. No nonzero capacity premise or new ABI/trust fact was needed. Parent witness12 uses aggressive_pre_process then Goal_apply for the corresponding two split lemmas.

Only the eight assigned proof spans were changed. Controller group-check exited zero with status passed, recompiling current goal, auto, manual and group wrapper; elapsed 35.97 seconds. No whole-function completion is claimed. Terminal report written last; stopped writing.
