#!/usr/bin/python3.12
import hashlib,json,subprocess,sys,time,re
from pathlib import Path
R=Path(__file__).resolve().parents[1];E=R/'evidence/final-integrity';B=E/'proof-closure'
sys.path.insert(0,str(R/'tools/qcp-controller/scripts/vc-proving'))
from proof_manual_utils import parse_manual
cl=json.loads((E/'closure-audit.json').read_text());names=[];imports=[]
for x in cl['functions']:
 module=x['function']+'_proof_manual';imports.append(module)
 m=parse_manual((B/'VC'/ (module+'.v')).read_text())
 names.extend(module+'.'+n for n in m.vc_index['top_level'])
source='From CRTOS_Verify.VC Require Import '+' '.join(imports)+'.\n'+'\n'.join('Print Assumptions '+n+'.' for n in names)+'\n'
p=E/'assumptions.v';p.write_text(source)
ch=json.loads((E/'coqchk-command.json').read_text())['argv'];args=ch[3:-len(cl['coqchk_roots'])]
cmd=['/home/xinra/.opam/pv-bench-8.20.1/bin/coqc','-q',*args,str(p)]
t=time.monotonic()
with (E/'assumptions.stdout.log').open('w') as out,(E/'assumptions.stderr.log').open('w') as err:r=subprocess.run(cmd,cwd=E,stdout=out,stderr=err,timeout=900)
text=(E/'assumptions.stdout.log').read_text()
# Actual concrete proof dependencies must not contain a trial axiom or any
# generated witness assumption. Module-type interfaces are not concrete proofs.
names_used=sorted(set(re.findall(r'^([A-Za-z_][A-Za-z0-9_.\']*)\s*:',text,re.M))-{'Axioms'})
framework=Path('/home/xinra/qcp-binary-democases/Rocq/SeparationLogic/CNotation.v').read_text()
framework_names=set(re.findall(r'\b(?:Axiom|Parameter)\s+(\w+)\s*:',framework))
inherited_admissions=['rvalue_expr_equiv_refl','rvalue_expr_equiv_sym','rvalue_expr_equiv_trans']
for n in inherited_admissions:
 assert re.search(r'Theorem '+n+r':[^.]*\.\s*Proof\.\s*Admitted\.',framework)
framework_names.update(inherited_admissions)
allowed={'CNotation.'+n for n in framework_names}|{
 'FunctionalExtensionality.functional_extensionality_dep',
 'PropExtensionality.propositional_extensionality',
 'CrtosOSProtocol.Crtos_C_Rules.addr_of_arrow_field',
 'CrtosOSProtocol.Crtos_C_Rules.eval_addr'}
forbidden=sorted(set(names_used)-allowed)
result={'status':'passed' if r.returncode==0 and not forbidden else 'failed','exit_code':r.returncode,'parent_proofs_queried':len(names),'trial_or_witness_assumption_lines':forbidden,'unique_existing_assumptions':names_used,'elapsed_seconds':time.monotonic()-t,'command':cmd,'stdout_sha256':hashlib.sha256(text.encode()).hexdigest(),'note':'Print Assumptions on every concrete parent proof using the exact normalized final closure; existing external framework and standard-library assumptions are retained. The two Crtos_C_Rules names are inherited through official DerivedPredSig -> CNotationSig; their declarations are CNotation.v:524 and :553, not new trial axioms.'}
(E/'assumptions-result.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='command'},indent=2));assert result['status']=='passed'
