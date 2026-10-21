from pathlib import Path
import json,hashlib,shlex,subprocess,difflib
T=Path(__file__).resolve().parents[1];E=T/'evidence/abi-candidate-preliminary';E.mkdir(exist_ok=True)
a=shlex.split((T/'_CoqProject.arm32le-candidate').read_text())
# The explicit candidate mapping must be the sole CRTOS_Verify.lib provider.
providers=[a[i+1] for i in range(len(a)-2) if a[i] in ['-R','-Q'] and a[i+2]=='CRTOS_Verify.lib']
assert providers==[str(T/'shared-candidate/arm32le')],providers
assert '/home/xinra/crtos/lib' not in a
assert all('/qcp-binary-democases/SeparationLogic/' not in x for x in a)
manifest=json.loads((T/'evidence/arm32le-candidate/root-source-closure.json').read_text())
completed=set(manifest['build_order'][:7]);comparisons=[]
for e in manifest['files']:
 src=Path(e['source']); candidate=T/e['candidate']
 if candidate.stem not in completed:continue
 original=src.read_bytes();copy=candidate.read_bytes()
 assert hashlib.sha256(original).hexdigest()==e['source_sha256']
 change=''.join(difflib.unified_diff(original.decode().splitlines(True),copy.decode().splitlines(True),fromfile=str(src),tofile=str(candidate)))
 (E/(candidate.stem+'.diff')).write_text(change)
 comparisons.append(dict(file=candidate.name,source_sha256=hashlib.sha256(original).hexdigest(),candidate_sha256=hashlib.sha256(copy).hexdigest(),identical=(original==copy)))
q='''Require Import Coq.ZArith.ZArith Coq.Strings.String.
Require Import CRTOS_Verify.lib.CrtosRules.
Open Scope Z_scope.
Open Scope string_scope.
Print Task_C_Rules.store_ptr.
Print Task_C_Rules.undef_store_ptr.
Print Task_C_Rules.store_uint.
Print Task_C_Rules.store_ushort.
Print Task_C_Rules.store_4byte.
Print Task_C_Rules.store_2byte.
Eval cbv in Task_C_Rules.ptr_size_Z.
Eval cbv in Task_C_Rules.ptr_align.
Eval cbv in Task_C_Rules.sizeof_front_end_type CNotation.FET_ptr.
Eval cbv in Task_C_Rules.sizeof_front_end_type CNotation.FET_int.
Eval cbv in Task_C_Rules.sizeof_front_end_type CNotation.FET_ushort.
Eval cbv in Task_C_Rules.merge_short 2 1 258.
Eval cbv in Task_C_Rules.merge_int 4 3 2 1 16909060.
Eval cbv in Task_C_Rules.sizeof_front_end_type (CNotation.FET_struct "Semaphore").
Print CNotation.eval_addr_expr.
'''
cmd=['/home/xinra/.opam/pv-bench-8.20.1/bin/coqtop','-quiet',*a]
r=subprocess.run(cmd,input=q,capture_output=True,text=True,cwd=T)
(E/'print.stdout').write_text(r.stdout);(E/'print.stderr').write_text(r.stderr)
result={'status':'preliminary-read-only-check; not formal predicate review-passed','completed_subset':comparisons,'command':cmd,'stdin':q,'exit_code':r.returncode,'has_coq_error':'Error:' in r.stderr,'sole_root_logical_provider':providers}
(E/'result.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'source_comparisons':comparisons,'exit_code':r.returncode,'has_coq_error':'Error:' in r.stderr},indent=2))
