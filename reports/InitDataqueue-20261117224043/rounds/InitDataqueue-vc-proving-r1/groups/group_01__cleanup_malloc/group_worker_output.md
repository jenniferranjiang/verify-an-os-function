# Malloc failure cleanup VC proof

Both assigned VCs, proof_of_InitDataqueue_entail_wit_2_1 and proof_of_InitDataqueue_entail_wit_2_2, independently reached Qed in Rocq MCP (states 59 and 117). The same checked script handles positive-request allocation failure and zero-request failure without imposing a positive capacity premise.

The proof selects the third result alternative and the exact private object dataqueue_constructed n 0 (-1) (-1), with no semaphore references. It folds all six fields and padding into store_dataqueue with an empty buffer, retaining InsideCritical and os_inv. The malloc-failure phase has an actual hs_eval witness, and highstepbind_derive transports the existing safeExec through that phase. The continuation Y is fun _ states => X (-1) states. Standard wp_bind/wp_ret reasoning connects cleanup followed by return -1 to that continuation and proves the universal return bridge. No cleanup-entry assumption is invented: it is inherited through the original safeExec residual.

Only the two assigned proof spans were modified. No statement, import, helper file, generated goal/auto/check, global library, or trust boundary was changed. No unproved obligation proposition or sibling theorem is used. Controller group-check result is recorded below after process completion.

Controller group-check exited 0 with status passed in 39.66 seconds, compiling current goal, auto, copied manual and exact group wrapper. Both assigned proofs are complete; this is a group result, not the entire InitDataqueue workflow.
