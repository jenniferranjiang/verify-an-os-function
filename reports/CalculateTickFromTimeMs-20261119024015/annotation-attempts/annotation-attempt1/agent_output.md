# CalculateTickFromTimeMs annotation delivery

Signature: x_ticks_t CalculateTickFromTimeMs(uint32 ms).
Preconditions: frozen Require emp; actual parameter ownership is UInt. No public input restriction was added.
Output: the existing reviewed tick_from_time_ms(ms), with emp. This preserves the current 100Hz conversion, uint64-before-multiplication, minimum one tick, and original remainder 5..9 branch. It is not the incompatible old32-bit multiplication contract.

Initial symexec succeeded, but its return witnesses lost the UInt parameter range when local cells were released; arbitrary Z inputs admitted out-of-domain truncation counterexamples. A plain Assert or identical typed-cell borrow/return still let the generator cancel that cell before the range proof, so those intermediate candidates were not accepted as resolved.

The final annotations borrow the actual UInt cell into the existing native store_uinteger (Z.to_nat 4) 4 view while extracting 0<=ms<=UINT_MAX, then return the cell. CommonAssertion defines store_uint as precisely store_uinteger 4 4; these are representation views of the same resource, not new memory predicates or layout assumptions. Extern declarations only expose this existing interface and its existing nat parameter conversion. The current generated range witness actually retains the UInt cell in its premise; all four current return witnesses retain the range facts. The two view conversions remain real manual obligations. No frozen function spec, executable code, shared library, or assumption changed. Native auto/manual division remains unchanged.

Diagnostics also included a temporary semicolon inside Assert and a Z/nat literal mismatch in the native view argument; both were corrected to supported syntax. All intermediate candidates were superseded by the final successful symexec.

Checks: controller formal-case-lib-design passed (absent policy, skipped); final symexec passed and committed all four VC files. GCC -m32 syntax check passed. Same-flag preprocessed executable tokens match the actual pre-attempt baseline. Six manual top-level obligations and six split goals remain (four functional returns plus two input-cell view entailments); 15 native auto obligations are left as generated. No manual/auto/goal/check was hand-edited, no raw Coq compilation or MCP source transmission was used. No case-lib exists or was created. Main must run dependency typecheck, independent VC checking and complete workflow/final-check; annotation success is not implementation proof.
