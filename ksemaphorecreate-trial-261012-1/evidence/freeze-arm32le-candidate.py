from pathlib import Path
import json,hashlib,difflib,shutil,datetime
T=Path(__file__).resolve().parents[1]; E=T/'evidence/arm32le-candidate'; F=E/'frozen-r4'
F.mkdir(exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
root=json.loads((E/'root-source-closure.json').read_text())
local=json.loads((E/'pre-migration/evidence/predicate-manifest.json').read_text())
paths=[x['candidate'] for x in root['files']]+[x['path'] for x in local['files']]
checks={}
for p in [E/'build-initial-closure.json',*sorted((E/'build-history').glob('*.json')),E/'build-latest.json']:
 for c in json.loads(p.read_text())['checks']:
  if c['exit_code']==0:checks[c['file']]={**c,'build_record':str(p.relative_to(T))}
assert set(paths)<=set(checks)
entries=[]
for rel in paths:
 p=T/rel;vo=p.with_suffix('.vo');assert vo.exists() and vo.stat().st_mtime>=p.stat().st_mtime,rel
 d=F/'sources'/rel;d.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,d)
 entries.append({'path':rel,'sha256':sha(p)})
manifest={'format':'explicit-predicate-sources-v1','files':entries}
encoded=(json.dumps(manifest,ensure_ascii=False,sort_keys=True,indent=2)+'\n').encode();digest=hashlib.sha256(encoded).hexdigest();(F/'predicate-manifest.json').write_bytes(encoded)
changes=[]
for x in root['files']:
 old=Path(x['source']);new=T/x['candidate'];assert sha(old)==x['source_sha256'],str(old)
 diff=''.join(difflib.unified_diff(old.read_text().splitlines(True),new.read_text().splitlines(True),fromfile=str(old),tofile=x['candidate']))
 changes.append({'source':str(old),'source_sha256':sha(old),'candidate':x['candidate'],'candidate_sha256':sha(new),'diff':diff})
for x in local['files']:
 old=E/'pre-migration'/x['path'];new=T/x['path']
 diff=''.join(difflib.unified_diff(old.read_text().splitlines(True),new.read_text().splitlines(True),fromfile='pre-migration/'+x['path'],tofile=x['path']))
 changes.append({'source':str(old.relative_to(T)),'source_sha256':sha(old),'candidate':x['path'],'candidate_sha256':sha(new),'diff':diff})
(F/'source-diffs.json').write_text(json.dumps(changes,ensure_ascii=False,indent=2)+'\n')
(F/'source-diffs.patch').write_text(''.join(x['diff'] for x in changes))
config=T/'_CoqProject.arm32le-candidate';shutil.copy2(config,F/config.name)
report={'revision':'predicate-r4-'+digest[:12],'manifest_sha256':digest,'status':'compiled-awaiting-independent-review','frozen_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'compiler':'/home/xinra/.opam/pv-bench-8.20.1/bin/coqc','config':str(config.relative_to(T)),'config_sha256':sha(config),'root_originals_unchanged':True,'source_count':len(paths),'checks':[checks[x] for x in paths],'compiled_objects':[{'path':str((T/x).with_suffix('.vo').relative_to(T)),'sha256':sha((T/x).with_suffix('.vo'))} for x in paths],'carrier_abi_check':'evidence/arm32le-candidate/carrier-check.json','helper_draft_included':False}
(F/'build.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(report['revision'],digest,len(paths))
