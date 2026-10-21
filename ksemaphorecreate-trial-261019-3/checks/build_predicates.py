from pathlib import Path
import re,subprocess,sys,shlex
T=Path(__file__).resolve().parents[1]
args=shlex.split((T/'_CoqProject').read_text())
files=list((T/'shared_candidates').glob('*.v'))+list((T/'lib').glob('*.v'))
local={('TrialShared.' if p.parent.name=='shared_candidates' else 'KSemaphoreCreateTrial.')+p.stem:p for p in files}
v=T/'vendor'/'MonadLib'
for p in v.rglob('*.v'):local['MonadLib.'+'.'.join(p.relative_to(v).with_suffix('').parts)]=p
seen=set(); order=[]; dependencies={}
def visit(n):
 if n in seen:return
 seen.add(n);p=local[n];s=p.read_text()
 deps=re.findall(r'(?:TrialShared|KSemaphoreCreateTrial)\.\w+',s)
 for prefix,rest in re.findall(r'From\s+(MonadLib[\w.]*)\s+Require\s+(?:Import|Export)\s+([^.]*)\.',s):deps += [prefix+'.'+x for x in rest.split()]
 dependencies[p]=[local[d] for d in deps if d in local]
 for d in deps:
  if d in local:visit(d)
 order.append(p)
for n in local:visit(n)
log=T/'checks'/'predicate-compile.log'
with log.open('a') as out:
 for p in order:
  vo=p.with_suffix('.vo')
  if vo.exists() and vo.stat().st_mtime > p.stat().st_mtime and all(q.with_suffix('.vo').exists() and q.with_suffix('.vo').stat().st_mtime <= vo.stat().st_mtime for q in dependencies[p]):
   continue
  cmd=['coqc',*args,str(p)]
  print('COMPILE',p.relative_to(T),flush=True)
  out.write('COMMAND '+shlex.join(cmd)+'\n');out.flush()
  r=subprocess.run(cmd,stdout=out,stderr=subprocess.STDOUT,cwd=T)
  if r.returncode:print('FAIL',p,flush=True);sys.exit(r.returncode)
print('PASS',len(order),'files')
with log.open('a') as out:out.write('PASS '+str(len(order))+' files; all source/dependency timestamps current\n')
