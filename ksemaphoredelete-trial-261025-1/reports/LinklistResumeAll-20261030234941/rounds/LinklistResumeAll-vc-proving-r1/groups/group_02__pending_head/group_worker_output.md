# pending_head annotation gap

Status: blocked by the redundant target-nonzero conjunct in proof_of_LinklistResumeAll_which_implies_wit_3.

## Completed proof work

The copied manual proves proof_of_LinklistResumeAll_which_implies_wit_1, proof_of_LinklistResumeAll_which_implies_wit_2_split_goal_spatial, and proof_of_LinklistResumeAll_which_implies_wit_2. The group library preserves its seed and adds only fully proved helpers with suffix __pending_head: dllseg_payload, dll_payload, pending_borrow, pending_desc, task_alignment.

Witness 1 focuses the selected semaphore payload, borrows the sentinel next field, and constructs the restoration wand. Its nonempty branch derives first-link/sentinel inequality by duplicate-pointer ownership contradiction, not by list syntax. Witness 2 returns the borrowed field using derivable1_wand_elim2.

Witness 3's permitted proof span contains the exact progress to the sole remaining goal target <> 0, ending with Abort. It extracts descriptor registration and SUSPEND from the semaphore DLL, obtains alignment from task_world_wf, and preserves/reconstructs the full os_inv. All other conjuncts close.

## Existing premises and missing conclusion

The current whole VC has remaining = target :: rest, next = sched_link_of target, semaphore_pending_nodes sem current (map sched_link_node remaining), and os_inv sg current. These entail a registered descriptor, SUSPEND status, target alignment, and the same pending-list relation and os_inv. They do not supply target <> 0.

The frozen task_world_wf record explicitly does not add address nonzero conditions (TaskInv.v:40–42), and store_published_task/store_task_descriptor do not assert a nonzero base. The DLL enforces nonzero embedded links, not nonzero containing task bases. StructFieldOffsetAxiom gives sched_link_of 0 = 16 and stack_point at address 0 under the valid alignment of 0. The QCP isvalidptr definition accepts x >= 0; store_ptr uses that condition and four/eight byte ownership. Both sequential and concurrent mstore definitions use single_byte_mem without a nonzero-address premise. Thus field ownership/layout does not establish the omitted base restriction.

Rocq MCP independently compiled the following concrete boundary facts:
- addr_aligned 0 ALIGN_SIZE;
- &(0 # "TaskDescriptor" ->ₛ "stack_point") = 0;
- sched_link_of 0 = 16;
- isvalidptr 0 /\ valid_ptr_value 0.

These are a precise local counterexample to the proposed ownership/layout implication, not a claim that a full global os_inv countermodel has been constructed. The exact current witness was reduced to target <> 0 with every other requirement discharged.

## Repair boundary

The affected annotation is annotated_C/src/LinklistResumeAll.c:148–158, specifically target != 0 at line 153 in the which-implies assertion starting line 151. Remove only that redundant conjunct and regenerate VCs. CONTAINER_OF_TASK_SCHED requires alignment and sched-link equality, and the selected KTaskWakeup contract requires its ID/lookup/pending relation and os_inv; neither call currently requires target <> 0. No frozen predicate or called contract needs strengthening. This worker made no annotation/spec/predicate edit.

## Validation

Proof iteration used mcp__rocq_mcp__rocq_compile with the exact current goal Definitions copied unchanged into source-only candidates and the current seed library/prelude. The final combined source returned success: true: the completed witnesses and all five helpers end in Qed; the witness-3 diagnostic intentionally ends in Abort and prints only target <> 0. The null-layout/pointer boundary probe also returned success: true. No interactive pet retry was used.

The required exact controller group-check ran and exited 1 with status failed, first_failure category structure/kind group-structure, solely because proof_of_LinklistResumeAll_which_implies_wit_3 contains Abort. This is not a successful group acceptance and is expected for this annotation-gap delivery. Earlier development/debug preparation likewise rejected the initial unfinished spans before staging, so no staged build workspace was used.

The added helper source was scanned for forbidden lemmas/tactics and contains none. Only the assigned proof spans and assigned group library were changed; generated statements, prelude, unassigned proofs, library seed, frozen predicates/specs, and sibling files were not changed.
