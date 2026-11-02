"""Compare fixed review inputs/contracts; not a QCP parser or closure scanner."""
from pathlib import Path
import re,json,hashlib
root=Path(__file__).resolve().parents[2]; t=root/'keventcreate-trial-261101-1'; src=t/'annotated_C/src'
def norm(x): return re.sub(r'\s+','',x)
def strip(x): return re.sub(r'/\*.*?\*/|//[^\n]*','',x,flags=re.S)
def contracts(x,name):
 m=re.search(r'\b'+re.escape(name)+r'\([^;{}]*?\)\s*((?:/\*@.*?\*/\s*)+)',x,re.S)
 if not m: raise ValueError(name)
 return re.findall(r'/\*@.*?\*/',m[1],re.S)
def body(x,name):
 x=strip(x);m=re.search(r'\b'+name+r'\([^;{}]*\)\s*\{',x); start=m.end();level=1;i=start
 while level:
  level+=(x[i]=='{')-(x[i]=='}');i+=1
 return x[start:i-1]
results={}
for caller, names in {'KEventCreate':['_EventCreate'],'_EventCreate':['x_malloc','memset','CriticalAreaLock','IdInsertObj','InitDoubleLinkList','DoubleLinkListInsertNodeAfter','CriticalAreaUnLock','x_free']}.items():
 txt=(src/(caller+'.c')).read_text()
 for name in names:
  local=contracts(txt,name);canonical=contracts((src/(name+'.c')).read_text(),name)
  results[caller+' -> '+name]=all(norm(c) in list(map(norm,canonical)) for c in local)
for name,source in {'IdInsertObj':'annotated_C/src/headers/id_module_spec.h','InitDoubleLinkList':'annotated_C/src/InitDoubleLinkList.c','DoubleLinkListInsertNodeAfter':'annotated_C/src/DoubleLinkListInsertNodeAfter.c'}.items():
 a=contracts((src/(name+'.c')).read_text(),name);b=contracts((root/source).read_text(),name)
 results['reused '+name]=list(map(norm,a))==list(map(norm,b))
a=(root/'Ubiquitous/XiZi_IIoT_Macro/kernel/thread/event.c').read_text()
for name in ['KEventCreate','_EventCreate']:
 expected=body(a,name).replace('KDEBUG_NOT_IN_INTERRUPT;','').replace('done.EventCreate','_EventCreate')
 expected=expected.replace('event->options = options;', 'event->options = options & 7U;')
 results['body '+name]=norm(expected)==norm(body((src/(name+'.c')).read_text(),name))
for name in ['InitDoubleLinkList','DoubleLinkListInsertNodeAfter']:
 expected=body((root/'Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c').read_text(),name)
 results['body '+name]=norm(expected)==norm(body((src/(name+'.c')).read_text(),name))
out={'checks':results,'all_passed':all(results.values()),'limits':'Fixed contract/body comparisons only; full closure reviewed manually. No QCP parsing, symbolic execution, VC or C proof.'}
(t/'checks/input-comparison.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2));raise SystemExit(0 if out['all_passed'] else 1)
