# Publication invariant: annotation gap

The assigned `proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial`, parent `proof_of__SemaphoreCreate_entail_wit_5`, targets the publication assertion at `annotated_C/src/_SemaphoreCreate.c:226`.

The explicit premises include `sem <> 0`, alignment, ID bounds/minimum-free-ID, the old `os_world_wf`, semaphore context and freshness. Spatially they include the linked manager, `DllInsertedCut`, `store_node_self_linked` for the new pending head, the old `dllseg_shift_rev` tail, value/padding, and unchanged OS components.

However, closing `os_inv` requires `semaphore_inv` and thus `store_dll` for the management list and each object's pending list. The definition in `shared_candidates/dll.v:66` requires the head, first and last node addresses to be nonzero and `dll_nodes_nonzero` for the list. These pure facts are absent from the current publication premise:

- `&(sem # "Semaphore" ->ₛ "pend_list") <> 0` is needed to fold the new empty pending list. `NodeStorage` contains it, but `InitDoubleLinkList`'s contract at C:106–108 returns only `store_node_self_linked`, whose definition deliberately contains just two pointer cells.
- `&(sem # "Semaphore" ->ₛ "link") <> 0` is needed for the new management-list node. `DllInsertAfterCut` contains this fact before the call, but `DoubleLinkListInsertNodeAfter` at C:111–114 returns `DllInsertedCut`, which contains only four pointer cells.
- `dll_nodes_nonzero (map semaphore_link_node (os_semaphores locked))` is needed when rebuilding the old management-list tail. `dllseg_shift_rev` at `shared_candidates/dll.v:51` does not retain that fact from the earlier `store_dll`.

The global list sentinel is nonzero by the existing variable-address axiom, but that does not establish any of the three facts above. The payload's `sem <> 0` does not imply that its separately addressed subobjects are nonzero in the current abstract address model. `SemaphoreLayout` is only a defined proposition, not an accepted theorem or an explicit premise. Pointer-cell validity cannot repair this: `isvalidptr` in QCP `CommonAssertion.v` permits address zero (`x >= 0`). Even an empty old list leaves the new pending-head and new link obligations unresolved.

Attempted route: inspect the exact split premise, unfold the target `os_inv`/`semaphore_inv`/`store_semaphore`/`store_dll`, and trace the candidate nonzero facts through the local list contracts. Also checked whether typed pointer validity or existing field layout facts recover the dropped facts; they do not. The manager/map equality and world-invariant helper work cannot establish these independent address facts.

Required repair boundary: annotation/spec review for the private zeroed object's field nonzero facts and their preservation at the C:198 assertion and across the C:221–224 helper calls; preserve the old management-list `dll_nodes_nonzero` when exposing its shifted tail. Changes must be justified from the accepted allocation/layout model and carried to C:226. Do not add assumed layout axioms or weaken `store_dll`. No source, accepted predicate, spec, or unassigned proof was edited by this worker.

The group library remains the exact seed. A first optional development check diagnosed an extra tactic after a goal already closed by `LLM_pre_process`; that extra tactic was removed. Publication spatial proof remains explicitly aborted, because the missing facts are an annotation gap rather than a proof-search failure.

The second development check reached the incomplete top-level routing proof and reported a Goal_apply instantiation failure. That unfinished routing attempt was removed and left Abort. The two unvalidated partial-solve attempts were likewise left Abort. Only the pure entail_wit_5 split, which the development compiler passed before reaching the later failure, remains Qed. No group-check success is claimed.
