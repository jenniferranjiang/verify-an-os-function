Completed the six assigned proof spans and added event_retired_forget__reclaim to the group library, preserving the seed.

The helper unfolds EventRetired and EventRaw, uses the existing ID-node address equality and node-field address lemmas, forgets the ID/options/events values and each self-linked pointer value, and converts exactly the original two padding bytes to undef. Nonzero and alignment facts are retained. No allocation provenance or additional byte resources are assumed.

The four partial-solve witnesses retain their own resched/continuation branch and close without unfolding OutsideCritical. The top-level which-implies witness uses the assigned aggressive split route.

Forbidden lemma/tactic scan had no matches. The exact group-check completed with process exit code 0 and JSON status passed.
