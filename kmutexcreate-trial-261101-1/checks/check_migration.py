from pathlib import Path
import json,hashlib,re
T=Path(__file__).resolve().parents[1];R=T.parent
sha=lambda b:hashlib.sha256(b).hexdigest()
pred=json.loads((T/'checks/predicate-revision.json').read_text())
spec=json.loads((T/'checks/spec-manifest.json').read_text())
locations=json.loads((T/'checks/review-file-locations.json').read_text())
for f,h in pred['files'].items():
 original=(T/locations.get(f,f)).read_bytes();assert sha(original)==h,f
 converted=original.decode().replace('KMutexCreateTrial.lib.','CRTOS_Verify.lib.').encode()
 assert converted==(R/f).read_bytes(),f
for f,h in spec['files'].items():
 original=(T/'checks/review-inputs'/f).read_bytes();assert sha(original)==h,f
 converted=original.decode().replace('KMutexCreateTrial.lib.','CRTOS_Verify.lib.').encode()
 assert converted==(T/f).read_bytes(),f
assert 'KMutexCreateTrial' not in (T/'_CoqProject').read_text()
assert not re.search(r'^lib/.*\.v$',(T/'_CoqProject').read_text(),re.M)
for n in ['MutexState','MutexInv','MutexOps','KMutexCreate']:
 assert not re.search(r'^\s*(Axiom|Parameter|Admitted)\b',(R/'lib'/f'{n}.v').read_text(),re.M)
result={'predicate_revision':pred['revision'],'spec_revision':spec['revision_sha256'],'library_files_checked':len(pred['files']),'spec_files_checked':len(spec['files']),'semantic_delta_during_migration':False,'trial_snapshots_excluded_from_build':True,'new_axiom_or_admitted':False}
(T/'checks/migration-check.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
