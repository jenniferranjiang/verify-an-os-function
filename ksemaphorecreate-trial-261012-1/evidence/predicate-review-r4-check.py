from pathlib import Path
import hashlib,json,shlex,subprocess,time,re
T=Path(__file__).resolve().parents[1];E=T/'evidence';F=E/'arm32le-candidate/frozen-r4';W=E/'predicate-review-r4-build';W.mkdir(exist_ok=True)
expected='1b07e9068830369255a3a49aa90c66581e9845b7a74c618d35219ed9282bb105'
b=(F/'predicate-manifest.json').read_bytes();assert hashlib.sha256(b).hexdigest()==expected
manifest=json.loads(b);assert len(manifest['files'])==18
root_inputs=json.loads((E/'arm32le-candidate/root-source-closure.json').read_text())
for e in root_inputs['files']:assert hashlib.sha256(Path(e['source']).read_bytes()).hexdigest()==e['source_sha256']
def uncomment(s):
 out=[];i=0;d=0
 while i<len(s):
  if s[i:i+2]=='(*':d+=1;i+=2
  elif d and s[i:i+2]=='*)':d-=1;i+=2
  else:
   if not d:out.append(s[i])
   i+=1
 assert not d;return ''.join(out)
localtheorems=[]
for e in manifest['files']:
 current=T/e['path']; frozen=F/'sources'/e['path'];data=current.read_bytes()
 assert hashlib.sha256(data).hexdigest()==e['sha256'] and data==frozen.read_bytes()
 dest=W/e['path'];dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data)
 code=uncomment(data.decode());assert not re.search(r'\b(Axiom|Parameter|Admitted|admit)\b',code)
 if e['path'].startswith('lib/'):
  localtheorems+=re.findall(r'^\s*(?:Lemma|Theorem|Corollary)\s+(\w+)',code,re.M)
a=shlex.split((F/'_CoqProject.arm32le-candidate').read_text())
assert '/home/xinra/crtos/lib' not in a
replacements={str(T/'shared-candidate/arm32le'):str(W/'shared-candidate/arm32le'),str(T/'lib'):str(W/'lib')}
a=[replacements.get(x,x) for x in a]
start=time.monotonic();checks=[]
for e in manifest['files']:
 cmd=['/home/xinra/.opam/pv-bench-8.20.1/bin/coqc',*a,str(W/e['path'])]
 r=subprocess.run(cmd,text=True,capture_output=True,cwd=T)
 checks.append(dict(file=e['path'],command=cmd,exit_code=r.returncode,stdout=r.stdout,stderr=r.stderr))
 print(e['path'],r.returncode,flush=True)
 assert r.returncode==0,r.stderr
for src in [E/'arm32le-candidate/Arm32LECarrierCheck.v',E/'probes/PR02PendingCheck.v',E/'predicate-review-r3-build/R3BoundaryCheck.v']:
 dest=W/src.name;dest.write_bytes(src.read_bytes());cmd=['/home/xinra/.opam/pv-bench-8.20.1/bin/coqc',*a,str(dest)]
 r=subprocess.run(cmd,text=True,capture_output=True,cwd=T)
 checks.append(dict(file=src.name,sha256=hashlib.sha256(src.read_bytes()).hexdigest(),command=cmd,exit_code=r.returncode,stdout=r.stdout,stderr=r.stderr));assert r.returncode==0,r.stderr
queries='Require Import '+ ' '.join('CRTOS_Verify.sem.'+Path(e['path']).stem for e in manifest['files'] if e['path'].startswith('lib/'))+'.\n'
queries+='Require Import CRTOS_Verify.lib.idnode CRTOS_Verify.lib.dll CRTOS_Verify.lib.TaskProtocolSTS CRTOS_Verify.lib.CrtosRules.\n'
names=localtheorems+['IDNode.store_idbuckets_replace','DLL.dllseg_concat','TaskRTrans_refl','tmp_task_protocol_meta_properties']
queries+='\n'.join('Print Assumptions '+n+'.' for n in names)+'\n'
queries+='Print Task_C_Rules.struct_padding.\nPrint Crtos_C_Rules.struct_padding.\n'
r=subprocess.run(['/home/xinra/.opam/pv-bench-8.20.1/bin/coqtop','-quiet',*a],input=queries,text=True,capture_output=True,cwd=T)
(W/'assumptions.stdout').write_text(r.stdout);(W/'assumptions.stderr').write_text(r.stderr)
assert r.returncode==0 and 'Error:' not in r.stderr,r.stderr
out={'revision':'predicate-r4-1b07e9068830','manifest_sha256':expected,'source_count':18,'checks':checks,'assumptions_theorems':names,'local_trust_scan':'clean','root_source_hashes_unchanged':True,'elapsed_seconds':time.monotonic()-start,'result':'machine-checks-passed; reuse issue review separate'}
(E/'predicate-review-r4-check.json').write_text(json.dumps(out,indent=2)+'\n')
print('All 18 formal + 3 regression probes passed independently')
