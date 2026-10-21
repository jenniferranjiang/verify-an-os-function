from pathlib import Path
import subprocess,shlex,json,time
T=Path(__file__).resolve().parents[1];E=T/'evidence/arm32le-candidate/nest-view-draft';args=shlex.split((T/'_CoqProject.arm32le-candidate').read_text());cmd=['/home/xinra/.opam/pv-bench-8.20.1/bin/coqc',*args,'-R',str(E),'CRTOS_Verify.nestdraft',str(E/'SemaphoreCriticalViews.v')]
start=time.monotonic()
try:
 p=subprocess.run(cmd,capture_output=True,text=True,timeout=120);r={'command':cmd,'exit_code':p.returncode,'stdout':p.stdout,'stderr':p.stderr,'seconds':time.monotonic()-start}
except subprocess.TimeoutExpired as e:r={'command':cmd,'exit_code':124,'stdout':str(e.stdout),'stderr':str(e.stderr),'seconds':time.monotonic()-start}
(E/'build.json').write_text(json.dumps(r,indent=2)+'\n');print(r['exit_code'],r['stdout'],r['stderr']);raise SystemExit(r['exit_code'])
