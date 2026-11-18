# InitDataqueue successful publication transition

Assigned manual declaration: `proof_of_InitDataqueue_entail_wit_1` (whole-goal LLM_pre_process route). Only this copied manual proof span was edited. No imports, global library, canonical C, generated goal/auto/check or other witness was edited.

The proof uses the user-authorized dataqueue_layout_abi, obtains NodeNumber's unsigned-short range from its stored cell, and eliminates allocation-size and Create argument casts constructively. It derives a single DataElem slot from eight undefined bytes, then proves an arbitrary-length array conversion by induction using CharArray splitting and the real two-field slot predicate. The exact fields, padding and array are folded to store_dataqueue.

Map freshness follows from actual ownership: if the authoritative map already contains this address, store_map_split yields a second front cell. Both front stores are forgotten to undefined ushort cells and the generic exclusive-store lemma gives False. No lifecycle assumption is added. Both semaphore effects provide created-object references; second allocation's free-ID query excludes the first created ID. The resulting empty FIFO is ready and its ID association holds.

A local constructive publication lemma uses MapLib missing_i conversion/equivalence/merge to insert the map cell. All other modules are framed. The task_world_wf and service publication records are rebuilt with their unchanged fields rather than assumed definitionally equal at changed whole OS states. This restores the original global os_inv with the new queue component.

The proof reconstructs the exact successful init-phase effect, proves its hs_eval atomic step from the actual IRQ observation to the published state, and applies highstepbind_derive to the existing safeExec hypothesis. This selects the already-proved successful branch. No unproved obligation Prop is used as a theorem, and no new axiom, admitted proof or trusted interface is introduced.

Interactive development genuinely used Rocq MCP with workspace /home/xinra/crtos-verify and explicitly threaded state IDs. The complete assigned VC reached Qed at state438 with proof_finished=true. The successful tactic chain was written into the allowed manual span, omitting Show commands. Earlier debugging also used the prescribed controller coq-debug. The group-check controller result below is the formal group validation evidence; interactive Qed alone is not whole-run completion.

Controller exact group-check: passed, exit code 0 and JSON status passed, 53.79 seconds; goal, auto, manual and the assigned-witness wrapper were compiled. This group does not establish any other Init witness, any callee body, parent check, final-check or done status.
