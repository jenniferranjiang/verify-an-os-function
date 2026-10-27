from pathlib import Path
import re,json,hashlib,subprocess
R=Path(__file__).resolve().parents[3];T=R/'ksemaphoredelete-trial-261025-1';S=T/'annotated_C/src';O=Path(__file__).resolve().parent
expected=set('KSemaphoreDelete _SemaphoreDelete IdGetObj GetObj IdRemoveObj FreeId RemoveObj LinklistResumeAll KTaskWakeup GetTaskWithIdnodeInfo _KTaskWakeup KTaskUnSetDelay KTaskInsertToReadyVector KTaskStatSetAsReady KTaskStateSet AssignPolicyInsert RoundRobinRemainReadyVectorInsert InitDoubleLinkList DoubleLinkListInsertNodeBefore DoubleLinkListInsertNodeAfter DoubleLinkListRmNode IsDoubleLinkListEmpty JudgeKTaskStatIsSuspend'.split())
boundaries={'CriticalAreaLock','CriticalAreaUnLock','x_free','KTASK_ASSIGN','CONTAINER_OF_IDNODE_LINK','CONTAINER_OF_SEMAPHORE_ID','CONTAINER_OF_TASK_ID','CONTAINER_OF_TASK_SCHED'}
def clean(s):return re.sub(r'/\*.*?\*/|//[^\n]*','',s,flags=re.S)
def norm(s):return re.sub(r'\s+','',s)
errors=[];entries={};canon={};boundary_specs={};hashes={}
for p in sorted(S.glob('*.c')):
 n=p.stem;s=p.read_text();hashes[str(p.relative_to(R))]=hashlib.sha256(s.encode()).hexdigest()
 pat=r'\b'+re.escape(n)+r'\s*\([^;{}]*?\)\s*((?:/\*.*?\*/\s*)+)\{'
 matches=list(re.finditer(pat,s,re.S))
 if len(matches)!=1:errors.append(f'{n}: {len(matches)} own active bodies');continue
 m=matches[0];specs=[a for a in re.findall(r'/\*@.*?\*/',m[1],re.S) if 'Require' in a and 'Ensure' in a];canon[n]=list(map(norm,specs))
 if not specs:errors.append(f'{n}: missing own contract')
 body=clean(s[m.end()-1:]);defs=re.findall(r'^[ \t]*[A-Za-z_][\w \t*]+?\b([A-Za-z_]\w*)\s*\([^;{}]*\)\s*\{',clean(s),re.M)
 defs=[x for x in defs if x not in ['if','for','while','switch']]
 if defs!=[n]:errors.append(f'{n}: unexpected body definitions {defs}')
 calls=sorted(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',body))-{'if','while','for','return','sizeof','switch'})
 local={}
 for c in calls:
  decls=list(re.finditer(r'\b'+re.escape(c)+r'\s*\([^;{}]*?\)\s*((?:/\*.*?\*/\s*)+);',s[:m.start()],re.S))
  if len(decls)!=1:errors.append(f'{n}->{c}: {len(decls)} declarations');continue
  cs=[a for a in re.findall(r'/\*@.*?\*/',decls[0][1],re.S) if 'Require' in a and 'Ensure' in a]
  if not cs:errors.append(f'{n}->{c}: no full local contract')
  local[c]=list(map(norm,cs))
 entries[n]={'calls':calls,'contracts':local}
 pcomp=subprocess.run(['gcc','-m32','-std=c11','-ffreestanding','-fsyntax-only','-Wall',str(p)],capture_output=True,text=True)
 entries[n]['syntax']={'exit_code':pcomp.returncode,'diagnostics':pcomp.stderr}
 if pcomp.returncode:errors.append(f'{n}: syntax failure')
if set(entries)!=expected:errors.append(f'body set diff {set(entries)^expected}')
for n,d in entries.items():
 for c in d['calls']:
  if c in canon:
   if d['contracts'].get(c)!=canon[c]:errors.append(f'{n}->{c}: canonical/local contracts differ')
  elif c in boundaries:
   cs=d['contracts'].get(c)
   if c in boundary_specs and boundary_specs[c]!=cs:errors.append(f'{n}->{c}: model contract inconsistent')
   boundary_specs[c]=cs
  else:errors.append(f'{n}->{c}: undeclared closure target')
seen=set();todo=['KSemaphoreDelete']
while todo:
 n=todo.pop()
 if n in seen:continue
 seen.add(n)
 if n in entries:todo+=entries[n]['calls']
if seen!=expected|boundaries:errors.append(f'reachability diff {seen^(expected|boundaries)}')
result={'status':'passed' if not errors else 'needs-fix','errors':errors,'body_count':len(entries),'reachable':sorted(seen),'boundaries':sorted(boundary_specs),'files':hashes,'entries':entries}
(O/'candidate-structure.json').write_text(json.dumps(result,indent=2)+'\n')
print(result['status'],errors)
