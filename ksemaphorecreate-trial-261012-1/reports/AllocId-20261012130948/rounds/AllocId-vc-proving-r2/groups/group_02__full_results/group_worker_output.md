Completed both assigned witnesses using the required LLM_pre_process route.

- proof_of_AllocId_return_wit_2: proves idmanager_full from the completed index prefix and the scanned entry bits. The non-255 guard excludes offset 8; all valid ids lie in the completed prefix or below the current offset.
- proof_of_AllocId_return_wit_3: proves idmanager_full from index = end and id_div8_lt_quot_ceil8.
- Both proofs select the returned -1 branch and reconstruct the original store_idmanager with the unchanged bytes and buckets. Qualified accepted OSHeap bridge lemmas and locally proved pointer/uchar-array equalities preserve the heap carrier and resources.

No predicate, spec, declaration, unassigned proof, or helper library was changed. Historical assigned proofs had only Abort and were not reused.

Validation: forbidden lemma/tactic scan clean; controller group-development passed with exit 0 and JSON status passed; controller group-check passed with exit 0 and JSON status passed. Native controller validation is authoritative; the optional Rocq MCP service uses an incompatible OCaml version and was not used for acceptance.
