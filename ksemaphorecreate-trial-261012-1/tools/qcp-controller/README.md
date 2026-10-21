# CRTOS trial controller adapter

This is a local copy of the current QCP controller, authorized by the user with
“允许在新 trial 内适配 controller”. It is confined to this trial. The external QCP
scripts and skills are unchanged. The upstream source hashes and local diff are
in `evidence/controller-upstream-manifest.json` and
`evidence/controller-adaptation.diff`.

The original `init-run` rejected `annotated_C/src/KSemaphoreCreate.c` before any
symbolic execution. That diagnostic and the permission are preserved in
`evidence/controller-adaptation-authorization.json`.

The adapter changes these infrastructure boundaries:

- Canonical C files remain `annotated_C/src/<function>.c`; each generated family
  is `VC/<function>_*.v`, with logical prefix `CRTOS_Verify.VC`.
- Includes are traversed inside `annotated_C`; traversal and symlinks escaping
  their owner are rejected. No second active source tree is created.
- The original QCP driver and role skills are used read-only at their actual
  external locations. Owner handoffs still contain the local controller's exact
  structured commands.
- The Make backend reads this trial's `_CoqProject`. External libraries have
  allowlisted virtual nodes in the dependency plan and are never build outputs.
  Source/object hashes are pinned. Some installed QCP modules provide only an
  object; those nodes are explicitly recorded without inventing source files,
  and their compiled dependencies are checked by `coqchk`. Local dependencies
  are built by the original exact Make approach with the compatible Coq binary.
  Successful external checks may be reused for unchanged, already checked input
  hashes; this never replaces the final full proof-closure `coqchk`.
- `init-closure` creates nine frozen single-case runs from the reviewed closure.
  It also checks the reviewed canonical call sets. The only source/canonical
  call difference is the previously approved unreachable KDBG_IPC log removal.
  `step-closure` dispatches the first unfinished case in dependency order and
  requires every child's successful original final-check before reporting the
  controller closure done. It does not classify declaration contracts as proved.

Annotation acceptance, VC checking, proving preparation/merge and final-check
checks are retained. The adapter does not change goal semantics, supply witnesses
or change any predicate/spec semantics. Full OS final integrity remains required
after controller completion.

The bundled driver leaves admissions in generated auto witnesses. The adapter
archives the raw four-file output by content hash and adds every exact auto
witness statement to the proof owner's manual worklist. Goal and raw auto bytes
remain unchanged. The original staging overlap rule removes those auto lemmas
from the compiled auto module; owners must prove their manual copies before
the full parent check can pass. Fresh symbolic replay applies the same worklist
extension. `complete-obligation-coverage` routes preexisting incomplete coverage
through the original annotation retry, retaining its original diagnostics and
owner. `check_auto_coverage.py` tests this mechanism on copies of actual output;
it does not establish any C verification condition.

The driver can emit the C local `end` as an illegal Rocq binder. A second,
strictly scoped generation pass archives the raw four files and alpha-renames
that binder to `qcp_local_end`. It verifies forall scopes and name freshness,
preserves comments and all C address strings, and requires exact byte recovery
under inverse renaming. Unsupported constructs are rejected. Arithmetic,
ownership, definitions and VC identities are unchanged. This pass runs before
the witness-worklist extension and identically during fresh replay.
`repair-generated-identifiers` is available only after actual matching group
infrastructure failures, with all claimed owners stopped. It requests the
original annotation retry; it does not accept a proof or edit canonical output
directly. The real AllocId goal copy passes the compatible compiler after the
rename; evidence is in `evidence/controller-identifier-check.json`.

An accepted-input guard additionally checks frozen shared headers and predicates
before proof tools run. The upstream controller has no recovery action for a
stopped infrastructure owner. The local `recover-infrastructure` action is
therefore offered only when an independently reviewed repair record matches the
run, attempt, repair index, accepted manifests and review-file hash. It returns
the same owner to the original `prepared -> claim -> acceptance` lifecycle;
it cannot accept a proof, erase a VC, unfreeze a contract, or reuse the repair
record for a later failure. Original failures remain in run logs.

Run the entry point with Python 3.12:

```sh
/usr/bin/python3.12 tools/qcp-controller/scripts/verification-orchestrator/controller.py --main-root /home/xinra/crtos/ksemaphorecreate-trial-261012-1 step-closure
```

Then execute only the returned actions. Each claimed owner receives the exact
handoff prompt. `check_adapter.py` tests path rejection, the nine symbolic plans,
and the actual reviewed predicate dependency build; it is a tooling test, not a
proof of C verification conditions.

新 accepted revision 后，`revalidate-revision` 只将旧 done 结果归档并返回原 `final-check`。终检重新执行 fresh symbolic、VC/statement/scope比较与完整当前依赖编译；全部通过才重新 done，并绑定 source/predicate/spec/_CoqProject hashes。closure 不再把旧或缺失 binding 的 done 当作当前完成。工具回归见 evidence/controller-revalidation-check.json；未借此接受任何 C VC。

The proving context accepts safe round names with a leading underscore, as generated by the controller for `_SemaphoreCreate`. Previously its own slug comparison rejected that identity. Directory names are preserved verbatim, and the original containment/symlink checks remain active. `check_round_names.py` checks the actual 9-group context and rejects traversal, separators, whitespace, empty and dot-only names; it does not change controller state or accept a proof.
