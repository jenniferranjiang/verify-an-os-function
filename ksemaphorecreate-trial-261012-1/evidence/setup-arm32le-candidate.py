from pathlib import Path
import json,re,hashlib,shutil,shlex,subprocess
T=Path(__file__).resolve().parents[1]; R=Path('/home/xinra/crtos/lib')
E=T/'evidence/arm32le-candidate'; E.mkdir(exist_ok=True)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
m=json.loads((T/'evidence/predicate-manifest.json').read_text())
snap=E/'pre-migration'; snap.mkdir(exist_ok=True)
for rel in [x['path'] for x in m['files']]+['evidence/accepted-revisions.json','evidence/predicate-manifest.json','evidence/predicate-build.json','evidence/annotated-manifest.json','_CoqProject']:
 p=T/rel
 if p.exists():
  d=snap/rel;d.parent.mkdir(parents=True,exist_ok=True)
  if not d.exists():shutil.copy2(p,d)
for item in m['files']:
 p=T/item['path']
 for ext in ['.vo','.vos','.vok','.glob']:
  x=p.with_suffix(ext)
  if x.exists():
   d=snap/x.relative_to(T);d.parent.mkdir(parents=True,exist_ok=True)
   if not d.exists():shutil.copy2(x,d)
   x.unlink()
# Keep the unaccepted helper entirely outside the active formal directory.
for ext in ['.v','.vo','.vos','.vok','.glob']:
 p=T/'lib'/('SemaphoreCriticalViews'+ext)
 if p.exists():
  d=E/'nest-view-draft'/p.name;d.parent.mkdir(exist_ok=True)
  if d.exists():raise RuntimeError('draft destination already exists')
  shutil.move(p,d)
def refs(s):
 while True:
  n=re.sub(r'\(\*(?:(?!\(\*|\*\)).)*\*\)','',s,flags=re.S)
  if n==s:break
  s=n
 return set(re.findall(r'CRTOS_Verify\.lib\.([A-Za-z_0-9]+)',s))
seen=set();order=[]
def visit(n):
 if n in seen:return
 seen.add(n);p=R/(n+'.v')
 for dep in sorted(refs(p.read_text())):visit(dep)
 order.append(n)
for item in m['files']:
 for n in sorted(refs((T/item['path']).read_text())):visit(n)
candidate=T/'shared-candidate/arm32le';candidate.mkdir(parents=True,exist_ok=True)
entries=[]
for n in order:
 p=R/(n+'.v');d=candidate/p.name
 if d.exists():raise RuntimeError('candidate source already exists')
 shutil.copy2(p,d);entries.append({'source':str(p),'source_sha256':sha(p),'candidate':str(d.relative_to(T))})
(E/'root-source-closure.json').write_text(json.dumps({'format':'explicit-root-source-closure-v1','build_order':order,'files':entries},indent=2)+'\n')
a=next(x['command'][2:] for x in json.loads((T/'evidence/abi-supplement/result.json').read_text())['commands'] if x['label']=='modern-little-endian-load')
assert len(a)%3==0
args=a+['-R',str(candidate),'CRTOS_Verify.lib','-R',str(T/'lib'),'CRTOS_Verify.sem','-R',str(T/'VC'),'CRTOS_Verify.VC']
(T/'_CoqProject.arm32le-candidate').write_text('\n'.join(' '.join(shlex.quote(x) for x in args[i:i+3]) for i in range(0,len(args),3))+'\n')
probe=E/'ModernEndianToolchain.v';probe.write_text('From SimpleC.SL Require Import SeparationLogic.\nLocal Open Scope Z_scope.\nExample pointer_width : Snaive_C_Rules.ptr_size_Z = 4. Proof. reflexivity. Qed.\nExample endian : Snaive_C_Rules.merge_short 1 0 1. Proof. reflexivity. Qed.\n')
results=[]
for name in ['default','pv-bench-8.20.1']:
 cmd=[f'/home/xinra/.opam/{name}/bin/coqc',*a,str(probe)]
 p=subprocess.run(cmd,capture_output=True,text=True,timeout=60)
 results.append({'command':cmd,'exit_code':p.returncode,'stdout':p.stdout,'stderr':p.stderr})
(E/'toolchain-probes.json').write_text(json.dumps(results,indent=2)+'\n')
print('closure',order);print('probes',[(x['command'][0],x['exit_code']) for x in results])
