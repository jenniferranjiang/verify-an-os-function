# safety_1_10 r2 delivery

Reused ten accepted r1 proof spans from safety_1/safety_2, after comparing current goal definitions against annotation-attempt2/before. All proofs use explicit `LLM_pre_process ltac:(lia || int_auto)` and have no hypothesis-name dependence. Added alignment in downstream statements does not remove or weaken any premise; the existing integer closer is rechecked on the current goal. Per-target comparison is in proof_reuse.md.

Only the ten assigned proof spans were changed. Removing these spans from the candidate and current canonical manual gives identical remaining text. No imports, helpers, generated statements, unassigned spans, Axiom, or admitted assigned proof were added.

The exact controller group-check returned exit 0 and status passed, elapsed 27.736237 seconds, recompiling current r2 goal, auto, manual and group wrapper. This validates all ten assigned current VCs. No redundant MCP replay was performed; the current-file controller compilation is the verification evidence.

Stopped writing after terminal report; main may finalize.
