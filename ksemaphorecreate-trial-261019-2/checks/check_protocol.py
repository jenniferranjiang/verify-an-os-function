#!/usr/bin/env python3
from pathlib import Path
import hashlib,json,shlex,subprocess
T=Path(__file__).resolve().parent.parent
files=['lib/NonemptyCSL.v','lib/CrtosRules.v','checks/ProtocolSanityCheck.v']
hashes={f:hashlib.sha256((T/f).read_bytes()).hexdigest() for f in files}
(T/'checks/protocol-input-hashes.json').write_text(json.dumps(hashes,indent=2)+'\n')
cmd=['coqc',*shlex.split((T/'_CoqProject').read_text()),str(T/files[-1])]
with (T/'checks/protocol-typecheck.log').open('w') as log:
    log.write('INPUT HASHES '+json.dumps(hashes)+'\nCOMMAND '+shlex.join(cmd)+'\n');log.flush()
    run=subprocess.run(cmd,cwd=T,stdout=log,stderr=log)
    log.write('EXIT '+str(run.returncode)+'\n')
print('Protocol sanity coqc exit',run.returncode)
raise SystemExit(run.returncode)
