# arithmetic_returns r2 delivery

Completed the four assigned return top-level VCs and four assigned split goals with Qed. Each split starts with LLM_pre_process; each top-level uses aggressive_pre_process and Goal_apply only. Statements, prelude, declaration order, unassigned proof spans, library and generated canonical files were unchanged. No helpers or imports were added.

The proofs use the actual UInt input bounds to derive nonnegative product, quotient at most 429496730 and remainder below 1000. They rewrite C quotient/remainder to Z.div/mod under nonnegativity and prove explicit unsigned32 truncation identities for quotient, remainder and quotient+1. The zero quotient branch gives the minimum tick; other branches simplify tick_from_time_ms using the same remainder guards. No reachability assumption or specification strengthening was introduced.

The prior round candidate's generic repeat rewrite silently failed to eliminate truncation. Current explicit equalities resolved that proof issue. The missing concrete scope from r1 is fixed by the annotation-owned existing CrtosRules import; current proof checking actually ran.

Validation: controller group-development passed (exit 0); latest exact group-check passed (exit 0/status passed, 18.381741 seconds), compiling current goal, auto, manual and assigned witness wrapper. This is group completion, not whole-function final-check. No forbidden lemma, admit, new axiom or unsafe typing was used in assigned proofs.
