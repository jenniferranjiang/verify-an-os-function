from pathlib import Path
import json,hashlib,difflib,shutil,datetime,re
T=Path(__file__).resolve().parents[1]; E=T/'evidence/arm32le-candidate'; F=E/'frozen-r5';F.mkdir(exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
build=json.loads((E/'build-latest.json').read_text());assert build['all_passed'] and len(build['checks'])==20
assert json.loads((E/'r5-checks/result.json').read_text())['exit_code']==0
root=json.loads((E/'root-source-closure.json').read_text())
for x in root['files']:assert sha(Path(x['source']))==x['source_sha256']
framework=json.loads((E/'framework-source.json').read_text());assert sha(Path(framework['source']))==framework['source_sha256'];assert sha(T/framework['candidate'])==framework['source_sha256']
old=json.loads((E/'frozen-r4/predicate-manifest.json').read_text());oldfiles={x['path']:x for x in old['files']}
entries=[];changes=[];objects=[]
for c in build['checks']:
 rel=c['file'];p=T/rel;vo=p.with_suffix('.vo');assert c['exit_code']==0 and vo.exists() and vo.stat().st_mtime>=p.stat().st_mtime,rel
 d=F/'sources'/rel;d.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,d)
 entries.append({'path':rel,'sha256':sha(p)});objects.append({'path':str(vo.relative_to(T)),'sha256':sha(vo)})
 previous=E/'frozen-r4/sources'/rel;before=previous.read_text() if previous.exists() else ''
 diff=''.join(difflib.unified_diff(before.splitlines(True),p.read_text().splitlines(True),fromfile='r4/'+rel if previous.exists() else '/dev/null',tofile='r5/'+rel))
 if diff:changes.append({'path':rel,'previous_sha256':sha(previous) if previous.exists() else None,'sha256':sha(p),'diff':diff})
manifest={'format':'explicit-predicate-sources-v1','files':entries};encoded=(json.dumps(manifest,ensure_ascii=False,sort_keys=True,indent=2)+'\n').encode();digest=hashlib.sha256(encoded).hexdigest();(F/'predicate-manifest.json').write_bytes(encoded)
(F/'delta-from-r4.json').write_text(json.dumps(changes,ensure_ascii=False,indent=2)+'\n');(F/'delta-from-r4.patch').write_text(''.join(x['diff'] for x in changes))
config=T/'_CoqProject.arm32le-candidate-r5';shutil.copy2(config,F/config.name)
report={'revision':'predicate-r5-'+digest[:12],'manifest_sha256':digest,'status':'compiled-awaiting-independent-delta-review','frozen_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'base_revision':'predicate-r4-1b07e9068830','compiler':'/home/xinra/.opam/pv-bench-8.20.1/bin/coqc','config':str(config.relative_to(T)),'config_sha256':sha(config),'root_originals_unchanged':True,'source_count':20,'checks':build['checks'],'compiled_objects':objects,'framework_source':framework,'delta_files':[x['path'] for x in changes],'aggregate_check':'evidence/arm32le-candidate/r5-checks/result.json','helper_source_sha256':sha(T/'lib/SemaphoreCriticalViews.v'),'helper_qed_count':len(re.findall(r'\bQed\.',(T/'lib/SemaphoreCriticalViews.v').read_text()))}
(F/'build.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n');print(report['revision'],digest);print(report['delta_files'])
