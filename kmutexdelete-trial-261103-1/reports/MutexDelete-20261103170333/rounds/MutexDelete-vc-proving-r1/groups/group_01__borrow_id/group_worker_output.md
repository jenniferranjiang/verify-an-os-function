Assigned witness: proof_of__MutexDelete_which_implies_wit_3.

The proof selects the object from the current mutex_delete_drained witness and uses In/in_split to expose prefix/current/suffix. Address uniqueness is derived by induction over the actual management DLL: a repeated address would require two copies of the holder pointer field, contradicting dup_store_ptr. ID uniqueness is extracted from the original store_idmanager's idbuckets_ok/idlist_ok. Both facts are obtained with prop_apply_p, preserving the original heap. Membership in the derived ID list establishes query=true.

The field-view helpers locate mutex_idnode current in the actual derived buckets, focus its payload through the ID bucket DLL, and extract only its UShort ID cell. The spatial wand retains the bucket links, manager fields and bitmap, other payloads, and all other OS modules. Returning the exact field/value restores the same os_inv sg st. The current object's other scalar values are not taken from any earlier snapshot.

Adapted only generic DLL/bucket/cell focus proof blocks from the read-only historical SemaphoreDelete_lib.v reference supplied by main. All adapted helpers use __borrow_id; the Mutex bucket membership proof and os resource framing were rechecked against current definitions. No Semaphore-specific conclusion is used.

The group-development command completed with exit 0 and JSON status passed (40.69937 seconds). Formal group-check subsequently completed with exit 0 and JSON status passed (54.451785 seconds).

After group-check was already running, an additional interactive recheck of the same completed top-level theorem was rejected by automatic approval review: it cited a prior user restriction against generating/running VC/C implementation verification, and said generic continuation did not clearly revoke it. No new proof call or workaround was attempted after this rejection. Main was notified to resolve the authorization context. This is an approval issue, not an annotation gap.
