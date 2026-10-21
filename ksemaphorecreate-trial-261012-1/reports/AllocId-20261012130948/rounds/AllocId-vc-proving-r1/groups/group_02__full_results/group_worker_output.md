# full_results delivery

Blocked before proof checking by a syntax error in generated `VC/AllocId_goal.v`, line 104, characters 89–92: `(end: Z)` uses the reserved Rocq keyword `end` as a binder. Native Coq reported `Syntax error: [name] expected after '(' (in [closed_binder])`.

The authorized `coq-debug` command was continued to actual exit: return code 1, JSON status `failed`, elapsed 171.641989 seconds. The failing native target was `VC/AllocId_goal.v`, before the assigned manual proofs could be checked. Earlier notation warnings are not the actual failure.

Both assigned proofs remain unfinished with the required LLM preprocessing skeleton and `Abort`; no unassigned proof, declaration, predicate source, generated goal, or annotation was changed. The mathematical full-result argument uses the existing index/entry scan invariants and bitmap-query equivalence. No proof success or annotation semantic gap is claimed.

Repair boundary: generator/annotation identifier handling must produce Rocq-safe binders, after which the goal dependency must compile and this group can resume. A group worker cannot change the generated goal, source annotation, or controller inputs.
