from pathlib import Path
import json,shlex,subprocess,time,os
root=Path(__file__).resolve().parent
compiler=Path('/home/xinra/.opam/pv-bench-8.20.1/bin/coqc')
env=os.environ.copy(); env['PATH']=str(compiler.parent)+':'+env['PATH']; env['OCAMLLIB']='/home/xinra/.opam/pv-bench-8.20.1/lib/ocaml'
args=shlex.split((root/'_CoqProject').read_text()); files=json.loads((root/'baseline-manifest.json').read_text())['files']
files += [{'path':'lib/SemaphoreInitialization.v'},{'path':'CandidateChecks.v'}]
start=time.monotonic(); results=[]
for row in files:
 cmd=[str(compiler),*args,row['path']]; run=subprocess.run(cmd,cwd=root,env=env,text=True,capture_output=True)
 results.append({'file':row['path'],'returncode':run.returncode,'stdout':run.stdout,'stderr':run.stderr})
 if run.returncode: break
(root/'compile.json').write_text(json.dumps({'compiler':str(compiler),'elapsed_seconds':time.monotonic()-start,'results':results},indent=2)+'\n')
print(json.dumps({'checked':len(results),'success':all(r['returncode']==0 for r in results),'last':results[-1]},indent=2))
