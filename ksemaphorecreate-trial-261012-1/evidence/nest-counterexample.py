#!/usr/bin/env python3
"""Run an ILP32 C counterexample using the source-equivalent trial bodies.

This is a source-behavior diagnostic, not a QCP proof or a board reachability claim.
No archived trial is accessed. The harness uses constant memory for nested calls.
"""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

evidence = Path(__file__).resolve().parent
trial = evidence.parent
names = ['KSemaphoreCreate', '_SemaphoreCreate', 'IdInsertObj', 'AllocId',
         'InsertObj', 'InitDoubleLinkList', 'DoubleLinkListInsertNodeAfter',
         'CriticalAreaLock', 'CriticalAreaUnLock']
header = (trial / 'annotated_C/include/crtos_semaphore_layout.h').read_text()
parts = [header]
inputs = {}
for name in names:
    path = trial / 'annotated_C/src' / (name + '.c')
    raw = path.read_text()
    inputs[str(path.relative_to(trial))] = hashlib.sha256(raw.encode()).hexdigest()
    raw = re.sub(r'/\*.*?\*/', '', raw, flags=re.S)
    raw = re.sub(r'^#include[^\n]*', '', raw, flags=re.M)
    parts.append(raw)
parts.append(r'''
_Static_assert(sizeof(void *) == 4 && sizeof(long) == 4, "ILP32");
_Static_assert(sizeof(struct Semaphore) == 32, "Semaphore ABI");
uint16 KTaskOsAssignLockNest;
static uint8 id_bitmap[16];
static DoubleLinklistType id_buckets[16];
struct IdManager k_sem_id_manager = {128, 16, id_bitmap, id_buckets};
DoubleLinklistType k_sem_list = {&k_sem_list, &k_sem_list};
static struct Semaphore arena_object;
static int allocated;
static x_base primask;
void *x_malloc(x_size_t size) {
    if (size != 32 || allocated) return 0;
    allocated = 1; return &arena_object;
}
void *memset(void *dest, int value, x_size_t size) {
    unsigned char *p = dest;
    for (x_size_t i = 0; i < size; ++i) p[i] = (unsigned char)value;
    return dest;
}
void x_free(void *ptr) { if (ptr == &arena_object) allocated = 0; }
x_base DisableLocalInterrupt(void) {
    x_base handler = primask; primask = 1; return handler;
}
void EnableLocalInterrupt(x_base handler) { primask = handler; }
void KPrintf(const char *fmt, const char *function, int line, const char *parameter) {
    (void)fmt; (void)function; (void)line; (void)parameter;
}
static void write_text(const char *text, unsigned size) {
    __asm__ volatile("int $0x80" : : "a"(4), "b"(1), "c"(text), "d"(size) : "memory");
}
void _start(void) {
    x_base outer_handler = CriticalAreaLock();
    for (unsigned i = 1; i < 65535; ++i) (void)CriticalAreaLock();
    unsigned before = KTaskOsAssignLockNest;
    int id = KSemaphoreCreate(3);
    unsigned after = KTaskOsAssignLockNest;
    int reproduced = before == 65535 && after == 0 && id == 0 &&
      arena_object.value == 3 && primask == 1 && outer_handler == 0;
    /* Finish the matching unlock sequence: no unmatched caller locks remain. */
    for (unsigned i = 1; i < 65535; ++i) CriticalAreaUnLock(1);
    CriticalAreaUnLock(outer_handler);
    reproduced = reproduced && KTaskOsAssignLockNest == 0 && primask == 0;
    const char result[] = "REPRODUCED: before=65535 after=0 id=0 value=3 primask=1\n";
    if (reproduced) write_text(result, sizeof(result) - 1);
    __asm__ volatile("int $0x80" : : "a"(1), "b"(reproduced ? 0 : 1) : "memory");
    __builtin_unreachable();
}
''')
c = evidence / 'nest-counterexample.c'
binary = evidence / 'nest-counterexample'
c.write_text('\n'.join(parts))
command = ['gcc', '-m32', '-std=gnu11', '-O0', '-ffreestanding', '-fno-builtin',
           '-fno-stack-protector', '-fno-pie', '-no-pie', '-nostdlib', '-static',
           str(c), '-o', str(binary)]
compile_result = subprocess.run(command, text=True, capture_output=True)
build_only = '--build-only' in sys.argv[1:]
run_result = (subprocess.run([str(binary)], text=True, capture_output=True)
              if compile_result.returncode == 0 and not build_only else None)
result = {'purpose': 'source behavior counterexample; not QCP verification',
          'scope': 'C critical API sequence with concrete allocation/zeroing/PRIMASK stubs; neither a board execution reachability claim nor a proof of the formal IRQ token/rely contracts',
          'input_sha256': inputs, 'harness_sha256': hashlib.sha256(c.read_bytes()).hexdigest(),
          'command': command, 'compile_exit': compile_result.returncode,
          'compile_stderr': compile_result.stderr,
          'build_only': build_only,
          'balanced_caller_locks': True,
          'run_exit': run_result.returncode if run_result else None,
          'stdout': run_result.stdout if run_result else '',
          'stderr': run_result.stderr if run_result else ''}
(evidence / 'nest-counterexample-result.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps({k: v for k, v in result.items() if k not in ['input_sha256', 'command']}, indent=2))
raise SystemExit(compile_result.returncode or
                 (0 if build_only else (run_result.returncode if run_result else 1)))
