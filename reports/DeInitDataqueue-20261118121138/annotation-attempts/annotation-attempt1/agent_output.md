# DeInitDataqueue annotation delivery

The frozen init_cleanup contract and every caller-local callee contract are unchanged. No executable C, global lib or shared header changed. Policy absent remains absent; no case lib or body copy was created. All generated files were published only by controller symexec.

The first symexec failed reading p_queue->base because store_dataqueue was opaque. Added a which-implies view exposing six scalar fields, the two-byte padding, nonzero/alignment facts, and either no buffer (base=0) or positive-length original array bytes. Conversion of known/unknown element slots back to bytes remains a genuine VC using the approved concrete ABI; no obligation Prop is assumed as a theorem.

After DisableLocalInterrupt, a full assertion preserves the parameter @pre bridge, saved IRQ value, RTrans, original safeExec and owned queue. It derives both semaphore_delete_quiescent conditions from the reviewed assertS cleanup observation condition. After the first conditional Delete, a merge assertion retains its exact conditional effect (or unchanged state), scalar fields/padding, original safeExec/RTrans and saved IRQ value; it also establishes the second ID's quiescence in the actual intermediate state. The last assertion folds the retired object and derives the safeExec return continuation plus GTrans before returning IRQ resources. These are proof obligations, not new assumptions or strengthened entry requirements. No loop exists.

Two intermediate tool errors were repaired locally: Given must name the callee's actual existential `after`, and symbolic field-equality resources need the established && syntax rather than ambiguous arithmetic `*` precedence. No semantics changed for either repair.

Ordered checks: formal-case-lib-design passed/skipped because policy absent; final controller symexec exit0/status passed and committed all four VC/dataqueue/DeInitDataqueue artifacts. This is annotation/VC generation only, not an implementation proof. Manual sources were not hand-edited; generated auto-routing preserves statements and promotes unsupported auto obligations to proof responsibilities.

Important downstream proof work includes slot-array-to-byte conversion, assertS observation extraction, preservation of second-ID quiescence through the first deletion, both conditional deletion effects, retired-field fold and atomic safeExec refinement. Existing IRQ trust boundary and default review whitelist001 remain unchanged.
