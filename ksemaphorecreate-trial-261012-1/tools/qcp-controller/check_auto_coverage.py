#!/usr/bin/python3.12
"""Test witness promotion on copies of real outputs, without proving C goals."""
from pathlib import Path
import sys,json,shutil
r=Path(__file__).absolute().parents[2];s=r/'tools/qcp-controller/scripts'
sys.path[:0]=[str(s/'verification-orchestrator'),str(s/'vc-proving')]
from auto_obligations import complete_generated_worklist,merged_manual
from path_utils import target_files_for_c
from proof_manual_utils import parse_manual,lemma_proof_parts,coq_token_text
from coq_tooling_common import stage_current_sources
out=r/'evidence/controller-adapter-tests/auto-coverage';out.mkdir(parents=True,exist_ok=True)
target=target_files_for_c('annotated_C/src/CriticalAreaLock.c','CriticalAreaLock')
roles=['goal_file','proof_auto_file','proof_manual_file','goal_check_file']
for key in roles:
 dest=out/target[key];dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(r/target[key],dest)
raw_goal=(out/target['goal_file']).read_bytes();raw_auto=(out/target['proof_auto_file']).read_bytes()
a=parse_manual(raw_auto.decode());m=parse_manual((out/target['proof_manual_file']).read_text())
added=complete_generated_worklist(r,out,target)
full=parse_manual((out/target['proof_manual_file']).read_text())
assert set(full.by_name)==set(a.by_name)|set(m.by_name)
assert (out/target['goal_file']).read_bytes()==raw_goal and (out/target['proof_auto_file']).read_bytes()==raw_auto
for model in [a,m]:
 for name,lemma in model.by_name.items():
  assert coq_token_text(lemma_proof_parts(lemma)[0])==coq_token_text(lemma_proof_parts(full.by_name[name])[0])
assert complete_generated_worklist(r,out,target)==[]
texts,_=stage_current_sources(workspace_root=r,build_workspace=out/'stage',sources={Path(target[key]):out/target[key] for key in roles})
auto_staged=texts[Path(target['proof_auto_file'])]
assert 'Admitted' not in auto_staged and not parse_manual(auto_staged).lemmas
assert len(full.vc_index['top_level'])==3
for before in [None,a.prelude]:
 result,names=merged_manual(a.text,before);assert len(names)==len(a.by_name)
bad=m.text+'\nLemma '+a.lemmas[0]['name']+' : False.\nProof. Admitted.\n'
try:merged_manual(a.text,bad,(target['active_case_theory'],Path(target['proof_auto_file']).stem))
except ValueError:pass
else:raise AssertionError('conflicting witness statement was accepted')
result={'status':'passed','actual_case':'CriticalAreaLock','original_goal_and_auto_bytes_preserved':True,'manual_statements_exact_union':True,'manual_parents':len(full.vc_index['top_level']),'added_manual':added,'normalized_auto_has_no_admissions':True,'duplicate_conflict_rejected':True,'no_canonical_generated_file_modified':True,'no_C_proof_claim':True}
(r/'evidence/controller-auto-coverage-check.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
