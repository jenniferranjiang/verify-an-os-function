from pathlib import Path
import subprocess,shlex,os,json,time
r=Path(__file__).resolve().parent
compiler='/home/xinra/.opam/pv-bench-8.20.1/bin/coqc'
env=os.environ.copy(); env['PATH']=str(Path(compiler).parent)+':'+env['PATH']; env['OCAMLLIB']='/home/xinra/.opam/pv-bench-8.20.1/lib/ocaml'
args=shlex.split((r/'_CoqProject').read_text()); start=time.monotonic(); results=[]
for f in ['lib/SemaphoreRep.v','lib/CrtosOSInv.v','lib/SemaphoreCritical.v','lib/SemaphoreCriticalViews.v','lib/SemaphoreInitialization.v','CandidateChecks.v']:
 p=subprocess.run([compiler,*args,f],cwd=r,env=env,capture_output=True,text=True)
 results.append({'file':f,'returncode':p.returncode,'stdout':p.stdout,'stderr':p.stderr})
 if p.returncode:break
(r/'checks.json').write_text(json.dumps({'elapsed_seconds':time.monotonic()-start,'results':results},indent=2)+'\n')
print(json.dumps(results[-1],indent=2))
