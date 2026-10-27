from pathlib import Path
import subprocess,hashlib,json
root=Path(__file__).resolve().parents[3]
out=Path(__file__).resolve().parent
base=root/'Ubiquitous/XiZi_IIoT_Macro/kernel/include'
commands=[]
for kind in ['original','adapted','slice']:
    cmd=['gcc','-m32','-std=c11','-ffreestanding','-fsyntax-only','-I',str(out)]
    if kind=='adapted': cmd+=['-I',str(out/'adapted')]
    cmd+=['-I',str(base),'-I',str(root/'Ubiquitous/XiZi_IIoT_Macro/arch/risc-v/k210'),'-I',str(root/'Ubiquitous/XiZi_IIoT_Macro/board/kd233/third_party_driver/include'),'-I',str(root/'Ubiquitous/XiZi_IIoT_Macro/board/kd233/include'),str(out/f'abi-{kind}.c')]
    p=subprocess.run(cmd,text=True,capture_output=True)
    commands.append({'kind':kind,'command':cmd,'exit_code':p.returncode,'stdout':p.stdout,'stderr':p.stderr})
(out/'abi-check-results.json').write_text(json.dumps(commands,indent=2)+'\n')
files=[out/'xsconfig.h',out/'abi-original.c',out/'abi-adapted.c',out/'abi-slice.c',root/'ksemaphoredelete-trial-261025-1/annotated_C/include/slice_types.h',out/'adapted/xs_ktask.h',root/'.agents/skills/verify-an-os-function/SKILL.md',root/'.agents/skills/verify-an-os-function/references/源代码处理.md']
(out/'adapted-analysis-sha256.json').write_text(json.dumps({str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in files},indent=2)+'\n')
assert all(c['exit_code']==0 for c in commands),commands
print('original/adapted/slice ILP32 ABI static assertions: PASS')
