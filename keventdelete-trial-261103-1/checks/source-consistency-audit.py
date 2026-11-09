from pathlib import Path
import re,json,hashlib
root=Path(__file__).resolve().parents[1]
def clean(s):return re.sub(r'/\*.*?\*/|//[^\n]*','',s,flags=re.S)
def body(s,name):
 s=clean(s);m=re.search(r'\b'+re.escape(name)+r'\([^)]*\)\s*\{',s);assert m,name
 start=s.index('{',m.start());n=0
 for i in range(start,len(s)):
  if s[i]=='{':n+=1
  elif s[i]=='}':
   n-=1
   if n==0:return s[start:i+1]
 raise ValueError(name)
def tokens(s):return re.findall(r'[A-Za-z_]\w*|\d+|==|!=|->|<=|>=|\S',s)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
results=[]
for name in ['KEventDelete','FindEventById','LinklistResumeAll','_EventDelete']:
 original=root/'checks/source-slices'/f'{name}.original.c';active=root/'annotated_C/src'/f'{name}.c'
 expected=body(original.read_text(),name);actual=body(active.read_text(),name);rules=[]
 if name=='KEventDelete':
  expected=expected.replace('KDEBUG_NOT_IN_INTERRUPT;','').replace('done.EventDelete(event)','_EventDelete(event)');rules=['TrustBase debug removal','immutable done dispatch resolution']
 if name=='FindEventById':
  expected=expected.replace('CONTAINER_OF(idnode, struct Event, id)','CONTAINER_OF_EVENT_ID(idnode)');rules=['TrustBase typed CONTAINER_OF API']
 if name=='LinklistResumeAll':
  expected=expected.replace('NULL_PARAM_CHECK(list);','if (list == NONE) { while (1) { } }')
  expected=expected.replace('for(;;)','while (1)')
  expected=expected.replace('SYS_DOUBLE_LINKLIST_ENTRY(node, struct TaskDescriptor, task_dync_sched_member.sched_link)','CONTAINER_OF_TASK_SCHED(node)')
  expected=expected.replace('KTaskWakeup(task->id.id);','int32 resume_task_id = task->id.id; KTaskWakeup(resume_task_id);')
  rules=['NULL macro expansion with debug print removal','for (;;) to while (1)','TrustBase typed task container API','single ID read into int32 temporary before call']
 if name=='_EventDelete':
  expected=expected.replace('x_base lock = 0;','x_base lock = 0; x_base inspect_lock = 0; int pending_empty;')
  expected=expected.replace('NULL_PARAM_CHECK(event);','if (event == NONE) { while (1) { } }')
  expected=expected.replace('if (!IsDoubleLinkListEmpty(&event->pend_list))','inspect_lock = CriticalAreaLock(); pending_empty = IsDoubleLinkListEmpty(&event->pend_list); CriticalAreaUnLock(inspect_lock); if (!pending_empty)')
  expected=expected.replace('IdRemoveObj(&k_event_id_manager, event->id.id);','uint16 delete_event_id = event->id.id; IdRemoveObj(&k_event_id_manager, delete_event_id);')
  expected=expected.replace('DO_KTASK_ASSIGN;','KTASK_ASSIGN();')
  actual=re.sub(r'\belse\s*\{\s*\}','',actual)
  rules=['NULL macro expansion with debug print removal','documented one-access inspection critical section','single ID read into uint16 temporary before call','documented scheduler API','annotation-only empty else']
 assert tokens(expected)==tokens(actual),name
 results.append({'function':name,'original_snapshot_sha256':sha(original),'active_c_sha256':sha(active),'executable_tokens_match_after_listed_adaptations':True,'adaptations':rules})
(root/'checks/implementation-source-consistency.json').write_text(json.dumps({'status':'consistent-under-approved-source-adaptation','scope':'executable bodies, independently compared; not a proof/check of generated VCs','limits':'CONTAINER_OF, scheduler and one-access critical wrapping are approved model/API adaptations, not unconditional machine-level equivalence','functions':results},indent=2)+'\n')
print('All 4 active bodies match authoritative extracts after exactly the documented adaptations.')
