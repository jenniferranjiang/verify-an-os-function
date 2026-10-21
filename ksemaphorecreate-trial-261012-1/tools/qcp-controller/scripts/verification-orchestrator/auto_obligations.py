"""Preserve every generated auto witness as an explicit proof-owner obligation.

The bundled driver emits admissions in *_proof_auto.v. Keep that raw artifact,
but copy its exact witness blocks into the manual proof worklist. The upstream
stager removes auto/manual overlaps, so a compiled parent uses proved manual
witnesses rather than the raw automatic placeholders. No goal definition changes.
"""
import hashlib
import json
import re
from pathlib import Path
from types import SimpleNamespace
from path_utils import fixed_path_under, write_bytes, write_text, write_json
from proof_manual_utils import parse_manual, lemma_proof_parts, coq_token_text


def merged_manual(auto_text, manual_text, auto_module=None):
    auto = parse_manual(auto_text)
    if not auto.lemmas:
        return manual_text, []
    manual = parse_manual(manual_text) if manual_text is not None else None
    manual_prelude = manual.prelude if manual else ''
    if auto_module is not None:
        theory, stem = auto_module
        # The generator's manual imports auto. Keep that import in the real
        # manual; ignore only this exact dependency when comparing environments.
        pattern = r'^\s*(?:From '+re.escape(theory)+r' Require Import '+re.escape(stem)+r'|Require Import '+re.escape(theory+'.'+stem)+r')\.\s*$'
        manual_prelude = re.sub(pattern, '', manual_prelude, flags=re.M)
    if manual and coq_token_text(manual_prelude) != coq_token_text(auto.prelude):
        raise ValueError('auto/manual proof preludes differ; cannot safely share their witness environment')
    added=[]
    for lemma in auto.lemmas:
        name=lemma['name']
        if manual and name in manual.by_name:
            if coq_token_text(lemma_proof_parts(lemma)[0]) != coq_token_text(lemma_proof_parts(manual.by_name[name])[0]):
                raise ValueError('auto/manual witness statements disagree: '+name)
        else:
            added.append(lemma)
    result=(manual_text if manual_text is not None else auto.prelude).rstrip()+'\n\n'
    result+='\n'.join(lemma['block'] for lemma in added)
    parsed=parse_manual(result)
    expected=set(auto.by_name) | (set(manual.by_name) if manual else set())
    if set(parsed.by_name)!=expected:
        raise ValueError('proof worklist does not exactly cover generated witnesses')
    return result, [lemma['name'] for lemma in added]


def complete_generated_worklist(root, output, target):
    roles=('goal_file','proof_auto_file','proof_manual_file','goal_check_file')
    paths={role:fixed_path_under(output/target[role],output,label='generated witness source') for role in roles}
    raw={role:(path.read_bytes() if path.exists() else None) for role,path in paths.items()}
    if raw['proof_auto_file'] is None:
        raise ValueError('generator did not produce its auto witness file')
    auto=raw['proof_auto_file'].decode('utf-8')
    manual=raw['proof_manual_file'].decode('utf-8') if raw['proof_manual_file'] is not None else None
    result,added=merged_manual(auto,manual,(target["active_case_theory"],Path(target["proof_auto_file"]).stem))
    if not added:
        return []
    # Retain immutable original bytes before any worklist extension, including
    # optional missing manual. The digest includes all four role boundaries.
    digest=hashlib.sha256(json.dumps({k:(v.hex() if v is not None else None) for k,v in raw.items()},sort_keys=True).encode()).hexdigest()
    archive=fixed_path_under(root/'evidence/qcp-raw-generated'/digest,root,label='raw generator archive')
    archive.mkdir(parents=True,exist_ok=True)
    for role,data in raw.items():
        if data is None:
            continue
        destination=fixed_path_under(archive/(role+'.v'),archive,label='immutable raw artifact')
        if destination.exists() and destination.read_bytes()!=data:
            raise ValueError('immutable raw generator archive conflict')
        if not destination.exists():write_bytes(destination,data)
    write_json(archive/'coverage.json',{'case':target['case_name'],'added_manual_witnesses':added,
               'raw_roles':{k:(hashlib.sha256(v).hexdigest() if v is not None else None) for k,v in raw.items()},
               'goal_definitions_changed':False,'auto_file_changed':False})
    write_text(paths['proof_manual_file'],result)
    goal_check=raw['goal_check_file'].decode('utf-8')
    manual_module=Path(target['proof_manual_file']).stem
    if manual_module not in goal_check:
        ending='End VC_Correctness.'
        if goal_check.count(ending)!=1 or 'Module VC_Correctness : VC_Correct.' not in goal_check:
            raise ValueError('unsupported goal-check wrapper; cannot add the complete witness provider safely')
        goal_check='From '+target['active_case_theory']+' Require Import '+manual_module+'.\n'+goal_check
        goal_check=goal_check.replace(ending,'  Include '+manual_module+'.\n'+ending)
        write_text(paths['goal_check_file'],goal_check)
    if paths['goal_file'].read_bytes()!=raw['goal_file'] or paths['proof_auto_file'].read_bytes()!=raw['proof_auto_file']:
        raise ValueError('raw goal/auto bytes changed while extending the proof worklist')
    return added


def uncovered_auto(state):
    if state['phase'] not in {'dependencies','vc-checking'}:
        return []
    if state['phase']=='vc-checking':
        task=state['attempts'].get(state['current']['vc-checking'])
        if not task or task['status']!='prepared':
            return []
    root=Path(state['main_root']);target=state['target_files']
    auto=fixed_path_under(root/target['proof_auto_file'],root,label='auto witness coverage')
    manual=fixed_path_under(root/target['proof_manual_file'],root,label='manual witness coverage')
    if not auto.is_file():return []
    a=parse_manual(auto.read_text())
    m=parse_manual(manual.read_text()) if manual.is_file() else None
    return [name for name in a.by_name if not m or name not in m.by_name]


def complete_obligation_coverage(args):
    """Route incomplete auto coverage through the original annotation retry."""
    from controller_state import load_run,_save_state,_append_event
    from controller_rounds import require_action,derive_actions
    state=load_run(args)
    require_action(state,'complete-obligation-coverage')
    names=uncovered_auto(state)
    if not names:raise SystemExit('no uncovered generated witnesses remain')
    state['pending_retry']={'phase':'annotation','reason':'generated-auto-proof-obligations',
                            'previous_attempt':state['current']['annotation']}
    state['current_blockers']=[{'failure_class':'infrastructure','kind':'uncovered-generated-auto',
        'vcs':[], 'message':'Generated auto witnesses require explicit proof worklist coverage: '+', '.join(names),
        'repair_boundary':'Controller regeneration adds exact raw witness statements to manual scope; owner keeps frozen contracts and all original goals.'}]
    run=Path(state['run_root']);_append_event(run,state,'generated-auto-coverage-retry',witnesses=names)
    _save_state(run,state)
    print(json.dumps({'status':'regeneration-required','uncovered_auto':names,'next_actions':derive_actions(state)},indent=2))
    return 0
