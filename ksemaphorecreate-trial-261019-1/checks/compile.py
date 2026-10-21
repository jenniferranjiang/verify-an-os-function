#!/usr/bin/env python3
"""Only compile this trial's explicit source allowlist and reviewed QCP libraries."""
from pathlib import Path
import subprocess,shlex,sys
trial=Path(__file__).resolve().parents[1]
args=shlex.split((trial/'_CoqProject').read_text())
assert all('trial-' not in a or str(trial) in a for a in args)
files=sys.argv[1:] or ['TaskStatus','TickOrder','StructFieldOffsetAxiom','dll_abs','idnode_abs','KTaskPure','KTaskDelay','CrtosGlobState','CrtosRules','dll','idnode','SemaphoreInv','KSemaphoreCreate']
for name in files:
 print('COMPILE '+name,flush=True)
 subprocess.run(['coqc',*args,str(trial/'lib'/f'{name}.v')],cwd=trial,check=True)
