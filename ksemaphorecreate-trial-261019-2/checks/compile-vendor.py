#!/usr/bin/env python3
"""Copy and compile only this explicit fresh QCP prerequisite list."""
from pathlib import Path
import hashlib, json, shlex, subprocess
T=Path(__file__).resolve().parent.parent
Q=Path('/home/xinra/qcp-binary-democases/Rocq')
FILES=['fixedpoints/LiftConstructors.v','fixedpoints/PartialOrder_Setoid.v',
       'fixedpoints/BourbakiWitt.v','MonadLib/Monad.v',
       'MonadLib/MonadErr/MonadErrBasic.v','MonadLib/MonadErr/MonadErrLoop.v',
       'MonadLib/MonadErr/MonadErrHoare.v','MonadLib/MonadErr/monadesafe_lib.v']
manifest={}
for name in FILES:
    source=Q/name; dest=T/'vendor'/name
    data=source.read_bytes()
    manifest[name]={'source':str(source),'sha256':hashlib.sha256(data).hexdigest()}
    dest.parent.mkdir(parents=True,exist_ok=True)
    if dest.exists():
        assert dest.read_bytes()==data, 'Refusing to overwrite modified vendor: '+name
    else: dest.write_bytes(data)
(T/'checks/vendor-source-hashes.json').write_text(json.dumps(manifest,indent=2)+'\n')
args=shlex.split((T/'_CoqProject').read_text())
for i in range(len(args)-2):
    if args[i] in ('-R','-Q') and args[i+2] in ('FP','MonadLib'):
        args[i+1]=str(T/'vendor'/('fixedpoints' if args[i+2]=='FP' else 'MonadLib'))
with (T/'checks/vendor-compile.log').open('w') as log:
    for name in FILES:
        cmd=['coqc',*args,str(T/'vendor'/name)]
        log.write('COMMAND '+shlex.join(cmd)+'\n');log.flush()
        run=subprocess.run(cmd,cwd=T,stdout=log,stderr=log)
        log.write('EXIT '+str(run.returncode)+'\n');log.flush()
        print(name,run.returncode,flush=True)
        if run.returncode: raise SystemExit(run.returncode)
    log.write('PASS: all eight unmodified vendored prerequisite files compiled.\n')
