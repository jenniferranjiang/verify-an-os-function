CURRENT_DIR ?= .
OPAM_SWITCH ?= default
OPAM_EXEC ?= opam exec --switch=$(OPAM_SWITCH) --
SL_DIR ?= /home/xinra/qcp-binary-democases/SeparationLogic/
COQC = $(OPAM_EXEC) coqc

COQ_FLAG = -R $(SL_DIR)flocq/src Flocq -R $(SL_DIR)SeparationLogic SimpleC.SL \
  -R $(SL_DIR)unifysl Logic -R $(SL_DIR)sets SetsClass \
  -R $(SL_DIR)compcert_lib compcert.lib -R $(SL_DIR)auxlibs AUXLib \
  -R $(SL_DIR)examples SimpleC.EE -R $(SL_DIR)stdlib SimpleC.StdLib \
  -R $(SL_DIR)StrategyLib SimpleC.StrategyLib -R $(SL_DIR)Common SimpleC.Common \
  -R $(SL_DIR)fixedpoints FP -R $(SL_DIR)MonadLib MonadLib \
  -R $(SL_DIR)listlib ListLib -R $(SL_DIR)MaxMinLib MaxMinLib \
  -R $(SL_DIR)GraphLib GraphLib -R $(SL_DIR)SumLib SumLib \
  -R lib CRTOS_Verify.lib

LIB_FILES = dll_abs.v NestedCriticalSTS.v SemaphorePure.v SemaphoreRules.v dll.v SemaphoreInv.v
LIB_VO = $(LIB_FILES:%.v=lib/%.vo)

ANNOTATED_INCLUDE_FLAGS = -Iannotated_C/src

# Selected symbolic/VC closure for this trial.  Each dependency function is a
# separate active-body slice; nested helper calls are APIs declared at the top
# of that function's file.  Dependency implementation proofs remain pending.
TARGET_C_FILES = \
  annotated_C/src/semaphore_create_internal.c \
  annotated_C/src/ksemaphore_create.c

DEPENDENCY_C_FILES = \
  annotated_C/src/x_malloc.c \
  annotated_C/src/memset.c \
  annotated_C/src/critical_area_lock.c \
  annotated_C/src/id_insert_obj.c \
  annotated_C/src/x_free.c \
  annotated_C/src/critical_area_unlock.c \
  annotated_C/src/init_double_link_list.c \
  annotated_C/src/double_link_list_insert_node_after.c

.PHONY: lib source-syntax target-syntax clean

lib: $(LIB_VO)

source-syntax:
	gcc -std=gnu11 -fsyntax-only $(ANNOTATED_INCLUDE_FLAGS) $(DEPENDENCY_C_FILES)

target-syntax:
	gcc -std=gnu11 -fsyntax-only -Iannotated_C/src $(TARGET_C_FILES)

lib/dll_abs.vo: lib/dll_abs.v
	$(COQC) $(COQ_FLAG) $<

lib/NestedCriticalSTS.vo: lib/NestedCriticalSTS.v
	$(COQC) $(COQ_FLAG) $<

lib/SemaphorePure.vo: lib/SemaphorePure.v
	$(COQC) $(COQ_FLAG) $<

lib/SemaphoreRules.vo: lib/SemaphoreRules.v lib/SemaphorePure.vo lib/NestedCriticalSTS.vo
	$(COQC) $(COQ_FLAG) $<

lib/dll.vo: lib/dll.v lib/dll_abs.vo lib/SemaphoreRules.vo
	$(COQC) $(COQ_FLAG) $<

lib/SemaphoreInv.vo: lib/SemaphoreInv.v lib/dll.vo
	$(COQC) $(COQ_FLAG) $<

clean:
	find lib -type f \( -name '*.vo' -o -name '*.vos' -o -name '*.vok' -o -name '*.glob' -o -name '.*.aux' \) -delete
