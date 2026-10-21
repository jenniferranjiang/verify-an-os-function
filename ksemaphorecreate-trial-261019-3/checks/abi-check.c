#include <xs_sem.h>
#define S(c) _Static_assert((c), #c)
#define OFF(t,f) __builtin_offsetof(t,f)
S(sizeof(char)==1); S(sizeof(short)==2); S(sizeof(int)==4); S(sizeof(long)==4); S(sizeof(void*)==4);
S(sizeof(x_base)==4); S(sizeof(DoubleLinklistType)==8); S(_Alignof(DoubleLinklistType)==4);
S(sizeof(struct IdNode)==12); S(OFF(struct IdNode,id)==0); S(OFF(struct IdNode,link)==4);
S(sizeof(struct Semaphore)==32); S(_Alignof(struct Semaphore)==4);
S(OFF(struct Semaphore,id)==0); S(OFF(struct Semaphore,value)==12); S(OFF(struct Semaphore,pend_list)==16); S(OFF(struct Semaphore,link)==24);
S(sizeof(struct IdManager)==12); S(OFF(struct IdManager,id_max)==0); S(OFF(struct IdManager,hoffset)==2); S(OFF(struct IdManager,id_map)==4); S(OFF(struct IdManager,htable)==8);
S(ID_NUM_MAX==128); S(ID_HTABLE_SIZE==16);
DECLARE_ID_MANAGER(k_sem_id_manager,ID_NUM_MAX);
S(sizeof(__id_map_k_sem_id_manager)==16); S(sizeof(__htable_k_sem_id_manager)==128);
#ifdef ARCH_SMP
#error SMP is forbidden
#endif
