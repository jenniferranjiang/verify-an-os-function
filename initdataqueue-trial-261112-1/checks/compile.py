"""Design-only Rocq compilation; deliberately no QCP parser or VC calls."""
from pathlib import Path
import hashlib,json,shlex,subprocess,tempfile
trial=Path(__file__).resolve().parents[1]
args=shlex.split((trial/'_CoqProject').read_text()); flags=[]; files=[]
while args:
    tok=args.pop(0)
    if tok in ('-R','-Q'): flags += [tok,args.pop(0),args.pop(0)]
    else: files.append(tok)
compiler='/home/xinra/.opam/pv-bench-8.20.1/bin/coqc'
summary={'compiler':compiler,'version':subprocess.check_output([compiler,'--version'],text=True).strip(),'checks':[]}
with tempfile.TemporaryDirectory(prefix='crtos-verify-initdataqueue-trial-261112-1-compile-') as tmp:
    for f in files:
        result=subprocess.run([compiler,*flags,f],cwd=trial,text=True,capture_output=True)
        summary['checks'].append({'file':f,'sha256':hashlib.sha256((trial/f).read_bytes()).hexdigest(),'exit_code':result.returncode,'diagnostic':result.stderr.strip(),'type_check_output':result.stdout.strip()})
        print(f, 'PASS' if result.returncode==0 else 'FAIL', flush=True)
        if result.returncode:
            print(result.stderr);break
(trial/'checks/rocq-summary.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2)+'\n')
raise SystemExit(any(c['exit_code'] for c in summary['checks']) or len(summary['checks'])!=len(files))
