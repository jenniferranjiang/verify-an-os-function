#!/usr/bin/env python3
"""Fault injection on authoritative C and the trial-only repair; no QCP or Rocq."""
from pathlib import Path
import re,subprocess,json,hashlib
here=Path(__file__).resolve().parent;root=here.parents[2];kernel=root/'Ubiquitous/XiZi_IIoT_Macro/kernel/thread'
functions={
'double_link.c':['InitDoubleLinkList','DoubleLinkListInsertNodeAfter','DoubleLinkListInsertNodeBefore','DoubleLinkListRmNode','IsDoubleLinkListEmpty'],
'CriticalArea.c':['CriticalAreaLock','CriticalAreaUnLock'],
'delay.c':['KTaskSetDelay','KTaskUnSetDelay'],
'ktask.c':['_SuspendKTask','_KTaskWakeup','SuspendKTask','KTaskWakeup','KTaskTimeout'],
'linklist.c':['LinklistSuspend'],'tick.c':['CalculateTickFromTimeMs'],'event.c':['_EventTrigger','_EventProcess']}
def extract(s,name):
    matches=list(re.finditer(r'^\s*(?:static\s+)?(?:[A-Za-z_]\w*\s+)+\b'+re.escape(name)+r'\s*\([^;{}]*\)\s*\{',s,re.M))
    if not matches:raise RuntimeError('Function not found: '+name)
    m=matches[-1];depth=1
    tokens=re.finditer(r'/\*.*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|\x27(?:\\.|[^\x27\\])*\x27|[{}]',s[m.end():],re.S)
    for token in tokens:
        v=token.group();depth+=(v=='{')-(v=='}')
        if depth==0:return s[m.start():m.end()+token.end()].strip()+'\n'
    raise RuntimeError('Unbalanced function '+name)
results=[]
for variant in ['before','after']:
    work=here/variant;work.mkdir(exist_ok=True);parts=[];sources={}
    for name,names in functions.items():
        for symbol in names:
            if variant=='after' and symbol=='_EventProcess':
                path=here.parents[1]/'source_fixes/_EventProcess.c'
            else:
                path=here/'before-event.c' if variant=='before' and name=='event.c' else kernel/name
            txt=path.read_text();sources[str(path.relative_to(root))]=hashlib.sha256(path.read_bytes()).hexdigest()
            parts.append(extract(txt,symbol))
    (work/'extracted.inc').write_text('\n'.join(parts));(work/'harness.c').write_text((here/'harness.c').read_text())
    cmd=['gcc','-std=c11','-g','-Wall','-Wextra','-Werror','-Wno-unused-variable','-fsanitize=undefined','-fno-sanitize-recover=all','harness.c','-o','regression']
    build=subprocess.run(cmd,cwd=work,text=True,capture_output=True);(work/'build.log').write_text(build.stdout+build.stderr)
    if build.returncode:print(build.stderr);raise SystemExit(build.returncode)
    run=subprocess.run([str(work/'regression')],cwd=work,text=True,capture_output=True,timeout=10);(work/'run.log').write_text(run.stdout+run.stderr)
    row={'variant':variant,'command':cmd,'compile_exit':build.returncode,'run_exit':run.returncode,'output':run.stdout+run.stderr,'sources':sources}
    results.append(row);print(variant,run.returncode,run.stdout+run.stderr)
(here/'results.json').write_text(json.dumps(results,indent=2)+'\n')
assert results[0]['run_exit']==20,'Baseline must expose lost timeout'
assert results[1]['run_exit']==0,'Patched scenarios must pass'
