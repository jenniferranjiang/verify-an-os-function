"""Exercise path boundaries and both actual symbolic plans; no C proof claims."""
import json
from pathlib import Path
import sys
import tempfile

ROOT = Path(__file__).absolute().parents[2]
BASE = ROOT / 'tools/qcp-controller/scripts'
sys.path[:0] = [str(BASE / 'verification-orchestrator'), str(BASE / 'vc-proving')]
from path_utils import fixed_path_under, target_files_for_c
from symexec_tooling import build_symexec_plan
from crtos_layout import external_source, load_paths, TRIAL_ROOT
from crtos_frozen_inputs import check_frozen_inputs


def reject(action):
    try:
        action()
    except (ValueError, SystemExit):
        return
    raise AssertionError('Invalid path unexpectedly accepted')


assert TRIAL_ROOT == ROOT
for bad in ['/tmp/X.c', 'annotated_C/src/../X.c', 'annotated_C/other/X.c',
            'annotated_C/src/sub/X.c']:
    reject(lambda: target_files_for_c(bad, 'X'))
reject(lambda: external_source(Path('external/999/X.v')))
reject(lambda: external_source(Path('external/0/../../X.v')))
with tempfile.TemporaryDirectory(dir=ROOT / 'checks') as temporary:
    link = Path(temporary) / 'outside'
    link.symlink_to('/tmp', target_is_directory=True)
    reject(lambda: fixed_path_under(link / 'X', ROOT, label='test'))

plans = {}
for symbol in ['_SemaphoreCreate', 'KSemaphoreCreate']:
    mapping = target_files_for_c('annotated_C/src/' + symbol + '.c', symbol)
    assert mapping['formal_directory'] == 'VC'
    assert mapping['active_case_theory'] == 'CRTOS_Verify.VC'
    plans[symbol] = build_symexec_plan(main_root=ROOT,
        target_c_file=ROOT / mapping['c_file'], output_root=ROOT, target_files=mapping)
    assert plans[symbol]['argv'][0] == '/home/xinra/qcp-binary-democases/linux-binary/symexec'
    assert '--arch=32' in plans[symbol]['argv']
    assert '--endian=little' in plans[symbol]['argv']

check_frozen_inputs(ROOT)
result = {'status': 'passed', 'path_and_symlink_rejection': True,
          'load_paths': len(load_paths()), 'symbolic_plans': plans,
          'c_proofs_executed': False}
(ROOT / 'checks/controller-adapter-check.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps({'status': 'passed', 'targets': list(plans), 'c_proofs_executed': False}))
