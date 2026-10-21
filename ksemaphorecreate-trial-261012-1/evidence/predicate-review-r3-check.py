from pathlib import Path
import hashlib,json,shlex,shutil,subprocess,time,re
T=Path(__file__).resolve().parents[1]; E=T/'evidence'
expected='16b6ee4a4e02383dcb7128da0c57212af2e672ccd15b15633142778e8d2d629f'
manifest_bytes=(E/'predicate-manifest.json').read_bytes(); assert hashlib.sha256(manifest_bytes).hexdigest()==expected
manifest=json.loads(manifest_bytes); baseline=E/'predicate-review-r2-build'; work=E/'predicate-review-r3-build';work.mkdir(exist_ok=True)
unchanged={'SemaphorePure','CrtosHeapBridge','SemaphoreRep'};changed=[]; theorem_names=[]; forbidden=[]
def uncomment(s):
 out=[]; i=0; depth=0
 while i<len(s):
  if s[i:i+2]=='(*': depth+=1;i+=2
  elif depth and s[i:i+2]=='*)':depth-=1;i+=2
  else:
   if not depth:out.append(s[i])
   i+=1
 assert depth==0
 return ''.join(out)
for e in manifest['files']:
 p=T/e['path']; b=p.read_bytes(); assert hashlib.sha256(b).hexdigest()==e['sha256']
 (work/p.name).write_bytes(b)
 if p.stem in unchanged:
  assert b==(baseline/p.name).read_bytes(); shutil.copyfile(baseline/(p.stem+'.vo'),work/(p.stem+'.vo'))
 else:changed.append(p.name)
 code=uncomment(b.decode());theorem_names+=re.findall(r'^\s*(?:Lemma|Theorem|Corollary)\s+(\w+)',code,re.M)
 forbidden+=re.findall(r'\b(?:Axiom|Parameter|Admitted|admit)\b',code)
assert not forbidden,forbidden
prov=json.loads((E/'nested-state-adapter.json').read_text()); official=Path(prov['official_source']).read_bytes()
assert hashlib.sha256(official).hexdigest()==prov['official_sha256']
assert prov['exact_reused_source'] in official.decode()
assert prov['exact_reused_source'] in (T/'lib/CrtosNestedState.v').read_text()
args=shlex.split((T/'_CoqProject').read_text());args=[str(work) if a==str(T/'lib') else a for a in args]
checks=[];start=time.monotonic()
for name in ['CrtosOSPure','CrtosNestedState','CrtosOSProtocol','CrtosOSProtocolProof','CrtosOSInv','SemaphoreCritical']:
 cmd=['/home/xinra/.opam/default/bin/coqc',*args,str(work/(name+'.v'))]
 r=subprocess.run(cmd,text=True,capture_output=True,cwd=T)
 checks.append(dict(file=name+'.v',command=cmd,exit_code=r.returncode,stdout=r.stdout,stderr=r.stderr));assert r.returncode==0,r.stderr
probe=E/'probes/PR02PendingCheck.v';shutil.copyfile(probe,work/probe.name)
cmd=['/home/xinra/.opam/default/bin/coqc',*args,str(work/probe.name)];r=subprocess.run(cmd,text=True,capture_output=True,cwd=T)
checks.append(dict(file=probe.name,sha256=hashlib.sha256(probe.read_bytes()).hexdigest(),command=cmd,exit_code=r.returncode,stdout=r.stdout,stderr=r.stderr));assert r.returncode==0,r.stderr
queries='Require Import '+' '.join('CRTOS_Verify.sem.'+Path(e['path']).stem for e in manifest['files'])+'.\n'
queries+='\n'.join('Print Assumptions '+n+'.' for n in theorem_names)+'\n'
r=subprocess.run(['/home/xinra/.opam/default/bin/coqtop','-quiet',*args],input=queries,text=True,capture_output=True,cwd=T)
(work/'assumptions.log').write_text(r.stdout+'\n'+r.stderr);assert r.returncode==0 and 'Error:' not in r.stderr,r.stderr
result={'revision':'predicate-r3-16b6ee4a4e02','manifest_sha256':expected,'recompiled_files':changed,'checks':checks,'assumptions_theorems':theorem_names,'local_forbidden_tokens':forbidden,'official_record_exact_match':True,'elapsed_seconds':time.monotonic()-start,'result':'checks-passed; semantic review separate'}
(E/'predicate-review-r3-check.json').write_text(json.dumps(result,indent=2)+'\n')
print('r3: exact manifest; 6 affected formal and PR02 regression compiled; all',len(theorem_names),'theorem assumptions printed; local trust scan clean')
