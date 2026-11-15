#ifndef CRTOS_DATAQUEUE_LOGIC_H
#define CRTOS_DATAQUEUE_LOGIC_H
#include "dataqueue_semaphore_create_logic.h"
typedef struct DataElemType {
    const void *data;
    x_size_t length;
} DataElemType;
typedef struct DataQueueType {
    uint16 front;
    uint16 rear;
    uint16 max_len;
    DataElemType *base;
    int sem_blank;
    int sem_data;
} DataQueueType;
/* Original anonymous structs in xs_dataqueue.h receive tags only for QCP.
 * ILP32 sizes/offsets are checked separately; no field is omitted/reordered. */
/*@ Import Coq Require Import InitDataqueueTrial.lib.KInitDataqueue */
/*@ Extern Coq
  (DataqueueAbs :: *) (DataElemAbs :: *) (option :: * => *)
  (dq_front : DataqueueAbs -> Z)
  (dq_rear : DataqueueAbs -> Z)
  (dq_max_len : DataqueueAbs -> Z)
  (dq_base : DataqueueAbs -> addr)
  (dq_blank : DataqueueAbs -> Z)
  (dq_data : DataqueueAbs -> Z)
  (dq_blank_object : DataqueueAbs -> addr)
  (dq_data_object : DataqueueAbs -> addr)
  (DataqueueRaw : addr -> Assertion)
  (dataqueue_storage : addr -> DataqueueAbs -> list(option DataElemAbs) -> Assertion)
  (dataqueue_init_slots : DataqueueAbs -> list(option DataElemAbs))
  (dq_cleared : DataqueueAbs -> DataqueueAbs)
  (dq_created_refs : DataqueueAbs -> VarGlobalState -> Prop)
  (abs_init_dataqueue : StableGlobalState -> addr -> Z -> program (VarGlobalState -> Prop) DataqueueAbs)
  (dq_published_at : addr -> DataqueueAbs -> VarGlobalState -> Prop)
  (abs_dataqueue_deinit : StableGlobalState -> DataqueueAbs -> program (VarGlobalState -> Prop) DataqueueAbs)
  (dq_sem_delete_empty : Z -> VarGlobalState -> Prop)
  (dq_semaphore_delete_effect : Z -> VarGlobalState -> VarGlobalState -> Prop)
 */
#endif
