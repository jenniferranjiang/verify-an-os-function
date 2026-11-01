# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "SemaphoreDelete-vc-checking-r3",
  "round": "SemaphoreDelete-vc-checking-r3",
  "main_root": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
  "target_files": {
    "c_file": "annotated_C/src/_SemaphoreDelete.c",
    "formal_directory": "VC",
    "formal_case_lib": "VC/SemaphoreDelete_lib.v",
    "goal_file": "VC/SemaphoreDelete_goal.v",
    "proof_auto_file": "VC/SemaphoreDelete_proof_auto.v",
    "proof_manual_file": "VC/SemaphoreDelete_proof_manual.v",
    "goal_check_file": "VC/SemaphoreDelete_goal_check.v",
    "case_name": "SemaphoreDelete",
    "active_case_theory": "CRTOS_Verify.VC"
  },
  "formal_case_lib_policy": "create",
  "report": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-checking-r3/agent_report.json",
  "notes": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-checking-r3/agent_output.md",
  "feedback": "[\n  {\n    \"failure_class\": \"parent-check\",\n    \"message\": \"{'status': 'failed', 'candidate': {'proof_manual': '/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/proving_merged/SemaphoreDelete_proof_manual.v', 'formal_case_lib': '/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/SemaphoreDelete-vc-proving-r1/proving_merged/SemaphoreDelete_lib.v'}, 'group_count': 24, 'group_errors': {}, 'added_declarations': [{'name': 'resume_keeps_semaphore_fields__manager_selection', 'kind': 'Lemma', 'group_id': 'manager_selection'}, {'name': 'manager_ids_nodup__manager_selection', 'kind': 'Lemma', 'group_id': 'manager_selection'}, {'name': 'os_inv_manager_view__manager_selection', 'kind': 'Lemma', 'group_id': 'manager_selection'}, {'name': 'From Coq Require Import Lia Bool.Bool Sorting.Permutation.', 'kind': 'Import', 'group_id': 'retirement_commit'}, {'name': 'mapped_nodup_injective__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'selected_bucket_member__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'deleted_id_node_unique__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'delete_atomic_continuation__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'ushort_distinct__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'pure_framed__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'payload_dllseg_distinct__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'payload_dll_distinct__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'unpublish_current__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'task_world_reindex__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'service_reindex__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'world_reindex__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'task_inv_reindex__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'global_frame_reindex__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'empty_dll_self__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'idnodes_remove_app__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'idnodes_remove_absent__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'filtered_remove_absent__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'map_seq_nth__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'replace_map_seq__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'idlist_remove_current__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'idnodes_remove_current_cons__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'bucket_remove_current__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'other_bucket_current__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'manager_remove_current__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'inv_recompose__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'waiters_remove_empty__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'embedded_field_addr__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'retired_payload__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'payload_rest_distinct__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'retire_empty_semaphore_memory__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'retired_nonzero__retirement_commit', 'kind': 'Lemma', 'group_id': 'retirement_commit'}, {'name': 'semaphore_bucket_member__lookup_views', 'kind': 'Lemma', 'group_id': 'lookup_views'}, {'name': 'semaphore_found_member__lookup_views', 'kind': 'Lemma', 'group_id': 'lookup_views'}, {'name': 'semaphore_segment_nonzero__lookup_views', 'kind': 'Lemma', 'group_id': 'lookup_views'}, {'name': 'semaphore_dll_nonzero__lookup_views', 'kind': 'Lemma', 'group_id': 'lookup_views'}, {'name': 'semaphore_manager_close__lookup_views', 'kind': 'Lemma', 'group_id': 'lookup_views'}, {'name': 'semaphore_frame_nonzero__lookup_views', 'kind': 'Lemma', 'group_id': 'lookup_views'}, {'name': 'semaphore_found_close__lookup_views', 'kind': 'Lemma', 'group_id': 'lookup_views'}, {'name': 'dllseg_focus__pending_views', 'kind': 'Lemma', 'group_id': 'pending_views'}, {'name': 'dll_focus__pending_views', 'kind': 'Lemma', 'group_id': 'pending_views'}, {'name': 'semaphore_payload_pending__pending_views', 'kind': 'Lemma', 'group_id': 'pending_views'}, {'name': 'os_inv_payload_focus__pending_views', 'kind': 'Lemma', 'group_id': 'pending_views'}, {'name': 'pending_dll_focus__pending_views', 'kind': 'Lemma', 'group_id': 'pending_views'}, {'name': 'From Coq Require Import Lia.', 'kind': 'Import', 'group_id': 'id_read_views'}, {'name': 'dllseg_focus__id_read_views', 'kind': 'Lemma', 'group_id': 'id_read_views'}, {'name': 'dll_focus__id_read_views', 'kind': 'Lemma', 'group_id': 'id_read_views'}, {'name': 'idbucket_focus__id_read_views', 'kind': 'Lemma', 'group_id': 'id_read_views'}, {'name': 'idbuckets_focus__id_read_views', 'kind': 'Lemma', 'group_id': 'id_read_views'}, {'name': 'semaphore_idnode_in_buckets__id_read_views', 'kind': 'Lemma', 'group_id': 'id_read_views'}, {'name': 'resume_current_sem__id_read_views', 'kind': 'Lemma', 'group_id': 'id_read_views'}, {'name': 'idnode_scalar_focus__id_read_views', 'kind': 'Lemma', 'group_id': 'id_read_views'}, {'name': 'os_id_cell_focus__id_read_views', 'kind': 'Lemma', 'group_id': 'id_read_views'}, {'name': 'resume_id_cell_focus__id_read_views', 'kind': 'Lemma', 'group_id': 'id_read_views'}, {'name': 'Require Import Coq.micromega.Lia.', 'kind': 'Import', 'group_id': 'lookup_miss'}, {'name': 'delete_miss_continuation__lookup_miss', 'kind': 'Lemma', 'group_id': 'lookup_miss'}, {'name': 'self_to_storage__retired_raw', 'kind': 'Lemma', 'group_id': 'retired_raw'}, {'name': 'retired_to_raw__retired_raw', 'kind': 'Lemma', 'group_id': 'retired_raw'}], 'coq_check': {'target_file': 'VC/SemaphoreDelete_goal_check.v', 'target_kind': 'parent', 'build_workspace': '/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r1/parent/src', 'dependency_mode': 'makefile', 'status': 'failed', 'returncode': 1, 'first_failure': {'category': 'verification', 'kind': 'tool-failed', 'message': 'Error:\\\\nIn environment\\\\nsg : StableGlobalState\\\\nst : VarGlobalState\\\\nThe term \\\"\u201c NoDup (map semaphore_id (os_semaphores st)) \u201d\\\" has type\\\\n \\\"model -> Prop\\\" while it is expected to have type \\\\n\\\"bool\\\".', 'repair': 'Inspect the reported native tool failure and retry the same command.', 'evidence': {'returncode': 1, 'argv': ['/home/xinra/.opam/pv-bench-8.20.1/bin/coqc', '-q', '-R', '/home/xinra/qcp-binary-democases/Rocq/flocq/src', 'Flocq', '-R', '/home/xinra/qcp-binary-democases/Rocq/SeparationLogic', 'SimpleC.SL', '-R', '/home/xinra/qcp-binary-democases/Rocq/unifysl', 'Logic', '-R', '/home/xinra/qcp-binary-democases/Rocq/sets', 'SetsClass', '-R', '/home/xinra/qcp-binary-democases/Rocq/compcert_lib', 'compcert.lib', '-R', '/home/xinra/qcp-binary-democases/Rocq/auxlibs', 'AUXLib', '-R', '/home/xinra/qcp-binary-democases/Rocq/examples', 'SimpleC.EE', '-R', '/home/xinra/qcp-binary-democases/Rocq/stdlib', 'SimpleC.StdLib', '-R', '/home/xinra/qcp-binary-democases/Rocq/StrategyLib', 'SimpleC.StrategyLib', '-R', '/home/xinra/qcp-binary-democases/Rocq/Common', 'SimpleC.Common', '-R', '/home/xinra/crtos/vendor/fixedpoints', 'FP', '-R', '/home/xinra/crtos/vendor/MonadLib', 'MonadLib', '-R', '/home/xinra/qcp-binary-democases/Rocq/listlib', 'ListLib', '-R', '/home/xinra/qcp-binary-democases/Rocq/MaxMinLib', 'MaxMinLib', '-R', '/home/xinra/qcp-binary-democases/Rocq/GraphLib', 'GraphLib', '-R', '/home/xinra/qcp-binary-democases/Rocq/SumLib', 'SumLib', '-R', '/home/xinra/qcp-binary-democases/Rocq/tracelib', 'TraceLib', '-R', '/home/xinra/qcp-binary-democases/Rocq/coq-record-update/src', 'RecordUpdate', '-Q', '/home/xinra/qcp-binary-democases/Rocq/algorithms', 'Algorithms', '-R', '/home/xinra/qcp-binary-democases/Rocq/cdcllib', 'CDCLLib', '-R', '/home/xinra/crtos/lib', 'CRTOS_Verify.lib', '-R', '/home/xinra/crtos/vendor/qcp_strategy', 'QCPCompat', '-R', '/home/xinra/crtos/ksemaphoredelete-trial-261025-1/VC', 'CRTOS_Verify.VC', '-R', '/home/xinra/crtos/ksemaphoredelete-trial-261025-1/verification_runs/SemaphoreDelete-20261030135715/_coq_builds/SemaphoreDelete-vc-proving-r1/parent/src/VC', 'CRTOS_Verify.VC', 'VC/SemaphoreDelete_lib.v'], 'stdout_tail': '', 'stderr_tail': 'File \\\"./VC/SemaphoreDelete_lib.v\\\", line 90, characters 4-55:\\\\nError:\\\\nIn environment\\\\nsg : StableGlobalState\\\\nst : VarGlobalState\\\\nThe term \\\"\u201c NoDup (map semaphore_id (os_semaphores st)) \u201d\\\" has type\\\\n \\\"model -> Prop\\\" while it is expected to have type \\\\n\\\"bool\\\".\\\\n\\\\n', 'first_diagnostic': {'file': './VC/SemaphoreDelete_lib.v', 'line': 90, 'characters': '4-55', 'message': 'Error:\\\\nIn environment\\\\nsg : StableGlobalState\\\\nst : VarGlobalState\\\\nThe term \\\"\u201c NoDup (map semaphore_id (os_semaphores st)) \u201d\\\" has type\\\\n \\\"model -> Prop\\\" while it is expected to have type \\\\n\\\"bool\\\".'}}}, 'stderr_tail': 'Error:\\\\nIn environment\\\\nsg : StableGlobalState\\\\nst : VarGlobalState\\\\nThe term \\\"\u201c NoDup (map semaphore_id (os_semaphores st)) \u201d\\\" has type\\\\n \\\"model -> Prop\\\" while it is expected to have type \\\\n\\\"bool\\\".', 'elapsed_seconds': 49.420617}}\"\n  }\n]",
  "feedback_sources": [],
  "previous_attempt": "SemaphoreDelete-vc-proving-r1",
  "group_plan": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-checking-r3/group_plan.json",
  "debug_manual": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/reports/SemaphoreDelete-20261030135715/rounds/SemaphoreDelete-vc-checking-r3/SemaphoreDelete_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_1": {
        "name": "proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_1",
        "parent": "proof_of__SemaphoreDelete_entail_wit_2_1",
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_1 : _SemaphoreDelete_entail_wit_2_1_split_goal_1.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_2": {
        "name": "proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_2",
        "parent": "proof_of__SemaphoreDelete_entail_wit_2_1",
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_2 : _SemaphoreDelete_entail_wit_2_1_split_goal_2.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_spatial": {
        "name": "proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_spatial",
        "parent": "proof_of__SemaphoreDelete_entail_wit_2_1",
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_spatial : _SemaphoreDelete_entail_wit_2_1_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_2_1": {
        "name": "proof_of__SemaphoreDelete_entail_wit_2_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_2_1 : _SemaphoreDelete_entail_wit_2_1.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_1": {
        "name": "proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_1",
        "parent": "proof_of__SemaphoreDelete_entail_wit_2_2",
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_1 : _SemaphoreDelete_entail_wit_2_2_split_goal_1.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_2": {
        "name": "proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_2",
        "parent": "proof_of__SemaphoreDelete_entail_wit_2_2",
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_2 : _SemaphoreDelete_entail_wit_2_2_split_goal_2.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_spatial": {
        "name": "proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_spatial",
        "parent": "proof_of__SemaphoreDelete_entail_wit_2_2",
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_spatial : _SemaphoreDelete_entail_wit_2_2_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_2_2": {
        "name": "proof_of__SemaphoreDelete_entail_wit_2_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_2_2 : _SemaphoreDelete_entail_wit_2_2.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_3_1_split_goal_1": {
        "name": "proof_of__SemaphoreDelete_entail_wit_3_1_split_goal_1",
        "parent": "proof_of__SemaphoreDelete_entail_wit_3_1",
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_3_1_split_goal_1 : _SemaphoreDelete_entail_wit_3_1_split_goal_1.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_3_1": {
        "name": "proof_of__SemaphoreDelete_entail_wit_3_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_3_1 : _SemaphoreDelete_entail_wit_3_1.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_3_2": {
        "name": "proof_of__SemaphoreDelete_entail_wit_3_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_3_2 : _SemaphoreDelete_entail_wit_3_2.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_4_1": {
        "name": "proof_of__SemaphoreDelete_entail_wit_4_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_4_1 : _SemaphoreDelete_entail_wit_4_1.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_4_2": {
        "name": "proof_of__SemaphoreDelete_entail_wit_4_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_4_2 : _SemaphoreDelete_entail_wit_4_2.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_4_3": {
        "name": "proof_of__SemaphoreDelete_entail_wit_4_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_4_3 : _SemaphoreDelete_entail_wit_4_3.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_4_4": {
        "name": "proof_of__SemaphoreDelete_entail_wit_4_4",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_4_4 : _SemaphoreDelete_entail_wit_4_4.\n"
      },
      "proof_of__SemaphoreDelete_return_wit_2_split_goal_1": {
        "name": "proof_of__SemaphoreDelete_return_wit_2_split_goal_1",
        "parent": "proof_of__SemaphoreDelete_return_wit_2",
        "statement": "Lemma proof_of__SemaphoreDelete_return_wit_2_split_goal_1 : _SemaphoreDelete_return_wit_2_split_goal_1.\n"
      },
      "proof_of__SemaphoreDelete_return_wit_2": {
        "name": "proof_of__SemaphoreDelete_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_return_wit_2 : _SemaphoreDelete_return_wit_2.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1",
        "parent": "proof_of__SemaphoreDelete_partial_solve_wit_3_pure",
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2",
        "parent": "proof_of__SemaphoreDelete_partial_solve_wit_3_pure",
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2 : _SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_3_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_3_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_3_pure : _SemaphoreDelete_partial_solve_wit_3_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_1": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_1",
        "parent": "proof_of__SemaphoreDelete_partial_solve_wit_10_pure",
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_10_pure_split_goal_1.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_2": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_2",
        "parent": "proof_of__SemaphoreDelete_partial_solve_wit_10_pure",
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_2 : _SemaphoreDelete_partial_solve_wit_10_pure_split_goal_2.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_10_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_10_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_10_pure : _SemaphoreDelete_partial_solve_wit_10_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1",
        "parent": "proof_of__SemaphoreDelete_partial_solve_wit_17_pure",
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2",
        "parent": "proof_of__SemaphoreDelete_partial_solve_wit_17_pure",
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2 : _SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3",
        "parent": "proof_of__SemaphoreDelete_partial_solve_wit_17_pure",
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3 : _SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_17_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_17_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_17_pure : _SemaphoreDelete_partial_solve_wit_17_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1",
        "parent": "proof_of__SemaphoreDelete_partial_solve_wit_18_pure",
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2",
        "parent": "proof_of__SemaphoreDelete_partial_solve_wit_18_pure",
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2 : _SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3",
        "parent": "proof_of__SemaphoreDelete_partial_solve_wit_18_pure",
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3 : _SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_18_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_18_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_18_pure : _SemaphoreDelete_partial_solve_wit_18_pure.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial",
        "parent": "proof_of__SemaphoreDelete_which_implies_wit_1",
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial : _SemaphoreDelete_which_implies_wit_1_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_1": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_1 : _SemaphoreDelete_which_implies_wit_1.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_2": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_2 : _SemaphoreDelete_which_implies_wit_2.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial",
        "parent": "proof_of__SemaphoreDelete_which_implies_wit_3",
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial : _SemaphoreDelete_which_implies_wit_3_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_3": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_3 : _SemaphoreDelete_which_implies_wit_3.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_1": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_1",
        "parent": "proof_of__SemaphoreDelete_which_implies_wit_4",
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_1 : _SemaphoreDelete_which_implies_wit_4_split_goal_1.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial",
        "parent": "proof_of__SemaphoreDelete_which_implies_wit_4",
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial : _SemaphoreDelete_which_implies_wit_4_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_4": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_4 : _SemaphoreDelete_which_implies_wit_4.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial",
        "parent": "proof_of__SemaphoreDelete_which_implies_wit_5",
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial : _SemaphoreDelete_which_implies_wit_5_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_5": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_5 : _SemaphoreDelete_which_implies_wit_5.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_6_split_goal_spatial": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_6_split_goal_spatial",
        "parent": "proof_of__SemaphoreDelete_which_implies_wit_6",
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_6_split_goal_spatial : _SemaphoreDelete_which_implies_wit_6_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_6": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_6 : _SemaphoreDelete_which_implies_wit_6.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_7": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_7 : _SemaphoreDelete_which_implies_wit_7.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_1": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_1",
        "parent": "proof_of__SemaphoreDelete_which_implies_wit_8",
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_1 : _SemaphoreDelete_which_implies_wit_8_split_goal_1.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_spatial": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_spatial",
        "parent": "proof_of__SemaphoreDelete_which_implies_wit_8",
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_spatial : _SemaphoreDelete_which_implies_wit_8_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_8": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_8 : _SemaphoreDelete_which_implies_wit_8.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_9_split_goal_spatial": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_9_split_goal_spatial",
        "parent": "proof_of__SemaphoreDelete_which_implies_wit_9",
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_9_split_goal_spatial : _SemaphoreDelete_which_implies_wit_9_split_goal_spatial.\n"
      },
      "proof_of__SemaphoreDelete_which_implies_wit_9": {
        "name": "proof_of__SemaphoreDelete_which_implies_wit_9",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_which_implies_wit_9 : _SemaphoreDelete_which_implies_wit_9.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_1": {
        "name": "proof_of__SemaphoreDelete_safety_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_1 : _SemaphoreDelete_safety_wit_1.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_2": {
        "name": "proof_of__SemaphoreDelete_safety_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_2 : _SemaphoreDelete_safety_wit_2.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_3": {
        "name": "proof_of__SemaphoreDelete_safety_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_3 : _SemaphoreDelete_safety_wit_3.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_4": {
        "name": "proof_of__SemaphoreDelete_safety_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_4 : _SemaphoreDelete_safety_wit_4.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_5": {
        "name": "proof_of__SemaphoreDelete_safety_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_5 : _SemaphoreDelete_safety_wit_5.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_6": {
        "name": "proof_of__SemaphoreDelete_safety_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_6 : _SemaphoreDelete_safety_wit_6.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_7": {
        "name": "proof_of__SemaphoreDelete_safety_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_7 : _SemaphoreDelete_safety_wit_7.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_8": {
        "name": "proof_of__SemaphoreDelete_safety_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_8 : _SemaphoreDelete_safety_wit_8.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_9": {
        "name": "proof_of__SemaphoreDelete_safety_wit_9",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_9 : _SemaphoreDelete_safety_wit_9.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_10": {
        "name": "proof_of__SemaphoreDelete_safety_wit_10",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_10 : _SemaphoreDelete_safety_wit_10.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_11": {
        "name": "proof_of__SemaphoreDelete_safety_wit_11",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_11 : _SemaphoreDelete_safety_wit_11.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_12": {
        "name": "proof_of__SemaphoreDelete_safety_wit_12",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_12 : _SemaphoreDelete_safety_wit_12.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_13": {
        "name": "proof_of__SemaphoreDelete_safety_wit_13",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_13 : _SemaphoreDelete_safety_wit_13.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_14": {
        "name": "proof_of__SemaphoreDelete_safety_wit_14",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_14 : _SemaphoreDelete_safety_wit_14.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_15": {
        "name": "proof_of__SemaphoreDelete_safety_wit_15",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_15 : _SemaphoreDelete_safety_wit_15.\n"
      },
      "proof_of__SemaphoreDelete_safety_wit_16": {
        "name": "proof_of__SemaphoreDelete_safety_wit_16",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_safety_wit_16 : _SemaphoreDelete_safety_wit_16.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_1": {
        "name": "proof_of__SemaphoreDelete_entail_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_1 : _SemaphoreDelete_entail_wit_1.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_5_1": {
        "name": "proof_of__SemaphoreDelete_entail_wit_5_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_5_1 : _SemaphoreDelete_entail_wit_5_1.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_5_2": {
        "name": "proof_of__SemaphoreDelete_entail_wit_5_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_5_2 : _SemaphoreDelete_entail_wit_5_2.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_6_1": {
        "name": "proof_of__SemaphoreDelete_entail_wit_6_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_6_1 : _SemaphoreDelete_entail_wit_6_1.\n"
      },
      "proof_of__SemaphoreDelete_entail_wit_6_2": {
        "name": "proof_of__SemaphoreDelete_entail_wit_6_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_entail_wit_6_2 : _SemaphoreDelete_entail_wit_6_2.\n"
      },
      "proof_of__SemaphoreDelete_return_wit_1": {
        "name": "proof_of__SemaphoreDelete_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_return_wit_1 : _SemaphoreDelete_return_wit_1.\n"
      },
      "proof_of__SemaphoreDelete_return_wit_3": {
        "name": "proof_of__SemaphoreDelete_return_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_return_wit_3 : _SemaphoreDelete_return_wit_3.\n"
      },
      "proof_of__SemaphoreDelete_return_wit_4": {
        "name": "proof_of__SemaphoreDelete_return_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_return_wit_4 : _SemaphoreDelete_return_wit_4.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_1": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_1",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_1 : _SemaphoreDelete_partial_solve_wit_1.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_2": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_2",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_2 : _SemaphoreDelete_partial_solve_wit_2.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_3": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_3",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_3 : _SemaphoreDelete_partial_solve_wit_3.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_4_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_4_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_4_pure : _SemaphoreDelete_partial_solve_wit_4_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_4": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_4",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_4 : _SemaphoreDelete_partial_solve_wit_4.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_5": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_5",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_5 : _SemaphoreDelete_partial_solve_wit_5.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_6_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_6_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_6_pure : _SemaphoreDelete_partial_solve_wit_6_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_6": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_6",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_6 : _SemaphoreDelete_partial_solve_wit_6.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_7_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_7_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_7_pure : _SemaphoreDelete_partial_solve_wit_7_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_7": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_7",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_7 : _SemaphoreDelete_partial_solve_wit_7.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_8": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_8",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_8 : _SemaphoreDelete_partial_solve_wit_8.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_9_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_9_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_9_pure : _SemaphoreDelete_partial_solve_wit_9_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_9": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_9",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_9 : _SemaphoreDelete_partial_solve_wit_9.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_10": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_10",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_10 : _SemaphoreDelete_partial_solve_wit_10.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_11_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_11_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_11_pure : _SemaphoreDelete_partial_solve_wit_11_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_11": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_11",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_11 : _SemaphoreDelete_partial_solve_wit_11.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_12_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_12_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_12_pure : _SemaphoreDelete_partial_solve_wit_12_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_12": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_12",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_12 : _SemaphoreDelete_partial_solve_wit_12.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_13_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_13_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_13_pure : _SemaphoreDelete_partial_solve_wit_13_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_13": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_13",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_13 : _SemaphoreDelete_partial_solve_wit_13.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_14_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_14_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_14_pure : _SemaphoreDelete_partial_solve_wit_14_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_14": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_14",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_14 : _SemaphoreDelete_partial_solve_wit_14.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_15_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_15_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_15_pure : _SemaphoreDelete_partial_solve_wit_15_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_15": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_15",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_15 : _SemaphoreDelete_partial_solve_wit_15.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_16_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_16_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_16_pure : _SemaphoreDelete_partial_solve_wit_16_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_16": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_16",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_16 : _SemaphoreDelete_partial_solve_wit_16.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_17": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_17",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_17 : _SemaphoreDelete_partial_solve_wit_17.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_18": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_18",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_18 : _SemaphoreDelete_partial_solve_wit_18.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_19_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_19_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_19_pure : _SemaphoreDelete_partial_solve_wit_19_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_19": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_19",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_19 : _SemaphoreDelete_partial_solve_wit_19.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_20_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_20_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_20_pure : _SemaphoreDelete_partial_solve_wit_20_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_20": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_20",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_20 : _SemaphoreDelete_partial_solve_wit_20.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_21_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_21_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_21_pure : _SemaphoreDelete_partial_solve_wit_21_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_21": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_21",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_21 : _SemaphoreDelete_partial_solve_wit_21.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_22_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_22_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_22_pure : _SemaphoreDelete_partial_solve_wit_22_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_22": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_22",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_22 : _SemaphoreDelete_partial_solve_wit_22.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_23": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_23",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_23 : _SemaphoreDelete_partial_solve_wit_23.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_24": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_24",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_24 : _SemaphoreDelete_partial_solve_wit_24.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_25": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_25",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_25 : _SemaphoreDelete_partial_solve_wit_25.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_26": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_26",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_26 : _SemaphoreDelete_partial_solve_wit_26.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_27_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_27_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_27_pure : _SemaphoreDelete_partial_solve_wit_27_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_27": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_27",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_27 : _SemaphoreDelete_partial_solve_wit_27.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_28_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_28_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_28_pure : _SemaphoreDelete_partial_solve_wit_28_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_28": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_28",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_28 : _SemaphoreDelete_partial_solve_wit_28.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_29": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_29",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_29 : _SemaphoreDelete_partial_solve_wit_29.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_30": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_30",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_30 : _SemaphoreDelete_partial_solve_wit_30.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_31": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_31",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_31 : _SemaphoreDelete_partial_solve_wit_31.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_32": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_32",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_32 : _SemaphoreDelete_partial_solve_wit_32.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_33_pure": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_33_pure",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_33_pure : _SemaphoreDelete_partial_solve_wit_33_pure.\n"
      },
      "proof_of__SemaphoreDelete_partial_solve_wit_33": {
        "name": "proof_of__SemaphoreDelete_partial_solve_wit_33",
        "parent": null,
        "statement": "Lemma proof_of__SemaphoreDelete_partial_solve_wit_33 : _SemaphoreDelete_partial_solve_wit_33.\n"
      }
    },
    "top_level": [
      "proof_of__SemaphoreDelete_entail_wit_2_1",
      "proof_of__SemaphoreDelete_entail_wit_2_2",
      "proof_of__SemaphoreDelete_entail_wit_3_1",
      "proof_of__SemaphoreDelete_entail_wit_3_2",
      "proof_of__SemaphoreDelete_entail_wit_4_1",
      "proof_of__SemaphoreDelete_entail_wit_4_2",
      "proof_of__SemaphoreDelete_entail_wit_4_3",
      "proof_of__SemaphoreDelete_entail_wit_4_4",
      "proof_of__SemaphoreDelete_return_wit_2",
      "proof_of__SemaphoreDelete_partial_solve_wit_3_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_10_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_17_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_18_pure",
      "proof_of__SemaphoreDelete_which_implies_wit_1",
      "proof_of__SemaphoreDelete_which_implies_wit_2",
      "proof_of__SemaphoreDelete_which_implies_wit_3",
      "proof_of__SemaphoreDelete_which_implies_wit_4",
      "proof_of__SemaphoreDelete_which_implies_wit_5",
      "proof_of__SemaphoreDelete_which_implies_wit_6",
      "proof_of__SemaphoreDelete_which_implies_wit_7",
      "proof_of__SemaphoreDelete_which_implies_wit_8",
      "proof_of__SemaphoreDelete_which_implies_wit_9",
      "proof_of__SemaphoreDelete_safety_wit_1",
      "proof_of__SemaphoreDelete_safety_wit_2",
      "proof_of__SemaphoreDelete_safety_wit_3",
      "proof_of__SemaphoreDelete_safety_wit_4",
      "proof_of__SemaphoreDelete_safety_wit_5",
      "proof_of__SemaphoreDelete_safety_wit_6",
      "proof_of__SemaphoreDelete_safety_wit_7",
      "proof_of__SemaphoreDelete_safety_wit_8",
      "proof_of__SemaphoreDelete_safety_wit_9",
      "proof_of__SemaphoreDelete_safety_wit_10",
      "proof_of__SemaphoreDelete_safety_wit_11",
      "proof_of__SemaphoreDelete_safety_wit_12",
      "proof_of__SemaphoreDelete_safety_wit_13",
      "proof_of__SemaphoreDelete_safety_wit_14",
      "proof_of__SemaphoreDelete_safety_wit_15",
      "proof_of__SemaphoreDelete_safety_wit_16",
      "proof_of__SemaphoreDelete_entail_wit_1",
      "proof_of__SemaphoreDelete_entail_wit_5_1",
      "proof_of__SemaphoreDelete_entail_wit_5_2",
      "proof_of__SemaphoreDelete_entail_wit_6_1",
      "proof_of__SemaphoreDelete_entail_wit_6_2",
      "proof_of__SemaphoreDelete_return_wit_1",
      "proof_of__SemaphoreDelete_return_wit_3",
      "proof_of__SemaphoreDelete_return_wit_4",
      "proof_of__SemaphoreDelete_partial_solve_wit_1",
      "proof_of__SemaphoreDelete_partial_solve_wit_2",
      "proof_of__SemaphoreDelete_partial_solve_wit_3",
      "proof_of__SemaphoreDelete_partial_solve_wit_4_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_4",
      "proof_of__SemaphoreDelete_partial_solve_wit_5",
      "proof_of__SemaphoreDelete_partial_solve_wit_6_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_6",
      "proof_of__SemaphoreDelete_partial_solve_wit_7_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_7",
      "proof_of__SemaphoreDelete_partial_solve_wit_8",
      "proof_of__SemaphoreDelete_partial_solve_wit_9_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_9",
      "proof_of__SemaphoreDelete_partial_solve_wit_10",
      "proof_of__SemaphoreDelete_partial_solve_wit_11_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_11",
      "proof_of__SemaphoreDelete_partial_solve_wit_12_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_12",
      "proof_of__SemaphoreDelete_partial_solve_wit_13_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_13",
      "proof_of__SemaphoreDelete_partial_solve_wit_14_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_14",
      "proof_of__SemaphoreDelete_partial_solve_wit_15_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_15",
      "proof_of__SemaphoreDelete_partial_solve_wit_16_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_16",
      "proof_of__SemaphoreDelete_partial_solve_wit_17",
      "proof_of__SemaphoreDelete_partial_solve_wit_18",
      "proof_of__SemaphoreDelete_partial_solve_wit_19_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_19",
      "proof_of__SemaphoreDelete_partial_solve_wit_20_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_20",
      "proof_of__SemaphoreDelete_partial_solve_wit_21_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_21",
      "proof_of__SemaphoreDelete_partial_solve_wit_22_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_22",
      "proof_of__SemaphoreDelete_partial_solve_wit_23",
      "proof_of__SemaphoreDelete_partial_solve_wit_24",
      "proof_of__SemaphoreDelete_partial_solve_wit_25",
      "proof_of__SemaphoreDelete_partial_solve_wit_26",
      "proof_of__SemaphoreDelete_partial_solve_wit_27_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_27",
      "proof_of__SemaphoreDelete_partial_solve_wit_28_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_28",
      "proof_of__SemaphoreDelete_partial_solve_wit_29",
      "proof_of__SemaphoreDelete_partial_solve_wit_30",
      "proof_of__SemaphoreDelete_partial_solve_wit_31",
      "proof_of__SemaphoreDelete_partial_solve_wit_32",
      "proof_of__SemaphoreDelete_partial_solve_wit_33_pure",
      "proof_of__SemaphoreDelete_partial_solve_wit_33"
    ],
    "split_goals": {
      "proof_of__SemaphoreDelete_entail_wit_2_1": [
        "proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_1",
        "proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_2",
        "proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_spatial"
      ],
      "proof_of__SemaphoreDelete_entail_wit_2_2": [
        "proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_1",
        "proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_2",
        "proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_spatial"
      ],
      "proof_of__SemaphoreDelete_entail_wit_3_1": [
        "proof_of__SemaphoreDelete_entail_wit_3_1_split_goal_1"
      ],
      "proof_of__SemaphoreDelete_entail_wit_3_2": [],
      "proof_of__SemaphoreDelete_entail_wit_4_1": [],
      "proof_of__SemaphoreDelete_entail_wit_4_2": [],
      "proof_of__SemaphoreDelete_entail_wit_4_3": [],
      "proof_of__SemaphoreDelete_entail_wit_4_4": [],
      "proof_of__SemaphoreDelete_return_wit_2": [
        "proof_of__SemaphoreDelete_return_wit_2_split_goal_1"
      ],
      "proof_of__SemaphoreDelete_partial_solve_wit_3_pure": [
        "proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1",
        "proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2"
      ],
      "proof_of__SemaphoreDelete_partial_solve_wit_10_pure": [
        "proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_1",
        "proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_2"
      ],
      "proof_of__SemaphoreDelete_partial_solve_wit_17_pure": [
        "proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1",
        "proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2",
        "proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3"
      ],
      "proof_of__SemaphoreDelete_partial_solve_wit_18_pure": [
        "proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1",
        "proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2",
        "proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3"
      ],
      "proof_of__SemaphoreDelete_which_implies_wit_1": [
        "proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial"
      ],
      "proof_of__SemaphoreDelete_which_implies_wit_2": [],
      "proof_of__SemaphoreDelete_which_implies_wit_3": [
        "proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial"
      ],
      "proof_of__SemaphoreDelete_which_implies_wit_4": [
        "proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_1",
        "proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial"
      ],
      "proof_of__SemaphoreDelete_which_implies_wit_5": [
        "proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial"
      ],
      "proof_of__SemaphoreDelete_which_implies_wit_6": [
        "proof_of__SemaphoreDelete_which_implies_wit_6_split_goal_spatial"
      ],
      "proof_of__SemaphoreDelete_which_implies_wit_7": [],
      "proof_of__SemaphoreDelete_which_implies_wit_8": [
        "proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_1",
        "proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_spatial"
      ],
      "proof_of__SemaphoreDelete_which_implies_wit_9": [
        "proof_of__SemaphoreDelete_which_implies_wit_9_split_goal_spatial"
      ],
      "proof_of__SemaphoreDelete_safety_wit_1": [],
      "proof_of__SemaphoreDelete_safety_wit_2": [],
      "proof_of__SemaphoreDelete_safety_wit_3": [],
      "proof_of__SemaphoreDelete_safety_wit_4": [],
      "proof_of__SemaphoreDelete_safety_wit_5": [],
      "proof_of__SemaphoreDelete_safety_wit_6": [],
      "proof_of__SemaphoreDelete_safety_wit_7": [],
      "proof_of__SemaphoreDelete_safety_wit_8": [],
      "proof_of__SemaphoreDelete_safety_wit_9": [],
      "proof_of__SemaphoreDelete_safety_wit_10": [],
      "proof_of__SemaphoreDelete_safety_wit_11": [],
      "proof_of__SemaphoreDelete_safety_wit_12": [],
      "proof_of__SemaphoreDelete_safety_wit_13": [],
      "proof_of__SemaphoreDelete_safety_wit_14": [],
      "proof_of__SemaphoreDelete_safety_wit_15": [],
      "proof_of__SemaphoreDelete_safety_wit_16": [],
      "proof_of__SemaphoreDelete_entail_wit_1": [],
      "proof_of__SemaphoreDelete_entail_wit_5_1": [],
      "proof_of__SemaphoreDelete_entail_wit_5_2": [],
      "proof_of__SemaphoreDelete_entail_wit_6_1": [],
      "proof_of__SemaphoreDelete_entail_wit_6_2": [],
      "proof_of__SemaphoreDelete_return_wit_1": [],
      "proof_of__SemaphoreDelete_return_wit_3": [],
      "proof_of__SemaphoreDelete_return_wit_4": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_1": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_2": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_3": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_4_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_4": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_5": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_6_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_6": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_7_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_7": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_8": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_9_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_9": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_10": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_11_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_11": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_12_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_12": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_13_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_13": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_14_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_14": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_15_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_15": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_16_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_16": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_17": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_18": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_19_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_19": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_20_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_20": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_21_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_21": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_22_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_22": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_23": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_24": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_25": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_26": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_27_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_27": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_28_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_28": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_29": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_30": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_31": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_32": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_33_pure": [],
      "proof_of__SemaphoreDelete_partial_solve_wit_33": []
    }
  },
  "max_witnesses_per_group": 12,
  "annotation_comparisons": [
    {
      "source": {
        "attempt": "SemaphoreDelete-vc-checking-r1",
        "name": "proof_of__SemaphoreDelete_entail_wit_4_2",
        "annotation_location": "after IdRemoveObj and DoubleLinkListRmNode, before CriticalAreaUnLock; resched == 0 retirement assertion"
      },
      "current": [
        "proof_of__SemaphoreDelete_entail_wit_4_2",
        "proof_of__SemaphoreDelete_which_implies_wit_7"
      ],
      "old_gap": "The old semaphore ID uniqueness was lost when IdRemoveObj consumed the complete old manager; post-manager validity cannot identify the returned node because deletion removes every matching ID.",
      "change": "Before IdRemoveObj the os_inv extraction now derives NoDup(map semaphore_id drained.os_semaphores), which remains a pure frame through deregistration and management-DLL removal. The current retirement VC has this NoDup premise; the extraction obligation establishes it from the unchanged full invariant.",
      "result": "resolved"
    },
    {
      "source": {
        "attempt": "SemaphoreDelete-vc-checking-r1",
        "name": "proof_of__SemaphoreDelete_entail_wit_4_4",
        "annotation_location": "after IdRemoveObj and DoubleLinkListRmNode, before CriticalAreaUnLock; resched == 1 retirement assertion"
      },
      "current": [
        "proof_of__SemaphoreDelete_entail_wit_4_4",
        "proof_of__SemaphoreDelete_which_implies_wit_7"
      ],
      "old_gap": "The old semaphore ID uniqueness was lost when IdRemoveObj consumed the complete old manager; post-manager validity cannot identify the returned node because deletion removes every matching ID.",
      "change": "Before IdRemoveObj the os_inv extraction now derives NoDup(map semaphore_id drained.os_semaphores), which remains a pure frame through deregistration and management-DLL removal. The current retirement VC has this NoDup premise; the extraction obligation establishes it from the unchanged full invariant.",
      "result": "resolved"
    }
  ]
}
```

Use exact argv and cwd. A shell-only tool must quote arguments for its actual shell. Keep the terminal session until exit; checks need exit code 0 and JSON passed.

```json
[
  {
    "argv": [
      "/home/xinra/qcp-binary-democases/.venv/bin/python",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1/tools/qcp-controller/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos/ksemaphoredelete-trial-261025-1",
      "coq-debug",
      "--run",
      "SemaphoreDelete-20261030135715",
      "--round",
      "SemaphoreDelete-vc-checking-r3"
    ],
    "cwd": "/home/xinra/crtos/ksemaphoredelete-trial-261025-1"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
