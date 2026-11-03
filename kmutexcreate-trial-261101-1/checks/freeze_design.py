#!/usr/bin/env python3
from pathlib import Path
import hashlib,json
p=Path(__file__).resolve().parents[1]
assert not (p/'checks/review-inputs').exists(), 'Reviewed inputs are frozen; use a new revision explicitly.'
def sha(b):return hashlib.sha256(b).hexdigest()
def write(name,paths,extra):
 files={str(f.relative_to(p)):sha(f.read_bytes()) for f in sorted(paths)}
 artifact={**extra,'files':files}
 artifact['revision_sha256']=sha(json.dumps(artifact,sort_keys=True,separators=(',',':')).encode())
 (p/'checks'/name).write_text(json.dumps(artifact,ensure_ascii=False,indent=2)+'\n')
 return artifact['revision_sha256']
pred=json.loads((p/'checks/predicate-revision.json').read_text())['revision']
spec=write('spec-manifest.json',list((p/'annotated_C').rglob('*.c'))+list((p/'annotated_C').rglob('*.h')),{'kind':'spec','predicate_revision':pred,'status':'candidate-awaiting-predicate-review'})
print('predicate',pred,'spec',spec)
