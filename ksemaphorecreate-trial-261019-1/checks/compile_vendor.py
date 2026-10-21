#!/usr/bin/env python3
"""Compile only the nine vendored QCP modules absent from the installed .vo set."""
from pathlib import Path
import subprocess,shlex
trial=Path(__file__).resolve().parents[1]
args=shlex.split((trial/'_CoqProject').read_text())
vendor=trial/'vendor'
files=sorted(str(p) for p in vendor.rglob('*.v'))
order=subprocess.check_output(['coqdep',*args,'-sort',*files],text=True).split()
for source in order:
 if not Path(source).is_relative_to(vendor): continue
 print('DEPENDENCY '+str(Path(source).relative_to(trial)),flush=True)
 subprocess.run(['coqc',*args,source],cwd=trial,check=True)
