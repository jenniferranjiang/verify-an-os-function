#!/usr/bin/env python3
"""Hash/path consistency of the reviewed design migration; no QCP calls."""
from pathlib import Path
import json,hashlib,re
trial=Path(__file__).resolve().parents[1];root=trial.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
checks={}
pred=json.loads((trial/'checks/predicate-manifest.json').read_text())
checks['predicate_snapshot_hashes']=all(sha(trial/f)==h for f,h in pred['files'].items())
checks['predicate_revision']=hashlib.sha256(json.dumps(pred['files'],sort_keys=True,separators=(',',':')).encode()).hexdigest()==pred['revision_sha256']
checks['compiled_snapshot_hashes']=all(x['exit']==0 and x['sha256']==pred['files']['lib/'+x['module']+'.v'] for x in json.loads((trial/'checks/compile-results.json').read_text()))
migration=json.loads((trial/'checks/migration.json').read_text())
checks['global_semantics_equal_review']=all((trial/x['review_file']).read_text().replace('KEventTrial.lib.','CRTOS_Verify.lib.')==(root/x['global_file']).read_text() for x in migration['files'])
checks['global_hashes']=all(sha(root/x['global_file'])==x['global_sha256'] for x in migration['files'])
spec=json.loads((trial/'checks/spec-manifest.json').read_text())
checks['spec_snapshot_hashes']=all(sha(trial/'checks/review-inputs'/f)==h for f,h in spec.items())
checks['spec_revision']=sha(trial/'checks/spec-manifest.json')==(trial/'checks/spec-revision.txt').read_text().strip()
checks['current_specs_only_import_migration']=all((trial/'checks/review-inputs'/f).read_text().replace('KEventTrial.lib.','CRTOS_Verify.lib.')==(trial/f).read_text() for f in spec)
inputs=json.loads((trial/'checks/source-manifest.json').read_text())
checks['current_source_config_trust_reused_match_pins']=all(sha(root/f)==h for f,h in inputs.items())
checks['root_no_trial_imports']=all('KEventTrial.' not in f.read_text() for f in (root/'lib').glob('*.v'))
checks['trial_build_excludes_review_snapshots']='KEventTrial' not in (trial/'_CoqProject').read_text() and not re.search(r'^lib/.*\.v$',(trial/'_CoqProject').read_text(),re.M)
results=json.loads((trial/'checks/root-compile-results.json').read_text())
checks['root_compilation_passed']=all(x['exit']==0 and x['sha256']==sha(root/'lib'/(x['module']+'.v')) for x in results)
checks['root_includes_changed_modules']=set(migration['changed_global_modules'])<=set(x['module'] for x in results)
checks['current_interface_passed']=json.loads((trial/'checks/post-merge-interface-result.json').read_text())['exit']==0
checks['design_only_artifacts']=not (trial/'VC').exists() and not (trial/'verification_runs').exists() and not (trial/'reports').exists()
out={'checks':checks,'all_passed':all(checks.values()),'reviewed_predicate_files':len(pred['files']),'reviewed_spec_files':len(spec),'root_compiled_modules':len(results),'scope':'Design consistency only; no C implementation proof'}
(trial/'checks/migration-check.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2));raise SystemExit(0 if out['all_passed'] else 1)
