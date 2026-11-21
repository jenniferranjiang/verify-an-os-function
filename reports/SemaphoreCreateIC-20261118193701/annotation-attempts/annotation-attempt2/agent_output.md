# SemaphoreCreateIC annotation retry r2

The r1 VC checker correctly identified an impossible assertion: the generated first resource-cut VC framed out the UShort parameter cell but still required bounds on an arbitrary val_pre. Read the historical manual and old goal, then compared the current generated manual/goal directly.

Changed only the three IC resource conversion assertions: removed redundant 0 <= val <= 65535, retaining val == val@pre and all resources and other facts. The frozen target spec, imported contracts, OC mode, ordinary C, shared headers and libraries remain unchanged. No extra precondition, assumption, or trusted boundary was introduced. No new predicate or loop was added.

Current entail_wit_1 has the same memory conversion and freshness obligations, but neither branch quantifies val_pre or claims an unrelated range. Thus the reported countermodel no longer applies; this is a semantic comparison, not merely missing split names. Bounds are not needed for IdInsertObj or for freeing the allocation. The actual val parameter cell remains UShort in generated safety/call states. After assignment, entail_wit_2_2/entail_wit_3/entail_wit_4 carry the Semaphore.value UShort cell with value val_pre. store_semaphore subsequently owns that same field inside the published DLL, so the final proof can derive its range from actual typed ownership rather than an unsupported pure fact.

controller formal-case-lib-design passed/skipped (absent policy); controller symexec passed and committed all four formal VC files. All current ordinary assertions retain required old/new state, dataqueue_inv and other module frames. Successful generation is not implementation proof; manual VC obligations remain for proving. No generated file or proof was hand edited.

Additional local elaboration check: direct coqc with current _CoqProject flags compiled SemaphoreCreateIC_goal.v successfully; .vo retained.
