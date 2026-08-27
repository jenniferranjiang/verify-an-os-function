# Trial-local Rocq project configuration

## Trigger problem

`verify-an-os-function` creates Rocq sources under `<trial>/lib/`, but a CRTOS-root
VS Code workspace cannot resolve their definitions unless the trial's physical
library path is registered manually. Registering every trial globally is unsafe
because different trials reuse logical module and file names.

## Method

Every trial owns a `<trial>/_CoqProject`. It contains the external `-R`/`-Q`
load paths used by that trial's build plus the exact mapping for its local
`lib/` directory. The Makefile and `_CoqProject` use the same logical names.

For Coq 8.18--8.20, the current VsRocq server cannot apply a local project's
load paths per document. Register one active trial in CRTOS-root
`.vscode/settings.json` under `vsrocq.args`, and associate `*.v` with `rocq`.
Use resolved absolute paths because the current extension passes these arguments
without expanding `${workspaceFolder}` and starts the server through a shell.
When the active trial changes, replace the old trial mapping instead of adding
another physical directory for the same logical library.

## Limits

- Required `.vo` dependencies must still be compiled before cross-file lookup.
- Closest-ancestor `_CoqProject` discovery alone is insufficient on Coq
  8.18--8.20 because the server initializes Rocq globally.
- A trial whose build changes a logical path must update `_CoqProject` in the
  same revision.

## Validation evidence

- Parse each load-path directory from the trial `_CoqProject` and require it to
  exist.
- Run `coqchk -norec` or an equivalent Rocq load check on a local compiled
  module using those mappings.
- Confirm root `vsrocq.args` contains exactly the active trial's local mapping.
