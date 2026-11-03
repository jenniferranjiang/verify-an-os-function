#!/usr/bin/env python3
"""Compile Rocq design only; no QCP/parser/symbolic/VC invocation."""
from pathlib import Path
import hashlib,json,re,shlex,subprocess,time
root=Path(__file__).resolve().parents[1]
args=[]
for line in (root/'_CoqProject').read_text().splitlines():
    w=shlex.split(line)
    if w and w[0] in ('-R','-Q'): args.extend(w)
files={p.stem:p for p in (root/'lib').glob('*.v')}
deps={n:set(re.findall(r'KEventTrial\.lib\.(\w+)',p.read_text()))&files.keys() for n,p in files.items()}
order=[]; remaining=set(files)
while remaining:
    ready=sorted(n for n in remaining if not deps[n]&remaining)
    if not ready: raise RuntimeError(f'dependency cycle: {remaining}')
    order.extend(ready); remaining-=set(ready)
prior={r['module']:r for r in json.loads((root/'checks/compile-results.json').read_text())} if (root/'checks/compile-results.json').exists() else {}
results=[]
for n in order:
    p=files[n]; out=root/'checks'/('compile-'+n+'.log')
    digest=hashlib.sha256(p.read_bytes()).hexdigest()
    vo=p.with_suffix('.vo')
    if n in prior and prior[n]['exit']==0 and prior[n]['sha256']==digest and vo.exists() and all(vo.stat().st_mtime >= files[d].with_suffix('.vo').stat().st_mtime for d in deps[n]):
        results.append(prior[n]); (root/'checks/compile-results.json').write_text(json.dumps(results,indent=2)+'\n'); print(n,'unchanged',flush=True); continue
    start=time.monotonic()
    command=['/home/xinra/.opam/pv-bench-8.20.1/bin/coqc',*args,str(p.relative_to(root))]
    result=subprocess.run(command,cwd=root,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
    out.write_text(result.stdout)
    row={'module':n,'exit':result.returncode,'seconds':round(time.monotonic()-start,3),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'log':str(out.relative_to(root))}
    results.append(row); (root/'checks/compile-results.json').write_text(json.dumps(results,indent=2)+'\n')
    print(n,result.returncode,flush=True)
    if result.returncode: print(result.stdout,flush=True); raise SystemExit(result.returncode)
