# DeInit native auto/manual restoration

No C, frozen function/callee contract, header, global lib or case-lib change was made. The existing annotated body is reused exactly. This function has no lexical loops, and no new predicate or case library is introduced (policy absent).

The prescribed formal-case-lib-design check returned passed/skipped. Controller symexec returned exit 0/status passed and committed all four generated artifacts. Generated files were not hand-edited; proof development remains the later proving owner's responsibility.

Native generator division is restored: proof_auto contains 35 generated lemmas, all ending in generator-produced Admitted; proof_manual contains 10 top-level obligations and 12 split declarations. At explicit user direction these automatic outputs remain in auto under the QCP solver trust boundary. They are not claimed as hand-written or Rocq-closed proof terms, and were not promoted into manual.

Compared with the pre-restoration completed snapshot `/tmp/crtos-verify-native-auto-baseline-y9mhvzna/DeInitDataqueue_*.v`, goal.v and goal_check.v are byte-identical. Every current auto/manual declaration has the same name and whitespace-normalized statement as the old completed manual; the current sets are disjoint and their union equals the old 57-declaration set. No obligation was removed or weakened. Current C is byte-identical to this attempt's before snapshot.

The prior complete proof is retained in the snapshot and done run DeInitDataqueue-20261118121138 for later exact manual-proof reuse. This delivery establishes regeneration and contract preservation only, not final-check completion of the new run.
