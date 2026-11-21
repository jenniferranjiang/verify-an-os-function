# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "LinklistResumeSemaphore-vc-checking-r2",
  "round": "LinklistResumeSemaphore-vc-checking-r2",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/semaphore/LinklistResume.c",
    "formal_directory": "VC/semaphore",
    "formal_case_lib": "VC/semaphore/LinklistResumeSemaphore_lib.v",
    "goal_file": "VC/semaphore/LinklistResumeSemaphore_goal.v",
    "proof_auto_file": "VC/semaphore/LinklistResumeSemaphore_proof_auto.v",
    "proof_manual_file": "VC/semaphore/LinklistResumeSemaphore_proof_manual.v",
    "goal_check_file": "VC/semaphore/LinklistResumeSemaphore_goal_check.v",
    "case_name": "LinklistResumeSemaphore",
    "active_case_theory": "CRTOS_Verify.VC.semaphore"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-checking-r2/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-checking-r2/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-checking-r2/group_plan.json",
  "debug_manual": "/home/xinra/crtos-verify/reports/LinklistResumeSemaphore-20261119085215/rounds/LinklistResumeSemaphore-vc-checking-r2/LinklistResumeSemaphore_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_LinklistResume_return_wit_1_split_goal_1": {
        "name": "proof_of_LinklistResume_return_wit_1_split_goal_1",
        "parent": "proof_of_LinklistResume_return_wit_1",
        "statement": "Lemma proof_of_LinklistResume_return_wit_1_split_goal_1 : LinklistResume_return_wit_1_split_goal_1.\n"
      },
      "proof_of_LinklistResume_return_wit_1": {
        "name": "proof_of_LinklistResume_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResume_return_wit_1 : LinklistResume_return_wit_1.\n"
      },
      "proof_of_LinklistResume_which_implies_wit_1": {
        "name": "proof_of_LinklistResume_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResume_which_implies_wit_1 : LinklistResume_which_implies_wit_1.\n"
      },
      "proof_of_LinklistResume_which_implies_wit_2_split_goal_spatial": {
        "name": "proof_of_LinklistResume_which_implies_wit_2_split_goal_spatial",
        "parent": "proof_of_LinklistResume_which_implies_wit_2",
        "statement": "Lemma proof_of_LinklistResume_which_implies_wit_2_split_goal_spatial : LinklistResume_which_implies_wit_2_split_goal_spatial.\n"
      },
      "proof_of_LinklistResume_which_implies_wit_2": {
        "name": "proof_of_LinklistResume_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResume_which_implies_wit_2 : LinklistResume_which_implies_wit_2.\n"
      },
      "proof_of_LinklistResume_which_implies_wit_3": {
        "name": "proof_of_LinklistResume_which_implies_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResume_which_implies_wit_3 : LinklistResume_which_implies_wit_3.\n"
      },
      "proof_of_LinklistResume_which_implies_wit_4_split_goal_spatial": {
        "name": "proof_of_LinklistResume_which_implies_wit_4_split_goal_spatial",
        "parent": "proof_of_LinklistResume_which_implies_wit_4",
        "statement": "Lemma proof_of_LinklistResume_which_implies_wit_4_split_goal_spatial : LinklistResume_which_implies_wit_4_split_goal_spatial.\n"
      },
      "proof_of_LinklistResume_which_implies_wit_4": {
        "name": "proof_of_LinklistResume_which_implies_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_LinklistResume_which_implies_wit_4 : LinklistResume_which_implies_wit_4.\n"
      }
    },
    "top_level": [
      "proof_of_LinklistResume_return_wit_1",
      "proof_of_LinklistResume_which_implies_wit_1",
      "proof_of_LinklistResume_which_implies_wit_2",
      "proof_of_LinklistResume_which_implies_wit_3",
      "proof_of_LinklistResume_which_implies_wit_4"
    ],
    "split_goals": {
      "proof_of_LinklistResume_return_wit_1": [
        "proof_of_LinklistResume_return_wit_1_split_goal_1"
      ],
      "proof_of_LinklistResume_which_implies_wit_1": [],
      "proof_of_LinklistResume_which_implies_wit_2": [
        "proof_of_LinklistResume_which_implies_wit_2_split_goal_spatial"
      ],
      "proof_of_LinklistResume_which_implies_wit_3": [],
      "proof_of_LinklistResume_which_implies_wit_4": [
        "proof_of_LinklistResume_which_implies_wit_4_split_goal_spatial"
      ]
    }
  },
  "max_witnesses_per_group": 12,
  "annotation_comparisons": [
    {
      "source": {
        "attempt": "LinklistResumeSemaphore-vc-checking-r1",
        "name": "proof_of_LinklistResume_which_implies_wit_1",
        "annotation_location": "annotated_C/src/kernel/semaphore/LinklistResume.c:50-57 first which implies (pending head field borrow)"
      },
      "current": [
        "proof_of_LinklistResume_which_implies_wit_1"
      ],
      "old_gap": "Generated (list : Z) binder shadows Coq list type in existential tail, causing actual goal load failure.",
      "change": "Add unchanged C-parameter bridge list == list@pre on both sides of first local view. Native generator now uses list_pre binder; executable body and public/callee specs unchanged.",
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
      "/usr/bin/python3",
      "/home/xinra/qcp-binary-democases/.agents/scripts/verification-orchestrator/controller.py",
      "--main-root",
      "/home/xinra/crtos-verify",
      "coq-debug",
      "--run",
      "LinklistResumeSemaphore-20261119085215",
      "--round",
      "LinklistResumeSemaphore-vc-checking-r2"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
