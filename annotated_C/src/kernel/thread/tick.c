#include "xs_base.h"

/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosRules */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSetDelay */
/*@ Import Coq Require Import CRTOS_Verify.libai.TickConversion */
/*@ Extern Coq (heartbeat_ticks_addr : Z) */
/*@ Extern Coq
      (tick_from_time_ms : Z -> Z)
      (time_ms_from_tick : Z -> Z)
 */

static x_ticks_t heartbeat_ticks = 0;

#define UPDATE_GLOBAL_HEARTBEAT()         \
    do {                                     \
       heartbeat_ticks ++;                \
    } while(0);

/**
 * get haertbeat count
 *
 * @return CurrentTicks
 */
x_ticks_t CurrentTicksGain(void)
/*@ With os_tick
    Require store_uint(heartbeat_ticks_addr, os_tick)
    Ensure __return == os_tick &&
           store_uint(heartbeat_ticks_addr, os_tick)
 */
{
    /*@ store_uint(heartbeat_ticks_addr, os_tick)
        which implies
        store_uint(&heartbeat_ticks, os_tick)
     */
    return heartbeat_ticks;
}

/**
 * this function increases global systick in tick interrupt,and process task time slice
 *
 */
// CheckTaskDelay --> KTaskTimeout --> DO_KTASK_ASSIGN

void TickAndTaskTimesliceUpdate(void)
{
    struct TaskDescriptor *task = NONE;

    UPDATE_GLOBAL_HEARTBEAT();

    task = GetKTaskDescriptor();
    if(task){
        RoundRobinRemainTaskTimesliceUpdate(task);
    }
    CheckTaskDelay();
    CheckTimerList();
}

/**
 * This function will convert ms to ticks.
 *
 * @param ms time need to be converted
 * @return ticks
 */
#define MIN_TICKS    1

x_ticks_t CalculateTickFromTimeMs(uint32 ms)
/*@ Require
      0 <= ms && ms <= UINT_MAX && emp
    Ensure
      __return == tick_from_time_ms(ms) && emp
 */
{
    uint32 tmp = 0;
    x_ticks_t ticks = 0;

    ticks = (uint32)(((uint64)(ms * TICK_PER_SECOND)) / 1000) ;
    if (0 == ticks) {
        ticks = MIN_TICKS;
    } else {
        tmp = (uint32)(((uint64)(ms * TICK_PER_SECOND)) % 1000);

        if(tmp >= 5 && tmp <= 9) {
            ticks = ticks + MIN_TICKS;
        }
    }

    return ticks;
}

/**
 * This function will convert ticks to ms.
 *
 * @param ticks ticks need to be converted
 * @return ms
 */
uint32 CalculateTimeMsFromTick(x_ticks_t ticks)
/*@ Require
      0 <= ticks && ticks <= UINT_MAX && emp
    Ensure
      __return == time_ms_from_tick(ticks) && emp
 */
{
    uint32 ms = 0;

    ms = (uint32)(((uint64)(ticks * 1000)) / TICK_PER_SECOND);

    return ms;
}
