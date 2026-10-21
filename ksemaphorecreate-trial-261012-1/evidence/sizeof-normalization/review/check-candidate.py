from pathlib import Path
import ast,hashlib,json,re,os,shutil,subprocess,time
start=time.monotonic()
T=Path('/home/xinra/crtos/ksemaphorecreate-trial-261012-1'); E=T/'evidence'; B=E/'sizeof-normalization'; C=B/'candidate'; R=B/'review'; W=R/'independent-work'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(C/'evidence/delivery-manifest.json')=='4e7a946348b00ad00bd14b3fd54d36889f3f8748c536095b180ebae2bd5d89ad'
delivery=json.loads((C/'evidence/delivery-manifest.json').read_text())
for p,h in delivery.items(): assert sha(C/p)==h,p
manifest=json.loads((C/'evidence/spec-annotated-manifest.json').read_text())
digest=hashlib.sha256(json.dumps(manifest,sort_keys=True,separators=(',',':')).encode()).hexdigest()
assert digest=='ae22a04e2c951be960fddd724fae8d23a5f2034b8f65765318472ff549c79e18'
for p,h in manifest.items(): assert sha(C/p)==h
assert len(manifest)==11
for rel in [Path(p).relative_to('annotated_C') for p in manifest]:
    old=(B/'before-annotated_C'/rel).read_text(); new=(C/'annotated_C'/rel).read_text()
    assert old==(T/'annotated_C'/rel).read_text(),('active not frozen before',str(rel))
    expected=old
    if str(rel)=='src/_SemaphoreCreate.c':
        for a,b in [('x_malloc(sizeof(struct Semaphore))','x_malloc((x_size_t)32)'),('memset(sem, 0, sizeof(struct Semaphore))','memset(sem, 0, (x_size_t)32)')]:
            assert expected.count(a)==1
            expected=expected.replace(a,b)
    assert expected==new,('extra candidate edit',str(rel))
    assert re.findall(r'/\*.*?\*/|//[^\n]*',old,re.S)==re.findall(r'/\*.*?\*/|//[^\n]*',new,re.S)
pred=json.loads((E/'predicate-manifest.json').read_text())
assert sha(E/'predicate-manifest.json')=='fe8c4261db5cff754395f3d9038769b3e50420d542347262a831aa3ce6a422b3'
for p in pred['files']:assert sha(T/p['path'])==p['sha256']
src=json.loads((E/'source-manifest.json').read_text());root=Path(json.loads((E/'source-check-result.json').read_text())['authoritative_root'])
for p,h in src.items():assert sha(root/p)==h
commands=[]
def run(cmd,**kw):
    p=subprocess.run(cmd,text=True,capture_output=True,**kw);commands.append({'command':cmd,'exit_code':p.returncode,'stderr':p.stderr})
    assert p.returncode==0,p.stderr
    return p.stdout
incs=[x for p in [E/'source-config',root/'kernel/include',root/'arch/arm/cortex-m3',root/'tool/shell/letter-shell'] for x in ['-I',str(p)]]
for f in ['source-type-check.c','slice-type-check.c']:
    run(['gcc','-m32','-std=gnu11','-ffreestanding','-fno-builtin','-fsyntax-only',str(C/'evidence'/f)]+(incs if f.startswith('source') else []))
tree=ast.parse((E/'source-check.py').read_text());ns={'re':re}
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['masked','definitions']],type_ignores=[]),'review-extraction','exec'),ns)
bodies={}
for f in ['semaphore.c','id.c','double_link.c','CriticalArea.c']:
    output=run(['gcc','-E','-P',str(root/'kernel/thread'/f)]+incs);bodies.update(ns['definitions'](output))
saved=json.loads((E/'source-bodies.json').read_text())
assert all(bodies[n]==body for n,body in saved.items())
W.mkdir(exist_ok=True);shutil.copytree(C/'annotated_C',W/'annotated_C',dirs_exist_ok=True);(W/'evidence').mkdir(exist_ok=True)
shutil.copyfile(C/'evidence/spec-layout-check.c',W/'evidence/spec-layout-check.c')
env={**os.environ,'SPEC_TRIAL_EVIDENCE':str(E),'SPEC_ANNOTATED_ROOT':str(W/'annotated_C'),'SPEC_OUTPUT_DIR':str(W/'evidence')}
run(['python3',str(C/'evidence/spec-check.py')],env=env)
baseline=json.loads((W/'evidence/spec-check-result.json').read_text()); assert baseline['annotated_manifest_sha256']==digest
mutants=[
('malloc31','_SemaphoreCreate','x_malloc((x_size_t)32)','x_malloc((x_size_t)31)'),
('memset64','_SemaphoreCreate','memset(sem, 0, (x_size_t)32)','memset(sem, 0, (x_size_t)64)'),
('malloc_original','_SemaphoreCreate','x_malloc((x_size_t)32)','x_malloc(sizeof(struct Semaphore))'),
('memset_original','_SemaphoreCreate','memset(sem, 0, (x_size_t)32)','memset(sem, 0, sizeof(struct Semaphore))'),
('wrong_type','_SemaphoreCreate','x_malloc((x_size_t)32)','x_malloc(sizeof(struct IdNode))'),
('extra_sizeof','_SemaphoreCreate','return id;','return id + sizeof(struct Semaphore);'),
('other_function','KSemaphoreCreate','return _SemaphoreCreate(val)','return _SemaphoreCreate(val + 1)'),
('wrong_zero_value','_SemaphoreCreate','memset(sem, 0, (x_size_t)32)','memset(sem, 1, (x_size_t)32)'),
('wrong_destination','_SemaphoreCreate','memset(sem, 0, (x_size_t)32)','memset(0, 0, (x_size_t)32)'),
('size_side_effect','_SemaphoreCreate','x_malloc((x_size_t)32)','x_malloc((x_size_t)(val++,32))'),
('other_assignment','_SemaphoreCreate','sem->value = val;','sem->value = val + 1;'),
('extra_call','_SemaphoreCreate','memset(sem, 0, (x_size_t)32);','memset(sem, 0, (x_size_t)32); memset(sem, 0, (x_size_t)32);')]
negative=[]
for name,f,a,b in mutants:
    p=W/'annotated_C/src'/f'{f}.c'; original=p.read_text();assert original.count(a)==1,(name,a)
    p.write_text(original.replace(a,b));x=subprocess.run(['python3',str(C/'evidence/spec-check.py')],env=env,text=True,capture_output=True);p.write_text(original)
    assert x.returncode!=0 and 'source token mismatch' in x.stderr,(name,x.stderr)
    negative.append({'mutation':name,'rejected':True,'exit_code':x.returncode,'diagnostic':'source token mismatch'})
for p,h in delivery.items(): assert sha(C/p)==h,('frozen candidate changed',p)
result={'spec_revision':baseline['spec_revision'],'canonical_manifest_digest':digest,'delivery_manifest_sha256':sha(C/'evidence/delivery-manifest.json'),'checker_sha256':sha(C/'evidence/spec-check.py'),'validator_sha256':sha(C/'evidence/validate-candidate.py'),'extraction_sha256':sha(C/'evidence/spec-extraction.json'),'source_hash_count':len(src),'source_reextracted':sorted(saved),'predicate_source_count':len(pred['files']),'exact_delta_only_two_arguments':True,'all_annotations_identical':True,'candidate_unchanged':True,'negative_checker_tests':negative,'commands':commands,'elapsed_seconds':time.monotonic()-start,'qcp_invoked':False}
(R/'independent-candidate-checks.json').write_text(json.dumps(result,indent=2)); print(json.dumps({k:v for k,v in result.items() if k!='commands'},indent=2))
