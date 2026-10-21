#!/usr/bin/env python3
"""Read-only checks of frozen inputs; writes reports only beside this script."""
from pathlib import Path
import ast, difflib, hashlib, json, os, re, shutil, subprocess, tempfile
O=Path(__file__).resolve().parent; C=O.parent; B=C.parent; E=B.parent; T=E.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
result={}; commands=[]
def run(cmd,**kw):
 p=subprocess.run(cmd,text=True,capture_output=True,**kw)
 commands.append({'command':cmd,'returncode':p.returncode,'stderr':p.stderr})
 assert p.returncode==0,p.stderr
 return p.stdout
manifest=json.loads((E/'source-manifest.json').read_text())
sr=json.loads((E/'source-check-result.json').read_text()); R=Path(sr['authoritative_root'])
assert len(manifest)==47 and all(sha(R/f)==h for f,h in manifest.items())
result['source_revision']=sr['source_revision'];result['source_files_matched']=47
result['source_manifest_sha256']=sha(E/'source-manifest.json')
result['bound_arm_evidence']={f:sha(E/f) for f in ['source-abi.c','source-abi.s','source-check-result.json','source-target-macros.txt','source-config/xsconfig.h']}
result['current_arm_compiler_exists']=Path('/tmp/crtos-arm-toolchain/root/usr/bin/arm-none-eabi-gcc').is_file()
result['arm_evidence_policy']='Reuse unchanged current-trial target compilation evidence; no new ARM compile claimed.'
incs=[x for p in [E/'source-config',R/'kernel/include',R/'arch/arm/cortex-m3',R/'tool/shell/letter-shell'] for x in ['-I',str(p)]]
base=['gcc','-m32','-std=gnu11','-ffreestanding','-fno-builtin','-fsyntax-only']
run(base+[str(O/'source-type-check.c')]+incs)
run(base+[str(O/'slice-type-check.c')])
result['native_ilp32_source_and_slice_type_layout_checks']='passed'
# Re-extract all current source function bodies, rather than trusting saved body text.
tree=ast.parse((E/'source-check.py').read_text())
ns={'re':re};exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in {'masked','definitions'}],type_ignores=[]),'source-extraction-functions','exec'),ns)
bodies={}
for rel in ['kernel/thread/semaphore.c','kernel/thread/id.c','kernel/thread/double_link.c','kernel/thread/CriticalArea.c']:
 pp=run(['gcc','-E','-P',str(R/rel)]+incs)
 bodies.update(ns['definitions'](pp))
 if rel.endswith('/semaphore.c'):
  assert re.search(r'extern void \*memset\s*\([^;]*size_t',pp)
  (O/'current-memset-prototype.txt').write_text('\n'.join(l for l in pp.splitlines() if 'memset (' in l or re.search(r'typedef.*size_t;',l))+'\n')
saved=json.loads((E/'source-bodies.json').read_text())
assert all(bodies[n]==b for n,b in saved.items())
result['current_source_reextraction_matches_saved_bodies']=sorted(saved)
# Predicate source closure is unchanged; no compilation or formal edits needed.
pred=json.loads((E/'predicate-manifest.json').read_text())
for item in pred['files']:
 assert sha(T/item['path'])==item['sha256'],item['path']
result['predicate_manifest_sha256']=sha(E/'predicate-manifest.json')
assert result['predicate_manifest_sha256']=='fe8c4261db5cff754395f3d9038769b3e50420d542347262a831aa3ce6a422b3'
result['predicate_source_files_matched']=len(pred['files'])
# Stronger than a contract-only check: all annotation/comments and all other bytes identical.
files=sorted(p.relative_to(B/'before-annotated_C') for p in (B/'before-annotated_C').rglob('*') if p.is_file())
assert len(files)==11
assert files==sorted(p.relative_to(C/'annotated_C') for p in (C/'annotated_C').rglob('*') if p.is_file())
changed=[];diff=[];comments=[]
for rel in files:
 old=(B/'before-annotated_C'/rel).read_text();new=(C/'annotated_C'/rel).read_text()
 expected=old
 if str(rel)=='src/_SemaphoreCreate.c':
  for a,b in [('x_malloc(sizeof(struct Semaphore))','x_malloc((x_size_t)32)'),('memset(sem, 0, sizeof(struct Semaphore))','memset(sem, 0, (x_size_t)32)')]:
   assert expected.count(a)==1; expected=expected.replace(a,b)
 assert new==expected,rel
 assert re.findall(r'/\*.*?\*/|//[^\n]*',old,re.S)==re.findall(r'/\*.*?\*/|//[^\n]*',new,re.S),rel
 if old!=new:changed.append(str(rel))
 diff.extend(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='before/annotated_C/'+str(rel),tofile='candidate/annotated_C/'+str(rel)))
(O/'annotated.diff').write_text(''.join(diff))
result['changed_annotated_files']=changed;result['all_contracts_and_proof_annotations_byte_identical']=True
result['snapshot_file_count']=len(files)
# Execute actual proposed checker against temporary mutants; no writes to candidate C.
mutations=[
 ('malloc31','src/_SemaphoreCreate.c','x_malloc((x_size_t)32)','x_malloc((x_size_t)31)'),
 ('memset64','src/_SemaphoreCreate.c','memset(sem, 0, (x_size_t)32)','memset(sem, 0, (x_size_t)64)'),
 ('malloc_not_normalized','src/_SemaphoreCreate.c','x_malloc((x_size_t)32)','x_malloc(sizeof(struct Semaphore))'),
 ('memset_not_normalized','src/_SemaphoreCreate.c','memset(sem, 0, (x_size_t)32)','memset(sem, 0, sizeof(struct Semaphore))'),
 ('other_sizeof','src/_SemaphoreCreate.c','x_malloc((x_size_t)32)','x_malloc(sizeof(struct IdNode))'),
 ('extra_sizeof','src/_SemaphoreCreate.c','return id;','return id + sizeof(struct Semaphore);'),
 ('other_function','src/KSemaphoreCreate.c','return _SemaphoreCreate(val)','return _SemaphoreCreate(val + 1)')]
negative=[]
with tempfile.TemporaryDirectory(prefix='sizeof-check-') as d:
 D=Path(d);shutil.copytree(C/'annotated_C',D/'annotated_C');(D/'evidence').mkdir()
 shutil.copy2(O/'spec-layout-check.c',D/'evidence/spec-layout-check.c')
 env={**os.environ,'SPEC_TRIAL_EVIDENCE':str(E),'SPEC_ANNOTATED_ROOT':str(D/'annotated_C'),'SPEC_OUTPUT_DIR':str(D/'evidence')}
 for name,rel,old,new in mutations:
  p=D/'annotated_C'/rel;original=p.read_text();assert original.count(old)==1,(name,old)
  p.write_text(original.replace(old,new))
  process=subprocess.run(['python3',str(O/'spec-check.py')],env=env,text=True,capture_output=True)
  p.write_text(original)
  assert process.returncode!=0 and 'source token mismatch' in process.stderr,(name,process.stderr)
  negative.append({'mutation':name,'rejected':True,'reason':'source token mismatch'})
result['negative_checker_tests']=negative
result['status']='author-checks-passed-awaiting-independent-review'
result['commands']=commands
(O/'candidate-validation.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k!='commands'},indent=2))
