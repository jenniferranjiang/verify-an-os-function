#!/usr/bin/python3.12
"""Audit completed controller closure and check its exact normalized proof objects."""
import collections, hashlib, json, os, re, shlex, shutil, subprocess, sys, time
from pathlib import Path
R=Path(__file__).resolve().parents[1]
E=R/'evidence/final-integrity'; E.mkdir(exist_ok=True)
B=E/'proof-closure'; B.mkdir(exist_ok=True)
sys.path[:0]=[str(R/'tools/qcp-controller/scripts/verification-orchestrator'),str(R/'tools/qcp-controller/scripts/vc-proving')]
from crtos_input_guard import accepted_inputs
from revision_revalidation import input_binding
from controller_state import _current_files_errors
from proof_manual_utils import parse_manual, strip_coq_comments, mask_coq_strings

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,x):p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n')
def code(p):return mask_coq_strings(strip_coq_comments(p.read_text()))
accepted=accepted_inputs(R); binding=input_binding(R)
closure=json.loads((R/'reports/closure_state.json').read_text())
assert len(closure['runs'])==9 and len(closure['trusted'])==6
assert set(closure['trusted'])==set(accepted['trusted'])
project=shlex.split((R/'_CoqProject').read_text()); assert len(project)%3==0
mappings=[]; args=[]
for i in range(0,len(project),3):
 flag,path,logical=project[i:i+3]; p=Path(path)
 assert flag in ['-R','-Q']
 assert p.is_relative_to(R) or p.is_relative_to(Path('/home/xinra/qcp-binary-democases/Rocq'))
 mappings.append((p,logical))
 if p.is_relative_to(R):p=B/p.relative_to(R);p.mkdir(parents=True,exist_ok=True)
 args += [flag,str(p),logical]
(B/'_CoqProject').write_text('\n'.join(shlex.join(args[i:i+3]) for i in range(0,len(args),3))+'\n')
files=[];roots=[];trust=[];counts=[]
def stage(src,relative):
 dst=B/relative;dst.parent.mkdir(parents=True,exist_ok=True)
 assert not src.is_symlink() and src.is_file()
 shutil.copyfile(src,dst)
 vo=src.with_suffix('.vo'); assert vo.is_file() and not vo.is_symlink()
 shutil.copyfile(vo,dst.with_suffix('.vo'))
 files.append({'path':relative.as_posix(),'source':str(src),'v_sha256':sha(dst),'vo_sha256':sha(dst.with_suffix('.vo'))})
 return dst
formal=json.loads((R/'evidence/predicate-manifest.json').read_text())['files']
for f in formal:
 rel=Path(f['path']);src=R/rel;assert sha(src)==f['sha256'];dst=stage(src,rel)
 tokens=re.findall(r'\b(?:Axiom|Parameter|Admitted|admit|Conjecture|Abort)\b',code(dst))
 if tokens:
  assert f['path']=='framework-candidate/NestedCriticalSTS.v' and tokens==['Parameter']
  assert re.search(r'Module Type nested_critical_STS_def\.\s*Parameter nc_sts : critical_STS\.\s*End nested_critical_STS_def\.',code(dst))
  trust.append({'file':f['path'],'classification':'unchanged official Module Type parameter, instantiated by concrete protocol','tokens':tokens})
 for p,logical in mappings:
  if src.is_relative_to(p):roots.append(logical+'.'+src.relative_to(p).with_suffix('').as_posix().replace('/','.'));break
for name,run in closure['runs'].items():
 state=json.loads((R/'reports'/run/'controller_state.json').read_text())
 assert state['phase']=='done' and state['final_check']['status']=='passed'
 assert state['final_check']['accepted_inputs']==binding
 assert not _current_files_errors(state)
 srcroot=R/'verification_runs'/run/'_coq_builds/final-check/src'
 family={}
 for key in ['goal_file','proof_auto_file','proof_manual_file','goal_check_file']:
  rel=Path(state['target_files'][key]);src=srcroot/rel
  if key!='proof_auto_file':assert src.read_bytes()==(R/rel).read_bytes(),(name,key,'canonical drift')
  family[key]=stage(src,rel)
 manual=parse_manual(family['proof_manual_file'].read_text()); top=manual.vc_index['top_level']
 split=[n for n,v in manual.vc_index['by_name'].items() if v['parent']]
 aborts=[]
 for lemma in manual.lemmas:
  text=mask_coq_strings(strip_coq_comments(lemma['block']))
  assert not re.search(r'\b(?:Axiom|Parameter|Admitted|admit|Conjecture)\b',text)
  if re.search(r'\bAbort\.',text):
   assert lemma['name'] in split
   aborts.append(lemma['name'])
  else:assert re.search(r'\bQed\.',text),(name,lemma['name'])
 assert not re.search(r'\b(?:Axiom|Parameter|Admitted|admit|Conjecture)\b',code(family['proof_manual_file']))
 assert not re.search(r'\b(?:Axiom|Parameter|Admitted|admit|Conjecture|Abort)\b',code(family['proof_auto_file']))
 goal=code(family['goal_file']);interface=goal.split('Module Type VC_Correct.',1)[1].split('End VC_Correct.',1)[0]
 axioms=re.findall(r'\bAxiom\s+(\w+)\s*:',goal)
 assert set(axioms)==set(top) and len(axioms)==len(top)
 assert len(re.findall(r'\bAxiom\b',interface))==len(axioms)
 assert not re.search(r'\b(?:Parameter|Admitted|admit|Conjecture|Abort)\b',goal)
 rawauto=parse_manual((R/state['target_files']['proof_auto_file']).read_text())
 promoted=len(rawauto.vc_index['top_level']); assert set(rawauto.vc_index['top_level'])<=set(top)
 proving=state['attempts'][state['current']['vc-proving']]
 check=state['attempts'][proving['source_vc_checking']]
 plan=json.loads((R/'reports'/run/'rounds'/check['attempt_id']/'group_plan.json').read_text())
 witnesses=[w for g in plan['groups'] for w in g['witnesses']]
 assert {w['name'] for w in witnesses}==set(top) and len(witnesses)==len(top)
 modes={w['name']:w['proof_mode'] for w in witnesses}
 for n in aborts:assert modes[manual.vc_index['by_name'][n]['parent']]=='LLM_pre_process'
 counts.append({'function':name,'run':run,'parents':len(top),'promoted_auto_placeholders':promoted,'original_manual_obligations':len(top)-promoted,'final_manual_parent_Qed':len(top),'final_auto_Qed':0,'split_definitions':len(split),'split_Qed':len(split)-len(aborts),'unused_split_Abort':aborts,'proof_modes':dict(collections.Counter(modes.values())),'final_check':state['final_check']})
 trust.append({'file':state['target_files']['goal_file'],'classification':'generated Module Type VC_Correct interface, discharged by compiled goal_check','axiom_count':len(axioms)})
 roots.append('CRTOS_Verify.VC.'+name+'_goal_check')
assert len(formal)==21 and len(files)==57
save(E/'closure-audit.json',{'status':'passed','accepted_inputs':binding,'trusted':closure['trusted'],'formal_sources':21,'normalized_local_modules':57,'functions':counts,'total_parents':sum(x['parents'] for x in counts),'total_promoted_auto':sum(x['promoted_auto_placeholders'] for x in counts),'total_original_manual':sum(x['original_manual_obligations'] for x in counts),'total_splits':sum(x['split_definitions'] for x in counts),'files':files,'trust_interfaces':trust,'coqchk_roots':roots,'note':'Raw canonical auto placeholders remain provenance only; copied compiled auto files contain no admissions. No historical trial path was enumerated or read.'})
C=E/'c-source';C.mkdir(exist_ok=True)
probe=(R/'evidence/spec-layout-check.c').read_text().replace('../annotated_C/include/crtos_semaphore_layout.h',str(R/'annotated_C/include/crtos_semaphore_layout.h'))
(C/'spec-layout-check.c').write_text(probe)
env=os.environ.copy();env['SPEC_OUTPUT_DIR']=str(C)
t=time.monotonic();p=subprocess.run(['/usr/bin/python3.12',str(R/'evidence/spec-check.py')],cwd=R,env=env,capture_output=True,text=True)
(C/'stdout.log').write_text(p.stdout);(C/'stderr.log').write_text(p.stderr)
save(C/'invocation.json',{'exit_code':p.returncode,'elapsed_seconds':time.monotonic()-t,'probe_only_change':'absolute include of exact active frozen layout header','accepted_semantic_revision':accepted['spec_revision'],'note':'Final mechanical audit of body annotations, not a new semantic spec revision or review.'})
assert p.returncode==0,p.stderr
save(E/'checkpoint.json',{'status':'whole-closure source/trust/binding checks passed; full coqchk pending'})
print('Whole-closure source/trust/binding checks passed; starting complete recursive coqchk',flush=True)
command=['/home/xinra/.opam/pv-bench-8.20.1/bin/coqchk','-silent','-o',*args,*roots]
save(E/'coqchk-command.json',{'argv':command,'cwd':str(B),'recursive':True,'admit_or_norec':False})
t=time.monotonic()
with (E/'coqchk.stdout.log').open('w') as out,(E/'coqchk.stderr.log').open('w') as err:
 p=subprocess.run(command,cwd=B,stdout=out,stderr=err,timeout=3600)
for f in files:
 assert sha(B/f['path'])==f['v_sha256'] and sha((B/f['path']).with_suffix('.vo'))==f['vo_sha256']
assert input_binding(R)==binding
result={'status':'passed' if p.returncode==0 else 'failed','exit_code':p.returncode,'elapsed_seconds':time.monotonic()-t,'explicit_roots':len(roots),'local_modules':len(files),'recursive':True,'admit_or_norec':False,'stdout_sha256':sha(E/'coqchk.stdout.log'),'stderr_sha256':sha(E/'coqchk.stderr.log')}
save(E/'coqchk-result.json',result);print(json.dumps(result),flush=True)
assert p.returncode==0
save(E/'checkpoint.json',{'status':'passed','whole_closure_source_trust_binding':True,'complete_recursive_coqchk':True})
