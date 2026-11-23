# Hand-maintained build, following ../crtosverify/Makefile.
# Edit file lists and load paths here; do not overwrite with coq_makefile.
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:

CURRENT_DIR ?= .
OPAM_EXEC ?= tools/rocq/launch-mcp run
COQBIN ?=
SL_DIR ?= ../qcp-binary-democases/Rocq/

-include CONFIGURE

COQC = $(OPAM_EXEC) $(COQBIN)coqc
COQDEP = $(OPAM_EXEC) $(COQBIN)coqdep

# Keep the current project's library namespaces and module-based VC layout.
COQ_FLAG = -R $(SL_DIR)Verification SimpleC.Verification -R $(SL_DIR)flocq/src Flocq -R $(SL_DIR)SeparationLogic SimpleC.SL -R $(SL_DIR)unifysl Logic -R $(SL_DIR)sets SetsClass -R $(SL_DIR)compcert_lib compcert.lib -R $(SL_DIR)auxlibs AUXLib -R $(SL_DIR)examples SimpleC.EE -R $(SL_DIR)stdlib SimpleC.StdLib -R $(SL_DIR)StrategyLib SimpleC.StrategyLib -R $(SL_DIR)Common SimpleC.Common -R $(SL_DIR)CoreLang SimpleC.CoreLang -R $(SL_DIR)fixedpoints FP -R $(SL_DIR)MonadLib MonadLib -R $(SL_DIR)listlib ListLib -R $(SL_DIR)MaxMinLib MaxMinLib -R $(SL_DIR)GraphLib GraphLib -R $(SL_DIR)SumLib SumLib -R $(SL_DIR)tracelib TraceLib -R $(SL_DIR)coq-record-update/src RecordUpdate -Q $(SL_DIR)algorithms Algorithms -R ./lib CRTOS_Verify.lib -R ./VC CRTOS_Verify.VC
DEP_FLAG = $(COQ_FLAG)

lib_FILES = \
	common/CrtosConfig.v \
	common/StructFieldOffsetAxiom.v \
	common/AllocationAddress.v \
	common/dll_abs.v \
	id/idnode_abs.v \
	event/EventState.v \
	mutex/MutexState.v \
	semaphore/SemaphoreState.v \
	isr/IsrState.v \
	common/CrtosGlobState.v \
	common/CrtosRules.v \
	common/dll.v \
	list/NodeSelfLinked.v \
	id/idnode.v \
	common/ObjectWaitNode.v \
	list/DoubleLinkListSpec.v \
	id/IdModuleSpec.v \
	common/RemoveFound.v \
	isr/IsrManagerInv.v \
	semaphore/SemaphoreInv.v \
	mutex/MutexInv.v \
	event/EventInv.v \
	semaphore/SemaphoreOps.v \
	mutex/MutexOps.v \
	event/EventOps.v \
	event/EventLayoutABI.v \
	common/CrtosInv.v \
	semaphore/KSemaphoreCreate.v \
	mutex/KMutexCreate.v \
	event/KEventCreate.v \
	assign/AssignInv.v \
	assign/AssignState.v \
	assign/Bitmap.v \
	delay/DelayInv.v \
	delay/DelayState.v \
	task/ExstatusInv.v \
	event/KEventDelete.v \
	mutex/KMutexDelete.v \
	semaphore/KSemaphoreDelete.v \
	delay/KTaskDelay.v \
	delay/KTaskDelayMem.v \
	task/KTaskDescriptor.v \
	assign/KTaskOsAssign.v \
	task/KTaskParseInfo.v \
	task/KTaskPure.v \
	task/KTaskSchedMember.v \
	task/KTaskStackSetup.v \
	task/KTaskStackSetupProofAux.v \
	delay/KTaskUnSetDelay.v \
	task/KTaskWakeup.v \
	assign/OsAssignReadyVector.v \
	common/ServiceSlotWf.v \
	task/TaskInv.v \
	task/TaskState.v \
	task/TaskStatus.v \
	task/TaskStatusMemory.v \
	tick/TickInv.v \
	tick/TickOrder.v \
	mutex/MutexDeleteState.v \
	mutex/MutexDeleteInv.v \
	dataqueue/DataqueueState.v \
	dataqueue/DataqueueInv.v \
	dataqueue/KInitDataqueue.v \
	dataqueue/KDeInitDataqueue.v \
	dataqueue/KDataqueuePeak.v \
	semaphore/KSemaphoreAbandon.v \
	common/TickConversion.v \
	pendlist/LinklistSuspend.v \
	delay/KTaskSetDelayState.v \
	semaphore/KSemaphoreObtain.v \
	dataqueue/KPopDataqueue.v \
	dataqueue/KPushDataqueue.v \
	task/KTaskSuspend.v

common_code_name = \
	common/CalculateTickFromTimeMs

dataqueue_code_name = \
	dataqueue/DataqueuePeak \
	dataqueue/DeInitDataqueue \
	dataqueue/InitDataqueue \
	dataqueue/PopDataqueue

event_code_name = \
	event/EventCreate \
	event/KEventCreate

mutex_code_name = \
	mutex/KMutexCreate \
	mutex/MutexCreate

pendlist_code_name = \
	pendlist/LinklistSuspendSemaphore

semaphore_code_name = \
	semaphore/KSemaphoreCreateIC \
	semaphore/KSemaphoreCreate \
	semaphore/KSemaphoreDeleteIC \
	semaphore/KSemaphoreDelete \
	semaphore/KSemaphoreObtainRuntime \
	semaphore/LinklistResumeAll \
	semaphore/LinklistResumeSemaphore \
	semaphore/SemaphoreAbandonRuntime \
	semaphore/SemaphoreCreateIC \
	semaphore/SemaphoreCreate \
	semaphore/SemaphoreDeleteIC \
	semaphore/SemaphoreDelete \
	semaphore/SemaphoreObtainRuntime

VC_code_FILE_NAME = \
	$(common_code_name) \
	$(dataqueue_code_name) \
	$(event_code_name) \
	$(mutex_code_name) \
	$(pendlist_code_name) \
	$(semaphore_code_name)

VC_code_FOLDER_NAME = $(sort $(dir $(VC_code_FILE_NAME)))

VC_lib_FILES = \
	event/EventCreate_lib.v \
	event/KEventCreate_lib.v \
	mutex/KMutexCreate_lib.v \
	mutex/MutexCreate_lib.v \
	semaphore/KSemaphoreCreate_lib.v \
	semaphore/KSemaphoreDelete_lib.v \
	semaphore/LinklistResumeAll_lib.v \
	semaphore/SemaphoreCreate_lib.v \
	semaphore/SemaphoreDelete_lib.v \
	semaphore/SemaphoreSpecBridge.v

VC_code_proof_FILES = \
	$(VC_code_FILE_NAME:%=VC/%_goal.v) \
	$(VC_code_FILE_NAME:%=VC/%_proof_auto.v) \
	$(VC_code_FILE_NAME:%=VC/%_proof_manual.v) \
	$(VC_code_FILE_NAME:%=VC/%_goal_check.v)

FILES = \
	$(lib_FILES:%=lib/%) \
	$(VC_lib_FILES:%=VC/%) \
	$(VC_code_proof_FILES)

LIB_VO_FILES = $(addprefix lib/,$(lib_FILES:.v=.vo))
COQ_VO_FILES = $(FILES:.v=.vo)
DIRS = lib VC

# Compile existing proof sources. VC generation remains owned by the QCP
# workflow, which records the per-function source/output mappings.
all: coq_file
check: coq_file
lib: $(LIB_VO_FILES)
coq_file: $(COQ_VO_FILES)

prepare_dirs:
	@mkdir -p $(DIRS)

# All proof objects share this rule; coqdep supplies their dependencies.
$(COQ_VO_FILES): %.vo: %.v
	@echo COQC $<
	@$(COQC) $(COQ_FLAG) $(CURRENT_DIR)/$<

# Keep editor/MCP configuration synchronized, without regenerating Makefile.
_CoqProject: Makefile $(wildcard CONFIGURE)
	@{ printf '%s\n' '# Generated by Makefile; edit COQ_FLAG and FILES there.'; \
	   printf '%s\n' '$(COQ_FLAG)'; \
	   $(foreach file,$(FILES),printf '%s\n' '$(file)';) } > $@.tmp
	@mv $@.tmp $@

# GNU make reloads this included file before scheduling parallel compilation.
# Atomic replacement preserves the previous dependency graph if coqdep fails.
.depend: _CoqProject $(FILES)
	@echo COQDEP
	@$(COQDEP) $(DEP_FLAG) $(FILES) > $@.tmp && mv $@.tmp $@

depend: .depend

print-env:
	@$(OPAM_EXEC) coqc --version
	@$(OPAM_EXEC) sh -c 'printf "coqdep: "; command -v coqdep'

# Restrict cleanup to compilation artifacts; retain all proof source files.
coq_clean:
	@find lib VC -type f \( -name '*.vo' -o -name '*.vos' -o -name '*.vok' \
	    -o -name '*.glob' -o -name '.*.aux' \) -delete
	@rm -f .depend .depend.tmp .lia.cache .nia.cache

vc_rocq_clean:
	@find VC -type f \( -name '*.vo' -o -name '*.vos' -o -name '*.vok' \
	    -o -name '*.glob' -o -name '.*.aux' \) -delete

clean: coq_clean

# Read-only and cleanup targets must not trigger dependency regeneration.
ifeq ($(strip $(MAKECMDGOALS)),)
include .depend
else ifneq ($(filter-out clean coq_clean vc_rocq_clean print-env prepare_dirs,$(MAKECMDGOALS)),)
include .depend
endif

.PHONY: all check lib coq_file prepare_dirs depend print-env coq_clean vc_rocq_clean clean
