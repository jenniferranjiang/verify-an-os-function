from pathlib import Path
import hashlib,json,subprocess,shlex
T=Path(__file__).resolve().parents[1]; E=T/'evidence/abi-supplement';E.mkdir(exist_ok=True)
qcp=Path('/home/xinra/qcp-binary-democases')
args=shlex.split((T/'_CoqProject').read_text())
oldqueries='''Require Import Coq.ZArith.ZArith.
Require Import CRTOS_Verify.lib.CrtosRules CRTOS_Verify.sem.CrtosOSProtocol.
Open Scope Z_scope.
Print Task_C_Rules.store_ptr.
Print Task_C_Rules.undef_store_ptr.
Print Task_C_Rules.store_ushort.
Print Task_C_Rules.store_4byte.
Print Task_C_Rules.store_2byte.
Print CommonAssertion.merge_int.
Print CommonAssertion.merge_short.
Print Crtos_C_Rules.store_ptr.
Print Crtos_C_Rules.store_ushort.
Eval cbv in CommonAssertion.merge_short 0 1 1.
Eval cbv in CommonAssertion.merge_short 1 0 1.
'''
records=[]
def capture(label,cmd,input=None):
 r=subprocess.run(cmd,input=input,text=True,capture_output=True)
 (E/(label+'.stdout')).write_text(r.stdout);(E/(label+'.stderr')).write_text(r.stderr)
 records.append(dict(label=label,command=cmd,stdin=input,exit_code=r.returncode,has_coq_error='Error:' in r.stderr))
 return r
capture('driver-help',[str(qcp/'linux-binary/symexec'),'--help'])
capture('loaded-legacy-stores',['/home/xinra/.opam/default/bin/coqtop','-quiet',*args],oldqueries)
# A separate process tests official modern modules only, never mixed with old root .vo.
modernargs=shlex.split((qcp/'Rocq/_CoqProject').read_text());modern=[]
for i in range(0,len(modernargs),3):
 flag,p,logical=modernargs[i:i+3]
 if p.startswith('../_build/'):continue
 modern += [flag,str((qcp/'Rocq'/p).resolve()),logical]
newqueries='''Require Import Coq.ZArith.ZArith.
From SimpleC.SL Require Import SeparationLogic.
Open Scope Z_scope.
Print Snaive_C_Rules.store_ptr.
Print Snaive_C_Rules.store_ushort.
Eval cbv in Snaive_C_Rules.ptr_size_Z.
Eval cbv in Snaive_C_Rules.merge_short 1 0 1.
'''
capture('modern-little-endian-load',['/home/xinra/.opam/pv-bench-8.20.1/bin/coqtop','-quiet',*modern],newqueries)
files=[qcp/'linux-binary/symexec',qcp/'docs/qcp-cli.md',qcp/'SeparationLogic/SeparationLogic/CommonAssertion.vo',qcp/'SeparationLogic/SeparationLogic/SeparationLogic.vo',qcp/'Rocq/SeparationLogic/CArch.v',qcp/'Rocq/SeparationLogic/CommonAssertion.v',qcp/'Rocq/SeparationLogic/SeparationLogic.v',Path('/home/xinra/crtos/lib/CrtosRules.v')]
out={'purpose':'Read-only ABI/model investigation; no symexec, no ARM layout rerun, no formal/spec edits','commands':records,'sha256':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}}
(E/'result.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps([{k:v for k,v in r.items() if k not in ['stdin','command']} for r in records],indent=2))
