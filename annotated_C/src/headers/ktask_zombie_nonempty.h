#ifndef CRTOS_KTASK_ZOMBIE_NONEMPTY_H
#define CRTOS_KTASK_ZOMBIE_NONEMPTY_H
#include "m_ktask.h"
/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosInv */
/*@ Extern Coq (ZombieQueueAbs :: *) */
/*@ Extern Coq
  (store_zombie_queue : (Z -> option TaskDescriptorAbs) -> Z -> ZombieQueueAbs -> Assertion)
  (ZombieLinked : list(DL_Node Z) -> ZombieQueueAbs)
 */

extern DoubleLinklistType KTaskZombie;

/* 薄包装只读取哨兵。先保留一般 DLL 的 payload，再细化成 zombie 视图；
 * 因而无需展开全局状态，也不需要丢弃 CLOSE/发布信息。 */
int JudgeZombieKTaskIsNotEmpty(void)
/*@ zombie_dll_ic
    With (storeA : Z -> Z -> Assertion) (nodes : list(DL_Node Z))
    Require store_dll(storeA, &KTaskZombie, nodes)
    Ensure ((__return == 0 && nodes == nil) || (__return == 1 && nodes != nil)) &&
      store_dll(storeA, &KTaskZombie, nodes)
 */;

int JudgeZombieKTaskIsNotEmpty(void)
/*@ zombie_nonempty_ic <= zombie_dll_ic
    With (T : Z -> option TaskDescriptorAbs) (nodes : list(DL_Node Z))
    Require store_zombie_queue(T, &KTaskZombie, ZombieLinked(nodes))
    Ensure ((__return == 0 && nodes == nil) || (__return == 1 && nodes != nil)) &&
      store_zombie_queue(T, &KTaskZombie, ZombieLinked(nodes))
 */;

/* 插入后调用者已知 nodes 非空，直接导出确定的返回值；原通用接口不变。 */
int JudgeZombieKTaskIsNotEmpty(void)
/*@ zombie_known_nonempty_ic <= zombie_nonempty_ic
    With (T : Z -> option TaskDescriptorAbs) (nodes : list(DL_Node Z))
    Require nodes != nil &&
      store_zombie_queue(T, &KTaskZombie, ZombieLinked(nodes))
    Ensure __return == 1 &&
      store_zombie_queue(T, &KTaskZombie, ZombieLinked(nodes))
 */;
#endif
