"""Generate Rocq Check commands for the annotated C Extern Coq vocabulary.
This checks exported symbol types, not C implementation or generated VCs.
"""
from pathlib import Path
import re

t = Path(__file__).resolve().parents[1]
header = (t/'annotated_C/logic.h').read_text()
entries = []
for block in re.findall(r'/\*@ Extern Coq(.*?)\*/', header, re.S):
    depth, start = 0, 0
    for i, c in enumerate(block):
        if c == '(':
            if depth == 0:
                start = i+1
            depth += 1
        elif c == ')':
            depth -= 1
            if depth == 0:
                entries.append(block[start:i].strip())
mapping = dict(re.findall(r'Printing Coq Name (\w+)\s*:=\s*([\w.]+)', header))
lines = ['(* Typechecking of declared vocabulary only. No function contracts or proofs. *)',
         'Require Import Coq.ZArith.ZArith.',
         'Require Import KSemaphoreCreateTrial.KSemaphoreCreate.',
         'Require Import TrialShared.CrtosInv TrialShared.SemaphoreInv.',
         'From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.',
         'Import IDNode DLL.']
for entry in entries:
    if '::' in entry:
        name, ty = entry.split('::', 1)
        ty = ty.replace('*', 'Type').replace('=>', '->')
    else:
        name, ty = entry.split(':', 1)
        binders = []
        while re.match(r'\s*\{(\w+)\}', ty):
            m = re.match(r'\s*\{(\w+)\}', ty)
            binders.append(m[1])
            ty = ty[m.end():]
        if binders:
            ty = re.sub(r'^\s*->', '', ty)
            ty = 'forall ('+' '.join(binders)+' : Type), '+ty
    name = mapping.get(name.strip(), name.strip())
    ty = re.sub(r'\bprogram\b', 'MonadErr.M', ty)
    # Explicit @ makes polymorphic arguments part of the checked signature.
    lines.append(f'Check (@{name} : {ty.strip()}).')
(t/'checks/SpecVocabulary.v').write_text('\n'.join(lines)+'\n')
print(f'Generated {len(entries)} formal vocabulary type checks.')
