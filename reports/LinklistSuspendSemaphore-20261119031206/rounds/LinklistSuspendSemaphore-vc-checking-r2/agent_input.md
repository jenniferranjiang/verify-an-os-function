# vc-checking

Read /home/xinra/qcp-binary-democases/.agents/skills/vc-checking/SKILL.md and its required documents.

Canonical sources are read-only. Add Show only to the debug copy. Follow the structural scan and split-first workflow. Plan array order defines dispatch order.

```json
{
  "attempt": "LinklistSuspendSemaphore-vc-checking-r2",
  "round": "LinklistSuspendSemaphore-vc-checking-r2",
  "main_root": "/home/xinra/crtos-verify",
  "target_files": {
    "c_file": "annotated_C/src/kernel/pendlist/LinklistSuspend.c",
    "formal_directory": "VC/pendlist",
    "formal_case_lib": "VC/pendlist/LinklistSuspendSemaphore_lib.v",
    "goal_file": "VC/pendlist/LinklistSuspendSemaphore_goal.v",
    "proof_auto_file": "VC/pendlist/LinklistSuspendSemaphore_proof_auto.v",
    "proof_manual_file": "VC/pendlist/LinklistSuspendSemaphore_proof_manual.v",
    "goal_check_file": "VC/pendlist/LinklistSuspendSemaphore_goal_check.v",
    "case_name": "LinklistSuspendSemaphore",
    "active_case_theory": "CRTOS_Verify.VC.pendlist"
  },
  "formal_case_lib_policy": "absent",
  "report": "/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-checking-r2/agent_report.json",
  "notes": "/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-checking-r2/agent_output.md",
  "feedback": null,
  "feedback_sources": [],
  "previous_attempt": null,
  "group_plan": "/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-checking-r2/group_plan.json",
  "debug_manual": "/home/xinra/crtos-verify/reports/LinklistSuspendSemaphore-20261119031206/rounds/LinklistSuspendSemaphore-vc-checking-r2/LinklistSuspendSemaphore_proof_manual.v",
  "obligations": {
    "by_name": {
      "proof_of_LinklistSuspend_entail_wit_1_1": {
        "name": "proof_of_LinklistSuspend_entail_wit_1_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_1_1 : LinklistSuspend_entail_wit_1_1.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_1_2": {
        "name": "proof_of_LinklistSuspend_entail_wit_1_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_1_2 : LinklistSuspend_entail_wit_1_2.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_2_1": {
        "name": "proof_of_LinklistSuspend_entail_wit_2_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_2_1 : LinklistSuspend_entail_wit_2_1.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_2_2": {
        "name": "proof_of_LinklistSuspend_entail_wit_2_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_2_2 : LinklistSuspend_entail_wit_2_2.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_3": {
        "name": "proof_of_LinklistSuspend_entail_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_3 : LinklistSuspend_entail_wit_3.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_4_1": {
        "name": "proof_of_LinklistSuspend_entail_wit_4_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_4_1 : LinklistSuspend_entail_wit_4_1.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_4_2": {
        "name": "proof_of_LinklistSuspend_entail_wit_4_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_4_2 : LinklistSuspend_entail_wit_4_2.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_5": {
        "name": "proof_of_LinklistSuspend_entail_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_5 : LinklistSuspend_entail_wit_5.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_6_1": {
        "name": "proof_of_LinklistSuspend_entail_wit_6_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_6_1 : LinklistSuspend_entail_wit_6_1.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_6_2": {
        "name": "proof_of_LinklistSuspend_entail_wit_6_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_6_2 : LinklistSuspend_entail_wit_6_2.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_7_1": {
        "name": "proof_of_LinklistSuspend_entail_wit_7_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_7_1 : LinklistSuspend_entail_wit_7_1.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_7_2": {
        "name": "proof_of_LinklistSuspend_entail_wit_7_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_7_2 : LinklistSuspend_entail_wit_7_2.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_7_3": {
        "name": "proof_of_LinklistSuspend_entail_wit_7_3",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_7_3 : LinklistSuspend_entail_wit_7_3.\n"
      },
      "proof_of_LinklistSuspend_entail_wit_7_4": {
        "name": "proof_of_LinklistSuspend_entail_wit_7_4",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_entail_wit_7_4 : LinklistSuspend_entail_wit_7_4.\n"
      },
      "proof_of_LinklistSuspend_return_wit_1_split_goal_1": {
        "name": "proof_of_LinklistSuspend_return_wit_1_split_goal_1",
        "parent": "proof_of_LinklistSuspend_return_wit_1",
        "statement": "Lemma proof_of_LinklistSuspend_return_wit_1_split_goal_1 : LinklistSuspend_return_wit_1_split_goal_1.\n"
      },
      "proof_of_LinklistSuspend_return_wit_1": {
        "name": "proof_of_LinklistSuspend_return_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_return_wit_1 : LinklistSuspend_return_wit_1.\n"
      },
      "proof_of_LinklistSuspend_return_wit_2_split_goal_1": {
        "name": "proof_of_LinklistSuspend_return_wit_2_split_goal_1",
        "parent": "proof_of_LinklistSuspend_return_wit_2",
        "statement": "Lemma proof_of_LinklistSuspend_return_wit_2_split_goal_1 : LinklistSuspend_return_wit_2_split_goal_1.\n"
      },
      "proof_of_LinklistSuspend_return_wit_2": {
        "name": "proof_of_LinklistSuspend_return_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_return_wit_2 : LinklistSuspend_return_wit_2.\n"
      },
      "proof_of_LinklistSuspend_return_wit_3_split_goal_1": {
        "name": "proof_of_LinklistSuspend_return_wit_3_split_goal_1",
        "parent": "proof_of_LinklistSuspend_return_wit_3",
        "statement": "Lemma proof_of_LinklistSuspend_return_wit_3_split_goal_1 : LinklistSuspend_return_wit_3_split_goal_1.\n"
      },
      "proof_of_LinklistSuspend_return_wit_3": {
        "name": "proof_of_LinklistSuspend_return_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_return_wit_3 : LinklistSuspend_return_wit_3.\n"
      },
      "proof_of_LinklistSuspend_return_wit_4_split_goal_1": {
        "name": "proof_of_LinklistSuspend_return_wit_4_split_goal_1",
        "parent": "proof_of_LinklistSuspend_return_wit_4",
        "statement": "Lemma proof_of_LinklistSuspend_return_wit_4_split_goal_1 : LinklistSuspend_return_wit_4_split_goal_1.\n"
      },
      "proof_of_LinklistSuspend_return_wit_4": {
        "name": "proof_of_LinklistSuspend_return_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_return_wit_4 : LinklistSuspend_return_wit_4.\n"
      },
      "proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial": {
        "name": "proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial",
        "parent": "proof_of_LinklistSuspend_which_implies_wit_1",
        "statement": "Lemma proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial : LinklistSuspend_which_implies_wit_1_split_goal_spatial.\n"
      },
      "proof_of_LinklistSuspend_which_implies_wit_1": {
        "name": "proof_of_LinklistSuspend_which_implies_wit_1",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_which_implies_wit_1 : LinklistSuspend_which_implies_wit_1.\n"
      },
      "proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial": {
        "name": "proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial",
        "parent": "proof_of_LinklistSuspend_which_implies_wit_2",
        "statement": "Lemma proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial : LinklistSuspend_which_implies_wit_2_split_goal_spatial.\n"
      },
      "proof_of_LinklistSuspend_which_implies_wit_2": {
        "name": "proof_of_LinklistSuspend_which_implies_wit_2",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_which_implies_wit_2 : LinklistSuspend_which_implies_wit_2.\n"
      },
      "proof_of_LinklistSuspend_which_implies_wit_3": {
        "name": "proof_of_LinklistSuspend_which_implies_wit_3",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_which_implies_wit_3 : LinklistSuspend_which_implies_wit_3.\n"
      },
      "proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial": {
        "name": "proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial",
        "parent": "proof_of_LinklistSuspend_which_implies_wit_4",
        "statement": "Lemma proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial : LinklistSuspend_which_implies_wit_4_split_goal_spatial.\n"
      },
      "proof_of_LinklistSuspend_which_implies_wit_4": {
        "name": "proof_of_LinklistSuspend_which_implies_wit_4",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_which_implies_wit_4 : LinklistSuspend_which_implies_wit_4.\n"
      },
      "proof_of_LinklistSuspend_which_implies_wit_5": {
        "name": "proof_of_LinklistSuspend_which_implies_wit_5",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_which_implies_wit_5 : LinklistSuspend_which_implies_wit_5.\n"
      },
      "proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial": {
        "name": "proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial",
        "parent": "proof_of_LinklistSuspend_which_implies_wit_6",
        "statement": "Lemma proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial : LinklistSuspend_which_implies_wit_6_split_goal_spatial.\n"
      },
      "proof_of_LinklistSuspend_which_implies_wit_6": {
        "name": "proof_of_LinklistSuspend_which_implies_wit_6",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_which_implies_wit_6 : LinklistSuspend_which_implies_wit_6.\n"
      },
      "proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial": {
        "name": "proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial",
        "parent": "proof_of_LinklistSuspend_which_implies_wit_7",
        "statement": "Lemma proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial : LinklistSuspend_which_implies_wit_7_split_goal_spatial.\n"
      },
      "proof_of_LinklistSuspend_which_implies_wit_7": {
        "name": "proof_of_LinklistSuspend_which_implies_wit_7",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_which_implies_wit_7 : LinklistSuspend_which_implies_wit_7.\n"
      },
      "proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic": {
        "name": "proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic",
        "parent": null,
        "statement": "Lemma proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic : LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic.\n"
      }
    },
    "top_level": [
      "proof_of_LinklistSuspend_entail_wit_1_1",
      "proof_of_LinklistSuspend_entail_wit_1_2",
      "proof_of_LinklistSuspend_entail_wit_2_1",
      "proof_of_LinklistSuspend_entail_wit_2_2",
      "proof_of_LinklistSuspend_entail_wit_3",
      "proof_of_LinklistSuspend_entail_wit_4_1",
      "proof_of_LinklistSuspend_entail_wit_4_2",
      "proof_of_LinklistSuspend_entail_wit_5",
      "proof_of_LinklistSuspend_entail_wit_6_1",
      "proof_of_LinklistSuspend_entail_wit_6_2",
      "proof_of_LinklistSuspend_entail_wit_7_1",
      "proof_of_LinklistSuspend_entail_wit_7_2",
      "proof_of_LinklistSuspend_entail_wit_7_3",
      "proof_of_LinklistSuspend_entail_wit_7_4",
      "proof_of_LinklistSuspend_return_wit_1",
      "proof_of_LinklistSuspend_return_wit_2",
      "proof_of_LinklistSuspend_return_wit_3",
      "proof_of_LinklistSuspend_return_wit_4",
      "proof_of_LinklistSuspend_which_implies_wit_1",
      "proof_of_LinklistSuspend_which_implies_wit_2",
      "proof_of_LinklistSuspend_which_implies_wit_3",
      "proof_of_LinklistSuspend_which_implies_wit_4",
      "proof_of_LinklistSuspend_which_implies_wit_5",
      "proof_of_LinklistSuspend_which_implies_wit_6",
      "proof_of_LinklistSuspend_which_implies_wit_7",
      "proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic"
    ],
    "split_goals": {
      "proof_of_LinklistSuspend_entail_wit_1_1": [],
      "proof_of_LinklistSuspend_entail_wit_1_2": [],
      "proof_of_LinklistSuspend_entail_wit_2_1": [],
      "proof_of_LinklistSuspend_entail_wit_2_2": [],
      "proof_of_LinklistSuspend_entail_wit_3": [],
      "proof_of_LinklistSuspend_entail_wit_4_1": [],
      "proof_of_LinklistSuspend_entail_wit_4_2": [],
      "proof_of_LinklistSuspend_entail_wit_5": [],
      "proof_of_LinklistSuspend_entail_wit_6_1": [],
      "proof_of_LinklistSuspend_entail_wit_6_2": [],
      "proof_of_LinklistSuspend_entail_wit_7_1": [],
      "proof_of_LinklistSuspend_entail_wit_7_2": [],
      "proof_of_LinklistSuspend_entail_wit_7_3": [],
      "proof_of_LinklistSuspend_entail_wit_7_4": [],
      "proof_of_LinklistSuspend_return_wit_1": [
        "proof_of_LinklistSuspend_return_wit_1_split_goal_1"
      ],
      "proof_of_LinklistSuspend_return_wit_2": [
        "proof_of_LinklistSuspend_return_wit_2_split_goal_1"
      ],
      "proof_of_LinklistSuspend_return_wit_3": [
        "proof_of_LinklistSuspend_return_wit_3_split_goal_1"
      ],
      "proof_of_LinklistSuspend_return_wit_4": [
        "proof_of_LinklistSuspend_return_wit_4_split_goal_1"
      ],
      "proof_of_LinklistSuspend_which_implies_wit_1": [
        "proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial"
      ],
      "proof_of_LinklistSuspend_which_implies_wit_2": [
        "proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial"
      ],
      "proof_of_LinklistSuspend_which_implies_wit_3": [],
      "proof_of_LinklistSuspend_which_implies_wit_4": [
        "proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial"
      ],
      "proof_of_LinklistSuspend_which_implies_wit_5": [],
      "proof_of_LinklistSuspend_which_implies_wit_6": [
        "proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial"
      ],
      "proof_of_LinklistSuspend_which_implies_wit_7": [
        "proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial"
      ],
      "proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic": []
    }
  },
  "max_witnesses_per_group": 12,
  "annotation_comparisons": [
    {
      "source": {
        "attempt": "LinklistSuspendSemaphore-vc-checking-r1",
        "name": "proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic",
        "annotation_location": "LinklistSuspend canonical C formal imports / generated shallow FuncSig and Spec prelude"
      },
      "current": [
        "proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic"
      ],
      "old_gap": "Generated shallow FuncSig and Spec syntax could not elaborate because the existing SimpleCtypeNotations module was not imported.",
      "change": "Added only a canonical C formal Import of SimpleC.CoreLang.CTypes.SimpleCtypeNotations and regenerated through symexec; all four generated files are byte-identical to the r2-before inputs after removing that import line.",
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
      "LinklistSuspendSemaphore-20261119031206",
      "--round",
      "LinklistSuspendSemaphore-vc-checking-r2"
    ],
    "cwd": "/home/xinra/crtos-verify"
  }
]
```

Write the terminal report last, stop writing, and notify main to finalize.
