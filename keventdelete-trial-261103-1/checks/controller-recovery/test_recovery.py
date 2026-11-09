import copy,json,sys,unittest
from pathlib import Path
sys.path[:0]=[str(Path(__file__).resolve().parent),'/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator','/home/xinra/qcp-binary-democases/.agents/scripts/vc-proving']
import project_layout
project_layout.configure(Path('/home/xinra/crtos/keventdelete-trial-261103-1'))
from controller_control import _reopen_infrastructure_group
from controller_cli import build_parser
from controller_rounds import derive_actions
ROOT=Path('/home/xinra/crtos/keventdelete-trial-261103-1')
BASE=json.loads((ROOT/'reports/EventLinklistResumeAll-20261103172104/controller_state.json').read_text())
ROUND='EventLinklistResumeAll-vc-proving-r1'; GROUP='import_sem_refinement'; ID=ROUND+':'+GROUP
# Synthetic infrastructure-failure fixture; never writes live controller state.
BASE['attempts'][ROUND]['groups'][GROUP].update(status='blocked',blocker={'failure_class':'infrastructure','kind':'approval-rejected'})
BASE['current_blockers']=[copy.deepcopy(BASE['attempts'][ROUND]['groups'][GROUP]['blocker'])]
class RecoveryTests(unittest.TestCase):
 def setUp(self):self.state=copy.deepcopy(BASE)
 def record(self):return self.state['attempts'][ROUND]['groups'][GROUP]
 def test_same_owner_requeued_without_acceptance(self):
  before=copy.deepcopy(self.state);owner=self.record()['owner']
  _reopen_infrastructure_group(self.state,ID,'User explicitly authorizes implementation now')
  self.assertEqual(self.record()['status'],'prepared');self.assertEqual(self.record()['owner'],owner)
  for name,g in self.state['attempts'][ROUND]['groups'].items():
   if name!=GROUP:self.assertEqual(g,before['attempts'][ROUND]['groups'][name])
  actions=derive_actions(self.state)
  act=next(a for a in actions if a.get('attempt_id')==ID)
  self.assertEqual(act['kind'],'append-group-worker');self.assertEqual(act['owner'],owner)
  self.assertEqual(self.state['phase'],'vc-proving');self.assertFalse(self.state['current_blockers'])
 def test_requires_evidence(self):
  before=copy.deepcopy(self.state)
  with self.assertRaises(SystemExit):_reopen_infrastructure_group(self.state,ID,' ')
  self.assertEqual(self.state,before)
 def test_rejects_semantic_gaps_and_nonblocked_states(self):
  for failure in ['annotation-gap','plan-defect','specification-gap']:
   self.setUp();self.record()['blocker']['failure_class']=failure;before=copy.deepcopy(self.state)
   with self.assertRaises(SystemExit):_reopen_infrastructure_group(self.state,ID,'evidence')
   self.assertEqual(self.state,before)
  for status in ['accepted','running','returned','prepared']:
   self.setUp();self.record()['status']=status;before=copy.deepcopy(self.state)
   with self.assertRaises(SystemExit):_reopen_infrastructure_group(self.state,ID,'evidence')
   self.assertEqual(self.state,before)
 def test_preserves_unrelated_blockers(self):
  other={'failure_class':'infrastructure','kind':'disk'};self.state['current_blockers'].append(other)
  _reopen_infrastructure_group(self.state,ID,'evidence');self.assertIn(other,self.state['current_blockers'])
 def test_cli_requires_no_changes_to_existing_resume(self):
  a=build_parser().parse_args(['resume-run','--run','r']);self.assertIsNone(a.resolved_attempt)
  a=build_parser().parse_args(['resume-run','--run','r','--resolved-attempt',ID,'--resolution-reason','direct user approval']);self.assertEqual(a.resolved_attempt,ID)
if __name__=='__main__':unittest.main(verbosity=2)
