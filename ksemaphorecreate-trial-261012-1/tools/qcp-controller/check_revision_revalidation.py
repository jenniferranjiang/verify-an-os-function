#!/usr/bin/python3.12
"""Regression checks of revision invalidation; no proof acceptance or real state edit."""
import copy,json,sys,tempfile
from pathlib import Path
from unittest.mock import patch
root=Path(__file__).resolve().parents[2]
base=root/'tools/qcp-controller/scripts'
sys.path[:0]=[str(base/'verification-orchestrator'),str(base/'vc-proving')]
import revision_revalidation as rev
import controller_rounds as rounds
import controller_state as states
from crtos_input_guard import accepted_inputs
state=json.loads((root/'reports/CriticalAreaLock-20261012130948/controller_state.json').read_text())
checks=[]
try:
    accepted_inputs(root)
except ValueError as exc:
    assert 'invalidated' in str(exc)
    checks.append('actual invalidated inputs refuse proof acceptance')
else:
    checks.append('actual accepted input guard passed')
binding={'source_manifest':'source','predicate_manifest':'new','spec_manifest':'spec','coqproject_sha256':'paths'}
with patch.object(rev,'input_binding',return_value=binding):
    assert rounds.derive_actions(state)[0]['action']=='revalidate-revision'
    checks.append('legacy done result requires revalidation')
    matching=copy.deepcopy(state);matching['final_check']['accepted_inputs']=binding
    assert rounds.derive_actions(matching)==[]
    checks.append('current bound result does not recheck needlessly')
    paused=copy.deepcopy(state);paused['run_control']['status']='paused'
    assert rounds.derive_actions(paused)==[]
    checks.append('paused run is not resumed')
    with tempfile.TemporaryDirectory(dir=root/'evidence',prefix='revalidation-test-') as folder:
        test=copy.deepcopy(state);test['main_root']=folder;test['report_root']=folder+'/report';test['run_root']=folder+'/run'
        report=Path(test['report_root']);(report/'final-check').mkdir(parents=True)
        (report/'final-check'/'sentinel').write_text('original evidence')
        saved=[]
        with patch.object(states,'load_run',return_value=test),patch.object(states,'_save_state',side_effect=lambda _,s:saved.append(copy.deepcopy(s))),patch.object(states,'_append_event'):
            rev.revalidate_revision(None)
        assert saved[0]['phase']=='final-check' and saved[0]['final_check'] is None
        assert saved[0]['attempts']==state['attempts'] and saved[0]['final_candidate']==state['final_candidate']
        history=report/'revision-history'/str(state['generation'])
        assert (history/'final-check'/'sentinel').read_text()=='original evidence'
        assert json.loads((history/'controller_state.json').read_text())['final_check']['status']=='passed'
        assert rounds.derive_actions(saved[0])[0]['action']=='final-check'
        checks.append('archives prior result and queues original check without accepting proofs or changing owners')
result={'status':'passed','checks':checks,'actual_run_state_modified':False,'c_vcs_proved':False}
(root/'evidence/controller-revalidation-check.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
