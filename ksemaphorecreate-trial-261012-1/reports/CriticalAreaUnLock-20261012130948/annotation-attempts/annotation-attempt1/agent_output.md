# CriticalAreaUnLock annotation r1

Signature: `void CriticalAreaUnLock(x_base lock)`.
Preconditions: the frozen caller IRQ handler validity, guarantee to the saturating-decremented state, and the matching inside-critical token plus complete OS invariant.
Output: the outside-critical view at `semaphore_nest_decrement(after)`, preserving the approved frozen contract.
Rocq relation and C Ensure are the same `SemaphoreOutsideCritical sg hs (semaphore_nest_decrement after)` interface; no new predicate or contract is introduced.

The global count cell is hidden in the accepted OS invariant. A necessary assertion before the branch exposes the exact UShort cell, CrtosOSValid and the accepted unchanged frame. The unchanged lock parameter is explicitly bridged. Removed the original call-site where annotation so the standard call matcher must establish the preserved trusted contract.

No lexical loop. No C executable tokens or frozen contracts changed. Formal case library remains absent.

First symbolic pass: resource-shape failure at `EnableLocalInterrupt` (line 34 in that revision). The complete branch state retained the IRQ token, guarantee, CrtosOSValid, precise updated UShort cell and unchanged frame, but the opaque SemaphoreOSInvariant could not be rebuilt by the builtin matcher. Added a necessary pre-call assertion to reassemble the accepted invariant at the saturating-decremented state. This exposes separate positive and zero branch entailments for proof and preserves every resource.

Final controller checks: formal-case-lib-design passed (correctly skipped because policy absent); symexec passed with returncode 0 and committed all four generated files. The generated interface requires seven witness declarations: safety; invariant split; positive-branch and zero-branch reassembly; return; call pure facts; call auxiliary entailment. All seven are present in the controller-generated manual worklist including originally auto-generated witnesses. The branch reassembly goals retain CrtosOSValid, the exact written count (positive branch uses `unsigned_last_nbits(n - 1, 16)`), and unchanged frame; no path or resource was omitted. Generated placeholders are pending proof-owner work, not verified results.

Self-check: no frozen Require/Ensure edits; no executable C edits; no new predicates; no loop; no remaining call where; only two necessary assertions; no generated file manually edited. Annotation completion does not claim VC proofs complete.
