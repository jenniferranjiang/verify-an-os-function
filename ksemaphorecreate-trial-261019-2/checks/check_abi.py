#!/usr/bin/env python3
"""GCC ILP32 compilation evidence; does not claim ARM object-code equivalence."""
import pathlib, re, subprocess
T = pathlib.Path(__file__).resolve().parent.parent
R = pathlib.Path('/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro')
out = T/'checks/abi'
out.mkdir(exist_ok=True)
config = (R/'board/stm32f103-nano/config').read_text()
defines = []
for line in config.splitlines():
    m = re.fullmatch(r'CONFIG_(\w+)=(.*)', line)
    if m:
        defines.append('#define '+m[1]+' '+('1' if m[2] == 'y' else m[2]))
(out/'xsconfig.h').write_text('/* Generated solely from board config by check_abi.py. */\n'+'\n'.join(defines)+'\n')
cmds = []
for name in ['abi_original', 'abi_slice']:
    cmds.append(['gcc', '-m32', '-std=c11', '-ffreestanding', '-Wall', '-Werror', '-I'+str(out), '-I'+str(R/'kernel/include'), '-c', str(T/'checks'/f'{name}.c'), '-o', str(out/f'{name}.o')])
for p in sorted((T/'annotated_C/src').glob('*.c')):
    cmds.append(['gcc', '-m32', '-std=c11', '-ffreestanding', '-Wall', '-Werror', '-fsyntax-only', str(p)])
log = [subprocess.check_output(['gcc','--version'], text=True), 'Target evidence: GCC -m32 ILP32; no installed ARM cross compiler was located on PATH.']
for cmd in cmds:
    run = subprocess.run(cmd, text=True, capture_output=True)
    log.extend(['COMMAND: '+' '.join(cmd), run.stdout, run.stderr, 'EXIT: '+str(run.returncode)])
    if run.returncode:
        (T/'checks/abi-compile.txt').write_text('\n'.join(log))
        raise SystemExit(run.returncode)
log.append('PASS: original-header ABI, slice ABI, all nine C slices.')
(T/'checks/abi-compile.txt').write_text('\n'.join(log))
print(log[-1])
