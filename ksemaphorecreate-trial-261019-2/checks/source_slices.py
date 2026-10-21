#!/usr/bin/env python3
"""Fresh authoritative extraction. Default is READ ONLY; --initialize uses exclusive writes.

No directory walk, glob, other-trial access, trusted-body reads or annotation overwrite.
The comparison removes comments (including QCP annotations), but checks C body tokens.
"""
from pathlib import Path
import argparse, hashlib, json, re

ROOT = Path('/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro')
TRIAL = Path(__file__).resolve().parent.parent
SOURCES = {
    'KSemaphoreCreate': 'kernel/thread/semaphore.c',
    '_SemaphoreCreate': 'kernel/thread/semaphore.c',
    'CriticalAreaLock': 'kernel/thread/CriticalArea.c',
    'CriticalAreaUnLock': 'kernel/thread/CriticalArea.c',
    'IdInsertObj': 'kernel/thread/id.c',
    'AllocId': 'kernel/thread/id.c',
    'InsertObj': 'kernel/thread/id.c',
    'InitDoubleLinkList': 'kernel/thread/double_link.c',
    'DoubleLinkListInsertNodeAfter': 'kernel/thread/double_link.c',
}
EXTRA = ['board/stm32f103-nano/config', 'board/stm32f103-nano/config.mk',
         'kernel/include/xs_sem.h', 'kernel/include/xs_id.h', 'kernel/include/xs_base.h',
         'kernel/include/xs_klist.h', 'kernel/include/xs_kdbg.h', 'kernel/include/xs_isr.h',
         'kernel/include/xs_memory.h', 'kernel/thread/linklist.c',
         'kernel/thread/data_queue.c', 'kernel/thread/Makefile', 'kernel/include/xizi.h']
TOKEN = re.compile(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|/\*[\s\S]*?\*/|//[^\n]*|\w+|[^\s]')
def tokens(s):
    return [x for x in TOKEN.findall(s) if not x.startswith(('/*', '//'))]

def definition(s, name, last=False):
    # A specification may occur between the declaration and opening brace.
    clean = re.sub(r'/\*[\s\S]*?\*/|//[^\n]*', lambda m: '\n'*m[0].count('\n')+' ', s)
    matches = list(re.finditer(r'^\s*(?:static\s+)?(?:int32|int|void|x_base)\s+' + re.escape(name) + r'\s*\([^;{}]*?\)\s*\{', clean, re.M))
    if not matches:
        raise ValueError('Missing active definition: '+name)
    if not last and len(matches) != 1:
        raise ValueError('Multiple definitions: '+name)
    m = matches[-1] if last else matches[0]
    # clean and original positions differ; use line mapping to retain original body.
    start_line = clean[:m.start()].count('\n')
    lines = s.splitlines(keepends=True)
    offset = sum(map(len, lines[:start_line]))
    start = re.search(r'\b(?:static\s+)?(?:int32|int|void|x_base)\s+'+re.escape(name)+r'\s*\(', s[offset:]).start()+offset
    opening = next(t.start() for t in TOKEN.finditer(s, start) if t[0] == '{')
    depth = 0
    for t in TOKEN.finditer(s, opening):
        if t[0] == '{': depth += 1
        elif t[0] == '}':
            depth -= 1
            if depth == 0:
                return s[start:t.end()], s[:start].count('\n')+1
    raise ValueError('Unclosed body: '+name)

def normalized(name):
    original = (ROOT/SOURCES[name]).read_text()
    body, line = definition(original, name, name.startswith('CriticalArea'))
    body = re.sub(r'^static\s+', '', body)
    # Expand real debug guard, retaining original function/line/string arguments.
    def guard(m):
        arg = m[1]
        ln = line + body[:m.start()].count('\n')
        return ('do { if ('+arg+' == NONE) {\n'
                '        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\\n", "'+name+'", '+str(ln)+', "'+arg+'");\n'
                '        while (RET_TRUE) ;\n    } } while (0)')
    body = re.sub(r'NULL_PARAM_CHECK\((\w+)\)', guard, body)
    body = body.replace('KDEBUG_NOT_IN_INTERRUPT;', ';')
    body = body.replace('done.SemaphoreCreate(val)', '_SemaphoreCreate(val)')
    body = body.replace('DISABLE_INTERRUPT()', 'DisableLocalInterrupt()')
    body = body.replace('ENABLE_INTERRUPT(lock)', 'EnableLocalInterrupt(lock)')
    # KDBG_IPC=0: retain the expanded dead branch and both trusted calls.
    body = body.replace('SYS_KDEBUG_LOG(KDBG_IPC, ("created semaphore: id %d, value %d\\n", id, (int)val));',
        'do { if (0) { KPrintf("[%s:%d] ", "_SemaphoreCreate", 59);\n'
        '        KPrintf("created semaphore: id %d, value %d\\n", id, (int)val); } } while (0);')
    return body, line

PROTOS = {
 'KSemaphoreCreate': 'int32 _SemaphoreCreate(uint16 val);',
 '_SemaphoreCreate': '''void *x_malloc(x_size_t nbytes);
void x_free(void *ptr);
void *memset(void *dest, int c, size_t n);
x_base CriticalAreaLock(void);
void CriticalAreaUnLock(x_base lock);
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode);
void InitDoubleLinkList(DoubleLinklistType *linklist_head);
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node);
void KPrintf(const char *fmt, ...);
extern struct IdManager k_sem_id_manager;
extern DoubleLinklistType k_sem_list;''',
 'CriticalAreaLock': 'x_base DisableLocalInterrupt(void);\nextern uint16 KTaskOsAssignLockNest;',
 'CriticalAreaUnLock': 'void EnableLocalInterrupt(x_base level);\nextern uint16 KTaskOsAssignLockNest;',
 'IdInsertObj': '''int AllocId(struct IdManager *manager);
void InsertObj(struct IdManager *manager, struct IdNode *idnode);
void KPrintf(const char *fmt, ...);''',
 'AllocId': 'void KPrintf(const char *fmt, ...);',
 'InsertObj': '''void InitDoubleLinkList(DoubleLinklistType *linklist_head);
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node);
void KPrintf(const char *fmt, ...);''',
 'InitDoubleLinkList': '', 'DoubleLinkListInsertNodeAfter': ''
}
TYPES = '''/* Exact field order and ILP32 ABI from authoritative xs_*.h. */
#ifndef FRESH_SEMAPHORE_TYPES_H
#define FRESH_SEMAPHORE_TYPES_H
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef signed int int32;
typedef long x_base;
typedef unsigned long x_size_t;
#include <stddef.h>
typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct IdManager {
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    DoubleLinklistType *htable;
};
struct Semaphore {
    struct IdNode id;
    uint16 value;
    DoubleLinklistType pend_list;
    DoubleLinklistType link;
};
#define NONE 0
#define RET_TRUE 1
#define ENOMEMORY 5
#endif
'''

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--initialize', action='store_true', help='create missing initial artifacts exclusively; never overwrite')
    args = p.parse_args()
    files = sorted(set(SOURCES.values()) | set(EXTRA))
    hashes = {str(ROOT/f): hashlib.sha256((ROOT/f).read_bytes()).hexdigest() for f in files}
    if args.initialize:
        (TRIAL/'annotated_C/include').mkdir(parents=True, exist_ok=True)
        (TRIAL/'annotated_C/src').mkdir(parents=True, exist_ok=True)
        with (TRIAL/'annotated_C/include/types.h').open('x') as f: f.write(TYPES)
        for name in SOURCES:
            body, line = normalized(name)
            content = ('/* Fresh extraction: '+SOURCES[name]+':'+str(line)+'; see source-analysis.md. */\n'
                       '#include "../include/types.h"\n\n'+PROTOS[name]+'\n\n'+body+'\n')
            with (TRIAL/'annotated_C/src'/f'{name}.c').open('x') as f: f.write(content)
        with (TRIAL/'checks/source-hashes.json').open('x') as f: json.dump(hashes, f, indent=2)
        print('INITIALIZED 9 exclusive slices; no canonical contracts added by extractor.')
    else:
        assert json.loads((TRIAL/'checks/source-hashes.json').read_text()) == hashes, 'Authoritative source/config changed'
        assert tokens((TRIAL/'annotated_C/include/types.h').read_text()) == tokens(TYPES), 'types.h changed'
        for name in SOURCES:
            actual, _ = definition((TRIAL/'annotated_C/src'/f'{name}.c').read_text(), name)
            expected, _ = normalized(name)
            assert tokens(actual) == tokens(expected), 'C body differs: '+name
            print('PASS', name, SOURCES[name])
        print('READ-ONLY PASS: 9 active bodies, types, authoritative source/config hashes.')
if __name__ == '__main__': main()
