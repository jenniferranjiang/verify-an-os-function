from pathlib import Path
import re,json,shutil
ROOT=Path('/home/xinra/crtos'); TRIAL=ROOT/'ksemaphoredelete-trial-261025-1'; OUT=TRIAL/'annotated_C'; SRC=ROOT/'Ubiquitous/XiZi_IIoT_Macro/kernel/thread'
NAMES={'semaphore.c':['KSemaphoreDelete','_SemaphoreDelete'],'id.c':['IdGetObj','GetObj','IdRemoveObj','FreeId','RemoveObj'],'linklist.c':['LinklistResumeAll'],'ktask.c':['KTaskWakeup','GetTaskWithIdnodeInfo','_KTaskWakeup'],'delay.c':['KTaskUnSetDelay'],'assign.c':['KTaskInsertToReadyVector'],'ktask_stat.c':['KTaskStatSetAsReady','KTaskStateSet','JudgeKTaskStatIsSuspend'],'assignstat.c':['AssignPolicyInsert'],'assign_roundrobinremain.c':['RoundRobinRemainReadyVectorInsert'],'double_link.c':['InitDoubleLinkList','DoubleLinkListInsertNodeBefore','DoubleLinkListInsertNodeAfter','DoubleLinkListRmNode','IsDoubleLinkListEmpty']}
def uncomment(s):return re.sub(r'/\*.*?\*/|//[^\n]*','',s,flags=re.S)
def get_source(file,name):
 s=uncomment((SRC/file).read_text()); m=re.search(r'(?m)^\s*((?:static\s+)?(?:inline\s+)?[\w \t*]+\b'+name+r'\s*\([^;{}]*\))\s*\{',s)
 assert m,name
 start=m.end()-1; count=1;end=start+1
 while count:
  count+=(s[end]=='{')-(s[end]=='}');end+=1
 sig=re.sub(r'^(static\s+|inline\s+)+','',m.group(1).strip())
 sig=re.sub(r'\bbool\b','BOOL',sig)
 return sig,s[start:end]
def get_specs(file,name,chosen=None):
 p=ROOT/file; baseline=TRIAL/'checks/spec-baseline'/file
 baseline.parent.mkdir(parents=True,exist_ok=True)
 if not baseline.exists():shutil.copy2(p,baseline)
 s=p.read_text(); found=[]
 for m in re.finditer(r'\b'+name+r'\s*\([^;{}]*?\)\s*((?:/\*.*?\*/\s*)+)(?=[;{])',s,re.S):
  for c in re.findall(r'/\*@.*?\*/',m.group(1),re.S):
   if ('Require' in c and (chosen is None or any(re.search(r'/\*@\s*'+x+r'(?:\s|$)',c) for x in chosen))):
    if c not in found:found.append(c)
 assert found,(file,name,chosen)
 return '\n'.join(found)
SIG={};BODY={};SPEC={};EDGES={};sources={}
for f,names in NAMES.items():
 for n in names:SIG[n],BODY[n]=get_source(f,n);sources[n]=str(SRC/f)
# Current-config preprocessing, without pulling a kernel/header tree into the trial.
for n,b in list(BODY.items()):
 b=re.sub(r'#ifdef ARCH_SMP.*?#endif','',b,flags=re.S)
 b=re.sub(r'#if KTASK_PRIORITY_MAX > 32.*?#endif','',b,flags=re.S)
 b=re.sub(r'#if defined \(SCHED_POLICY_FIFO\).*?#endif','RoundRobinRemainReadyVectorInsert(task, ready_table);',b,flags=re.S)
 b=re.sub(r'SYS_KDEBUG_LOG\(.*?\);','',b,flags=re.S)
 b=re.sub(r'KPrintf\(.*?\);','',b,flags=re.S)
 b=re.sub(r'HOOK\(.*?\);','',b,flags=re.S)
 b=b.replace('KDEBUG_NOT_IN_INTERRUPT;','').replace('done.SemaphoreDelete(id)','_SemaphoreDelete(id)').replace('task->Done->wake(task)','_KTaskWakeup(task)').replace('Assign.ready_vector_done->insert(task)','KTaskInsertToReadyVector(task)')
 b=re.sub(r'NULL_PARAM_CHECK\((\w+)\);',r'if (\1 == NONE) { while (1) { } }',b)
 if n!='_SemaphoreDelete':
  b=re.sub(r'lock\s*=\s*(CriticalAreaLock|DISABLE_INTERRUPT)\(\);',r'/* Nested critical operation removed under the documented inside-critical adaptation. */',b)
  b=re.sub(r'(CriticalAreaUnLock|ENABLE_INTERRUPT)\(lock\);','',b)
 b=b.replace('DO_KTASK_ASSIGN;','KTASK_ASSIGN();')
 b=b.replace('MERGE_FLAG(&Assign.os_assign_ready_vector.priority_ready_group, task->task_dync_sched_member.bitmap_column);','Assign.os_assign_ready_vector.priority_ready_group |= task->task_dync_sched_member.bitmap_column;')
 b=re.sub(r'(?:SYS_DOUBLE_LINKLIST_ENTRY|CONTAINER_OF)\((\w+),\s*struct (\w+),\s*([\w.]+)\)',lambda m:{'IdNode.link':'CONTAINER_OF_IDNODE_LINK','Semaphore.id':'CONTAINER_OF_SEMAPHORE_ID','TaskDescriptor.id':'CONTAINER_OF_TASK_ID','TaskDescriptor.task_dync_sched_member.sched_link':'CONTAINER_OF_TASK_SCHED'}[m[2]+'.'+m[3]]+'('+m[1]+')',b)
 b=b.replace('DOUBLE_LINKLIST_FOR_EACH(node, head)','for (node = head->node_next; node != head; node = node->node_next)')
 head='&ready_table->priority_ready_vector[task->task_dync_sched_member.cur_prio]'
 b=b.replace('DOUBLE_LINKLIST_FOR_EACH(node, '+head+')','for (node = ('+head+')->node_next; node != '+head+'; node = node->node_next)')
 assert not re.search(r'^\s*#',b,re.M),(n,b)
 BODY[n]=b
# Retain existing formal intent; only selected applicable named interfaces are duplicated in callers.
for n in ['IdGetObj','GetObj','RemoveObj']:
 SPEC[n]=get_specs('annotated_C/src/headers/m_id.h',n)
for n in ['KTaskStateSet','KTaskStatSetAsReady','JudgeKTaskStatIsSuspend']:
 SPEC[n]=get_specs('annotated_C/src/headers/ktask_set_status.h',n)
for n in ['KTaskInsertToReadyVector','AssignPolicyInsert']:
 SPEC[n]=get_specs('annotated_C/src/kernel/thread/assign_ready_insert.c',n)
SPEC['RoundRobinRemainReadyVectorInsert']=get_specs('annotated_C/src/kernel/thread/rrr_ready_vector_insert.c','RoundRobinRemainReadyVectorInsert')
for n in ['KTaskWakeup','_KTaskWakeup']:
 SPEC[n]=get_specs('annotated_C/src/kernel/thread/ktask_wakeup.c',n)
SPEC['GetTaskWithIdnodeInfo']=get_specs('annotated_C/src/kernel/thread/get_task_with_idnode.c','GetTaskWithIdnodeInfo',['inside_critical','inside_known'])
SPEC['KTaskUnSetDelay']=get_specs('annotated_C/src/headers/ktask_unset_delay.h','KTaskUnSetDelay')
SPEC['DoubleLinkListRmNode']=get_specs('annotated_C/src/headers/m_double_linklist.h','DoubleLinkListRmNode')
SPEC['InitDoubleLinkList']=get_specs('ksemaphorecreate-trial-261022-1/annotated_C/src/InitDoubleLinkList.c','InitDoubleLinkList')
SPEC['DoubleLinkListInsertNodeAfter']=get_specs('annotated_C/src/headers/m_double_linklist.h','DoubleLinkListInsertNodeAfter')
SPEC['DoubleLinkListInsertNodeBefore']=get_specs('annotated_C/src/headers/m_double_linklist.h','DoubleLinkListInsertNodeBefore')
SPEC['IsDoubleLinkListEmpty']=get_specs('annotated_C/src/headers/m_double_linklist.h','IsDoubleLinkListEmpty')
SPEC['FreeId']='''/*@ found_node
    With (sidm : StableIdmanager) (idm : VarIdmanager) (idnode : addr)
    Require store_idmanager_found(sidm, idm, manager, idnode, id)
    Ensure store_idmanager_remove_ready(sidm, idm, manager, idnode, id)
 */'''
SPEC['IdRemoveObj']=get_specs('annotated_C/src/headers/m_id.h','IdRemoveObj',['known_node'])+'''
/*@ current_node
    With (sidm : StableIdmanager) (idm : VarIdmanager) (idnode : addr)
    Require store_idmanager_found(sidm, idm, manager, idnode, id)
    Ensure store_idmanager(sidm, idmanager_remove(sidm, idm, id), manager) *
      store_idnode(&(idnode->link), Build_IdNodeAbs(65535, idnode)) *
      store_node_self_linked(&(idnode->link))
 */
/*@ found_node
    With (sidm : StableIdmanager) (idm : VarIdmanager) (idnode : addr)
    Require store_idmanager_found(sidm, idm, manager, idnode, id)
    Ensure store_idmanager(sidm, idmanager_remove(sidm, idm, id), manager) *
      store_idnode(&(idnode->link), Build_IdNodeAbs(65535, idnode)) *
      store_node_self_linked(&(idnode->link))
 */
/*@ absent_node
    With (sidm : StableIdmanager) (idm : VarIdmanager)
    Require idmanager_query(idm, id) == false && store_idmanager(sidm, idm, manager)
    Ensure store_idmanager(sidm, idm, manager)
 */'''
# Boundaries authorized by TrustBase or the explicitly adopted source-processing rule.
SIG.update({'CriticalAreaLock':'x_base CriticalAreaLock(void)','CriticalAreaUnLock':'void CriticalAreaUnLock(x_base lock)','CONTAINER_OF_IDNODE_LINK':'struct IdNode *CONTAINER_OF_IDNODE_LINK(DoubleLinklistType *link_ptr)','CONTAINER_OF_SEMAPHORE_ID':'struct Semaphore *CONTAINER_OF_SEMAPHORE_ID(struct IdNode *id_ptr)','CONTAINER_OF_TASK_ID':'KTaskDescriptorType CONTAINER_OF_TASK_ID(struct IdNode *id_ptr)','CONTAINER_OF_TASK_SCHED':'struct TaskDescriptor *CONTAINER_OF_TASK_SCHED(DoubleLinklistType *sched_link_ptr)','x_free':'void x_free(void *ptr)','KTASK_ASSIGN':'void KTASK_ASSIGN(void)'})
SPEC['CriticalAreaLock']=get_specs('annotated_C/src/headers/m_ktask.h','CriticalAreaLock',['ordinary'])
SPEC['CriticalAreaUnLock']=get_specs('annotated_C/src/headers/m_ktask.h','CriticalAreaUnLock',['stable'])
SPEC['CONTAINER_OF_TASK_ID']=get_specs('annotated_C/src/kernel/thread/get_task_with_idnode.c','CONTAINER_OF_TASK_ID')
SPEC['CONTAINER_OF_TASK_SCHED']=get_specs('annotated_C/src/headers/m_ktask.h','CONTAINER_OF_TASK_SCHED')
SPEC['CONTAINER_OF_IDNODE_LINK']='''/*@ With (idnode_ptr : addr)
    Require link_ptr == field_addr(idnode_ptr, struct IdNode, link) && emp
    Ensure __return == idnode_ptr && link_ptr == &(__return->link) && emp
 */'''
SPEC['CONTAINER_OF_SEMAPHORE_ID']='''/*@ With (sem_ptr : addr)
    Require id_ptr == field_addr(sem_ptr, struct Semaphore, id) && emp
    Ensure __return == sem_ptr && id_ptr == &(__return->id) && emp
 */'''
SPEC['x_free']='''/*@ Require SemaphoreRaw(ptr)
    Ensure emp
 */'''
SPEC['KTASK_ASSIGN']='''/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_ktask_assign, X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */'''
# Top-level and resume interfaces are supplied by the concurrently designed formal revision.
custom=TRIAL/'checks/spec-custom.json'
if custom.exists():SPEC.update(json.loads(custom.read_text()))
# KNONE is the legacy spelling of the C null constant, not a library definition.
SPEC={name: contract.replace('KNONE','0') for name,contract in SPEC.items()}
# Named behavior choices at direct calls; remaining logical values are inferred
# from the explicitly declared module resources (no synthetic ghost assumptions).
for n,b in list(BODY.items()):
 if n == 'KSemaphoreDelete':
  b=b.replace('_SemaphoreDelete(id);', '_SemaphoreDelete(id) /*@ where (outside_critical) sg = sg, before = before, X = X */;')
 if n == '_SemaphoreDelete':
  b=b.replace('CriticalAreaLock();', 'CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;')
  b=b.replace('CriticalAreaUnLock(lock);', 'CriticalAreaUnLock(lock) /*@ where (stable) sg = sg */;')
  b=b.replace('IsDoubleLinkListEmpty(&sem->pend_list)', 'IsDoubleLinkListEmpty(&sem->pend_list) /*@ where (dll) */')
  b=b.replace('LinklistResumeAll(&sem->pend_list);', 'LinklistResumeAll(&sem->pend_list) /*@ where (semaphore_waiters) sg = sg */;')
  b=b.replace('IdRemoveObj(&k_sem_id_manager, sem->id.id);', 'IdRemoveObj(&k_sem_id_manager, sem->id.id) /*@ where (current_node) */;')
  b=b.replace('DoubleLinkListRmNode(&sem->link);', 'DoubleLinkListRmNode(&sem->link) /*@ where (remove_member) */;')
  b=b.replace('KTASK_ASSIGN();', 'KTASK_ASSIGN() /*@ where (outside_critical) sg = sg */;')
 if n == 'KTaskWakeup':
  b=b.replace('GetTaskWithIdnodeInfo(id);', 'GetTaskWithIdnodeInfo(id) /*@ where (inside_known) sg = sg, st = st, target = target */;')
  b=b.replace('_KTaskWakeup(task);', '_KTaskWakeup(task) /*@ where (not_suspended) old_stat = old_stat $ not_suspended where (wakeup_unified) sg = sg, st = st, desc = desc, ready_before = ready_before, sched_view = sched_view $ wakeup_unified */;')
 if n == 'LinklistResumeAll':
  b=b.replace('KTaskWakeup(task->id.id);', 'KTaskWakeup(task->id.id) /*@ where (wakeup_unified) sg = sg */;')
 if n == '_KTaskWakeup':
  b=b.replace('KTaskUnSetDelay(task);', 'KTaskUnSetDelay(task) /*@ where (all_case_delay) sg = sg, st_before = st, desc = desc $ wakeup_unified */;')
 if n in ['RemoveObj','KTaskUnSetDelay']:
  b=re.sub(r'(DoubleLinkListRmNode\([^;]+\));', r'\1 /*@ where (remove_member) */;', b)
 if n == 'RoundRobinRemainReadyVectorInsert':
  b=re.sub(r'(DoubleLinkListInsertNode(?:Before|After)\([^;]+\));', r'\1 /*@ where (dispatch_case) */;', b)
 if n == 'KTaskStatSetAsReady':
  b=b.replace('KTaskStateSet(task, KTASK_READY);', 'KTaskStateSet(task, KTASK_READY) /*@ where old_stat = old_stat */;')
 BODY[n]=b
for n,b in BODY.items():
 calls=[]
 for call in re.findall(r'\b([A-Za-z_]\w*)\s*\(',uncomment(b)):
  if call in ['if','while','for','sizeof','switch','return']:continue
  if call not in calls:calls.append(call)
 EDGES[n]=calls
 for call in calls:assert call in SIG,(n,call)
 if n not in SPEC:continue
 declarations=[]
 for call in calls:
  if call not in SPEC:break
  declarations.append(SIG[call]+'\n'+SPEC[call]+';')
 else:
  contents='#include "../include/slice_types.h"\n#include "../include/logic.h"\n\n'
  contents+='/* Source: '+sources[n]+'. Current 32-bit non-SMP configuration. */\n'
  contents+='\n\n'.join(declarations)+'\n\n'+SIG[n]+'\n'+SPEC[n]+'\n'+b+'\n'
  (OUT/'src'/f'{n}.c').write_text(contents)
(TRIAL/'checks/spec-closure.json').write_text(json.dumps({'source':sources,'direct_calls':EDGES,'boundaries':list(SIG.keys()-BODY.keys()),'pending_contracts':[n for n in BODY if n not in SPEC]},indent=2))
print('Wrote',len(list((OUT/'src').glob('*.c'))),'canonical slices; pending:',[n for n in BODY if n not in SPEC])
