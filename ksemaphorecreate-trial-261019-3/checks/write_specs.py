"""Materialize canonical annotated C and exact caller-local copies.
This build helper is not a second canonical specification: review src/*.c.
Reads only this trial's freshly derived body evidence.
"""
from pathlib import Path
import json
trial=Path(__file__).resolve().parents[1]
bodies=json.loads((trial/'checks/source-bodies.json').read_text())
contracts={}
contracts['KSemaphoreCreate']=contracts['_SemaphoreCreate']='''/*@ With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) &&
      OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == -5 &&
        safeExec(LastSeen(after), return(-5), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        0 <= __return && __return < 128 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
*/'''
contracts['AllocId']='''/*@ With (sidm : StableIdmanager) (before : VarIdmanager)
    Require manager != 0 &&
      store_idmanager(sidm, before, manager)
    Ensure
      (__return == -1 && idmanager_full(sidm, before) &&
        store_idmanager(sidm, before, manager))
      ||
      (0 <= __return && __return < sidm.idmax &&
        store_idmanager_allocated_unlinked(sidm, before, manager, __return))
*/'''
contracts['IdInsertObj']='''/*@ With (sidm : StableIdmanager) (before : VarIdmanager)
    Require manager != 0 && idnode != 0 &&
      store_idmanager(sidm, before, manager) * ZeroIdNode(idnode)
    Ensure
      (__return == -1 && idmanager_full(sidm, before) &&
        store_idmanager(sidm, before, manager) * ZeroIdNode(idnode))
      ||
      (0 <= __return && __return < sidm.idmax &&
        idmanager_min_free_id(sidm, before, __return) &&
        store_idmanager(sidm,
          idmanager_link(sidm, idmanager_add(before, __return), __return, idnode),
          manager))
*/'''
contracts['InsertObj']='''/*@ With (sidm : StableIdmanager) (before : VarIdmanager) (id : Z)
    Require manager != 0 && idnode != 0 &&
      store_idmanager_allocated_unlinked(sidm, before, manager, id) *
      AssignedIdNode(idnode, id)
    Ensure
      store_idmanager(sidm,
        idmanager_link(sidm, idmanager_add(before, id), id, idnode), manager)
*/'''
contracts['InitDoubleLinkList']='''/*@ Require NodeStorage(linklist_head)
    Ensure store_node_self_linked(linklist_head)
*/'''
contracts['DoubleLinkListInsertNodeAfter']='''/*@ With (next : Z) (oldprev : Z) (oldnext : Z)
    Require DllInsertAfterCut(linklist, next, linklist_node, oldprev, oldnext)
    Ensure DllInsertedCut(linklist, next, linklist_node)
*/'''
contracts['x_malloc']='''/*@ Require nbytes == 32 && emp
    Ensure (__return == 0 && emp) ||
      (__return != 0 && SemaphoreRaw(__return))
*/'''
contracts['memset']='''/*@ Require c == 0 && n == 32 && SemaphoreRaw(dest)
    Ensure __return == dest && SemaphoreZero(dest)
*/'''
contracts['x_free']='''/*@ Require SemaphoreZero(ptr)
    Ensure emp
*/'''
contracts['KPrintf']='''/*@ Require emp
    Ensure emp
*/'''
contracts['CriticalAreaLock']='/*@ With (sg : StableGlobalState) (before : VarGlobalState)\n    Require OutsideCritical(sg, before)\n    Ensure exists locked,\n      Crtos_RTrans(before, locked) &&\n      InsideCritical(sg, locked) * os_inv(sg, locked)\n*/'
contracts['CriticalAreaUnLock']='/*@ With (sg : StableGlobalState) (locked : VarGlobalState)\n         (after : VarGlobalState)\n    Require Crtos_GTrans(locked, after) &&\n      InsideCritical(sg, locked) * os_inv(sg, after)\n    Ensure OutsideCritical(sg, after)\n*/'
signatures={k:v['normalized'].split('{',1)[0].strip() for k,v in bodies.items()}
signatures.update({
 'x_malloc':'void *x_malloc(x_size_t nbytes)',
 'x_free':'void x_free(void *ptr)',
 'memset':'void *memset(void *dest, int c, size_t n)',
 'KPrintf':'void KPrintf(const char *fmt, ...)',
})
callees={
 'KSemaphoreCreate':['_SemaphoreCreate'],
 '_SemaphoreCreate':['x_malloc','memset','CriticalAreaLock','IdInsertObj','x_free','InitDoubleLinkList','DoubleLinkListInsertNodeAfter','CriticalAreaUnLock','KPrintf'],
 'IdInsertObj':['KPrintf','AllocId','InsertObj'],
 'AllocId':['KPrintf'],
 'InsertObj':['KPrintf','InitDoubleLinkList','DoubleLinkListInsertNodeAfter'],
 'InitDoubleLinkList':[],
 'DoubleLinkListInsertNodeAfter':[],
}
def annotate_body(symbol, body):
 if symbol in {'KSemaphoreCreate', '_SemaphoreCreate'}:
  body='\n    /*@ 0 <= val && val <= 65535 by local */'+body
 if symbol == 'KSemaphoreCreate':
  body=body.replace('_SemaphoreCreate(val)', '_SemaphoreCreate(val) /*@ where sg = sg, before = before, X = X */')
 elif symbol == 'IdInsertObj':
  body=body.replace('AllocId(manager)', 'AllocId(manager) /*@ where sidm = sidm, before = before */')
  body=body.replace('InsertObj(manager, idnode);', 'InsertObj(manager, idnode) /*@ where sidm = sidm, before = before, id = id */;')
 elif symbol == 'InsertObj':
  body=body.replace('DoubleLinkListInsertNodeAfter(head, &idnode->link);',
    'DoubleLinkListInsertNodeAfter(head, &idnode->link)\n        /*@ where next = idbucket_first_link(sidm, before, id), oldprev = 0, oldnext = 0 */;')
 elif symbol == '_SemaphoreCreate':
  body=body.replace('CriticalAreaLock();', 'CriticalAreaLock() /*@ where sg = sg, before = before */;\n    /*@ Given locked */')
  body=body.replace('IdInsertObj(&k_sem_id_manager, &sem->id);',
    'IdInsertObj(&k_sem_id_manager, &sem->id)\n        /*@ where sidm = sg.os_semaphore_stable.semaphore_manager_stable,\n                  before = semaphore_manager(locked.os_semaphores) */;')
  body=body.replace('CriticalAreaUnLock(lock);',
    'CriticalAreaUnLock(lock) /*@ where sg = sg, locked = locked, after = locked */;',1)
  body=body.replace('DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link);',
    'DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link)\n        /*@ where next = semaphore_first_link(sg.os_semaphore_stable, locked.os_semaphores),\n                  oldprev = 0, oldnext = 0 */;')
  body=body.replace('CriticalAreaUnLock(lock);',
    'CriticalAreaUnLock(lock)\n        /*@ where sg = sg, locked = locked,\n                  after = replace_semaphores(semaphore_publish(sem, id, val, locked.os_semaphores), locked) */;')
 return body

def write_all():
 for symbol in callees:
  evidence=bodies[symbol]
  head,body=evidence['normalized'].split('{',1)
  body=annotate_body(symbol,body)
  text='#include "../slice_types.h"\n#include "../logic.h"\n\n'
  for callee in callees[symbol]:
   if callee in {'CriticalAreaLock', 'CriticalAreaUnLock'}:
    text+='/* Trusted primitive: TrustBase.md; VRTOS m_ktask.h ordinary/stable spec. */\n'
   text+=signatures[callee]+'\n'+contracts[callee]+';\n\n'
  text+=f'/* Canonical: {symbol}. Source: {evidence["source"]}:{evidence["line"]}. */\n'
  text+=head.strip()+'\n'+contracts[symbol]+'\n{'+body+'\n'
  (trial/'annotated_C/src'/f'{symbol}.c').write_text(text)
 (trial/'checks/caller-map.json').write_text(json.dumps(callees,indent=2)+'\n')
if __name__=='__main__':
 write_all()
