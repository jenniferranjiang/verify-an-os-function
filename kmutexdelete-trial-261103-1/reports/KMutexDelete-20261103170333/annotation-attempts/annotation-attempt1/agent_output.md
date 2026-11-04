# KMutexDelete annotation delivery

Signature: void KMutexDelete(int32 id). Preconditions and output remain the reviewed assumed_environment contract: the caller provides OutsideCritical and safeExec for abs_mutex_delete; negative IDs and lookup misses return, while hits delegate _MutexDelete under A1/A2, preserving the same continuation. All target and caller-local contracts remain frozen byte-for-token; no shared library, header, reused input, or executable C statement was changed.

Added a type-range by-local annotation, explicit lock result binding, manager split/restore which-implies views, found-object extraction, and complete known where parameters. The range follows the real signed-int32 storage; the incoming ID still undergoes the uint16 conversion at IdGetObj. There is no loop and no extra scheduling step. The one case-local spatial definition mutex_lookup_frame combines the existing non-Mutex frame with the unchanged Mutex management DLL and mutex_context; it neither duplicates manager ownership nor asserts lifetime safety.

Checks in the required order passed on this attempt:

1. Controller formal-case-lib-design: passed, returncode 0.
2. Controller symexec: passed, returncode 0; generated VC family published, including promoted unfinished auto obligations. Exactly one driver was used for the command.
3. Controller formal-case-lib: passed, returncode 0.

Read the current generated goals without editing or proving the manual. The manager=NULL branch is infeasible by the existing addr_of_LE_var_not_zero property, not a new assumption. The miss branch retains idmanager_query=false; the found branch explicitly retains current object membership, actual low16 ID, base/id-node correspondence and mutex_delete_live, with os_inv recovered before Unlock. Their safeExec continuation obligations remain visible for the proof groups. Split/restore and manager-found membership are ordinary spatial proof obligations; no new axiom or admitted helper was supplied. First attempt has no failed-VC comparisons.

Generated artifacts were changed only by controller symexec. No manual proof was written. Terminal report is now completed; stop writing for main finalize-delivery.

## Acceptance repair 1

The freeze extractor recognizes Require Import blocks but not Require Export. The added Require Export was therefore grouped into the frozen three-line seed import block, causing a false removed-import finding. Changed only the newly added line to Require Import CRTOS_Verify.lib.KMutexDelete; the original seed import/scope block remains token-identical. No frozen declaration or contract changed and no unfreeze was performed. All three required checks again passed in order (design/lib, symexec, post-lib); generated VC statement hashes are unchanged. Terminal report rewritten last; stopped for main acceptance.
