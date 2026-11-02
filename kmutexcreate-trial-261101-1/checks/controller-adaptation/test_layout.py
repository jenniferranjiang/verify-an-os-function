"""Tool-layout regression checks, not a proof or controller acceptance shortcut."""
from pathlib import Path
import sys, json, unittest
ROOT=Path('/home/xinra/crtos/kmutexcreate-trial-261101-1')
SCRIPTS=Path('/home/xinra/qcp-binary-democases/.agents/scripts')
sys.dont_write_bytecode=True
sys.path[:0]=[str(SCRIPTS/'vc-proving'),str(SCRIPTS/'verification-orchestrator')]
from path_utils import target_files_for_c
import project_layout as layout
import coq_tooling_common as common
import coq_tooling_makefile as backend
from symexec_tooling import _validated_target_files, _driver_for_platform
class LayoutChecks(unittest.TestCase):
 def setUp(self):layout.configure(ROOT)
 def test_legacy_topology(self):
  t=target_files_for_c('QCP_examples/demo/deep/input.c','Example')
  self.assertEqual(t['formal_case_lib'],'Rocq/examples/demo/deep/Example_lib.v')
  self.assertEqual(t['active_case_theory'],'SimpleC.EE.demo.deep')
 def test_trial_topology(self):
  t=target_files_for_c('annotated_C/src/_MutexCreate.c','MutexCreate',project_root=ROOT)
  self.assertEqual(t['formal_case_lib'],'VC/MutexCreate_lib.v')
  self.assertEqual(t['active_case_theory'],'CRTOS_Verify.VC')
  self.assertEqual(_validated_target_files(target_rel=Path(t['c_file']),target_files=t,main_root=ROOT),t)
 def test_escapes_and_missing_project(self):
  for path in ['../outside.c','/tmp/outside.c','annotated_C/../outside.c']:
   with self.assertRaises(ValueError):target_files_for_c(path,'X',project_root=ROOT)
  with self.assertRaises(ValueError):target_files_for_c('annotated_C/src/a.c','X')
 def test_external_library_mapping(self):
  path=common.logical_module_to_relative('CRTOS_Verify.lib.CrtosInv')
  self.assertEqual(path,Path('/home/xinra/crtos/lib/CrtosInv.v'))
  self.assertEqual(common.relative_to_logical_module(path),'CRTOS_Verify.lib.CrtosInv')
  self.assertEqual(common.fixed_source(ROOT,path),path)
  self.assertEqual(common._plan_relative(str(path),'.v'),path)
  with self.assertRaises(ValueError):common._plan_relative('/etc/not-a-library.v','.v')
  with self.assertRaises(ValueError):layout.checked_external('/tmp/not-a-library.v')
 def test_loadpaths_do_not_copy_dependencies(self):
  paths=backend.base_load_paths(ROOT)
  self.assertIn(('-R',Path('/home/xinra/crtos/lib'),'CRTOS_Verify.lib'),paths)
  self.assertNotIn('KMutexCreateTrial.lib',[logical for _,_,logical in paths])
  self.assertEqual(common.relative_to_logical_module(Path('VC/MutexCreate_lib.v')),'CRTOS_Verify.VC.MutexCreate_lib')
 def test_coqdep_external_boundary(self):
  g=backend._parse_dependencies('VC/X_goal.vo : VC/X_goal.v /home/xinra/crtos/lib/CrtosInv.vo\n',ROOT)
  self.assertIn(Path('/home/xinra/crtos/lib/CrtosInv.v'),g[Path('VC/X_goal.v')])
  with self.assertRaises(common.CoqBuildPlanError):backend._parse_dependencies('VC/X.vo : /etc/injected.vo\n',ROOT)
 def test_driver_is_tool_owned(self):
  self.assertEqual(_driver_for_platform(ROOT),Path('/home/xinra/qcp-binary-democases/linux-binary/symexec'))
if __name__=='__main__':unittest.main(verbosity=2)
