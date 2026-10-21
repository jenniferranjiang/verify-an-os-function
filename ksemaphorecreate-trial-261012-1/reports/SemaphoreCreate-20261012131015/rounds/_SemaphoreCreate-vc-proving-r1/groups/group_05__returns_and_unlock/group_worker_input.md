# Group worker handoff

Read `/home/xinra/qcp-binary-democases/.agents/skills/group-worker-proving/SKILL.md` and its required workflow documents completely. Use this assignment without relying on a parent transcript or current sibling output.

- Group: `returns_and_unlock`; difficulty hint: 2/5.
- Copied manual: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_SemaphoreCreate-vc-proving-r1/groups/group_05__returns_and_unlock/_SemaphoreCreate_proof_manual.v`.
- Editable proof spans: `proof_of__SemaphoreCreate_return_wit_1`, `proof_of__SemaphoreCreate_return_wit_2`, `proof_of__SemaphoreCreate_return_wit_3`, `proof_of__SemaphoreCreate_partial_solve_wit_9_pure`, `proof_of__SemaphoreCreate_partial_solve_wit_9`.
- Protected LLM split blocks (keep generated Proof/Abort tokens): none.
- Statements, declaration order, prelude and all unassigned proof tokens remain fixed. Formatting is ignored.
No case library exists: do not create helpers, imports, or a library.

The current accepted predicate sources listed in `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/evidence/predicate-manifest.json`
and their formal dependencies are read-only semantic inputs. Read their definitions
and existing lemmas as needed; do not edit them. Never access historical CRTOS trials.

### `proof_of__SemaphoreCreate_return_wit_1` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. P is OutsideCritical at dec(inc(publish sem id val_pre current_3)); Q has three result alternatives. Choose the successful third alternative with current_2=current_3 and p=sem. Copy sem nonzero, Rely, min_free_id and the direct publication guarantee from PreH1/3/4/5. Establish dec(inc(publish...)) = publish... by record equality: task and semaphore components reduce definitionally; PreH6 SemaphoreGuarantee gives equality of the restored scheduler to current_3, which is also the scheduler of publish. This avoids assuming an entry bound absent from this VC. Rewrite and cancel exactly the OutsideCritical resource, including caller stack/tokens and nested heap when present.
### `proof_of__SemaphoreCreate_return_wit_2` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. P is OutsideCritical at dec(inc current_3). Choose the second (ID-full failure) result alternative with current=current_3 and return value -5. Copy Rely and idmanager_full from PreH4/5. Derive dec(inc current_3)=current_3 by record equality: task/semaphore fields are definitionally unchanged; PreH6 guarantee supplies full scheduler equality. No additional bound is needed or available. Rewrite and cancel the OutsideCritical resource; prove -5=-5 by reflexivity. Preserve the same caller IRQ stack and all nested invariant resources.
### `proof_of__SemaphoreCreate_return_wit_3` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. Choose the first allocation-failure result alternative. The return equality is -5=-5 and P already is the exact OutsideCritical sg hs before required by Q. Prove reflexivity and cancel that resource. No existential current, Rely step, heap allocation, or IRQ transition is required.
### `proof_of__SemaphoreCreate_partial_solve_wit_9_pure` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. Pure projection/reflexivity pattern: prove IRQ handler validity and the published-state restoration guarantee are PreH2 and PreH6. P also has C locals and SemaphoreInsideCritical at current and SemaphoreOSInvariant at nest_increment(publish sem id val_pre current); Q has only the stated pure conjunction. Extract explicit premises and split the conjunction; do not consume or reconstruct resources. No existential witnesses or new refinement transition.
### `proof_of__SemaphoreCreate_partial_solve_wit_9` — `LLM_pre_process`

Unfold the named VC, introduce its quantified parameters, and use LLM_pre_process on the whole goal. This definition is pure-VC -> auxiliary-VC. Introduce that implication premise, unfold the auxiliary, and establish its pure conjuncts directly: IRQ handler validity and the published-state restoration guarantee are PreH2 and PreH6. P and Q contain exactly SemaphoreInsideCritical at current and SemaphoreOSInvariant at nest_increment(publish sem id val_pre current); cancel these resources modulo separating associativity/commutativity. Retain all other named pure premises. No change of abstract state or existential instantiation is required.

## Helpers

- None planned.

## Historical references

- Previous proving round: `none`.
- Annotation history: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/annotation_history`; earlier canonical proofs may be in an attempt's `before` directory.
- Optional human reuse note: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_05__returns_and_unlock/proof_reuse.md`.

Search relevant historical blocks when useful. The controller does not search, copy, or rename historical proofs. Decide whether to adapt them and recheck against current inputs.

## Commands

Use these exact argv/cwd objects. Shell-only tools may quote each argument for the actual shell; PowerShell uses `&` with single-quoted arguments and doubled embedded apostrophes. Follow the skill for proof modes, safety, and checks.

```json
{
  "debug": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-debug",
      "--run",
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-proving-r1",
      "--group",
      "returns_and_unlock"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  },
  "development": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-development",
      "--group",
      "returns_and_unlock"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  },
  "check": {
    "argv": [
      "/usr/bin/python3.12",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphorecreate-trial-261012-1",
      "coq-check",
      "--run",
      "SemaphoreCreate-20261012131015",
      "--round",
      "_SemaphoreCreate-vc-proving-r1",
      "--target-kind",
      "group-check",
      "--group",
      "returns_and_unlock"
    ],
    "cwd": "/home/xinra/crtos/ksemaphorecreate-trial-261012-1"
  }
}
```

Debug script: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/verification_runs/SemaphoreCreate-20261012131015/_coq_builds/_SemaphoreCreate-vc-proving-r1/group_05/src/.coq_debug/group_05_returns_and_unlock.v`. Continue each live tool session until its actual exit. Successful checks require both exit zero and JSON status passed.

## Delivery

- Notes: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_05__returns_and_unlock/group_worker_output.md`; annotation-gap requires a nonempty explanation.
- Terminal report: `/home/xinra/crtos/ksemaphorecreate-trial-261012-1/reports/SemaphoreCreate-20261012131015/rounds/_SemaphoreCreate-vc-proving-r1/groups/group_05__returns_and_unlock/group_worker_report.json`.

Use the skill's exact completed/blocked report contract. Stop writing before main finalizes. The group directory contains only its copied manual and, when provided, group library. Finalization validates the current files.
