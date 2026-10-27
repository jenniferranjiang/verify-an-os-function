from pathlib import Path
import re,subprocess,json,shlex
TRIAL=Path(__file__).resolve().parents[1]
s=(TRIAL/'annotated_C/include/logic.h').read_text()
lines=['(* Standalone type checks for the QCP Extern declarations; this is not QCP parsing or a C proof. *)','Require Import Coq.ZArith.ZArith Coq.Lists.List.','Require Import KSemaphoreDeleteTrial.KSemaphoreDelete KSemaphoreDeleteTrial.KTaskUnSetDelay.','Require Import CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo.','From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.','From SimpleC.SL Require Import Mem SeparationLogic MapLib.','Require Import Logic.LogicGenerator.demo932.Interface.','Import IDNode DLL.','Local Open Scope Z_scope.']
rename={'return':'MonadErr.ret','safeExec':'monadesafe_lib.safeExec','program':'MonadErr.M'}
def tyconvert(t):
 t=t.strip();m=re.match(r'((?:\{\w+\}\s*)+)\s*->\s*(.*)',t,re.S)
 if m:t='forall '+' '.join(re.findall(r'\{(\w+)\}',m[1]))+' : Type, '+m[2]
 for a,b in rename.items():t=re.sub(r'\b'+a+r'\b',b,t)
 return ' '.join(t.split())
for block in re.findall(r'/\*@\s*Extern Coq\s+(.*?)\*/',s,re.S):
 if block.startswith('Record '):
  m=re.match(r'Record (\w+)\s*\{(.*)\}',block,re.S)
  for f,t in re.findall(r'(\w+)\s*:\s*([^;]+);',m[2]):lines.append(f'Check (@{f} : {m[1]} -> {tyconvert(t)}).')
 elif ':=' in block:
  name,t=block.split(':=',1);lines.append(f'Check (eq_refl : {name.strip()} = {tyconvert(t)}).')
 else:
  # Declarations are parenthesized; nested list argument parentheses require balance.
  i=0
  while i<len(block):
   if block[i]!='(':i+=1;continue
   j=i+1;d=1
   while d:d+=(block[j]=='(')-(block[j]==')');j+=1
   decl=block[i+1:j-1];i=j
   if '::' in decl:
    n,t=decl.split('::',1);t=t.replace('*','Type').replace('=>','->')
   else:n,t=decl.split(':',1)
   n=n.strip();lines.append(f'Check (@{rename.get(n,n)} : {tyconvert(t)}).')
p=TRIAL/'checks/SpecVocabulary.v';p.write_text('\n'.join(lines)+'\n')
args=[]
for line in (TRIAL/'_CoqProject').read_text().splitlines():
 if line.startswith(('-R ','-Q ')):args.extend(shlex.split(line))
cmd=['coqc',*args,'checks/SpecVocabulary.v']
r=subprocess.run(cmd,cwd=TRIAL,text=True,capture_output=True)
(TRIAL/'checks/spec-vocabulary.log').write_text(r.stdout+r.stderr)
(TRIAL/'checks/spec-vocabulary-command.json').write_text(json.dumps(cmd,indent=2))
print('Extern types checked:',sum(line.startswith('Check ') for line in lines),'exit:',r.returncode)
print(r.stderr)
raise SystemExit(r.returncode)
