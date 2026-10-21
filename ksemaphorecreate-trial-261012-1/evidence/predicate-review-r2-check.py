from pathlib import Path
import hashlib,json,shlex,shutil,subprocess,time
T=Path(__file__).resolve().parents[1]; E=T/'evidence'
expected='fc2db1b1c8870dbbffdca92e0ad739aca885c70d8a752eb028caf203030a10e3'
manifest_bytes=(E/'predicate-manifest.json').read_bytes(); assert hashlib.sha256(manifest_bytes).hexdigest()==expected
manifest=json.loads(manifest_bytes)
old=E/'predicate-review-build'; work=E/'predicate-review-r2-build';work.mkdir(exist_ok=True)
changed=[];inputs=[]
for e in manifest['files']:
 p=T/e['path']; b=p.read_bytes(); assert hashlib.sha256(b).hexdigest()==e['sha256']
 if b!=(old/p.name).read_bytes():changed.append(p.name)
 (work/p.name).write_bytes(b)
 if p.stem in ['SemaphorePure','CrtosHeapBridge','SemaphoreRep']:
  shutil.copyfile(old/(p.stem+'.vo'),work/(p.stem+'.vo'))
 inputs.append(e)
assert changed==['CrtosOSPure.v'],changed
args=shlex.split((T/'_CoqProject').read_text()); args=[str(work) if a==str(T/'lib') else a for a in args]
checks=[]; start=time.monotonic()
for name in ['CrtosOSPure','CrtosOSProtocol','CrtosOSInv','SemaphoreCritical']:
 cmd=['/home/xinra/.opam/default/bin/coqc',*args,str(work/(name+'.v'))]
 r=subprocess.run(cmd,text=True,capture_output=True,cwd=T)
 checks.append(dict(file=name+'.v',command=cmd,exit_code=r.returncode,stdout=r.stdout,stderr=r.stderr))
 assert r.returncode==0,r.stderr
probe=E/'probes/PR02PendingCheck.v'; shutil.copyfile(probe,work/probe.name)
cmd=['/home/xinra/.opam/default/bin/coqc',*args,str(work/probe.name)]
r=subprocess.run(cmd,text=True,capture_output=True,cwd=T)
checks.append(dict(file=probe.name,sha256=hashlib.sha256(probe.read_bytes()).hexdigest(),command=cmd,exit_code=r.returncode,stdout=r.stdout,stderr=r.stderr))
assert r.returncode==0,r.stderr
out={'revision':'predicate-r2-fc2db1b1c887','manifest_sha256':expected,'changed_formal_files':changed,'checks':checks,'elapsed_seconds':time.monotonic()-start,'result':'compile-passed; issue delta review separate'}
(E/'predicate-review-r2-check.json').write_text(json.dumps(out,indent=2)+'\n')
print('r2 delta: exact hashes; only CrtosOSPure changed; 4 affected formal + PR02 probe compiled independently')
