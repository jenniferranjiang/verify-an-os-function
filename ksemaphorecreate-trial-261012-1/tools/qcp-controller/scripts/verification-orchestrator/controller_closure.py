"""Nine canonical cases, each retaining the upstream single-case lifecycle.

Only initialization and aggregate scheduling are added. Per-case success is
always obtained through the unmodified owner acceptance and final-check path.
"""
import contextlib
import io
import json
import hashlib
from pathlib import Path
from types import SimpleNamespace
from path_utils import fixed_path_under, write_json
from controller_state import init_run, load_run
from controller_rounds import step
from spec_freeze import extract_spec_surface

CLOSURE_PATH = 'reports/closure_state.json'


def canonical_closure(root):
    source = fixed_path_under(root/'evidence/source-closure.json', root, label='source closure')
    data = json.loads(source.read_text())
    symbols = set(data['nontrusted'])
    approved = json.loads((root/'evidence/accepted-revisions.json').read_text())
    if set(data['trusted']) != set(approved['trusted']) or len(symbols) != 9:
        raise ValueError('closure differs from the approved nine functions/six trusted')
    order, active, seen = [], set(), set()
    def visit(symbol):
        if symbol in data['trusted']:
            return
        if symbol not in symbols or symbol in active:
            raise ValueError(f'unresolved or cyclic closure member: {symbol}')
        if symbol in seen:
            return
        active.add(symbol)
        for child in data['direct_calls'][symbol]:
            visit(child)
        active.remove(symbol)
        seen.add(symbol)
        order.append(symbol)
    visit(data['entry'])
    if seen != symbols:
        raise ValueError('closure contains unreachable nontrusted entries')
    actual = {path.stem for path in (root/'annotated_C/src').glob('*.c')}
    if actual != symbols:
        raise ValueError('canonical C file set differs from complete closure')
    return data, order, hashlib.sha256(source.read_bytes()).hexdigest()


def closure_step_invocation(root):
    import sys
    return {'argv':[sys.executable,str(Path(__file__).with_name('controller.py')),
                    '--main-root',str(root),'step-closure'], 'cwd':str(root)}


def init_closure(args):
    """Initialize or resume initialization of the complete approved closure."""
    root = Path(args.main_root)
    data, order, digest = canonical_closure(root)
    path = fixed_path_under(root/CLOSURE_PATH, root, label='closure state')
    record = json.loads(path.read_text()) if path.exists() else {
        'version':1,'entry':data['entry'],'closure_sha256':digest,
        'order':order,'trusted':data['trusted'],'runs':{}}
    if record['closure_sha256'] != digest or record['order'] != order:
        raise ValueError('closure input changed after initialization')
    from controller_cli import build_parser
    for symbol in order:
        if symbol in record['runs']:
            continue
        c = root / f'annotated_C/src/{symbol}.c'
        surface = extract_spec_surface(c,None)
        names = sorted({name.split('::',1)[0] for name in surface['specs']})
        checked = json.loads((root/'evidence/spec-check-result.json').read_text())
        accepted = json.loads((root/'evidence/accepted-revisions.json').read_text())
        if checked['annotated_manifest_sha256'] != accepted['spec_manifest']:
            raise ValueError('canonical closure check is not bound to accepted spec revision')
        calls = set(checked['checks'][symbol]['direct_calls'])
        delta = set(data['direct_calls'][symbol]) - calls
        if calls - set(data['direct_calls'][symbol]) or (delta and not (symbol == '_SemaphoreCreate' and delta == {'KPrintf'})):
            raise ValueError('unreviewed source-to-canonical call difference')
        if set(names) != {symbol,*calls}:
            raise ValueError(f'caller-local contract set mismatch: {symbol}: {names}')
        arguments = ['--main-root',str(root),'init-run','--case',symbol,
                     '--target-c-file',str(c),'--formal-case-lib-policy','absent',
                     '--problem-statement-file',str(root/'evidence/implementation-constraints.txt'),
                     '--target-function',symbol,'--max-parallel-group-workers','3']
        for name in names:
            arguments += ['--freeze-spec',name]
        child = build_parser().parse_args(arguments)
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            init_run(child)
        result = json.loads(output.getvalue())
        record['runs'][symbol] = result['run_id']
        write_json(path,record)
    print(json.dumps({'closure':str(path),'function_count':len(order),
                      'next_actions':[{'action':'step-closure','invocation':closure_step_invocation(root)}]},indent=2))
    return 0


def step_closure(args):
    """Dispatch the first incomplete child; never infer callee verification."""
    root = Path(args.main_root)
    data, order, digest = canonical_closure(root)
    path = fixed_path_under(root/CLOSURE_PATH,root,label='closure state')
    record = json.loads(path.read_text())
    if record['closure_sha256'] != digest or record['order'] != order or set(record['runs']) != set(order):
        raise ValueError('closure identity or complete child set mismatch')
    completed = []
    for symbol in order:
        child = SimpleNamespace(main_root=str(root),run=record['runs'][symbol])
        state = load_run(child)
        if state['target_files']['c_file'] != f'annotated_C/src/{symbol}.c' or state['case'] != symbol:
            raise ValueError('child target binding mismatch')
        if state['phase'] == 'done':
            if not state['final_check'] or state['final_check'].get('status') != 'passed':
                raise ValueError('done child has no successful final check')
            from revision_revalidation import revalidation_needed
            if not revalidation_needed(state):
                completed.append(symbol)
                continue
        # A reviewed shared-input repair may occur while this owner is prepared.
        # Refresh only its unclaimed handoff metadata; preserve all run facts.
        if state['phase'] in {'annotation','vc-checking'}:
            attempt = state['attempts'].get(state['current'][state['phase']])
            if attempt and attempt['status']=='prepared':
                from controller_rounds import render_handoff
                render_handoff(state,attempt)
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            step(child)
        result = json.loads(output.getvalue())
        result.update(closure_entry=data['entry'],current_function=symbol,completed_functions=completed,
                      closure_resume=closure_step_invocation(root))
        print(json.dumps(result,indent=2))
        return 0
    print(json.dumps({'phase':'done','scope':'complete-nine-function-controller-closure',
                      'completed_functions':completed,'next_actions':[],
                      'remaining_os_checks':['coqchk','whole-closure C/spec/trust integrity']},indent=2))
    return 0
