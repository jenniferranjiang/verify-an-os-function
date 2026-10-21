# IdInsertObj annotation attempt 1

Signature: `int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)`.
Preconditions: nonzero manager and detached node; exact manager ownership and original detached ID/link values, as stated in the frozen accepted contract.
Output: when the manager is full return -1 and preserve both inputs exactly; otherwise return the least free identifier and own the manager after adding that identifier and linking this node.
Rocq relation: the accepted `idmanager_full` / `idmanager_min_free_id` branch distinction, with `store_idmanager`, `store_idmanager_allocated_unlinked`, `idmanager_add`, `idmanager_link` and `store_sem_id_detached` carrying the accepted states. No new definitions or contracts.

Added invariants for the two single-pass macro loops and their unreachable null traps. Removed body call-where hints. Expose the detached fields before the ID write and fold the updated node before InsertObj; the allocated manager and minimum-free property stay live. Frozen declarations and function contract remain unchanged. No earlier failed VCs to compare. No preexisting generated manual or case library exists.

Validation: the exact handoff `formal-case-lib-design` command returned exit 0 and JSON passed (skipped because policy is absent). The exact symexec command returned exit 0 and JSON passed; publication committed all four generated files. Reviewed the current manual and generated goal interfaces: call witnesses use the accepted manager/node states; negative successful-allocation branches retain `idmanager_min_free_id` and are contradictory; node field expansion/folding and unsigned-short bounds remain explicit proof obligations. The goal-check interface has 25 obligations. Generated proof skeletons are unproved and are left entirely to the proving phase. No handwritten proof, shared predicate, frozen contract, or C executable statement was changed.

This first attempt has no failed VC feedback and therefore no VC comparisons. No case library was created. Ready for main-owned finalize-delivery.
