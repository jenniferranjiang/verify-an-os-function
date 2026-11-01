#!/usr/bin/env python3
"""Read-only design checks; no QCP, symbolic execution, VCs, or C proofs."""
from pathlib import Path
import re,json,hashlib,subprocess
TRIAL=Path(__file__).resolve().parents[1]; ROOT=TRIAL.parent
SRC=TRIAL/'annotated_C/src'
def clean(s):
 return re.sub(r'//[^\n]*','',re.sub(r'/\*.*?\*/','',s,flags=re.S))
def norm(s): return re.sub(r'\s+','',s)
def body(s,name):
 s=clean(s); m=re.search(r'\b'+re.escape(name)+r'\s*\([^;{}]*\)\s*\{',s)
 if not m:return None
 a=m.end();level=1
 for i in range(a,len(s)):
  level+=(s[i]=='{')-(s[i]=='}')
  if level==0:return s[a:i]
 raise AssertionError(name)
def contract(s,name,spec=None):
 for m in re.finditer(r'\b'+re.escape(name)+r'\s*\([^;{}]*?\)\s*((?:/\*@.*?\*/\s*)+)',s,re.S):
  blocks=re.findall(r'/\*@.*?\*/',m.group(1),re.S)
  for b in blocks:
   if spec is None or re.match(r'/\*@\s*'+spec+r'\b',b):return norm(b)
 raise AssertionError((name,spec))
classify={n:'body-target' for n in ['KMutexCreate','_MutexCreate']}
classify.update({n:'reused-spec' for n in ['IdInsertObj','InitDoubleLinkList','DoubleLinkListInsertNodeAfter']})
classify.update({n:'TrustBase-primitive' for n in ['x_malloc','memset','x_free','CriticalAreaLock','CriticalAreaUnLock']})
selected={'DoubleLinkListInsertNodeAfter':'dispatch_case'}
edges={}; seen=set(); queue=['KMutexCreate']; checks=[]
while queue:
 n=queue.pop();
 if n in seen:continue
 seen.add(n); assert n in classify,n
 p=SRC/(n+'.c'); assert p.exists(),n
 contract(p.read_text(),n,selected.get(n))
 if classify[n]!='body-target':continue
 b=body(p.read_text(),n); assert b is not None,n
 calls=set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',b))-{'if','while','for','switch','sizeof'}
 edges[n]=sorted(calls)
 for callee in calls:
  assert callee in classify,(n,callee)
  assert contract(p.read_text(),callee,selected.get(callee))==contract((SRC/(callee+'.c')).read_text(),callee,selected.get(callee)),(n,callee,'contract mismatch')
  queue.append(callee)
assert seen==set(classify),(seen,set(classify))
original=(ROOT/'Ubiquitous/XiZi_IIoT_Macro/kernel/thread/mutex.c').read_text()
assert norm(body(original,'_MutexCreate'))==norm(body((SRC/'_MutexCreate.c').read_text(),'_MutexCreate'))
kbody=body(original,'KMutexCreate').replace('KDEBUG_NOT_IN_INTERRUPT;','').replace('done.MutexCreate','_MutexCreate')
assert norm(kbody)==norm(body((SRC/'KMutexCreate.c').read_text(),'KMutexCreate'))
for n in ['InitDoubleLinkList','DoubleLinkListInsertNodeAfter']:
 root=(ROOT/'annotated_C/src'/f'{n}.c').read_text(); local=(SRC/f'{n}.c').read_text()
 assert norm(root)==norm(local),n
 assert norm(body((ROOT/'Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c').read_text(),n))==norm(body(local,n)),n
idroot=(ROOT/'annotated_C/src/headers/id_module_spec.h').read_text()
assert contract(idroot,'IdInsertObj')==contract((SRC/'IdInsertObj.c').read_text(),'IdInsertObj')
primitives=(ROOT/'annotated_C/src/headers/m_ktask.h').read_text()
for n in ['x_malloc','memset','CriticalAreaLock','CriticalAreaUnLock']:
 assert contract(primitives,n)==contract((SRC/(n+'.c')).read_text(),n),n
for f in sorted(SRC.glob('*.c')):
 cmd=['gcc','-m32','-std=c11','-ffreestanding','-fsyntax-only','-Wall','-Wextra','-Werror',str(f)]
 r=subprocess.run(cmd,text=True,capture_output=True); assert r.returncode==0,r.stderr
 checks.append({'file':str(f.relative_to(TRIAL)),'exit':r.returncode})
result={'target':'KMutexCreate','reachable':classify,'edges':edges,'caller_contract_equality':True,'original_body_equality_after_documented_adaptation':True,'imported_contract_equality':True,'c_structure':checks,'qcp_run':False,'vc_generated':False}
(TRIAL/'checks/design-audit.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'closure_symbols':len(seen),'body_targets':2,'reused_specs':3,'trusted_primitives':5,'checks':'passed'},indent=2))
