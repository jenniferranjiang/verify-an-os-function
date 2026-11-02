#!/usr/bin/env python3
"""Recompile affected shared Rocq library with root project paths, no QCP."""
from pathlib import Path
import hashlib,json,re,shlex,subprocess,time
trial=Path(__file__).resolve().parents[1]; root=trial.parent
args=[]
for line in (root/'_CoqProject').read_text().splitlines():
    w=shlex.split(line)
    if w and w[0] in ('-R','-Q'): args.extend(w)
files={p.stem:p for p in (root/'lib').glob('*.v')}
deps={n:set(re.findall(r'CRTOS_Verify\.lib\.(\w+)',p.read_text()))&files.keys() for n,p in files.items()}
changed=set(json.loads((trial/'checks/migration.json').read_text())['changed_global_modules'])
affected=set(changed)
while True:
    more={n for n in files if deps[n]&affected}; new=affected|more
    if new==affected: break
    affected=new
order=[];remaining=set(affected)
while remaining:
    ready=sorted(n for n in remaining if not deps[n]&remaining)
    if not ready: raise RuntimeError(f'dependency cycle: {remaining}')
    order+=ready;remaining-=set(ready)
results=[]
for n in order:
    p=files[n];out=trial/'checks'/('root-compile-'+n+'.log');start=time.monotonic()
    cmd=['/home/xinra/.opam/pv-bench-8.20.1/bin/coqc',*args,str(p.relative_to(root))]
    r=subprocess.run(cmd,cwd=root,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
    out.write_text(r.stdout);results.append({'module':n,'exit':r.returncode,'seconds':round(time.monotonic()-start,3),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'log':str(out.relative_to(trial))})
    (trial/'checks/root-compile-results.json').write_text(json.dumps(results,indent=2)+'\n');print(n,r.returncode,flush=True)
    if r.returncode: print(r.stdout,flush=True);raise SystemExit(r.returncode)
