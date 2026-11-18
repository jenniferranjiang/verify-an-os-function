# Map-based InitDataqueue annotation

Read the current map-refactor and design records, canonical C and frozen handoff. No C, header, predicate or contract changes were needed. The existing annotation cuts already use DataQueueAbs, dataqueue_map lookup, and store_dataqueue(p_queue,q). The single-execution do-while(0) wrapper has no iterative invariant.

The approved concrete ILP32 dataqueue_layout_abi is available through the canonical library; no byte-to-fields, array, map, function-effect or obligation proposition was assumed by this owner. Existing TrustBase/IRQ and whitelist001 boundaries remain unchanged; reused contracts are not promoted into body proof targets.

Ordered checks: formal-case-lib-design passed/skipped (case-lib policy absent); symexec passed with exit0 and committed all four current VC/dataqueue/InitDataqueue files. Spot inspection confirms generated goal types use DataQueueAbs, dataqueue_map and store_dataqueue, rather than the invalidated list representation. Statement-preserving auto routing promotes obligations to the manual responsibilities. No manual proof was edited or claimed complete. No duplicate formal case lib was created. This is VC generation only; independent VC checking/proving and final-check remain required.
