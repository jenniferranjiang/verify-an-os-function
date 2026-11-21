# range_views blocked delivery

The assigned copied manual contains candidate proofs for the two UInt/store_uinteger view entailments and their aggressive top-level dispatches. They only unfold the existing store_uint definition and cancel the identical cell; no statement, prelude, import, unassigned span, library, or generated file was changed. These candidates are not reported as verified.

The exact controller group-check failed before compiling the manual: the staged CalculateTickFromTimeMs_goal.v line 3 reports `Scope sac is not declared`. Evidence is the last tool_calls.jsonl entry, call_id e7dc0afe8a3140c2b85b24b705739744, with complete coqc argv and stderr. The generated prelude imports VCPrelude and TickConversion, but TickConversion imports only ZArith. Main identified that CommonAssertion's scope is inside the parameterized DerivedPredSig module type and the no_crules configuration requires the project's existing concrete rules instance. This is an annotation import dependency gap, not a new memory/pure premise or a proven cache failure.

Repair in the canonical C annotation: import existing CRTOS_Verify.lib.common.CrtosRules so regenerated obligations and manual load the already adopted CRTOS rules. Do not change generated imports by hand, add a new assumption, or rebuild unrelated caches to conceal the missing dependency. After the workflow annotation retry and independent checks, adapt/recheck these candidate proofs against the actual new prelude/goals.

Terminal status is blocked; no implementation-proof or exact-check success is claimed. All writing is stopped for main finalization.
