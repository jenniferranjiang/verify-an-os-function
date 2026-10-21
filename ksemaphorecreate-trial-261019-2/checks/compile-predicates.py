from pathlib import Path
import subprocess, shlex, sys
root=Path(__file__).resolve().parents[1]
args=shlex.split((root/'_CoqProject').read_text())
files=['libai/TaskStatus.v','libai/TickOrder.v','lib/dll_abs.v','lib/idnode_abs.v','lib/StructFieldOffsetAxiom.v','lib/KTaskPure.v','lib/KTaskDelay.v','lib/CrtosGlobState.v','lib/NonemptyCSL.v','lib/CrtosRules.v','libai/NodeSelfLinked.v','lib/dll.v','lib/idnode.v','lib/semaphore.v','lib/CrtosInv.v','lib/KSemaphoreCreate.v']
log=[]
files=files[files.index(sys.argv[1]):] if len(sys.argv)>1 else files
for f in files:
 if not (root/f).exists(): raise FileNotFoundError(root/f)
 r=subprocess.run(['coqc',*args,f],cwd=root,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 line=f+' EXIT '+str(r.returncode)+'\n'+r.stdout
 print(line,flush=True);log.append(line)
 (root/'checks/predicate-compile.log').write_text('\n'.join(log))
 if r.returncode:sys.exit(r.returncode)
