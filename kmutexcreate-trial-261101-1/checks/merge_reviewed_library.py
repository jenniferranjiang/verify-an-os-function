#!/usr/bin/env python3
"""Run only after both independent design reviews pass."""
from pathlib import Path
import hashlib,json,shutil,subprocess,shlex,time
T=Path(__file__).resolve().parents[1]; R=T.parent
state=json.loads((T/'checks/review-status.json').read_text())
assert state['predicate']=='review-passed' and state['spec']=='review-passed'
sha=lambda b:hashlib.sha256(b).hexdigest()
base=json.loads((T/'checks/predicate-baseline.json').read_text())
manifest=json.loads((T/'checks/predicate-revision.json').read_text())
assert state['predicate_revision']==manifest['revision']
for file,digest in manifest['files'].items(): assert sha((T/file).read_bytes())==digest,file
# Compare against the actual worktree baseline, not HEAD: preserve earlier user changes.
for name,digest in base.items(): assert sha((R/'lib'/name).read_bytes())==digest,('concurrent change',name)
new=['MutexState.v','MutexInv.v','MutexOps.v','KMutexCreate.v']
for name in new:assert not (R/'lib'/name).exists(),('new-file conflict',name)
records=[]
for src in sorted((T/'lib').glob('*.v')):
 before=(R/'lib'/src.name).read_bytes() if (R/'lib'/src.name).exists() else None
 converted=src.read_text().replace('KMutexCreateTrial.lib.','CRTOS_Verify.lib.').encode()
 assert b'KMutexCreateTrial' not in converted
 if before!=converted:(R/'lib'/src.name).write_bytes(converted)
 records.append({'trial':'lib/'+src.name,'trial_sha256':sha(src.read_bytes()),'global':'lib/'+src.name,'global_sha256':sha(converted),'changed':before!=converted})
proj=R/'_CoqProject'; content=proj.read_text()
for name in new:
 line='lib/'+name
 if line not in content.splitlines():content+='\n'+line+'\n'
proj.write_text(content)
# Preserve the reviewed input, then use only globally compiled modules.
snap=T/'checks/review-inputs'; snap.mkdir(exist_ok=True)
shutil.copy2(T/'_CoqProject',snap/'_CoqProject')
shutil.copytree(T/'annotated_C',snap/'annotated_C')
shutil.copy2(T/'checks/SpecInterfaceCheck.v',snap/'SpecInterfaceCheck.v')
for f in (T/'annotated_C').rglob('*.h'):
 f.write_text(f.read_text().replace('KMutexCreateTrial.lib.','CRTOS_Verify.lib.'))
f=T/'checks/SpecInterfaceCheck.v'; f.write_text(f.read_text().replace('KMutexCreateTrial.lib.','CRTOS_Verify.lib.'))
lines=[]
for line in proj.read_text().splitlines():
 parts=shlex.split(line)
 if parts and parts[0] in ['-R','-Q']:
  lines.append(' '.join([parts[0],str((R/parts[1]).resolve()),parts[2]]))
(T/'_CoqProject').write_text('\n'.join(lines)+'\n\nchecks/SpecInterfaceCheck.v\n')
(T/'checks/migration.json').write_text(json.dumps({'predicate_revision':state['predicate_revision'],'spec_revision':state['spec_revision'],'semantics':'logical path substitution only after reviewed changes','files':records},indent=2)+'\n')
# Root Makefile must be generated from the root project and cannot reference trial.
coqbin=Path('/home/xinra/.opam/pv-bench-8.20.1/bin')
r=subprocess.run([str(coqbin/'coq_makefile'),'-f','_CoqProject','-o','Makefile.coq'],cwd=R,capture_output=True,text=True)
(T/'checks/root-makefile.log').write_text(r.stdout+r.stderr);assert r.returncode==0
print(json.dumps({'changed_global_files':[x['global'] for x in records if x['changed']],'trial_build':'global-library-only'},indent=2))
