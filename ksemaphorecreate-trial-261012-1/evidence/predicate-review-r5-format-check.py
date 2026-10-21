from pathlib import Path
import json,hashlib,shlex,subprocess,time,shutil
T=Path(__file__).resolve().parents[1];E=T/'evidence';F=E/'arm32le-candidate/frozen-r5-format';Old=E/'arm32le-candidate/frozen-r5';W=E/'predicate-review-r5-format-build';Previous=E/'predicate-review-r5-build'
sha=lambda b:hashlib.sha256(b).hexdigest()
expected='0a139d64743cce8000b0910d7880d6c5a0bf89147b730665aa6ebefbfb45585a'
assert sha((F/'predicate-manifest.json').read_bytes())==expected
entries=json.loads((F/'predicate-manifest.json').read_text())['files'];assert len(entries)==20
oldentries={e['path']:e['sha256'] for e in json.loads((Old/'predicate-manifest.json').read_text())['files']}
assert [e['path'] for e in entries if oldentries.get(e['path'])!=e['sha256']]==['lib/SemaphoreCriticalViews.v']
p='lib/SemaphoreCriticalViews.v';old=(Old/'sources'/p).read_text();new=(F/'sources'/p).read_text()
start=old.index('(** Lock/UnLock');end=old.index('\nLemma SemaphoreOSInvariant_split_nest',start)+1
block=old[start:end];assert new.count(block)==1
assert old.replace(block,'',1)==new.replace(block,'',1)
assert new.index('Definition SemaphoreCriticalFrame') < new.index('Local Lemma OSHeap_sep_eq')
reused=[]
for e in entries:
 p=e['path'];data=(F/'sources'/p).read_bytes();assert sha(data)==e['sha256'] and data==(T/p).read_bytes()
 dest=W/p;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data)
 if p!='lib/SemaphoreCriticalViews.v':
  assert (Previous/p).read_bytes()==data
  vo=(Previous/p).with_suffix('.vo');shutil.copy2(vo,dest.with_suffix('.vo'));reused.append({'file':p,'vo_sha256':sha(vo.read_bytes())})
a=shlex.split((Old/'_CoqProject.arm32le-candidate-r5').read_text())
for sub in ['shared-candidate/arm32le','lib','framework-candidate']:a=[str(W/sub) if x==str(T/sub) else x for x in a]
cmd=['/home/xinra/.opam/pv-bench-8.20.1/bin/coqc',*a,str(W/'lib/SemaphoreCriticalViews.v')]
t=time.monotonic();r=subprocess.run(cmd,text=True,capture_output=True,cwd=T);elapsed=time.monotonic()-t
assert r.returncode==0,r.stderr
for e in entries:assert sha((T/e['path']).read_bytes())==e['sha256']
out={'revision':'predicate-r5-0a139d64743c','manifest_sha256':expected,'move_only':True,'moved_block_sha256':sha(block.encode()),'other_19_sources_unchanged':True,'reused_independent_objects':reused,'command':cmd,'exit_code':r.returncode,'stdout':r.stdout,'stderr':r.stderr,'elapsed_seconds':elapsed,'result':'pure-reordering-delta-passed'}
(E/'predicate-review-r5-format-check.json').write_text(json.dumps(out,indent=2)+'\n');print(out['result'],elapsed)
