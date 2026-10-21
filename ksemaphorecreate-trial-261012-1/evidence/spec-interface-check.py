#!/usr/bin/env python3
"""Check declared logical names/types against frozen formal sources; never run QCP."""
from pathlib import Path
import argparse,hashlib,json,re,shlex,subprocess,time
E=Path(__file__).resolve().parent;T=E.parent
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--predicate-build', type=Path, required=True)
parser.add_argument('--predicate-manifest', type=Path, required=True)
parser.add_argument('--expected-predicate-revision', required=True)
parser.add_argument('--coq-project', type=Path, required=True)
parser.add_argument('--coqc', type=Path, required=True)
args=parser.parse_args()
start=time.monotonic()
pred=json.loads(args.predicate_build.read_text())
assert pred['revision']==args.expected_predicate_revision
manifest=json.loads(args.predicate_manifest.read_text())
assert hashlib.sha256(args.predicate_manifest.read_bytes()).hexdigest()==pred['manifest_sha256']
project_text=args.coq_project.read_text()
project_sha256=hashlib.sha256(args.coq_project.read_bytes()).hexdigest()
if 'config_sha256' in pred: assert project_sha256==pred['config_sha256']
if 'compiler' in pred: assert str(args.coqc.resolve())==str(Path(pred['compiler']).resolve())
project_args=shlex.split(project_text)
assert 'ksemaphorecreate-trial-260928-1' not in project_text
assert '/home/xinra/qcp-binary-democases/SeparationLogic/' not in project_text, 'legacy big-endian framework path is not accepted for this repair'
assert '/home/xinra/qcp-binary-democases/Rocq/' in project_text
assert 'pv-bench-8.20.1' in str(args.coqc), 'use the accepted modern compiler'

for entry in manifest['files']:
 assert hashlib.sha256((T/entry['path']).read_bytes()).hexdigest()==entry['sha256'],entry['path']
acceptance=json.loads((E/'accepted-revisions.json').read_text())
assert acceptance['predicate_status']=='review-passed'
assert acceptance['predicate_revision']==pred['revision'] and acceptance['predicate_manifest']==pred['manifest_sha256']
assert acceptance['coqproject_sha256']==project_sha256
assert str(args.coqc.resolve())==str(Path(acceptance['compiler']).resolve())
annotated=json.loads((E/'spec-annotated-manifest.json').read_text())
for rel,h in annotated.items():assert hashlib.sha256((T/rel).read_bytes()).hexdigest()==h,rel
header=(T/'annotated_C/include/semaphore_logic.h').read_text()
imports=re.findall(r'/\*@ Import Coq (.*?) \*/',header)
extern='\n'.join(re.findall(r'/\*@ Extern Coq(.*?)\*/',header,re.S))
entries=re.findall(r'\(([A-Za-z_][A-Za-z_0-9:]*)\s+(::|:)\s+([^()]*)\)',extern)
assert len(entries)==len(re.findall(r'^    \(',extern,re.M))
lines=['(* Interface type checks only; no copied C function contracts or added definitions. *)', 'From Coq Require Import ZArith.ZArith Lists.List.']
lines += [x+'.' for x in imports]
lines += ['Import ListNotations.','Local Open Scope Z_scope.', 'Check ((fun (P : Assertion) => P) : Crtos_C_Rules.expr -> Crtos_C_Rules.expr).']
for name,kind,typ in entries:
 coq_name=name.replace('::','.')
 coq_type='Type' if kind=='::' else re.sub(r'\bAssertion\b','Crtos_C_Rules.expr',typ.replace('::','.'))
 lines.append(f'Check ({coq_name} : {coq_type}).')
lines += ['''(* Representative composed terms appearing within contracts; these are not full specs. *)
Section ContractTermTypes.
Variables (sg : CrtosOSStable) (hs : list Z) (before current after : CrtosOSState).
Variables (sm : StableIdmanager) (manager_before : VarIdmanager).
Variables (p id value handler old_id previous next : Z).
Check (scheduler_lock_nest (os_scheduler before) < 65535 : Prop).
Check (idmanager_full (semaphore_manager_abs (os_sem_stable sg))
  (semaphore_manager_state (os_sem_stable sg) (os_semaphores current)) : Prop).
Check (idmanager_min_free_id (semaphore_manager_abs (os_sem_stable sg))
  (semaphore_manager_state (os_sem_stable sg) (os_semaphores current)) id : Prop).
Check (SemaphoreGuarantee current (semaphore_os_publish p id value current) : Prop).
Check (SemaphoreOutsideCritical sg hs (semaphore_os_publish p id value current) : Crtos_C_Rules.expr).
Check (SemaphoreOSInvariant sg (semaphore_nest_increment current) : Crtos_C_Rules.expr).
Check (SemaphoreGuarantee before (semaphore_nest_decrement after) : Prop).
Check (SemaphoreOutsideCritical sg hs (semaphore_nest_decrement after) : Crtos_C_Rules.expr).
Check (semaphore_nest_increment (semaphore_os_publish p id value current) : CrtosOSState).
Check (OSHeap (store_idmanager sm (idmanager_link sm (idmanager_add manager_before id) id p) p) : Crtos_C_Rules.expr).
Check (OSHeap (store_idmanager_allocated_unlinked sm manager_before p id) : Crtos_C_Rules.expr).
Check (OSHeap (store_sem_id_detached p old_id previous next) : Crtos_C_Rules.expr).
End ContractTermTypes.
''']
D=E/'spec-interface-check';D.mkdir(exist_ok=True)
v=D/'SpecInterfaceCheck.v';v.write_text('\n'.join(lines)+'\n')
cmd=[str(args.coqc),*project_args,str(v)]
r=subprocess.run(cmd,capture_output=True,text=True,cwd=T)
(E/'spec-interface-check.log').write_text(r.stdout+r.stderr)
result={'status':'passed' if r.returncode==0 else 'failed','predicate_revision':pred['revision'],'predicate_manifest_sha256':pred['manifest_sha256'],'coq_project':str(args.coq_project),'coq_project_sha256':project_sha256,'compiler':str(args.coqc),'compiler_sha256':hashlib.sha256(args.coqc.read_bytes()).hexdigest(),'source_revision':json.loads((E/'source-check-result.json').read_text())['source_revision'],'spec_revision':json.loads((E/'spec-check-result.json').read_text())['spec_revision'],'annotated_manifest_sha256':json.loads((E/'spec-check-result.json').read_text())['annotated_manifest_sha256'],'extern_count':len(entries),'composed_term_checks':12,'default_assertion_carrier_checked':True,'header_sha256':hashlib.sha256(header.encode()).hexdigest(),'check_file_sha256':hashlib.sha256(v.read_bytes()).hexdigest(),'command':cmd,'exit_code':r.returncode,'elapsed_seconds':time.monotonic()-start,'qcp_started':False,'predicate_independent_review_status':acceptance['predicate_status'],'predicate_independent_review':acceptance['predicate_review'],'predicate_acceptance_record_sha256':hashlib.sha256((E/'accepted-revisions.json').read_bytes()).hexdigest(),'scope':'Names/types/arities and composed-term compatibility only; not QCP syntax, symbolic execution, contract validity, or independent spec review.'}
(E/'spec-interface-check.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k!='command'},indent=2))
if r.returncode:print(r.stdout,r.stderr)
raise SystemExit(r.returncode)
