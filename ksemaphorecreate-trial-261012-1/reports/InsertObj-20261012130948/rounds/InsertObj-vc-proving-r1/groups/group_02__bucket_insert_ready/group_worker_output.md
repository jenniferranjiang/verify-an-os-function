# bucket_insert_ready annotation gap

Affected assigned VCs: `proof_of_InsertObj_entail_wit_3_1` and `proof_of_InsertObj_entail_wit_3_2`, generated from the Assert beginning at `annotated_C/src/InsertObj.c:128`, specifically `&(idnode->link) != 0` at line 130.

Both original whole-goal branches retain idnode nonzero, the UShort id field, and both uninitialized link fields. They require the separate embedded link address to be nonzero. The accepted `store_sem_id_detached` definition in `lib/SemaphoreRep.v:21` has only three field resources and does not assert link nonzero. Thus no already available detached pure premise can simply be carried through the earlier assertions.

The attempted proof follows the assigned LLM_pre_process route. `prop_apply_p (valid_store_ushort (&(idnode_pre # "IdNode" ->ₛ "id")) id)` succeeds. Its lower bound is `&(idnode_pre # "IdNode" ->ₛ "id") >= 0`. The required conclusion remains `&(idnode_pre # "IdNode" ->ₛ "link") <> 0`. The native group-development diagnostic printed both expressions unchanged after simplification. The formal notation uses `eval_addr_expr`, declared as a Parameter in `SimpleC.SL.CNotation`; current imported sources provide no accepted equality identifying these expressions with idnode_pre and idnode_pre + 4. Consequently the concrete ILP32 offset argument in the proving hint is unavailable in these formal premises.

The other proposed ingredients were inspected: the empty reverse segment and carrier emp conversion, and `DLL.dllseg_to_dllseg_shift_rev` for the nonempty segment. They do not establish the missing link-address fact. No absence of heap resources or DLL-shape premise is claimed here.

Repair boundary: revise the upstream annotation/spec or accepted representation to supply and preserve the embedded link nonzero fact through the assertions at lines 84, 101, and 128, or provide an independently justified formal layout bridge. Adding the fact only to the final or preceding assertion merely moves the same proof obligation earlier. Workers cannot alter accepted predicates, shared libraries, C annotations, or VC statements.

Checks: two exact group-development invocations exited 1 on the attempted address implication; the second stdout records the abstract lower-bound and target expressions above. No group-check success is claimed. The final copied manual retains only the successful preprocessing and UShort fact extraction before Abort in each assigned witness. Protected split blocks and all unassigned proof tokens are unchanged. No helper, import, axiom, forbidden lemma, or shared source was added. This report is the terminal annotation-gap result for this group.

This is a formal-premise gap, not a claim of a C source bug. The physical arm32le C layout can place IdNode.link at offset 4; the current Rocq expressions remain abstract, and that physical fact has not been established as a theorem available in this proof context. No unreviewed layout bridge is assumed.
