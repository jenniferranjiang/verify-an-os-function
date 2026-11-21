#include "m_semaphore.h"
/* Existing project assertion instance required with no_crules enabled. */
/*@ Import Coq Require Import CRTOS_Verify.lib.common.CrtosRules */
/*@ Import Coq Require Import CRTOS_Verify.lib.common.TickConversion */
/*@ Extern Coq (tick_from_time_ms : Z -> Z) */
/*@ Extern Coq (nat :: *) */
/*@ Extern Coq (Z::to_nat : Z -> nat) */
/*@ Extern Coq (store_uinteger : nat -> Z -> Z -> Z -> Assertion) */
/* Source: current crtoslatest/thread/tick.c, 100Hz; uint64 cast occurs BEFORE multiply. */
x_ticks_t CalculateTickFromTimeMs(uint32 ms)
/*@
 Require emp
 Ensure __return == tick_from_time_ms(ms) && emp
*/
{
 uint32 tmp = 0;
 x_ticks_t ticks = 0;
 ticks = (uint32)(((unsigned long long)ms * 100) / 1000);
 /* Preserve the actual UInt input range after local cells are released at
  * return. Borrow and return the input cell so its range has a resource basis. */
 /*@ data_at(&ms, unsigned int, ms@pre)
     which implies 0 <= ms@pre && ms@pre <= 4294967295 &&
       store_uinteger(Z::to_nat(4), 4, &ms, ms@pre) */
 /*@ store_uinteger(Z::to_nat(4), 4, &ms, ms@pre)
     which implies data_at(&ms, unsigned int, ms@pre) */
 if (0 == ticks) ticks = 1;
 else {
  tmp = (uint32)(((unsigned long long)ms * 100) % 1000);
  if(tmp >= 5 && tmp <= 9) ticks = ticks + 1;
 }
 return ticks;
}
