import argparse, contextlib, copy, io, json, sys, types
from pathlib import Path
base=Path(__file__).parent
base_state={'phase':'annotation','run_root':'/tmp/unfreeze-test','annotation_owner':'owner-1','current':{'annotation':'ann-1'},'attempts':{'ann-1':{'attempt_id':'ann-1','phase':'annotation','status':'running','owner':'owner-1'}},'spec_freeze':{'functions':['f'],'baseline':{'specs':{'f':'original'}}},'current_blockers':[]}
def invoke(filename,state,round='ann-1'):
    calls=[];mod=types.ModuleType('controller_state')
    mod._append_event=lambda *a,**k:calls.append(('event',a[2],k))
    mod._failed_vcs_errors=lambda _:[]
    mod._save_state=lambda *a:calls.append(('save',))
    mod.load_run=lambda _:state
    def require(s,r,p):
        if s['current']['annotation']!=r or s['attempts'][r]['phase']!=p:raise SystemExit('not current')
        return s['attempts'][r]
    mod.require_attempt=require;sys.modules['controller_state']=mod
    attempts=types.ModuleType('controller_attempts')
    def repair(s,a,record,group,errors):
        assert s is state and a is record and group is None
        calls.append(('repair',a['attempt_id'],a['owner'],errors))
        return 7
    attempts._repair=repair;sys.modules['controller_attempts']=attempts
    ns={};exec(compile((base/filename).read_text(),filename,'exec'),ns)
    with contextlib.redirect_stdout(io.StringIO()):code=ns['unfreeze'](argparse.Namespace(round=round))
    return code,calls
results=[]
s=copy.deepcopy(base_state);code,calls=invoke('annotation_design.after.py',s);assert code==0 and s['spec_freeze']['baseline'] is None and not any(c[0]=='repair' for c in calls);results.append('running behavior retained')
b={'failure_class':'infrastructure','kind':'ambiguous-ghost-struct-field'}
s=copy.deepcopy(base_state);s['attempts']['ann-1'].update(status='blocked',blocker=b);s['current_blockers']=[b,{'kind':'other'}]
code,calls=invoke('annotation_design.after.py',s);assert code==7 and s['spec_freeze']['baseline'] is None and s['current_blockers']==[{'kind':'other'}];assert calls[-1][0:3]==('repair','ann-1','owner-1');assert s['attempts']['ann-1']['status']=='blocked';results.append('blocked routes through existing repair, same attempt and owner, no acceptance')
for change,label in [(lambda s:s['attempts']['ann-1'].update(status='accepted'),'accepted rejected'),(lambda s:s.update(phase='vc-proving'),'other phase rejected'),(lambda s:s.update(spec_freeze=None),'unfrozen input rejected')]:
 s=copy.deepcopy(base_state);change(s)
 try:invoke('annotation_design.after.py',s)
 except SystemExit:results.append(label)
 else:raise AssertionError(label)
s=copy.deepcopy(base_state);s['attempts']['ann-1'].update(status='blocked',blocker=b)
try:invoke('annotation_design.before.py',s)
except SystemExit:results.append('original blocked-recovery failure reproduced')
else:raise AssertionError('baseline did not reproduce')
print(json.dumps({'status':'passed','tests':results},indent=2))
