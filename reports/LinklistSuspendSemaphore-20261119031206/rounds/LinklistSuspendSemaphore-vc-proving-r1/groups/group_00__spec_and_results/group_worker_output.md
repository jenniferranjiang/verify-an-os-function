# spec_and_results delivery

All five assigned top-level witnesses and four assigned split witnesses are proved with Qed. The four returns use the given suspend/enqueue facts for flag 0 or 1, and use the invalid-flag arm with unchanged state for -10. The derived specification selects exactly the same base-spec parameters; a locally proved emp-to-universal-wand preserves the returned os_inv and derives retval=0 from linklist_suspend_step at flag=1, thereby obtaining linklist_suspend_prio without extra premises.

Only the nine assigned proof spans were changed. No helper declarations, imports, case library, generated files, public contracts, assumptions, or business C were changed. Native auto remains untouched. Development and exact group-check both passed (exit 0 / JSON passed); final exact check recompiled current goal, auto, manual and the assigned-witness wrapper, elapsed 22.202575 seconds. The permitted debug script was used only to inspect a remaining frame/flag match; no incomplete debug token remains in assigned proofs. No MCP source payload or raw compiler invocation was used.

This delivery proves this group's obligations only; main must finalize and continue the full function workflow.
