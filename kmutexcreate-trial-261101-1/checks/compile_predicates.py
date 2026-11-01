from pathlib import Path
import json,subprocess,time
p=Path.cwd()
assert 'KMutexCreateTrial.lib' in (p/'_CoqProject').read_text(), 'Historical build only: current trial uses the global library; do not overwrite frozen logs.'
order=json.loads((p/'checks/compile-order.json').read_text()); results=[]
for n in order:
 log=p/'checks'/('compile-'+n+'.log')
 t=time.time()
 with log.open('w') as out:
  r=subprocess.run(['/home/xinra/crtos/tools/rocq/coqc','lib/'+n+'.v'],stdout=out,stderr=subprocess.STDOUT)
 results.append({'module':n,'exit':r.returncode,'seconds':round(time.time()-t,3),'log':str(log.relative_to(p))})
 (p/'checks/compile-results.json').write_text(json.dumps(results,indent=2)+'\n')
 print(n,r.returncode,flush=True)
 if r.returncode: print(log.read_text(),flush=True);raise SystemExit(r.returncode)
