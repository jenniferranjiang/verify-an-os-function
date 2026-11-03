#!/usr/bin/env python3
"""Apply reviewed design deltas, preserving baselines and shared work."""
from pathlib import Path
import hashlib,json,shutil,shlex,subprocess
trial=Path(__file__).resolve().parents[1]; root=trial.parent
review=json.loads((trial/'checks/review-decisions.json').read_text())
assert review['predicate_status']==review['spec_status']=='review-passed'
changes=json.loads((trial/'checks/predicate-change-map.json').read_text())
# All conflict checks happen before any shared mutation.
for x in changes:
 f=Path(x['file']);baseline=trial/'.baseline'/f;live=root/f
 if baseline.exists():
  assert live.read_bytes()==baseline.read_bytes(), f'Global changed since baseline: {f}'
  if x['kind']=='imports-only':
   assert (trial/f).read_text().replace('KEventTrial.lib.','CRTOS_Verify.lib.')==baseline.read_text(), f'Unexpected semantic delta: {f}'
 else: assert not live.exists(), f'New module already exists: {f}'
reviewcopy=trial/'checks/review-inputs';reviewcopy.mkdir(exist_ok=True)
shutil.copytree(trial/'annotated_C',reviewcopy/'annotated_C',dirs_exist_ok=True)
shutil.copy2(trial/'_CoqProject',reviewcopy/'_CoqProject')
shutil.copy2(trial/'checks/interface.v',reviewcopy/'interface.v')
shutil.copy2(root/'.vscode/settings.json',trial/'.baseline/vscode-settings.json')
rows=[];modified=[]
for x in changes:
 f=Path(x['file']);before=hashlib.sha256((root/f).read_bytes()).hexdigest() if (root/f).exists() else None
 normalized=(trial/f).read_text().replace('KEventTrial.lib.','CRTOS_Verify.lib.')
 if x['kind']!='imports-only':
  (root/f).write_text(normalized);modified.append(f.stem)
 assert normalized==(root/f).read_text()
 rows.append({'review_file':str(f),'global_file':str(f),'kind':x['kind'],'baseline_sha256':before,'review_sha256':hashlib.sha256((trial/f).read_bytes()).hexdigest(),'global_sha256':hashlib.sha256((root/f).read_bytes()).hexdigest(),'migration':'KEventTrial.lib. -> CRTOS_Verify.lib.; semantics unchanged'})
project=root/'_CoqProject';s=project.read_text()
for x in changes:
 if x['kind']=='new' and x['file'] not in s.splitlines(): s+='\n'+x['file']+'\n'
project.write_text(s)
# Trial switches to global definitions. Reviewed lib snapshots are no longer mapped.
args=[];config=[]
for line in s.splitlines():
 w=shlex.split(line)
 if w and w[0] in ('-R','-Q'):
  w[1]=str((root/w[1]).resolve());config.append(' '.join(w));args+=w
(trial/'_CoqProject').write_text('\n'.join(config)+'\n\nchecks/interface.v\n')
for f in list((trial/'annotated_C').rglob('*.h'))+list((trial/'annotated_C').rglob('*.c'))+[trial/'checks/interface.v']:
 f.write_text(f.read_text().replace('KEventTrial.lib.','CRTOS_Verify.lib.'))
settingspath=root/'.vscode/settings.json';settings=json.loads(settingspath.read_text());settings['vsrocq.args']=args;settings.setdefault('files.associations',{})['*.v']='rocq';settingspath.write_text(json.dumps(settings,ensure_ascii=False,indent=2)+'\n')
(trial/'KEventCreate.code-workspace').write_text(json.dumps({'folders':[{'path':'.'}],'settings':{'vsrocq.args':args,'files.associations':{'*.v':'rocq'}}},ensure_ascii=False,indent=2)+'\n')
(trial/'checks/migration.json').write_text(json.dumps({'predicate_revision':review['predicate_revision'],'spec_revision':review['spec_revision'],'changed_global_modules':modified,'files':rows,'trial_lib':'review snapshots only; not mapped or listed in current _CoqProject','reused_specs':'unchanged; no root annotated_C contract delta to merge'},indent=2)+'\n')
r=subprocess.run(['/home/xinra/.opam/pv-bench-8.20.1/bin/coq_makefile','-f','_CoqProject','-o','Makefile.coq'],cwd=root,text=True,capture_output=True)
(trial/'checks/makefile-regenerate.log').write_text(r.stdout+r.stderr)
print('Migrated',modified,'makefile exit',r.returncode);raise SystemExit(r.returncode)
