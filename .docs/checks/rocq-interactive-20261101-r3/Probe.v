From CRTOS_Verify.VC Require Import SemaphoreDelete_goal.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
From CRTOS_Verify.lib Require Import KSemaphoreDelete.
Local Open Scope sac.
Lemma qcp_mcp_environment_probe : forall sg st,
  os_inv sg st |-- os_inv sg st.
Proof.
Abort.
