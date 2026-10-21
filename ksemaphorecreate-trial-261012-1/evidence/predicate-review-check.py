from pathlib import Path
import hashlib,json,shlex,subprocess,time
trial=Path(__file__).resolve().parents[1]
manifest=json.loads((trial/'evidence/predicate-manifest.json').read_text())
expected='f6fc3c3b2bf82120166696c0790a8870c612466b0a1e0a3ab95f1adabaf84b92'
assert hashlib.sha256((trial/'evidence/predicate-manifest.json').read_bytes()).hexdigest()==expected
scratch=trial/'evidence/predicate-review-build'; scratch.mkdir(exist_ok=True)
args=shlex.split((trial/'_CoqProject').read_text())
args=[str(scratch) if a==str(trial/'lib') else a for a in args]
checks=[]; start=time.monotonic()
for entry in manifest['files']:
 p=trial/entry['path']; b=p.read_bytes(); assert hashlib.sha256(b).hexdigest()==entry['sha256']
 copy=scratch/p.name; copy.write_bytes(b)
 cmd=['/home/xinra/.opam/default/bin/coqc',*args,str(copy)]
 r=subprocess.run(cmd,text=True,capture_output=True,cwd=trial)
 checks.append(dict(file=entry['path'],sha256=entry['sha256'],command=cmd,exit_code=r.returncode,stdout=r.stdout,stderr=r.stderr))
 if r.returncode: break
queries='''Require Import CRTOS_Verify.sem.SemaphoreCritical CRTOS_Verify.sem.CrtosOSProtocol.
Print CrtosCritical.OutsideCritical.
Print CrtosCritical.InsideCritical.
Print Crtos_C_STS.c_sts.
Print Crtos_C_Rules.struct_padding.
Print Assumptions CrtosHeapBridge.crtos_heap_lift_sep.
Print Assumptions SemaphoreOutsideCritical_valid.
'''
cmd=['/home/xinra/.opam/default/bin/coqtop','-quiet',*args]
r=subprocess.run(cmd,input=queries,text=True,capture_output=True,cwd=trial)
(scratch/'framework-print.log').write_text(r.stdout+'\n'+r.stderr)
result={'revision':'predicate-r1-f6fc3c3b2bf8','manifest_sha256':expected,'checks':checks,'framework_print_exit':r.returncode,'framework_print_errors':('Error:' in r.stderr),'elapsed_seconds':time.monotonic()-start}
(trial/'evidence/predicate-review-check.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'compile_exit_codes':[c['exit_code'] for c in checks],'elapsed_seconds':result['elapsed_seconds']}))
