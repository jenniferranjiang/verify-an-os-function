#!/usr/bin/python3.12
"""Adapter tests: path boundaries, actual nine plans, native predicate closure.
These are tooling checks, not proofs of any C verification condition.
"""
import sys
from pathlib import Path
import json,time,argparse
root=Path(__file__).absolute().parents[2]
base=root/'tools/qcp-controller/scripts'
sys.path[:0]=[str(base/'verification-orchestrator'),str(base/'vc-proving')]
import path_utils as paths
from crtos_layout import external_source,TRIAL_ROOT
from symexec_tooling import build_symexec_plan
from controller_closure import canonical_closure
import coq_tooling_makefile as backend

parser=argparse.ArgumentParser()
parser.add_argument('--paths-only',action='store_true')
options=parser.parse_args()
assert TRIAL_ROOT==root
checks=[]
def reject(label,action):
 try:
  action()
 except (ValueError,SystemExit):
  checks.append(label)
 else:
  raise AssertionError('unsafe input accepted: '+label)
for bad in ('/tmp/X.c','annotated_C/src/../X.c','annotated_C/other/X.c','annotated_C/src/sub/X.c'):
 reject('target rejects '+bad,lambda bad=bad: paths.target_files_for_c(bad,'X'))
reject('unknown external key',lambda:external_source(Path('external/999/A.v')))
reject('external traversal',lambda:external_source(Path('external/0/../../A.v')))
# Real symlink rejection, no read through the link.
fixture=root/'evidence/controller-adapter-tests';fixture.mkdir(exist_ok=True)
link=fixture/'outside';link.symlink_to('/tmp',target_is_directory=True)
try:
 reject('symlink write boundary',lambda:paths.fixed_path_under(link/'should-not-exist',root,label='test'))
finally: link.unlink()
data,order,digest=canonical_closure(root)
for symbol in order:
 target=Path(f'annotated_C/src/{symbol}.c')
 mapping=paths.target_files_for_c(target,symbol)
 assert mapping['formal_directory']=='VC'
 assert mapping['active_case_theory']=='CRTOS_Verify.VC'
 plan=build_symexec_plan(main_root=root,target_c_file=root/target,output_root=root,
                         target_files=mapping)
 assert '--input-file='+str(target) in plan['argv']
 assert plan['argv'][0]=='/home/xinra/qcp-binary-democases/linux-binary/symexec'
checks.append('nine canonical symbolic plans (driver not executed)')
if options.paths_only:
    print(json.dumps({'status':'passed','checks':checks,'c_vcs_generated':False},indent=2))
    raise SystemExit(0)
start=time.monotonic()
graph=backend.prepare_native(root=root,targets=[Path('lib/SemaphoreCritical.v')],family=set(),deadline=start+900)
checks.append('actual reviewed predicate dependency discovery and native build')
result={'status':'passed','checks':checks,'closure_order':order,'dependency_nodes':len(graph),
        'elapsed_seconds':round(time.monotonic()-start,3),'c_vcs_generated':False}
(root/'evidence/controller-adapter-check.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
