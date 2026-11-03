from pathlib import Path
import sys,importlib.util,tempfile,json,shutil,unittest
sys.dont_write_bytecode=True
ROOT=Path(__file__).resolve().parents[2];BASE=Path('/home/xinra/qcp-binary-democases/.agents/scripts')
sys.path[:0]=[str(BASE/'verification-orchestrator'),str(BASE/'vc-proving')]
spec=importlib.util.spec_from_file_location('routing_candidate',Path(__file__).with_name('routing-proposed.py'));m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
from proof_manual_utils import parse_manual,incomplete_proof_markers,lemma_statement_text,coq_token_text
class Routing(unittest.TestCase):
 def test_actual_case_obligation_conservation(self):
  for case,expected in [('MutexCreate',45),('KMutexCreate',4)]:
   with self.subTest(case=case),tempfile.TemporaryDirectory() as tmp:
    output=Path(tmp); target={'proof_auto_file':'auto.v','proof_manual_file':'manual.v'}
    fixture=json.loads(Path(__file__).with_name('routing-test-inputs.json').read_text())['cases'][case]
    for key,part in [('proof_auto_file','auto'),('proof_manual_file','manual')]: (output/target[key]).write_text(fixture[part])
    before={name:coq_token_text(lemma_statement_text(l)) for f in target.values() for name,l in parse_manual((output/f).read_text()).by_name.items()}
    r=m._route_unproved_auto_obligations({'target_files':target},output)
    self.assertEqual(len(r['promoted']),expected)
    after=parse_manual((output/'manual.v').read_text())
    self.assertEqual(before,{name:coq_token_text(lemma_statement_text(l)) for name,l in after.by_name.items()})
    self.assertFalse(incomplete_proof_markers((output/'auto.v').read_text()))
    # No proof has been invented: pending obligations still contain real templates.
    self.assertTrue(incomplete_proof_markers((output/'manual.v').read_text()))
 def test_proved_auto_untouched(self):
  with tempfile.TemporaryDirectory() as tmp:
   out=Path(tmp);text='Lemma proof_of_ok : True.\nProof. exact I. Qed.\n';(out/'auto.v').write_text(text)
   self.assertEqual(m._route_unproved_auto_obligations({'target_files':{'proof_auto_file':'auto.v','proof_manual_file':'manual.v'}},out),{'promoted':[]})
   self.assertEqual((out/'auto.v').read_text(),text)
 def test_conflicting_statement_rejected(self):
  with tempfile.TemporaryDirectory() as tmp:
   out=Path(tmp);(out/'auto.v').write_text('Lemma proof_of_a : True.\nProof. Admitted.\n');(out/'manual.v').write_text('Lemma proof_of_a : False.\nProof. Admitted.\n')
   with self.assertRaises(ValueError):m._route_unproved_auto_obligations({'target_files':{'proof_auto_file':'auto.v','proof_manual_file':'manual.v'}},out)
if __name__=='__main__':unittest.main(verbosity=2)
