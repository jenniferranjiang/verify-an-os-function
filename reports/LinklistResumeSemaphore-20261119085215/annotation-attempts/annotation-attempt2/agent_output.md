# LinklistResume annotation r2

First head-borrow which-implies generated a C variable binder named list, shadowing the list type in EX rest. Added list == list@pre on both sides of that local view: the C parameter is never assigned, so this is the real unchanged parameter bridge, not a new function premise. Generated binder is now list_pre.

Read historical/current manual and goal. The complete affected VC, including both alternative branches, is byte-identical after replacing only the old generated term binder list by list_pre (excluding @list type). Pure premises, existential first/rest, alignment, waiting-head relation, owned pointer and restoration wand all remain. Other manual names/counts unchanged: 5 top-level, 3 split, 12 native auto. No generated file handwritten. No executable C, function/callee spec or library changes.

formal-case-lib-design exit0 passed/skipped under absent policy; native symexec exit0/status passed. Naming defect resolved in current generated output. This owner has no VC compilation command in handoff; independent checker must perform actual coq-debug load before claiming typecheck or proof success. No implementation proof is claimed.
