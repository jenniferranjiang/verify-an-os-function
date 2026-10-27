from pathlib import Path
import re,json,hashlib,difflib
ROOT=Path('/home/xinra/crtos'); T=ROOT/'ksemaphoredelete-trial-261025-1'; ST=T/'checks/merge-staging'; BASE=T/'checks/merge-baselines'
plan=json.loads((T/'checks/spec-merge-plan.json').read_text())
def sha(s):return hashlib.sha256(s.encode()).hexdigest()
def migrate(s):return s.replace('KSemaphoreDeleteTrial.','CRTOS_Verify.lib.')
# Select complete annotation blocks attached to a function declaration/definition.
def pat(name):return re.compile(r'(?m)^(?P<sig>(?:inline\s+)?[\w *]+\b'+re.escape(name)+r'\s*\([^;{}]*\))(?P<gap>\s*)(?P<ann>(?:/\*@.*?\*/\s*)+)(?=[;{])',re.S)
def canonical(n):
 s=(T/'annotated_C/src'/f'{n}.c').read_text();matches=list(pat(n).finditer(s));assert len(matches)==1,(n,len(matches))
 m=matches[0];return m['sig'],re.findall(r'/\*@.*?\*/',m['ann'],re.S)
canon={row['symbol']:canonical(row['symbol']) for row in plan['functions']}
for boundary,owner in {'CONTAINER_OF_TASK_ID':'GetTaskWithIdnodeInfo','CONTAINER_OF_TASK_SCHED':'LinklistResumeAll','CONTAINER_OF_IDNODE_LINK':'GetObj','CONTAINER_OF_SEMAPHORE_ID':'_SemaphoreDelete'}.items():
 text=(T/'annotated_C/src'/f'{owner}.c').read_text();matches=list(pat(boundary).finditer(text));assert len(matches)==1
 m=matches[0];canon[boundary]=(m['sig'],re.findall(r'/\*@.*?\*/',m['ann'],re.S))
def label(c):
 x=re.match(r'/\*@\s*(\w+)',c)[1];return '' if x in ['With','Require'] else x
def sync(s,n):
 sig,cs=canon[n];by={label(c):c for c in cs}
 def replace(m):
  chunks=[]
  for c in re.findall(r'/\*@.*?\*/',m['ann'],re.S):
   # Keep shorthand binding comments and other unselected historical contracts.
   chunks.append(by.get(label(c),c) if 'Require' in c else c)
  return m['sig']+'\n'+'\n'.join(chunks)+'\n'
 return pat(n).sub(replace,s)
files={};methods={}
for row in plan['functions']:
 n=row['symbol'];old=row['global_source']
 if old:
  files.setdefault(old,(ROOT/old).read_text());files[old]=sync(files[old],n)
  methods.setdefault(old,[]).append('Synchronize existing full '+n+' contract blocks; retain all C bodies, short spec references and proof annotations.')
 else:
  dst='annotated_C/src/'+n+'.c';assert not (ROOT/dst).exists(),dst
  files[dst]=migrate((T/'annotated_C/src'/f'{n}.c').read_text())
  methods[dst]=['Add reviewed canonical function; change only logical imports to global modules.']
for row in plan['existing_header_changes']:
 f=row['file'];files.setdefault(f,(ROOT/f).read_text());methods.setdefault(f,[]).append(row['changes'])
files['annotated_C/src/headers/m_ktask.h']=(ROOT/'annotated_C/src/headers/m_ktask.h').read_text()
methods['annotated_C/src/headers/m_ktask.h']=['Keep the existing CONTAINER_OF_TASK_SCHED contract identical to the selected typed boundary; no body or extra assumptions changed.']
# Ordinary reused semantic contracts are synchronized in any selected caller file.
for f,s in list(files.items()):
 if (ROOT/f).exists():
  for n in canon:s=sync(s,n)
  # KNONE only appeared as a now unused declaration or the normalized null constant.
  s=re.sub(r'\s*\(KNONE\s*:\s*Z\)','',s)
  files[f]=s
# m_id: restore the exact C signature and replace the complete old two-behavior API.
f='annotated_C/src/headers/m_id.h';s=files[f]
s=s.replace('void RemoveObj(struct IdManager *manager, struct IdNode *idnode)','struct IdNode *RemoveObj(struct IdManager *manager, struct IdNode *idnode)')
pat_id=pat('IdRemoveObj');ms=list(pat_id.finditer(s));assert len(ms)==1
sig,cs=canon['IdRemoveObj'];s=pat_id.sub(sig+'\n'+'\n'.join(cs)+'\n',s)
sig,cs=canon['FreeId'];s=s.replace('struct IdNode *RemoveObj(',sig+'\n'+'\n'.join(cs)+';\n\nstruct IdNode *RemoveObj(',1)
# store_idnode is used by the repaired API, so move its existing declaration earlier.
block='/*@ Extern Coq\n  (store_idnode : addr -> IdNodeAbs -> Assertion)\n*/\n'
found=re.search(r'/\*@ Extern Coq\s*\(store_idnode\s*:\s*addr -> IdNodeAbs -> Assertion\)\s*\*/\s*',s);assert found
s=s[:found.start()]+s[found.end():]
s=s.replace('void FreeId(',block+'\nvoid FreeId(',1);files[f]=s
# Only replace imports when this task has the actual semantic definitions.
# Keep unknown proof-specific libai modules explicit; their recovery is outside this review.
exact={
 'CRTOS_Verify.libai.TaskStatusMemory':'CRTOS_Verify.lib.TaskStatusMemory',
 'CRTOS_Verify.libai.DoubleLinkListSpec':'CRTOS_Verify.lib.DoubleLinkListSpec',
 'CRTOS_Verify.libai.NodeSelfLinked':'CRTOS_Verify.lib.NodeSelfLinked',
 'CRTOS_Verify.libai.GetTaskWithIdnodeInside':'CRTOS_Verify.lib.KTaskWakeup',
}
for f,s in list(files.items()):
 if not (ROOT/f).exists():continue
 for a,b in exact.items():s=s.replace(a,b)
 if f=='annotated_C/src/headers/ktask_unset_delay.h':
  s=re.sub(r'/\*@ Import Coq Require Import CRTOS_Verify\.libai\.(KTaskSchedDelayState|KTaskUnSetDelayState|KTaskUnSetDelaySpec) \*/', '/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskUnSetDelay */',s)
  s=s.replace('/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskUnSetDelay */\n'*3,'/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskUnSetDelay */\n')
 if f=='annotated_C/src/headers/m_double_linklist.h':
  s=s.replace('CRTOS_Verify.libai.RRR_ReadyInsert','CRTOS_Verify.lib.KTaskWakeup')
 # New exported vocabulary applies to selected canonical APIs, while proof-only imports remain.
 if f.endswith('.c'):
  mods={
   'ktask_wakeup.c':'KTaskWakeup KTaskUnSetDelay KTaskParseInfo',
   'ktask_unset_delay.c':'KTaskUnSetDelay KTaskParseInfo',
   'assign_ready_insert.c':'KTaskWakeup',
   'assignstat.c':'KTaskWakeup',
   'rrr_ready_vector_insert.c':'KTaskWakeup',
  }.get(Path(f).name)
  if mods:s='/*@ Import Coq Require Import '+' '.join('CRTOS_Verify.lib.'+n for n in mods.split())+' */\n'+s
 files[f]=s
for h in ['slice_types.h','logic.h']:
 f='annotated_C/include/'+h;assert not (ROOT/f).exists(),f
 files[f]=migrate((T/'annotated_C/include'/h).read_text());methods[f]=['New shared ABI/vocabulary header; no function contracts. Trial logical prefixes migrated only.']
manifest=[]
for f,s in sorted(files.items()):
 dest=ST/f;dest.parent.mkdir(parents=True,exist_ok=True)
 assert 'KSemaphoreDeleteTrial' not in s and 'ksemaphoredelete-trial' not in s,(f,'trial reference')
 old=(ROOT/f).read_text() if (ROOT/f).exists() else None
 if old is not None:
  base=BASE/f;base.parent.mkdir(parents=True,exist_ok=True);base.write_text(old)
 dest.write_text(s)
 diff=''.join(difflib.unified_diff((old or '').splitlines(True),s.splitlines(True),fromfile=f+' (global baseline)',tofile=f+' (staged)'))
 dp=ST/'diffs'/(f+'.diff');dp.parent.mkdir(parents=True,exist_ok=True);dp.write_text(diff)
 manifest.append({'global_path':f,'baseline_sha256':None if old is None else sha(old),'staged_sha256':sha(s),'changed':old!=s,'method':methods.get(f,[]),'remaining_libai_imports':re.findall(r'/\*@ Import Coq.*?CRTOS_Verify\.libai\.[^\n]+',s)})
(ST/'manifest.json').write_text(json.dumps({'spec_revision':'KSemaphoreDelete-spec-r2','files':manifest},ensure_ascii=False,indent=2)+'\n')
print('Staged files:',len(files),'existing:',sum((ROOT/f).exists() for f in files))
print('Changed existing:',[m['global_path'] for m in manifest if m['baseline_sha256'] and m['changed']])
