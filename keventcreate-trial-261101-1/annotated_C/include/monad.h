#ifndef CRTOS_MONAD_H
#define CRTOS_MONAD_H

/* Native QCP MonadErr declarations shared by all abstract-program Specs. */
/*@ Import Coq From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope monad */
/*@ Extern Coq (program :: * => * => *) (unit :: *) */
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Extern Coq
      (safeExec : {Sigma} {A} ->
        (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
      (return : {Sigma} {A} -> A -> program Sigma A)
      (tt : unit)
 */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */

#endif
