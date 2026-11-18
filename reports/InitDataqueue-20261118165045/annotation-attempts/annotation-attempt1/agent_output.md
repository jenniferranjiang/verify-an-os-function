# Native auto/manual restoration

No C, public spec, header or library edit was made. The frozen approved map-based specification and all existing body annotations are reused. The do-while(0) is a single-execution failure wrapper, not an iterative algorithm.

Ordered checks: formal-case-lib-design passed/skipped (absent policy); controller symexec passed, exit 0, generated and committed the four canonical files. No generated file was manually edited.

Native output contains 51 auto lemmas, each generator-produced Admitted; manual contains 12 top-level obligations plus 6 split lemmas. Goal and goal_check files are byte-identical to the previous completed version (goal SHA-256 08149ed04ce353e9b0b8b29f0332f2bc0e185a2183099f2621d11aef311c60ae; goal_check SHA-256 8c5aa0b7ea47c706aa6319a9f7f42b2cf47babd2085e5a770040054b37b713e6). Every auto/manual lemma statement, compared after whitespace normalization, equals the same-named statement in the previous completed manual; the two sets are disjoint and their union equals its 69 declarations (63 top-level and 6 split).

The change restores generator ownership of its automatic results; it does not claim that those 51 generated Admitted entries contain Rocq proof terms. They are accepted according to the user's explicit native QCP solver-trust instruction. The remaining manual obligations still require actual proof reuse and formal controller checks. The previous complete manual is retained in /tmp/crtos-verify-native-auto-baseline-y9mhvzna/InitDataqueue_proof_manual.v and the previous done run; this annotation owner did not copy proof bodies or edit manual files.

Imports/prelude and all VC statements are unchanged; only allocation between native auto and manual files is restored. No Axiom, new predicate, or strengthened public Require was introduced. No standalone case lib was created.
