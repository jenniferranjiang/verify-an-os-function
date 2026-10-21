#include "ktask_assign_oc.h"

/* User-authorized logical model of DO_KTASK_ASSIGN, not its implementation. */
void KTASK_ASSIGN()
/*@ outside_critical */
{
    x_base lock = 0;

    lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */

    /*@ Crtos_RTrans(before, st_lock) &&
        safeExec(LastSeen(before), abs_ktask_assign, X) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        safeExec(LastSeen(st_lock), return(tt), X) &&
        Crtos_GTrans(st_lock, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    CriticalAreaUnLock(lock)
        /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
}
