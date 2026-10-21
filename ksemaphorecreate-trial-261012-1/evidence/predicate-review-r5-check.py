from pathlib import Path
import hashlib,json,shlex,subprocess,time,re,shutil
T=Path(__file__).resolve().parents[1]; E=T/'evidence'
F=E/'arm32le-candidate/frozen-r5'; W=E/'predicate-review-r5-build'; W.mkdir(exist_ok=True)
R4=E/'predicate-review-r4-build'
expected='6227128b789d2843de342612ae57f48888905772f9fc1eff72400363fa25f697'
sha=lambda b:hashlib.sha256(b).hexdigest()
b=(F/'predicate-manifest.json').read_bytes(); assert sha(b)==expected
entries=json.loads(b)['files']; assert len(entries)==20
old=json.loads((E/'arm32le-candidate/frozen-r4/predicate-manifest.json').read_text())['files']
old={e['path']:e['sha256'] for e in old}
changed=[e['path'] for e in entries if old.get(e['path'])!=e['sha256']]
assert changed==['framework-candidate/NestedCriticalSTS.v','lib/CrtosNestedState.v','lib/SemaphoreCriticalViews.v']
official=Path('/home/xinra/qcp-binary-democases/Rocq/SeparationLogic/NestedCriticalSTS.v')
assert official.read_bytes()==(T/'framework-candidate/NestedCriticalSTS.v').read_bytes()
root_inputs=json.loads((E/'arm32le-candidate/root-source-closure.json').read_text())
for e in root_inputs['files']: assert sha(Path(e['source']).read_bytes())==e['source_sha256']
def uncomment(s):
 out=[];i=0;d=0
 while i<len(s):
  if s[i:i+2]=='(*':d+=1;i+=2
  elif d and s[i:i+2]=='*)':d-=1;i+=2
  else:
   if not d:out.append(s[i])
   i+=1
 assert not d;return ''.join(out)
rebuild=['framework-candidate/NestedCriticalSTS.v','lib/CrtosNestedState.v','lib/CrtosOSProtocol.v','lib/CrtosOSProtocolProof.v','lib/CrtosOSInv.v','lib/SemaphoreCritical.v','lib/SemaphoreCriticalViews.v']
reuse=[]
for e in entries:
 p=e['path']; data=(T/p).read_bytes()
 assert sha(data)==e['sha256'] and data==(F/'sources'/p).read_bytes()
 dest=W/p;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data)
 if not p.startswith('framework-candidate/'):
  assert not re.search(r'\b(Axiom|Parameter|Admitted|admit)\b',uncomment(data.decode()))
 if p not in rebuild:
  assert (R4/p).read_bytes()==data
  vo=(R4/p).with_suffix('.vo'); assert vo.is_file()
  shutil.copy2(vo,dest.with_suffix('.vo'));reuse.append({'file':p,'vo_sha256':sha(vo.read_bytes()),'from':str(vo)})
a=shlex.split((F/'_CoqProject.arm32le-candidate-r5').read_text())
assert '/home/xinra/crtos/lib' not in a
for sub in ['shared-candidate/arm32le','lib','framework-candidate']:a=[str(W/sub) if x==str(T/sub) else x for x in a]
start=time.monotonic();checks=[]
def run(p):
 cmd=['/home/xinra/.opam/pv-bench-8.20.1/bin/coqc',*a,str(p)]
 r=subprocess.run(cmd,text=True,capture_output=True,cwd=T)
 checks.append(dict(file=str(p.relative_to(W)),command=cmd,exit_code=r.returncode,stdout=r.stdout,stderr=r.stderr))
 print(p.name,r.returncode,flush=True);assert r.returncode==0,r.stderr
for p in rebuild:run(W/p)
for src in [E/'arm32le-candidate/r5-checks/CarrierAndViewsCheck.v',E/'probes/PR02PendingCheck.v',E/'predicate-review-r3-build/R3BoundaryCheck.v']:
 dest=W/src.name;dest.write_bytes(src.read_bytes());run(dest)
for e in entries: assert sha((T/e['path']).read_bytes())==e['sha256']
out={'revision':'predicate-r5-6227128b789d','manifest_sha256':expected,'source_count':20,'delta_files':changed,'independently_rebuilt':rebuild,'reused_independent_r4_objects':reuse,'checks':checks,'official_record_source_sha256':sha(official.read_bytes()),'handwritten_trust_scan':'clean','root_source_hashes_unchanged':True,'elapsed_seconds':time.monotonic()-start,'result':'delta-machine-checks-passed'}
(E/'predicate-review-r5-check.json').write_text(json.dumps(out,indent=2)+'\n')
print('Independent r5 delta and regression checks passed',flush=True)
