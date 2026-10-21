"""Escape the driver's reserved `end` binder, without changing C addresses.

Only forall binders in generated Definitions are supported. Their parenthesis
scopes must account for every renamed occurrence, including disjoint branches. The
fresh name is absent from the entire source, comments/strings retain exact
bytes, and reversing the alpha rename must reproduce the complete raw source.
Unexpected binding constructs are refused rather than guessed.
"""
import hashlib
import json
import re
from pathlib import Path
from path_utils import fixed_path_under, write_bytes, write_text, write_json
from proof_manual_utils import mask_coq_comments, mask_coq_strings


def escape_end_binder(text):
    masked = mask_coq_strings(mask_coq_comments(text))
    binder = re.compile(r"\(\s*end\s*:\s*Z\s*\)")
    if not binder.search(masked):
        return text, []
    fresh = 'qcp_local_end'
    if re.search(r'\b'+fresh+r'\b', masked):
        raise ValueError('reserved binder escape would capture an existing name')
    definitions = re.compile(r'^Definition\s+([A-Za-z_][A-Za-z0-9_]*)\s*:=\s*(.*?)\.(?=\s|$)', re.M|re.S)
    edits, names, covered = [], [], set()
    for definition in definitions.finditer(masked):
        body = definition.group(2)
        binders = list(binder.finditer(body))
        if not binders:
            continue
        if re.search(r'\b(match|fix|cofix|let)\b', body):
            raise ValueError('unsupported scope around reserved end binder')
        stack, pairs = [], []
        for index,char in enumerate(body):
            if char=='(': stack.append(index)
            elif char==')':
                if not stack: raise ValueError('unbalanced generated binder scope')
                pairs.append((stack.pop(),index))
        if stack: raise ValueError('unbalanced generated binder scope')
        scopes, seen = [], set()
        for header in re.finditer(r'^forall [^\n]*,',body,re.M):
            declarations = list(binder.finditer(header.group()))
            if not declarations: continue
            if len(declarations)!=1: raise ValueError('duplicate binder in one forall header')
            declaration = header.start()+declarations[0].start()
            enclosing = [(a,b) for a,b in pairs if a<header.start()<b]
            stop = min((b for a,b in enclosing),default=len(body))
            scopes.append((declaration,stop));seen.add(declaration)
        if seen!={b.start() for b in binders}:
            raise ValueError('reserved binder outside generated forall header')
        offset = definition.start(2)
        covered.update(offset+b.start() for b in binders)
        for token in re.finditer(r"(?<![A-Za-z0-9_'.])end(?![A-Za-z0-9_'])", body):
            if not any(a<=token.start()<b for a,b in scopes):
                raise ValueError('unbound end occurrence outside verified forall scopes')
            edits.append((offset+token.start(), offset+token.end()))
        names.append(definition.group(1))
    if covered != {m.start() for m in binder.finditer(masked)}:
        raise ValueError('reserved binder outside supported generated Definition')
    result = text
    for start, end in reversed(edits):
        result = result[:start]+fresh+result[end:]
    restored = result
    escaped = mask_coq_strings(mask_coq_comments(result))
    for token in reversed(list(re.finditer(r'\b'+fresh+r'\b', escaped))):
        restored = restored[:token.start()]+'end'+restored[token.end():]
    if restored != text:
        raise ValueError('alpha rename was not byte-reversible')
    return result, names


def normalize_generated_identifiers(root, output, target):
    roles = ('goal_file','proof_auto_file','proof_manual_file','goal_check_file')
    paths = {role: fixed_path_under(output/target[role],output,label='raw generated identifiers') for role in roles}
    raw = {role:(p.read_bytes() if p.exists() else None) for role,p in paths.items()}
    normalized, names = escape_end_binder(raw['goal_file'].decode('utf-8'))
    if not names:
        return []
    # Proof declarations refer to goal Definitions; refuse hidden binder scopes
    # in other artifacts instead of rewriting proof statements opportunistically.
    for role in roles[1:]:
        if raw[role] is not None and escape_end_binder(raw[role].decode('utf-8'))[1]:
            raise ValueError('reserved binder also occurs outside the goal module')
    digest = hashlib.sha256(json.dumps({k:v.hex() if v is not None else None for k,v in raw.items()},sort_keys=True).encode()).hexdigest()
    archive = fixed_path_under(root/'evidence/qcp-raw-identifiers'/digest,root,label='raw identifier archive')
    archive.mkdir(parents=True,exist_ok=True)
    for role,data in raw.items():
        if data is None: continue
        path = archive/(role+'.v')
        if path.exists() and path.read_bytes()!=data:
            raise ValueError('immutable identifier archive conflict')
        if not path.exists(): write_bytes(path,data)
    write_json(archive/'alpha-rename.json',{'case':target['case_name'],'from':'end','to':'qcp_local_end',
        'definitions':names,'raw_goal_sha256':hashlib.sha256(raw['goal_file']).hexdigest(),
        'normalized_goal_sha256':hashlib.sha256(normalized.encode()).hexdigest(),
        'byte_reversible_outside_comments_and_strings':True,'arithmetic_and_ownership_unchanged':True})
    write_text(paths['goal_file'],normalized)
    return names


def identifier_recovery_needed(state):
    if state['phase'] != 'vc-proving': return False
    task = state['attempts'][state['current']['vc-proving']]
    records = list(task.get('groups',{}).values())
    if any(r['status'] in {'running','returned'} for r in records): return False
    blocked = [r for r in records if r['status']=='blocked']
    kinds = {'generated-goal-syntax','generated-goal-syntax-error','generated-rocq-syntax'}
    if not blocked or any(r.get('blocker',{}).get('failure_class')!='infrastructure' or r['blocker'].get('kind') not in kinds for r in blocked): return False
    root = Path(state['main_root'])
    goal = fixed_path_under(root/state['target_files']['goal_file'],root,label='identifier recovery goal')
    return bool(escape_end_binder(goal.read_text())[1])


def repair_generated_identifiers(args):
    """Regenerate only after an actual reserved-binder failure and stopped owners."""
    from controller_state import load_run,_save_state,_append_event
    from controller_rounds import require_action,derive_actions
    state = load_run(args)
    require_action(state,'repair-generated-identifiers')
    if not identifier_recovery_needed(state): raise SystemExit('no supported identifier repair is currently needed')
    state['pending_retry']={'phase':'annotation','reason':'generated-reserved-binder','previous_attempt':state['current']['vc-proving']}
    _append_event(Path(state['run_root']),state,'generated-identifier-regeneration',rename={'end':'qcp_local_end'})
    _save_state(Path(state['run_root']),state)
    print(json.dumps({'status':'regeneration-required','next_actions':derive_actions(state)},indent=2))
    return 0
