#!/usr/bin/env python3
"""Translate actual Import/Extern annotations into pure Rocq Check commands.

This is not a QCP parser run. No source/spec/lib is changed.
"""
from pathlib import Path
import argparse, hashlib, json, re, shlex, subprocess
T=Path(__file__).resolve().parent.parent
HEADERS=[T/'annotated_C/include/monad.h',T/'annotated_C/include/logic.h']
def groups(block):
    depth=0;start=None
    for i,ch in enumerate(block):
        if ch=='(':
            if depth==0:start=i+1
            depth+=1
        elif ch==')':
            depth-=1
            if depth==0:yield block[start:i]
    assert depth==0
def main():
    p=argparse.ArgumentParser();p.add_argument('--generate-only',action='store_true');a=p.parse_args()
    hashes={str(h):hashlib.sha256(h.read_bytes()).hexdigest() for h in HEADERS}
    blocks=[(h,m[1].strip()) for h in HEADERS for m in re.finditer(r'/\*@([\s\S]*?)\*/',h.read_text())]
    aliases={}
    for _,b in blocks:
        m=re.fullmatch(r'Printing Coq Name\s+(\w+)\s*:=\s*([\w.]+)',b)
        if m:aliases[m[1]]=m[2]
    def names(s):
        return re.sub(r'\b\w+\b',lambda m:aliases.get(m[0],m[0]),s)
    out=['(* Generated only from current monad.h/logic.h by checks/check_headers.py. *)']
    n=0
    for h,b in blocks:
        if b.startswith('Import Coq '):
            out.append(' '.join(b[len('Import Coq '):].split()).rstrip('.')+'.')
        elif b.startswith('Extern Coq'):
            for d in groups(b[len('Extern Coq'):]):
                if '::' in d:
                    sym,typ=d.split('::',1)
                    typ=typ.replace('=>','->').replace('*','Type')
                    polymorphic=False
                else:
                    sym,typ=d.split(':',1)
                    typ=typ.strip();params=[]
                    while typ.startswith('{'):
                        m=re.match(r'\{(\w+)\}\s*',typ)
                        assert m,(sym,typ)
                        params.append(m[1]);typ=typ[m.end():]
                    polymorphic=bool(params)
                    if params:
                        assert typ.startswith('->'),(sym,typ)
                        typ='forall '+ ' '.join('('+x+' : Type)' for x in params)+', '+typ[2:].strip()
                sym=sym.strip();typ=' '.join(names(typ).split())
                out.append('(* '+h.name+': '+sym+' *)')
                out.append('Check ('+('@' if polymorphic else '')+names(sym)+' : '+typ+').')
                n+=1
    out+=['''
(* Exact state parameters used by the outer create and return continuations. *)
Check (fun (sg : StableGlobalState) (value : Z) (before : VarGlobalState)
           (X : Z -> (VarGlobalState -> Prop) -> Prop) =>
  monadesafe_lib.safeExec (LastSeen before) (abs_semaphore_create sg value) X).
Check (fun (sg : StableGlobalState) (value : Z) (before : VarGlobalState)
           (Y : Z -> VarGlobalState -> Prop) =>
  monadesafe_lib.safeExec (ExactSeen before) (abs_semaphore_create_masked sg value) Y).
Check (fun (after : VarGlobalState) (result : Z)
           (X : Z -> (VarGlobalState -> Prop) -> Prop) =>
  monadesafe_lib.safeExec (LastSeen after) (MonadErr.ret result) X).
Check (fun (after : VarGlobalState) (result : Z)
           (Y : Z -> VarGlobalState -> Prop) =>
  monadesafe_lib.safeExec (ExactSeen after) (MonadErr.ret result) Y).
''']
    target=T/'checks/HeaderVocabularyCheck.v';target.write_text('\n'.join(out)+'\n')
    (T/'checks/header-input-hashes.json').write_text(json.dumps(hashes,indent=2)+'\n')
    print('Generated',n,'exact extern checks plus four continuation checks.',flush=True)
    if a.generate_only:return
    args=shlex.split((T/'_CoqProject').read_text())
    cmd=['coqc',*args,str(target)]
    with (T/'checks/header-typecheck.log').open('w') as log:
        log.write('INPUT HASHES '+json.dumps(hashes)+'\nCOMMAND '+shlex.join(cmd)+'\n');log.flush()
        run=subprocess.run(cmd,cwd=T,stdout=log,stderr=log)
        log.write('EXIT '+str(run.returncode)+'\n')
    print('coqc exit',run.returncode)
    raise SystemExit(run.returncode)
if __name__=='__main__':main()
