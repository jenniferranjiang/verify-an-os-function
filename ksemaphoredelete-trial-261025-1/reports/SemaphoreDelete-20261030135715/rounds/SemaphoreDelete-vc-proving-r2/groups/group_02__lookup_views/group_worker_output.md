# lookup_views r2 delivery

Reused the verified r1 lookup_views proofs and helper closure after confirming all three assigned goal definitions are unchanged and the annotation-library seed differs only in whitespace. Historical files were not modified.

The proofs retain the original invariant resources, reverse the semaphore bucket map/filter to identify the selected object, derive nonzero base from the DLL payload, return the unchanged manager, and reconstruct os_inv.

Validation:
- Rocq MCP `rocq_compile`: success true for the complete candidate with current seed, helpers, verbatim current assigned goals and assigned proofs.
- Controller exact `group-check`: actual exit 0, status passed, 80.101255 seconds.

Only r2 assigned proof spans and suffixed helper closure were restored; statements, seed and unassigned proof spans remain fixed. No new assumptions or forbidden tactics.
