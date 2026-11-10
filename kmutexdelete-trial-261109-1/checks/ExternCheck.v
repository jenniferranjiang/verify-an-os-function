Require Import KMutexDeleteTrial.lib.KMutexDelete.
Require Import Coq.ZArith.ZArith Coq.Lists.List SimpleC.SL.Mem.
Import IDNode DLL Monad MonadNotation.
Local Open Scope monad.
Check StableGlobalState.
Check VarGlobalState.
Check TaskDescriptorAbs.
Check TaskSchedMemberAbs.
Check TaskStatus.
Check TaskState.
Check MutexAbs.
Check StableIdmanager.
Check VarIdmanager.
Check @DL_Node.
Check @option.
Check unit.
Check MonadErr.M.
Check (idmax : StableIdmanager -> Z).
Check (hoffset : StableIdmanager -> Z).
Check (id_map : StableIdmanager -> Z).
Check (htable : StableIdmanager -> Z).
Check (tsmStat : TaskSchedMemberAbs -> TaskStatus).
Check (tdSchedMember : TaskDescriptorAbs -> TaskSchedMemberAbs).
Check (task_desc_map : TaskState -> addr -> option TaskDescriptorAbs).
Check (os_tasks : VarGlobalState -> TaskState).
Check (os_mutexes : VarGlobalState -> list MutexAbs).
Check @Some.
Check @None.
Check tt.
Check @nil.
Check @cons.
Check @app.
Check true.
Check false.
Check (@Build_DL_Node : forall A, A -> addr -> DL_Node A).
Check (@store_dll : forall A, (addr -> A -> Assertion) -> addr -> list (DL_Node A) -> Assertion).
Check (store_node_self_linked : addr -> Assertion).
Check (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion).
Check (store_idmanager_found : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion).
Check (idmanager_query : VarIdmanager -> Z -> bool).
Check (idmanager_contains : StableIdmanager -> VarIdmanager -> Z -> addr -> Prop).
Check (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager).
Check (ALIGN_SIZE : Z).
Check (addr_aligned : addr -> Z -> Prop).
Check (TSK_SUSPEND : TaskStatus).
Check (sched_link_of : addr -> addr).
Check (mutex_pending_head : addr -> addr).
Check (MutexRaw : addr -> Assertion).
Check (mutex_delete_find_addr : addr -> list MutexAbs -> option MutexAbs).
Check (get_task_with_idnode_success : StableGlobalState -> VarGlobalState -> Z -> addr -> Prop).
Check (ktask_wakeup_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop).
Check (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop).
Check (@safeExec : forall Sigma A, (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop).
Check (@MonadErr.ret : forall Sigma A, A -> program Sigma A).
Check (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion).
Check (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop).
Check (os_inv : StableGlobalState -> VarGlobalState -> Assertion).
Check (mutex_resume_entry_condition : StableGlobalState -> addr -> (VarGlobalState -> Prop) -> Prop).
Check (mutex_detach_entry_condition : StableGlobalState -> addr -> (VarGlobalState -> Prop) -> Prop).
Check (abs_linklist_resume_all : StableGlobalState -> addr -> program (VarGlobalState -> Prop) Z).
Check (abs_mutex_delete : StableGlobalState -> addr -> program (VarGlobalState -> Prop) unit).
Check (abs_kmutex_delete : StableGlobalState -> Z -> program (VarGlobalState -> Prop) unit).
