"""Recheck published proofs after an independently accepted shared revision."""
from pathlib import Path
import json
import shutil

from crtos_input_guard import accepted_inputs
from path_utils import fixed_path_under


def input_binding(root):
    accepted = accepted_inputs(root)
    return {key: accepted[key] for key in (
        'source_manifest', 'predicate_manifest', 'spec_manifest', 'coqproject_sha256')}


def revalidation_needed(state):
    if state['phase'] != 'done':
        return False
    current = input_binding(Path(state['main_root']))
    return (state.get('final_check') or {}).get('accepted_inputs') != current


def revalidate_revision(args):
    """Archive the former result and queue the original full final-check."""
    from controller_state import load_run, _save_state, _append_event
    from controller_rounds import require_action, derive_actions, waiting
    state = load_run(args)
    require_action(state, 'revalidate-revision')
    if waiting(state) or state['current_blockers'] or state['pending_retry']:
        raise ValueError('revision revalidation requires stopped owners and no pending work')
    if (state.get('final_check') or {}).get('status') != 'passed':
        raise ValueError('completed run lacks its former successful final check')
    if (state.get('final_apply') or {}).get('status') != 'applied':
        raise ValueError('revision revalidation requires the existing published candidate')
    root = Path(state['main_root'])
    reports = Path(state['report_root'])
    archive = fixed_path_under(reports / 'revision-history' / str(state['generation']),
                               reports, label='prior revision check archive')
    archive.mkdir(parents=True, exist_ok=False)
    (archive / 'controller_state.json').write_text(json.dumps(state, indent=2)+'\n')
    # Preserve replay/backup evidence before the original final-check refreshes it.
    source = fixed_path_under(reports / 'final-check', reports, label='prior final check')
    if source.exists():
        for item in source.rglob('*'):
            fixed_path_under(item, reports, label='prior final check evidence')
        shutil.copytree(source, archive / 'final-check')
    binding = input_binding(root)
    state['phase'] = 'final-check'
    state['final_check'] = None
    state.pop('finished_at', None)
    _save_state(Path(state['run_root']), state)
    _append_event(Path(state['run_root']), state, 'accepted-revision-revalidation',
                  accepted_inputs=binding, history=str(archive))
    print(json.dumps({'status':'revalidation-required',
                      'next_actions':derive_actions(state)}, indent=2))
    return 0
