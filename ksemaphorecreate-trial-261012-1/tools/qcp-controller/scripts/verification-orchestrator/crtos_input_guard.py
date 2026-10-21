"""Keep accepted shared predicates/headers frozen across per-function runs."""
from pathlib import Path
import json,hashlib
from path_utils import fixed_path_under


def accepted_inputs(root):
    def read(relative):
        path=fixed_path_under(root/relative,root,label='accepted input')
        return path, path.read_bytes()
    _,raw=read('evidence/accepted-revisions.json')
    accepted=json.loads(raw)
    if accepted.get('predicate_status')!='review-passed' or accepted.get('spec_status')!='review-passed':
        raise ValueError('accepted formal revision is invalidated or awaiting independent review')
    if accepted.get('coqproject_sha256'):
        _,config=read('_CoqProject')
        if hashlib.sha256(config).hexdigest()!=accepted['coqproject_sha256']:
            raise ValueError('active load paths differ from independently accepted ABI configuration')
    for name,key in (('predicate-manifest.json','predicate_manifest'),('spec-annotated-manifest.json','spec_manifest')):
        _,blob=read('evidence/'+name)
        data=json.loads(blob)
        digest_bytes = blob if key=='predicate_manifest' else json.dumps(data,sort_keys=True,separators=(',',':')).encode()
        if hashlib.sha256(digest_bytes).hexdigest()!=accepted[key]:
            raise ValueError('formal manifest is not the accepted revision: '+name)
        data=json.loads(blob)
        entries=data['files'] if key=='predicate_manifest' else [{'path':path,'sha256':digest} for path,digest in data.items() if path.startswith('annotated_C/include/')]
        for entry in entries:
            _,content=read(entry['path'])
            if hashlib.sha256(content).hexdigest()!=entry['sha256']:
                raise ValueError('unreviewed shared formal input change: '+entry['path'])
    return accepted


def recovery_evidence(state):
    """Only independently reviewed fixes can re-enable a blocked owner."""
    if state['phase']!='annotation':
        return None
    identifier=state['current']['annotation']
    attempt=state['attempts'][identifier]
    blocker=attempt.get('blocker',{})
    if attempt['status']!='blocked' or blocker.get('failure_class')!='infrastructure':
        return None
    root=Path(state['main_root'])
    file=fixed_path_under(root/'evidence/controller-infrastructure-repairs.json',root,label='infrastructure repair evidence')
    if not file.exists():
        return None
    records=json.loads(file.read_text())
    matching=[record for record in records if record['run']==state['run_id'] and record['attempt']==identifier
              and record['blocker_kind']==blocker.get('kind') and record.get('repair_index')==attempt.get('repair_index',0)
              and record['status']=='review-passed']
    if not matching:
        return None
    record=matching[-1]
    accepted=accepted_inputs(root)
    if record['accepted_spec_manifest']!=accepted['spec_manifest'] or record['accepted_predicate_manifest']!=accepted['predicate_manifest']:
        return None
    report=fixed_path_under(root/record['review'],root,label='independent repair review')
    if hashlib.sha256(report.read_bytes()).hexdigest()!=record['review_sha256']:
        raise ValueError('repair review hash changed')
    if record['author']==record['reviewer']:
        raise ValueError('repair author cannot be its independent reviewer')
    return record


def recover_infrastructure(args):
    """Return the stopped annotation owner to the original repair lifecycle."""
    from controller_state import load_run
    from controller_rounds import require_action
    from controller_attempts import _repair
    state=load_run(args)
    require_action(state,'recover-infrastructure')
    record=recovery_evidence(state)
    if record is None:
        raise SystemExit('reviewed repair evidence is missing or stale')
    attempt=state['attempts'][state['current']['annotation']]
    state['current_blockers']=[]
    return _repair(state,attempt,attempt,None,[
        'Reviewed shared-input infrastructure repair: '+record['review']+'. '+record['summary']+
        ' Repeat the original development checks; no generated VC/proof or acceptance is assumed.'
    ])
