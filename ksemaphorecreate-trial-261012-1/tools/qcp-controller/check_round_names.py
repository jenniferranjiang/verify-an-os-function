#!/usr/bin/python3.12
"""Check safe underscore round identity; no state mutation or proof acceptance."""
import json, sys
from pathlib import Path
root = Path(__file__).resolve().parents[2]
base = root/'tools/qcp-controller/scripts'
sys.path[:0] = [str(base/'verification-orchestrator'), str(base/'vc-proving')]
from proving import _fixed_round_name
from controller_proving import _context
valid = ['_SemaphoreCreate-vc-proving-r1', '_SemaphoreCreate-vc-proving-r2', 'AllocId-vc-proving-r2', '__foo-r1', 'x']
invalid = ['', '_', '__', '.', '..', '../x', '_../x', '/x', '_/x', 'x/y', 'x\\y', ' x', 'x ', '.x', '_..', '_ x', 'x.', 'x-', None, 1]
for name in valid:
    assert _fixed_round_name(name), name
for name in invalid:
    assert not _fixed_round_name(name), name
state=json.loads((root/'reports/SemaphoreCreate-20261012131015/controller_state.json').read_text())
ctx=_context(state, state['attempts']['_SemaphoreCreate-vc-proving-r1'])
assert ctx.round_id == '_SemaphoreCreate-vc-proving-r1'
assert ctx.directory.name == ctx.round_id and ctx.report_directory.name == ctx.round_id
assert len(ctx.groups) == 9
result={'status':'passed','valid_names':valid,'rejected_names':invalid,'actual_round':ctx.round_id,'group_count':len(ctx.groups),'actual_run_state_modified':False,'c_vcs_proved':False}
(root/'evidence/controller-round-name-check.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
