from pathlib import Path
import hashlib,json,subprocess
E=Path(__file__).resolve().parent; T=E.parent
run=json.loads((E/'nest-counterexample-result.json').read_text())
esc=json.loads((E/'nest-counterexample-escalated-result.json').read_text())
# Reuse only lexical helper definitions; do not execute author-side spec review/build.
ns={'__file__':str(E/'spec-check.py')}
code=(E/'spec-check.py').read_text().split('files=sorted(',1)[0]
exec(compile(code,str(E/'spec-check.py'),'exec'),ns)
checks={}
for rel,digest in run['input_sha256'].items():
 p=T/rel; raw=p.read_bytes(); name=p.stem
 assert hashlib.sha256(raw).hexdigest()==digest
 pp=subprocess.run(['gcc','-E','-P',str(p)],capture_output=True,text=True,check=True).stdout
 assert ns['normalize'](ns['definition'](pp,name),name)==ns['normalize'](ns['source'][name],name)
 checks[name]={'sha256':digest,'independent_token_comparison':True}
for e in json.loads((E/'spec-extraction.json').read_text())['functions']:
 assert hashlib.sha256((T.parent/e['source']).read_bytes()).hexdigest()==e['source_sha256']
assert hashlib.sha256((E/'nest-counterexample.c').read_bytes()).hexdigest()==run['harness_sha256']
binary_digest=hashlib.sha256((E/'nest-counterexample').read_bytes()).hexdigest()
assert binary_digest==esc['binary_sha256']
assert run['harness_sha256']==esc['harness_sha256']
assert 'static struct Semaphore arena_object;' in (E/'nest-counterexample.c').read_text()
assert run['balanced_caller_locks'] and esc['balanced_caller_locks']
execution=subprocess.run([str(E/'nest-counterexample')],text=True,capture_output=True)
assert execution.returncode==0
out={'checks':checks,'harness_sha256':run['harness_sha256'],'binary_sha256':binary_digest,
     'reviewer_independent_execution':{'mode':'require_escalated; auto-approved','exit_code':execution.returncode,
       'stdout':execution.stdout,'stderr':execution.stderr},
     'limitations':['ILP32 x86 diagnostic, not execution on Cortex-M3 hardware',
       'IRQ stubs match concrete PRIMASK effects; full formal Rely/token contracts not proved',
       'Unrestricted API-client sequence, not fixed-board call-graph reachability',
       'Typed arena and matching caller unlock sequence reviewed; no claim that r1 Outside nest=0 permits this sequence']}
(E/'predicate-review-nest-check.json').write_text(json.dumps(out,indent=2)+'\n')
print('9 source-token comparisons and all current-input/harness/binary hashes passed')
