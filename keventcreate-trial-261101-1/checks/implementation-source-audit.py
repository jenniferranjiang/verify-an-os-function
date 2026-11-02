#!/usr/bin/env python3
"""Post-proof provenance/source audit; proof completion comes from controller final-check."""
from pathlib import Path
import hashlib,json,subprocess,sys
trial=Path(__file__).resolve().parents[1];root=trial.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
inputs=json.loads((trial/'checks/implementation-inputs.json').read_text());checks={}
checks['frozen_shared_definitions_unchanged']=all(sha(root/f)==h for f,h in inputs['global_lib_hashes'].items())
checks['authoritative_sources_config_and_trust_unchanged']=all(sha(root/f)==h for f,h in inputs['source_manifest'].items())
abi=json.loads((trial/'checks/event-layout-migration.json').read_text())
checks['new_abi_matches_independent_review']=sha(root/abi['global_file'])==abi['sha256']
checks['trial_repair_unchanged']=sha(trial/inputs['trial_fix']['trial_fix'])==inputs['trial_fix']['trial_fix_sha256']
spec_manifest=json.loads((trial/'checks/spec-manifest.json').read_text())
checks['reviewed_header_interfaces_unchanged']=all((trial/f).read_text()==(trial/'checks/review-inputs'/f).read_text().replace('KEventTrial.lib.','CRTOS_Verify.lib.') for f in spec_manifest if f.endswith('.h'))
check=subprocess.run([sys.executable,str(trial/'checks/compare-inputs.py')],cwd=root,text=True,capture_output=True)
checks['create_bodies_and_caller_contracts_match']=check.returncode==0
results={}
for symbol,run in [('_EventCreate','EventCreate-20261101232623'),('KEventCreate','KEventCreate-20261101232854')]:
 state=json.loads((trial/'reports'/run/'controller_state.json').read_text())
 final=state.get('final_check',{})
 checks[symbol+'_controller_done']=state.get('phase')=='done' and final.get('status')=='passed' and final.get('errors')==[]
 group_round=state['current']['vc-proving'];plan=json.loads((trial/'reports'/run/'rounds'/state['current']['vc-checking']/'group_plan.json').read_text())
 targets=state['target_files'];proof=targets['proof_manual_file'];lib=targets['formal_case_lib']
 results[symbol]={'run':run,'phase':state['phase'],'final_check':final,'proof_manual':proof,'proof_sha256':sha(trial/proof),'case_library':lib,'case_library_sha256':sha(trial/lib),'top_level_vcs':sum(len(g['witnesses']) for g in plan['groups']),'group_count':len(plan['groups'])}
out={'checks':checks,'all_passed':all(checks.values()),'targets':results,'predicate_revision':inputs['predicate_revision'],'spec_revision':inputs['spec_revision'],'new_trusted_abi_symbols':abi['trusted_abi_symbols'],'abi_evidence':'checks/event-layout-migration.json','trial_only_repair':'source_fixes/_EventProcess.c','scope':'Two Create bodies under reviewed model/TrustBase and recorded environment; not an Event module or repaired Process proof.'}
(trial/'checks/implementation-result.json').write_text(json.dumps(out,ensure_ascii=False,indent=2)+'\n');print(json.dumps(out,ensure_ascii=False,indent=2));raise SystemExit(0 if out['all_passed'] else 1)
