#ifndef CRTOS_DATAQUEUE_H
#define CRTOS_DATAQUEUE_H
/* Source ABI: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_dataqueue.h; current ILP32 non-SMP configuration.
 * Source SHA-256: fb10a4ae331e8646d0cf26c3302c63d0b199e3bb6562d351a9130aa705454df8.
 * Shared scalar, ID and semaphore layouts are imported without copying.
 * Latest NULL_PARAM_CHECK is log/count-only and supplies no non-null fact. */
#include "m_semaphore.h"

typedef struct DataElem {
    const void *data;
    x_size_t length;
} DataElemType;
typedef struct DataQueue {
    uint16 front;
    uint16 rear;
    uint16 max_len;
    DataElemType *base;
    int sem_blank;
    int sem_data;
} DataQueueType;
/*@ Import Coq Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak */
/*@ Import Coq From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope monad */
/*@ Extern Coq
  (program :: * => * => *) (unit :: *)
*/
/*@ Extern Coq
  (tt : unit)
  (safeExec : {Sigma} {A} -> (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
  (return : {Sigma} {A} -> A -> program Sigma A)
  (addr_aligned : Z -> Z -> Prop)
  (CharArray::undef_full : Z -> Z -> Assertion)
  (CharArray::full : Z -> Z -> list Z -> Assertion)
  (repeat_Z : {A} -> A -> Z -> list A)
*/
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */
#ifndef CRTOS_DATAQUEUE_COQ_OPTION
#define CRTOS_DATAQUEUE_COQ_OPTION
/*@ Extern Coq
  (option :: * => *)
*/
/*@ Extern Coq
  (Some : {A} -> A -> option A) (None : {A} -> option A)
*/
#endif
/*@ Extern Coq
  (StableGlobalState :: *) (VarGlobalState :: *)
  (DataQueueAbs :: *) (DataqueueState :: *) (DataqueueSemRefs :: *)
*/
/*@ Extern Coq
  (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
  (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
  (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
  (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
  (DataqueueStorage : Z -> Assertion)
  (store_dataqueue : Z -> DataQueueAbs -> Assertion)
  (dataqueue_retired : DataQueueAbs -> DataQueueAbs)
  (dq_base : DataQueueAbs -> Z)
  (dq_max_len : DataQueueAbs -> Z) (dq_front : DataQueueAbs -> Z)
  (dq_rear : DataQueueAbs -> Z) (dq_sem_blank : DataQueueAbs -> Z)
  (dq_sem_data : DataQueueAbs -> Z)
  (os_dataqueues : VarGlobalState -> DataqueueState)
  (dataqueue_map : DataqueueState -> Z -> option DataQueueAbs)
  (In : {A} -> A -> list A -> Prop)
  (abs_init_dataqueue : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
  (abs_deinit_dataqueue : StableGlobalState -> Z -> DataQueueAbs -> DataqueueSemRefs -> program (VarGlobalState -> Prop) unit)
  (semaphore_create_ic_effect : StableGlobalState -> Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
  (semaphore_delete_quiescent : Z -> VarGlobalState -> Prop)
  (semaphore_delete_ic_effect : Z -> VarGlobalState -> VarGlobalState -> Prop)
*/
/*@ Printing Coq Name StableGlobalState := CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState */
/*@ Printing Coq Name VarGlobalState := CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState */
/*@ Printing Coq Name os_dataqueues := CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues */
/*@ Printing Coq Name InsideCritical := CRTOS_Verify.lib.common.CrtosRules.InsideCritical */
/*@ Printing Coq Name OutsideCritical := CRTOS_Verify.lib.common.CrtosRules.OutsideCritical */
/*@ Printing Coq Name Crtos_RTrans := CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans */
/*@ Printing Coq Name Crtos_GTrans := CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans */
/*@ Printing Coq Name LastSeen := CRTOS_Verify.lib.common.CrtosRules.LastSeen */
/*@ Printing Coq Name os_inv := CRTOS_Verify.lib.common.CrtosInv.os_inv */
/*@ Printing Coq Name DataqueueState := CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueState */
/*@ Printing Coq Name dataqueue_map := CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map */
/*@ Printing Coq Name DataQueueAbs := CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs */
/*@ Printing Coq Name dataqueue_retired := CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired */
/*@ Printing Coq Name dq_base := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base */
/*@ Printing Coq Name dq_max_len := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len */
/*@ Printing Coq Name dq_front := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front */
/*@ Printing Coq Name dq_rear := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear */
/*@ Printing Coq Name dq_sem_blank := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank */
/*@ Printing Coq Name dq_sem_data := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data */
/*@ Printing Coq Name DataqueueStorage := CRTOS_Verify.lib.common.DataqueueInv.DataqueueStorage */
/*@ Printing Coq Name store_dataqueue := CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue */
/*@ Printing Coq Name DataqueueSemRefs := CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs */
/*@ Printing Coq Name abs_deinit_dataqueue := CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue */
/*@ Printing Coq Name abs_init_dataqueue := CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue */
/*@ Printing Coq Name semaphore_create_ic_effect := CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect */
/*@ Printing Coq Name semaphore_delete_quiescent := CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent */
/*@ Printing Coq Name semaphore_delete_ic_effect := CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect */
/*@ Extern Coq
  (DataqueueElem :: *)
*/
/*@ Extern Coq
  (dq_data : DataqueueElem -> Z) (dq_length : DataqueueElem -> Z)
  (peak_data_slot : Z -> option Z -> Assertion)
  (peak_length_slot : Z -> option Z -> Assertion)
  (abs_dataqueue_peak : StableGlobalState -> Z -> program (VarGlobalState -> Prop) (option DataqueueElem))
*/
/*@ Printing Coq Name DataqueueElem := CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem */
/*@ Printing Coq Name dq_data := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data */
/*@ Printing Coq Name dq_length := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length */
/*@ Printing Coq Name peak_data_slot := CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot */
/*@ Printing Coq Name peak_length_slot := CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot */
/*@ Printing Coq Name abs_dataqueue_peak := CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak */
#ifdef CRTOS_DATAQUEUE_WITH_OPERATIONS
/* Pop/Push semantic components; contracts remain caller-local in C files. */
/*@ Import Coq Require Import CRTOS_Verify.lib.dataqueue.KPopDataqueue CRTOS_Verify.lib.dataqueue.KPushDataqueue */
/*@ Extern Coq (DataqueuePopResult :: *) */
/*@ Extern Coq
  (DqPopFailed : DataqueuePopResult) (DqPopEmpty : DataqueuePopResult)
  (DqPopItem : DataqueueElem -> DataqueuePopResult)
  (abs_pop_dataqueue : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) DataqueuePopResult)
  (abs_push_dataqueue : StableGlobalState -> Z -> Z -> Z -> Z -> program (VarGlobalState -> Prop) Z)
*/
#endif /* CRTOS_DATAQUEUE_WITH_OPERATIONS */
#endif
