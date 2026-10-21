#include <xs_sem.h>
#define ASSERT(e) _Static_assert((e), #e)
#define OFF(t,f,n) ASSERT(__builtin_offsetof(t,f)==n)
ASSERT(sizeof(int)==4); ASSERT(sizeof(long)==4); ASSERT(sizeof(void*)==4);
ASSERT(sizeof(uint16)==2); ASSERT(sizeof(x_base)==4);
ASSERT(sizeof(DoubleLinklistType)==8); OFF(DoubleLinklistType,node_next,0); OFF(DoubleLinklistType,node_prev,4);
ASSERT(sizeof(struct IdNode)==12); OFF(struct IdNode,id,0); OFF(struct IdNode,link,4);
ASSERT(sizeof(struct IdManager)==12); OFF(struct IdManager,id_max,0); OFF(struct IdManager,hoffset,2); OFF(struct IdManager,id_map,4); OFF(struct IdManager,htable,8);
ASSERT(sizeof(struct Semaphore)==32); ASSERT(_Alignof(struct Semaphore)==4);
OFF(struct Semaphore,id,0); OFF(struct Semaphore,value,12); OFF(struct Semaphore,pend_list,16); OFF(struct Semaphore,link,24);
ASSERT(sizeof(SemaphoreDoneType)==20); OFF(SemaphoreDoneType,SemaphoreCreate,0);
ASSERT(ID_NUM_MAX==128); ASSERT(ID_HTABLE_SIZE==16);
#ifdef ARCH_SMP
#error unexpected SMP
#endif
DECLARE_ID_MANAGER(layout_manager,ID_NUM_MAX);
ASSERT(sizeof(__id_map_layout_manager)==16); ASSERT(sizeof(__htable_layout_manager)==128);
