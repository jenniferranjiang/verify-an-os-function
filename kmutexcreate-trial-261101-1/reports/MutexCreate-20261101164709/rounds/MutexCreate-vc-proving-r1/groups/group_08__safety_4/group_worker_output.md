# safety_4 proof delivery

Completed `proof_of__MutexCreate_safety_wit_16` through `proof_of__MutexCreate_safety_wit_20` using the assigned whole-goal route:

```coq
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.
```

The goals establish signed-int bounds for initialization constants 5, 1, 0, 255 and 0. No helper, import, statement, annotation, library seed or frozen specification change was needed. Only the five assigned proof spans were edited.

Rocq MCP used controller staging workspace `verification_runs/MutexCreate-20261101164709/_coq_builds/MutexCreate-vc-proving-r1/group_08/dev` and file `VC/MutexCreate_proof_manual.v`. Each exact theorem was opened by `rocq_start` then completed by `rocq_check`; start/completion state pairs were 1/3, 4/6, 7/9, 10/12 and 13/15. All five calls returned success, proof_finished=true, no goals remaining, and a Qed definition confirmation.

Controller group-development passed with exit 0. Forbidden lemma/tactic scan of the copied manual and group library had no hits. Final controller group-check passed with exit 0, status passed, returncode 0 (18.130173 seconds); it compiled the current case library, goal, auto, manual and exact group wrapper, reusing 198 current base objects. There is no annotation or infrastructure blocker.

All worker writing has finished; main may finalize this delivery.
