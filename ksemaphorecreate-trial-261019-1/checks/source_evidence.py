from pathlib import Path
import re, subprocess, hashlib, json, argparse
parser = argparse.ArgumentParser(description="Validate frozen source/config and ILP32 ABI; annotated C is read-only by default.")
parser.add_argument("--extract-unannotated", action="store_true", help="Explicitly overwrite types.h and all nine C slices with unannotated source bodies.")
args = parser.parse_args()
root=Path('/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro')
trial=Path('/home/xinra/crtos/ksemaphorecreate-trial-261019-1')
checks=trial/'checks'
config=root/'board/stm32f103-nano/config'
expected_hashes = {'board/stm32f103-nano/config': '6702975d356756d6e46534d620e28611db221c88a5e23aa57a612db21ea16713', 'board/stm32f103-nano/config.mk': '0814ca204a82413d504c415aac1c9f14a437b3261cda25d48920efda81fcc3f8', 'kernel/include/xs_base.h': '1861d40f9934834c0b6515e3c273d84e50787252f69f38d72420774f9b7d49c8', 'kernel/include/xs_sem.h': 'c2c6edfde22823863a655d6d2a3f59fb749085a8b426166c885c2d5354174fab', 'kernel/include/xs_klist.h': '5bea28cd16a799e414830dadfb6f3be8efd9dbf69b980fc4d44611531f71f7ca', 'kernel/include/xs_id.h': 'a44025ae2113ce756ddfb659556ba2211140284ba324907255e60fd515f8f42d', 'kernel/include/xs_kdbg.h': '14cbe426145b99a1b69c01113ffb5aff77f2553bfcfddde13e43df3d6ea34eae', 'kernel/include/xs_isr.h': 'cd78673f5defbf088a8bcd6f9c18cc618b97643c296e28a25a27c76133b8e561'}
for source_path, expected_hash in expected_hashes.items():
    assert hashlib.sha256((root/source_path).read_bytes()).hexdigest() == expected_hash, 'Source/config changed: ' + source_path
lines=[]
for line in config.read_text().splitlines():
    m=re.fullmatch(r'CONFIG_(\w+)=(.*)',line)
    if m:
        name,value=m.groups()
        lines.append('#define '+name+('' if value=='y' else ' '+value))
assert (checks/'config/xsconfig.h').read_text() == '\n'.join(lines)+'\n', 'Configuration changed: review required; generated config not overwritten.'
layout='''#include <xs_sem.h>
#define ASSERT(e) _Static_assert((e), #e)
#define OFF(t,f,n) ASSERT(__builtin_offsetof(t,f)==n)
ASSERT(sizeof(int)==4); ASSERT(sizeof(long)==4); ASSERT(sizeof(void*)==4);
ASSERT(sizeof(uint16)==2); ASSERT(sizeof(x_base)==4);
ASSERT(sizeof(DoubleLinklistType)==8); OFF(DoubleLinklistType,node_next,0); OFF(DoubleLinklistType,node_prev,4);
ASSERT(sizeof(struct IdNode)==12); OFF(struct IdNode,id,0); OFF(struct IdNode,link,4);
ASSERT(sizeof(struct IdManager)==12); OFF(struct IdManager,id_max,0); OFF(struct IdManager,hoffset,2); OFF(struct IdManager,id_map,4); OFF(struct IdManager,htable,8);
ASSERT(sizeof(struct Semaphore)==32); ASSERT(_Alignof(struct Semaphore)==4);
OFF(struct Semaphore,id,0); OFF(struct Semaphore,value,12); OFF(struct Semaphore,pend_list,16); OFF(struct Semaphore,link,24);
ASSERT(sizeof(SemaphoreDoneType)==20); OFF(SemaphoreDoneType,SemaphoreCreate,0);
ASSERT(ID_NUM_MAX==128); ASSERT(ID_HTABLE_SIZE==16);
#ifdef ARCH_SMP
#error unexpected SMP
#endif
DECLARE_ID_MANAGER(layout_manager,ID_NUM_MAX);
ASSERT(sizeof(__id_map_layout_manager)==16); ASSERT(sizeof(__htable_layout_manager)==128);
'''
assert (checks/'layout.c').read_text() == layout, 'Layout check differs from frozen assertion source.'
cmd=['gcc','-m32','-std=c11','-ffreestanding','-fsyntax-only','-I'+str(checks/'config'),'-I'+str(root/'kernel/include'),str(checks/'layout.c')]
p=subprocess.run(cmd,text=True,capture_output=True)
print(' '.join(cmd))
print(p.stdout + p.stderr, end='')
assert p.returncode==0
# Minimal header preserves all fields of every accessed struct and the actual typedef widths.
types='''#ifndef TRIAL_TYPES_H
#define TRIAL_TYPES_H
/* Source: kernel/include/xs_base.h, xs_klist.h, xs_id.h, xs_sem.h; ILP32. */
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef signed int int32;
typedef long x_base;
typedef unsigned long x_size_t;
typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct IdManager { uint16 id_max; uint16 hoffset; uint8 *id_map; DoubleLinklistType *htable; };
struct Semaphore { struct IdNode id; uint16 value; DoubleLinklistType pend_list; DoubleLinklistType link; };
#define NONE ((void *)0)
#define ENOMEMORY 5
extern struct IdManager k_sem_id_manager;
extern DoubleLinklistType k_sem_list;
extern uint16 KTaskOsAssignLockNest;
#endif
'''
if args.extract_unannotated:
    (trial/'annotated_C/include/types.h').write_text(types)
locations={}
for filename,names in [('semaphore.c',['KSemaphoreCreate','_SemaphoreCreate']),('id.c',['IdInsertObj','AllocId','InsertObj']),('double_link.c',['InitDoubleLinkList','DoubleLinkListInsertNodeAfter']),('CriticalArea.c',['CriticalAreaLock','CriticalAreaUnLock'])]:
    path=root/'kernel/thread'/filename
    text=path.read_text()
    for name in names:
        matches=list(re.finditer(r'^(?:static )?(?:int32|int|void|x_base) '+re.escape(name)+r'\([^\n]*\)\s*\{',text,re.M))
        m=matches[-1] # last is configured non-SMP definition for CriticalArea
        depth=1; end=m.end()
        while depth:
            depth+=(text[end]=='{')-(text[end]=='}'); end+=1
        body=text[m.start():end]
        original_line=text.count('\n',0,m.start())+1
        body=re.sub(r'^static ','',body)
        body=body.replace('KDEBUG_NOT_IN_INTERRUPT;','; /* source-local empty macro */')
        body=body.replace('done.SemaphoreCreate(val)','_SemaphoreCreate(val)')
        body=body.replace('DISABLE_INTERRUPT()','DisableLocalInterrupt()').replace('ENABLE_INTERRUPT(lock)','EnableLocalInterrupt(lock)')
        # Preserve exact macro source line through expansion for diagnostic output.
        for mm in reversed(list(re.finditer(r'NULL_PARAM_CHECK\((\w+)\);',body))):
            param=mm.group(1); line=original_line+body.count('\n',0,mm.start())
            expansion='do { if ('+param+' == NONE) { KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\\n", "'+name+'", '+str(line)+', "'+param+'"); while (1) ; } } while (0);'
            body=body[:mm.start()]+expansion+body[mm.end():]
        if name=='_SemaphoreCreate':
            body=body.replace('SYS_KDEBUG_LOG(KDBG_IPC, ("created semaphore: id %d, value %d\\n", id, (int)val));','do { if (0) { KPrintf("[%s:%d] ", "_SemaphoreCreate", 59); KPrintf("created semaphore: id %d, value %d\\n", id, (int)val); } } while (0);')
        if args.extract_unannotated:
            (trial/'annotated_C/src'/f'{name}.c').write_text('#include "../include/types.h"\n\n/* Contracts to be authored; source '+str(path.relative_to(root))+':'+str(original_line)+'. */\n'+body+'\n')
        locations[name]={'file':str(path.relative_to(root)),'line':original_line,'source_sha256':hashlib.sha256(path.read_bytes()).hexdigest()}
assert locations == json.loads((checks/'source-locations.json').read_text()), 'Authoritative function source/hash changed: review required.'
print('Source/config hashes and ILP32 assertions passed. ' + ('Unannotated C extracted by explicit request.' if args.extract_unannotated else 'No files modified.'))
