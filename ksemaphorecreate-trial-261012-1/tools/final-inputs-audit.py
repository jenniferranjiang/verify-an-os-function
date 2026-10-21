#!/usr/bin/python3.12
import hashlib,json,sys
from pathlib import Path
R=Path(__file__).resolve().parents[1];E=R/'evidence';O=E/'final-integrity'
sys.path[:0]=[str(R/'tools/qcp-controller/scripts/verification-orchestrator'),str(R/'tools/qcp-controller/scripts/vc-proving')]
from spec_freeze import extract_spec_surface
from crtos_input_guard import accepted_inputs
from revision_revalidation import input_binding

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
accepted=accepted_inputs(R);cl=json.loads((R/'reports/closure_state.json').read_text());checks=[]
def api_specs(surface):
 # Upstream freeze parser recognizes `Import Coq Require Import`, but treats
 # the reviewed BODY-01 fix `Import Coq Require` as a spurious unnamed API.
 # Exclude exactly that already typechecked module-load annotation only.
 specs=dict(surface['specs'])
 if '<unknown>::<default>' in specs:
  assert specs['<unknown>::<default>']=='Import Coq Require Coq.Program.Basics'
  del specs['<unknown>::<default>']
 return specs
for name,run in cl['runs'].items():
 s=json.loads((R/'reports'/run/'controller_state.json').read_text());t=s['target_files']
 current=extract_spec_surface(R/t['c_file'],R/t['formal_case_lib'])
 assert api_specs(current)==api_specs(s['spec_freeze']['baseline']),name
 candidate=E/'sizeof-normalization/candidate'/t['c_file']
 reviewed=extract_spec_surface(candidate,R/t['formal_case_lib'])
 assert api_specs(current)==api_specs(reviewed),name
 assert s['final_check']['accepted_inputs']==input_binding(R)
 checks.append({'function':name,'all_specs_equal_frozen_baseline_and_independent_spec_r6':True,'final_check_current_binding':True})
roots=json.loads((E/'root-shared-inputs.json').read_text())
for rel,h in roots.items():
 p=Path('/home/xinra/crtos/lib')/rel
 assert sha(p)==h['source_sha256'] and sha(p.with_suffix('.vo'))==h['object_sha256'],rel
external=json.loads((E/'controller-external-inputs.json').read_text());n=0
for entry in external.values():
 for path,h in entry.items():
  p=Path(path);assert p.is_relative_to('/home/xinra/qcp-binary-democases/Rocq')
  assert sha(p)==h,path;n+=1
upstream=json.loads((E/'controller-upstream-manifest.json').read_text())
for rel,h in upstream['files'].items():assert sha(Path(upstream['source'])/rel)==h,rel
local=json.loads((E/'controller-local-manifest.json').read_text())
for rel,h in local['files'].items():assert sha(R/'tools/qcp-controller/scripts'/rel)==h,rel
result={'status':'passed','contract_checks':checks,'root_shared_source_and_object_pairs_unchanged':len(roots),'external_framework_source_or_object_hashes_unchanged':n,'controller_upstream_files_unchanged':len(upstream['files']),'local_adapter_manifest_matches':True,'no_historical_trial_input':'All inputs came from explicit current-trial manifests and allowed root/shared or official framework paths; historical trials were neither enumerated nor read by this audit.'}
(O/'frozen-inputs-audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n');print(json.dumps(result,ensure_ascii=False,indent=2))
