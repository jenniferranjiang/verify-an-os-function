#include "m_semaphore.h"
/*@ Import Coq Require Import CRTOS_Verify.lib.common.TickConversion */
/*@ Extern Coq (tick_from_time_ms : Z -> Z) */
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
 if (0 == ticks) ticks = 1;
 else {
  tmp = (uint32)(((unsigned long long)ms * 100) % 1000);
  if(tmp >= 5 && tmp <= 9) ticks = ticks + 1;
 }
 return ticks;
}
