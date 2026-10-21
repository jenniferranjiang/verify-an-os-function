#!/usr/bin/env python3
"""Rebuild current-source evidence without reading any other trial.
ABI_CC / ABI_FLAGS override only the ARM ABI compiler, not source/config inputs.
Native preprocessing is explicitly separate from the target ABI check.
"""
from pathlib import Path
import hashlib,json,os,re,shlex,subprocess,time
E=Path(__file__).resolve().parent
ROOT=E.parent.parent/'Ubiquitous/XiZi_IIoT_Macro'
CFG=ROOT/'board/stm32f103-nano/config'
CONFIG=E/'source-config'
CONFIG.mkdir(exist_ok=True)
start=time.monotonic(); commands=[]
def run(args, **kw):
    commands.append(args)
    p=subprocess.run(args,text=True,capture_output=True,**kw)
    if p.returncode: raise RuntimeError(shlex.join(args)+'\n'+p.stderr)
    return p.stdout
run(['bash',str(ROOT/'tool/hosttools/xsconfig.sh'),str(CFG)],cwd=CONFIG,env={**os.environ,'BSP_ROOT':str(CONFIG)})
inc=[str(CONFIG),str(ROOT/'kernel/include'),str(ROOT/'arch/arm/cortex-m3'),str(ROOT/'tool/shell/letter-shell')]
incs=[a for d in inc for a in ['-I',d]]
abi_cc=shlex.split(os.environ.get('ABI_CC','/tmp/crtos-arm-toolchain/root/usr/bin/arm-none-eabi-gcc'))
abi_flags=shlex.split(os.environ.get('ABI_FLAGS','-mcpu=cortex-m3 -mthumb -DSOURCE_REQUIRE_ARM'))
run(abi_cc+abi_flags+['-std=gnu11','-ffreestanding','-S',str(E/'source-abi.c'),'-o',str(E/'source-abi.s')]+incs)
version=run(abi_cc+['--version']).splitlines()[0]
target_macros=run(abi_cc+abi_flags+['-E','-dM',str(E/'source-abi.c')]+incs)
(E/'source-target-macros.txt').write_text(target_macros)
assert '#define __ARM_ARCH_7M__ 1' in target_macros
assert '#define __thumb__ 1' in target_macros

# These TUs use no compiler predefined ABI switches in the selected kernel branches.
# Native preprocessing permits using installed libc headers; it does NOT establish ARM ABI.
source_files=['kernel/thread/semaphore.c','kernel/thread/id.c','kernel/thread/double_link.c','kernel/thread/CriticalArea.c']
deps=set()
for rel in source_files:
    stem=Path(rel).stem
    src=ROOT/rel
    pp=run(['gcc','-E','-P',str(src)]+incs)
    (E/('source-'+stem+'.i')).write_text(pp)
    dd=run(['gcc','-MM',str(src)]+incs).replace('\\\n',' ')
    for f in shlex.split(dd.split(':',1)[1]):
        p=Path(f).resolve()
        if p.is_relative_to(ROOT): deps.add(p)
macros=run(['gcc','-E','-dM',str(ROOT/'kernel/thread/semaphore.c')]+incs)
(E/'source-macros.txt').write_text(macros)
assert '#define KERNEL_DEBUG ' in macros
assert '#define KDBG_IPC 0' in macros
assert '#define KDEBUG_NOT_IN_INTERRUPT ' in macros
assert '#define ARCH_SMP ' not in macros
assert '#define ID_NUM_MAX 128' in macros
assert '#define ID_HTABLE_SIZE 16' in macros
# Explicit context inputs; no entire-tree scan/hash and no access to archived trials.
for rel in ['board/stm32f103-nano/config','board/stm32f103-nano/config.mk',
            'tool/hosttools/xsconfig.sh','arch/arm/cortex-m3/interrupt.c',
            'kernel/thread/data_queue.c','kernel/thread/linklist.c','kernel/thread/ktask.c','kernel/thread/delay.c',
            'kernel/thread/tick.c','kernel/thread/assign.c','kernel/thread/assign_roundrobinremain.c',
            'kernel/thread/assignstat.c','kernel/include/xs_ktask_stat.h',
            'tool/shell/letter-shell/cmd.c']:
    deps.add(ROOT/rel)
manifest={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(deps)}
encoded=json.dumps(manifest,sort_keys=True,indent=2)+'\n'
(E/'source-manifest.json').write_text(encoded)
h=hashlib.sha256(encoded.encode()).hexdigest()
result={'source_revision':'source-r2-'+h[:12],'manifest_sha256':h,'authoritative_root':str(ROOT),
        'config':'board/stm32f103-nano/config','compiler':version,'abi_command':commands[1],
        'target_check':'Cortex-M3 ARMv7-M Thumb ILP32; actual target compilation passed',
        'config_generated_sha256':hashlib.sha256((CONFIG/'xsconfig.h').read_bytes()).hexdigest(),
        'source_files_count':len(manifest),'commands':commands,'elapsed_seconds':round(time.monotonic()-start,3)}

# Scan actual preprocessed bodies. Strip strings while preserving offsets/braces.
def masked(s):
    return re.sub(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'',lambda m:' '*len(m[0]),s)
def definitions(s):
    z=masked(s); out={}
    for m in re.finditer(r'\b([A-Za-z_]\w*)\s*\([^;{}]*\)\s*\{',z):
        # Only translation-unit definitions, not nested control statements.
        if z[:m.start()].count('{') != z[:m.start()].count('}'): continue
        i=m.end(); depth=1
        while depth:
            depth+=(z[i]=='{')-(z[i]=='}'); i+=1
        out[m[1]]=s[m.start():i]
    return out
bodies={}; origins={}
for rel in source_files:
    for name,body in definitions((E/('source-'+Path(rel).stem+'.i')).read_text()).items():
        if name in bodies and bodies[name]!=body: raise RuntimeError('conflicting definition '+name)
        bodies[name]=body; origins[name]=rel
trusted=['x_malloc','x_free','memset','DisableLocalInterrupt','EnableLocalInterrupt','KPrintf']
ignore={'if','while','for','switch','sizeof','_Alignof','__attribute__'}
dispatch={'done.SemaphoreCreate':'_SemaphoreCreate'}
q=['KSemaphoreCreate']; seen=set(); graph={}
while q:
    name=q.pop()
    if name in seen: continue
    seen.add(name)
    if name in trusted: continue
    if name not in bodies: raise RuntimeError('unresolved body '+name)
    z=masked(bodies[name]); z=z[z.index('{'):]
    calls=set(re.findall(r'\b((?:[A-Za-z_]\w*\.)?[A-Za-z_]\w*)\s*\(',z))-ignore
    calls={dispatch.get(c,c) for c in calls}
    graph[name]=sorted(calls); q.extend(calls)
expected={'KSemaphoreCreate','_SemaphoreCreate','IdInsertObj','AllocId','InsertObj',
          'InitDoubleLinkList','DoubleLinkListInsertNodeAfter','CriticalAreaLock','CriticalAreaUnLock'}
assert set(graph)==expected,graph
assert seen & set(trusted)==set(trusted)
sem=(ROOT/'kernel/thread/semaphore.c').read_text()
assert len(re.findall(r'\.SemaphoreCreate\s*=',sem))==1
assert '.SemaphoreCreate = _SemaphoreCreate' in sem
assert not re.search(r'\bdone\s*\.\s*SemaphoreCreate\s*=',sem)
assert not re.search(r'&\s*done\b',sem)
closure={'entry':'KSemaphoreCreate','nontrusted':sorted(graph),'trusted':trusted,
         'direct_calls':graph,'origins':{n:origins[n] for n in graph},
         'dispatch':dispatch,'note':'Includes KPrintf in constant-false log branches as well as reachable NULL_PARAM_CHECK. Nontrusted closure unchanged by approved deletion of KDBG_IPC=0 logging.'}
(E/'source-closure.json').write_text(json.dumps(closure,indent=2)+'\n')
(E/'source-bodies.json').write_text(json.dumps({n:bodies[n] for n in sorted(graph)},indent=2)+'\n')
result['elapsed_seconds']=round(time.monotonic()-start,3)
result['closure_counts']={'nontrusted':len(graph),'trusted':len(trusted)}
(E/'source-check-result.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k!='commands'},ensure_ascii=False,indent=2))
print('Recursive closure scan passed: 9 active bodies, 6 trusted symbols.')
