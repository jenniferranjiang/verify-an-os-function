#include "ktask_zombie_nonempty.h"

/* 原样提取自 kernel/thread/zombierecycle.c；调用者持有队列内存及所需锁。 */
int JudgeZombieKTaskIsNotEmpty(void)
/*@ zombie_dll_ic */
{
    return (IsDoubleLinkListEmpty(&KTaskZombie)
      /*@ where (dll) storeA=storeA, nodes=nodes; A = Z */ ? 0 : RET_TRUE);
}
