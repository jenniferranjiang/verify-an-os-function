#!/usr/bin/env python3
"""Build an isolated, explicit trial candidate; no root .vo or old QCP loads."""
from pathlib import Path
import argparse,shlex,subprocess,json,hashlib,time,difflib,datetime,shutil
T=Path(__file__).resolve().parents[1];E=T/'evidence/arm32le-candidate'
a=argparse.ArgumentParser();a.add_argument('--from-file');a.add_argument('--revision-number',type=int,default=4);opt=a.parse_args()
config=T/('_CoqProject.arm32le-candidate-r5' if opt.revision_number==5 else '_CoqProject.arm32le-candidate')
args=shlex.split(config.read_text())
assert '/home/xinra/crtos/lib' not in args
assert not any('/qcp-binary-democases/SeparationLogic/' in x for x in args)
coqc='/home/xinra/.opam/pv-bench-8.20.1/bin/coqc'
closure=json.loads((E/'root-source-closure.json').read_text())
local=json.loads((E/'pre-migration/evidence/predicate-manifest.json').read_text())
files=[x['candidate'] for x in closure['files']]+[x['path'] for x in local['files']]
if opt.revision_number==5:files=['framework-candidate/NestedCriticalSTS.v']+files+['lib/SemaphoreCriticalViews.v']
if opt.from_file:files=files[files.index(opt.from_file):]
history=E/"build-history"; history.mkdir(exist_ok=True)
if (E/"build-latest.json").exists():
 shutil.copy2(E/"build-latest.json",history/(datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%dT%H%M%S%f")+".json"))
checks=[]
for rel in files:
 cmd=[coqc,*args,str(T/rel)];start=time.monotonic()
 try:
  p=subprocess.run(cmd,cwd=T,capture_output=True,text=True,timeout=180)
  rec={'file':rel,'command':cmd,'exit_code':p.returncode,'stdout':p.stdout,'stderr':p.stderr,'seconds':time.monotonic()-start}
 except subprocess.TimeoutExpired as x:
  rec={'file':rel,'command':cmd,'exit_code':124,'stdout':str(x.stdout),'stderr':str(x.stderr),'seconds':time.monotonic()-start}
 checks.append(rec);print(rel,rec['exit_code'],flush=True)
 (E/'build-latest.json').write_text(json.dumps({'checks':checks,'all_passed':len(checks)==len(files) and all(c['exit_code']==0 for c in checks)},indent=2)+'\n')
 if rec['exit_code']:
  print(rec['stdout'],rec['stderr'],flush=True);raise SystemExit(rec['exit_code'])
print('passed',flush=True)
