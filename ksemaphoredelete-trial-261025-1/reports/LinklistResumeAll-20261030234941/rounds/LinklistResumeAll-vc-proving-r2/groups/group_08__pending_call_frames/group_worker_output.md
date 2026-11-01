# pending_call_frames — r2

Completed all six assigned witnesses: partial_solve_wit_3, 4, 5_pure, 5, 6_pure, and 6.

Compared the corresponding r1 proof blocks and staged goal definitions with current inputs. The library seed is identical. Within the assigned goals, r2 removes `target <> 0` from witness 6's premises and auxiliary conclusion, renumbering later premises; other assigned definitions are unchanged. The historical scripts do not address premises by number, so all six were reused unchanged. Only assigned proof spans were written; no helpers or library changes were needed.

Rocq MCP `rocq_compile` compiled a candidate containing complete imports, verbatim current goal and auxiliary definitions, the current library seed, and all six historical proof scripts. Result: `success: true`.

Forbidden lemma/tactic scan was clear. The exact r2 controller `group-check` completed with process exit code 0 and JSON `status: passed`, recompiling all five current staged sources. Build workspace: `verification_runs/LinklistResumeAll-20261030234941/_coq_builds/LinklistResumeAll-vc-proving-r2/group_08/src`.

No annotation gap. Delivery complete; writes stop after the terminal report.
