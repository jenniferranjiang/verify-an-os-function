#!/usr/bin/env python3
"""Translate current Extern declarations to explicit Rocq Check terms; no QCP execution."""
from pathlib import Path
import re,shlex,subprocess,hashlib
trial=Path(__file__).resolve().parents[1]
imports=[]
items=[]
headers=[trial/'annotated_C/include'/n for n in ['monad.h','logic.h']]
for header in headers:
 text=header.read_text()
 for statement in re.findall(r'/\*@ Import Coq\s*(.*?)\*/',text,re.S):
  imports.append(statement.strip().rstrip('.')+'.')
 for block in re.findall(r'/\*@ Extern Coq\s*(.*?)\*/',text,re.S):
  depth=0
  for i,c in enumerate(block):
   if c=='(':
    if depth==0:start=i+1
    depth+=1
   elif c==')':
    depth-=1
    if depth==0:
     item=block[start:i].strip()
     name,kind,typ=re.match(r'(\w+)\s*(::|:)\s*(.*)',item,re.S).groups()
     if kind=='::':typ=typ.replace('*','Type').replace('=>','->')
     else:
      params=re.match(r'((?:\{\w+\}\s*)+)\s*->\s*(.*)',typ,re.S)
      if params:typ='forall '+' '.join(re.findall(r'\{(\w+)\}',params[1]))+' : Type, '+params[2]
     name={'program':'MonadErr.M','return':'MonadErr.ret'}.get(name,name)
     explicit='@' if typ.startswith('forall ') or name=='MonadErr.M' else ''
     items.append(f'Check ({explicit}{name} : {typ}).')
source=trial/'checks/SpecInterfaceCheck.v'
source.write_text('(** Design-only interface Check. No VC or C proof. Generated from current headers. *)\n'+
 '\n'.join(imports)+'\n\n'+'\n'.join(items)+'''

Check (fun sg val before (X : Z -> (VarGlobalState -> Prop) -> Prop) =>
 safeExec (LastSeen before) (abs_semaphore_create sg val) X).
Check (fun sg val before (Y : Z -> VarGlobalState -> Prop) =>
 safeExec (ExactSeen before) (abs_semaphore_create_nested sg val) Y).
Check (fun (ret : Z) (P : (VarGlobalState -> Prop) -> Prop)
 (X : Z -> (VarGlobalState -> Prop) -> Prop) =>
 safeExec P (MonadErr.ret ret) X).
Check (fun (ret : Z) (P : VarGlobalState -> Prop)
 (Y : Z -> VarGlobalState -> Prop) => safeExec P (MonadErr.ret ret) Y).
''')
with (trial/'checks/spec-interface-check.log').open('w') as log:
 for header in headers:
  log.write(f'HEADER {header.relative_to(trial)} SHA256 {hashlib.sha256(header.read_bytes()).hexdigest()}\n')
 log.write(f'EXTERN declarations {len(items)}; composition checks 4\n');log.flush()
 result=subprocess.run(['coqc',*shlex.split((trial/'_CoqProject').read_text()),str(source)],cwd=trial,stdout=log,stderr=subprocess.STDOUT)
 log.write(f'EXIT {result.returncode}\n')
print(f'Extern {len(items)}, compositions 4, coqc exit {result.returncode}')
raise SystemExit(result.returncode)
