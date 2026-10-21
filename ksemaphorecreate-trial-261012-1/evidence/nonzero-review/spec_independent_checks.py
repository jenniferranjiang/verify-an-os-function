from pathlib import Path
import re,json,hashlib,subprocess,difflib,time
start=time.monotonic()
trial=Path('/home/xinra/crtos/ksemaphorecreate-trial-261012-1')
review=trial/'evidence/nonzero-review'
old=trial/'evidence/spec-arm32le-r4/frozen-annotated_C'
current=trial/'annotated_C'
manifest=json.loads((trial/'evidence/spec-annotated-manifest.json').read_text())
digest=hashlib.sha256(json.dumps(manifest,sort_keys=True,separators=(',',':')).encode()).hexdigest()
assert digest=='480669e8557a5f09a7683b69c5de2b087857f93649ef9c6729096df1c6a8b3cf'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for rel,h in manifest.items(): assert sha(trial/rel)==h,rel
pred=trial/'evidence/predicate-manifest.json'
assert sha(pred)=='fe8c4261db5cff754395f3d9038769b3e50420d542347262a831aa3ce6a422b3'
for e in json.loads(pred.read_text())['files']: assert sha(trial/e['path'])==e['sha256'],e['path']
names={'AllocId','InsertObj','IdInsertObj','KSemaphoreCreate','_SemaphoreCreate','CriticalAreaLock','CriticalAreaUnLock','InitDoubleLinkList','DoubleLinkListInsertNodeAfter'}
trusted={'x_malloc','x_free','memset','DisableLocalInterrupt','EnableLocalInterrupt','KPrintf'}
assert {p.stem for p in (current/'src').glob('*.c')}==names
strip=lambda s:re.sub(r'/\*.*?\*/|//[^\n]*','',s,flags=re.S)
tok=lambda s:re.findall(r'"(?:\\.|[^"\\])*"|[A-Za-z_]\w*|\d+|->|\+\+|--|==|!=|<=|>=|&&|\|\||[^\s]',s)
contracts={};calls={};changed=[];deltas=[];canonical={}
for n in sorted(names):
    p=current/'src'/f'{n}.c'; q=old/'src'/f'{n}.c'; new=p.read_text(); before=q.read_text()
    if new!=before:
        changed.append(str(p.relative_to(trial)))
        deltas.extend(difflib.unified_diff(before.splitlines(),new.splitlines(),fromfile=str(q.relative_to(trial)),tofile=str(p.relative_to(trial)),lineterm=''))
    assert tok(strip(new))==tok(strip(before)),(n,'executable tokens changed')
    pattern=r'^(?:void\s*\*|void|int32|int|x_base)\s*([A-Za-z_]\w*)\([^\n]*\)\s*(/\*@.*?\*/)\s*([;{])'
    now=list(re.finditer(pattern,new,re.M|re.S)); prev=list(re.finditer(pattern,before,re.M|re.S))
    assert [(m.group(1),m.group(2),m.group(3)) for m in now]==[(m.group(1),m.group(2),m.group(3)) for m in prev],(n,'contract delta')
    contracts[n]={m.group(1):m.group(2) for m in now}
    bodymatches=[m for m in now if m.group(3)=='{']
    assert len(bodymatches)==1 and bodymatches[0].group(1)==n
    canonical[n]=bodymatches[0].group(2)
    body=strip(new[bodymatches[0].end()-1:]);body=re.sub(r'"(?:\\.|[^"\\])*"','""',body)
    calls[n]=sorted(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',body))-{'if','for','while','switch','sizeof','return'})
    assert set(contracts[n])=={n}|set(calls[n])
for n in names:
    for callee in calls[n]:
        assert callee in names|trusted
        if callee in names: assert contracts[n][callee]==canonical[callee]
for t in trusted:
    cs=[v[t] for v in contracts.values() if t in v]
    assert cs and len(set(cs))==1
seen=set();todo=['KSemaphoreCreate']
while todo:
    n=todo.pop()
    if n in seen: continue
    seen.add(n);todo.extend(calls.get(n,[]))
assert seen==names|trusted
for h in (current/'include').glob('*.h'):
    assert h.read_bytes()==(old/'include'/h.name).read_bytes(),('header changed',h.name)
command=['gcc','-m32','-std=gnu11','-ffreestanding','-fno-builtin','-Wall','-Wextra','-fsyntax-only',*[str(p) for p in sorted((current/'src').glob('*.c'))],str(trial/'evidence/spec-layout-check.c')]
r=subprocess.run(command,text=True,capture_output=True);assert r.returncode==0,r.stderr
(review/'spec-annotation-delta.patch').write_text('\n'.join(deltas)+'\n')
result={'spec_revision':'spec-r5-480669e8557a','canonical_manifest_digest':digest,'predicate_manifest_sha256':sha(pred),'manifest_files':len(manifest),'canonical_count':len(canonical),'trusted_count':len(trusted),'changed_vs_r4':changed,'header_changed':False,'all_canonical_and_caller_contracts_unchanged_vs_r4':True,'all_executable_tokens_unchanged_vs_r4':True,'all_caller_contracts_equal_canonical':True,'direct_calls':calls,'reachable':sorted(seen),'c_compile':{'command':command,'returncode':r.returncode,'stderr':r.stderr},'elapsed_seconds':time.monotonic()-start,'qcp_invoked':False}
(review/'spec-independent-checks.json').write_text(json.dumps(result,indent=2));print(json.dumps({k:v for k,v in result.items() if k not in ('direct_calls','c_compile')},indent=2))
