from pathlib import Path
import shlex, subprocess, json
trial=Path(__file__).resolve().parents[1]
args=[]
for line in (trial/'_CoqProject').read_text().splitlines():
    words=shlex.split(line)
    if words and words[0] in ('-R','-Q','-I'):
        args.extend(words)
files=['TaskInv.v','SemaphoreInv.v','CrtosInv.v','KTaskUnSetDelay.v','KTaskWakeup.v','SemaphoreOps.v','KSemaphoreDelete.v']
results=[]
for name in files:
    cmd=['coqc',*args,'lib/'+name]
    result=subprocess.run(cmd,cwd=trial,capture_output=True,text=True)
    (trial/'checks'/('compile-'+name+'.log')).write_text(result.stdout+result.stderr+'\nexit_code='+str(result.returncode)+'\n')
    results.append({'file':name,'command':shlex.join(cmd),'cwd':str(trial),'exit_code':result.returncode})
    print(name,result.returncode)
    if result.returncode:
        print(result.stdout+result.stderr)
        break
(trial/'checks'/'predicate-compile.json').write_text(json.dumps(results,indent=2)+'\n')
raise SystemExit(0 if len(results)==len(files) and all(r['exit_code']==0 for r in results) else 1)
