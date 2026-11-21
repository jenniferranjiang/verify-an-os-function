# observation_focus delivery

Both assigned top-level VCs and all three aggressive split goals are Qed. Exact controller group-check returned exit 0/status passed on the current candidate.

The observation proof extracts the actual assertS guard from safeExec via wp_bind/wp_assertS, specializes it to the lock observation through LastSeen/RTrans, and uses prop_apply_p to retain os_inv while obtaining the map lookup. The focus entailment is proved inline: unfold only os_inv/dataqueue_inv, derive ready from the existing map invariant, split store_map at the address, and introduce the restoration wand using store_map_merge and the unchanged full global frame. No Prop obligation was assumed. Caller output slots and InsideCritical are preserved.

The field-view splits project the object's existing alignment/nonzero facts and unfold its six typed fields plus explicit two-byte padding and unchanged buffer. sizeof(CHAR) was definitionally normalized. No helper declaration/import/library/spec/trust changes were made; only assigned proof spans changed. Native auto and other groups remain untouched.
