# Annotation delivery: _SemaphoreCreate

The accepted function contracts and all shared formal inputs remain unchanged. No ordinary C statement was changed. The only source edits are logical name imports/declarations and body annotations; pre-existing call-where instantiations were removed because the explicit resource assertions now support inference. The existing Given current binding is retained. There are no lexical loops and no new predicates or case library.

## Accepted natural-language and Rocq contract correspondence

Signature: int32 _SemaphoreCreate(uint16 val).
Precondition: the caller owns SemaphoreOutsideCritical(sg, hs, before), with entry scheduler_lock_nest(os_scheduler(before)) < 65535. The uint16 input is represented by its actual local cell; the frozen Require was not strengthened.
Output: malloc failure returns -5 and the original outside resource; ID exhaustion returns -5 and an allowed rely state whose manager is full, after releasing the whole zeroed object; success returns the minimum free ID, publishes a nonzero object with val and an empty pending queue, and preserves the exact task/scheduler state and caller IRQ prefix. These are the three unchanged Ensure disjuncts using SemaphoreRely, idmanager_full, idmanager_min_free_id, SemaphoreGuarantee and SemaphoreOutsideCritical. No second Rocq spec or weakened alternative was introduced.

## Body assertions and resource boundaries

Five necessary assertions expose resources QCP cannot automatically unfold or recombine:

1. After CriticalAreaLock, split the invariant into task views, incremented scheduler view, ID manager, and registry, and split the private object into detached ID plus its registered-private remainder.
2. On ID failure, rebuild the whole zeroed private object for x_free and the unchanged critical invariant and guarantee for unlock.
3. On success, expose the value, pending and registry link cells and exact padding while preserving manager, registry, task/scheduler and IRQ resources.
4. Before registry insertion, expose the head-next and successor-prev cells and the existing DLL.dllseg_shift_rev remainder.
5. Before unlock, rebuild the complete published invariant and both required guarantees; the unlock postcondition connects directly to the frozen return contract.

The registry payload is the existing Coq.Program.Basics.const store_semaphore_body, definitionally the payload already used by store_sem_registry. There is no invented payload predicate or new formal declaration. The list witness nodes is constrained by map data nodes = os_semaphores current, by each node's exact embedded Semaphore.link address, and by DLL.dll_nodes_nonzero. These facts and the exposed spatial remainder are conclusions of the generated entail_wit_4 assertion obligation, not new Require assumptions. entail_wit_5 must reconstruct the published invariant, including fresh-address validity and all untouched resources, from those actual resources. The earlier temporary existential payload encoding was replaced by const before final generation.

QCP treats SemaphoreState as an opaque type name even though its accepted Rocq definition is list SemaphoreObject. The Extern map declaration specializes the existing map to DL_Node SemaphoreObject -> SemaphoreObject and result SemaphoreState. Generated Rocq uses ordinary map; no conversion axiom or new alias was added.

The global manager nonzero fact has the existing official foundation CNotation.addr_of_LE_var_not_zero. Embedded object nonzero facts use accepted semaphore_object_addresses, and registry successor nonzero uses the accepted store_dll metadata. No nonzero fact is inferred merely from field-cell ownership.

## Symbolic diagnostics and fixes

- Initial symbolic-execution/symexec-error at IdInsertObj: opaque SemaphoreOSInvariant and store_sem_zeroed_private did not expose the callee's manager and detached-ID resources. Fixed by assertion 1 with exact residual resources.
- Next execution reported missing local id at assignment: assertion 1 had omitted the live local slot. Fixed by preserving id = 0; the failure assertion preserves id = -1.
- Next execution reported Prefill Evaluation failed at DoubleLinkListInsertNodeAfter: the registry head cells were still opaque. Fixed by assertion 4 using the existing reverse-shift DLL segment.
- Next execution rejected list B versus opaque SemaphoreState at map(data,nodes). Fixed by the definitionally valid monomorphic Extern signature described above.
- Subsequent execution passed. After simplifying payload to Basics.const and removing call-where annotations, the final design check and symbolic execution both passed again.

## Checks and remaining proof work

The exact handoff formal-case-lib-design invocation exited 0 with status passed and skipped=true, as required by absent case-library policy. The final exact handoff symexec invocation exited 0 with status passed, returncode 0, and committed all four generated files. No manual generated file was edited or proved. No unsupported direct coqc/RocqMCP or alternative workflow was used.

The generated return_wit_1, return_wit_2 and return_wit_3 preserve respectively success publication, ID failure cleanup, and allocation failure. Impossible combinations of the helper disjunction and C branch guard remain explicit obligations. The full caller prefix, task views, scheduler view, registry remainder and private padding remain represented until their corresponding reassembly obligation.

This is annotation completion, not implementation proof completion: generated manual placeholders are controller output for the subsequent proving phase. Current goals, return branches, resources and witnesses were inspected; independent proof checking must still discharge all obligations, including const elaboration, registry reconstruction, freshness, bounded nesting roundtrip, and frame preservation. First attempt has no failed-VC retry inputs and therefore vc_comparisons is empty.
