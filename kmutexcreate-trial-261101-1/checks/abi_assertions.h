#define OFF(t,f) __builtin_offsetof(t,f)
#define ASSERT(c) _Static_assert((c), #c)
ASSERT(sizeof(void*) == 4);
ASSERT(sizeof(x_base) == 4);
ASSERT(sizeof(struct IdNode) == 12);
ASSERT(OFF(struct IdNode,id) == 0);
ASSERT(OFF(struct IdNode,link) == 4);
ASSERT(sizeof(struct SysDoubleLinklistNode) == 8);
ASSERT(OFF(struct SysDoubleLinklistNode,node_next) == 0);
ASSERT(OFF(struct SysDoubleLinklistNode,node_prev) == 4);
ASSERT(sizeof(struct Mutex) == 36);
ASSERT(OFF(struct Mutex,id) == 0);
ASSERT(OFF(struct Mutex,val) == 12);
ASSERT(OFF(struct Mutex,recursive_cnt) == 14);
ASSERT(OFF(struct Mutex,origin_prio) == 15);
ASSERT(OFF(struct Mutex,holder) == 16);
ASSERT(OFF(struct Mutex,pend_list) == 20);
ASSERT(OFF(struct Mutex,link) == 28);
ASSERT(sizeof(struct IdManager) == 12);
ASSERT(OFF(struct IdManager,id_max) == 0);
ASSERT(OFF(struct IdManager,hoffset) == 2);
ASSERT(OFF(struct IdManager,id_map) == 4);
ASSERT(OFF(struct IdManager,htable) == 8);
