/* The same assertions compile against original headers and the slice types. */
#define ABI_ASSERT(x) _Static_assert((x), #x)
#define OFF(t, f) __builtin_offsetof(t, f)
ABI_ASSERT(sizeof(void *) == 4);
ABI_ASSERT(sizeof(int) == 4);
ABI_ASSERT(sizeof(long) == 4);
ABI_ASSERT(sizeof(uint8) == 1);
ABI_ASSERT(sizeof(uint16) == 2);
ABI_ASSERT(sizeof(x_base) == 4);
ABI_ASSERT(sizeof(DoubleLinklistType) == 8);
ABI_ASSERT(OFF(DoubleLinklistType, node_next) == 0);
ABI_ASSERT(OFF(DoubleLinklistType, node_prev) == 4);
ABI_ASSERT(sizeof(struct IdNode) == 12);
ABI_ASSERT(OFF(struct IdNode, id) == 0);
ABI_ASSERT(OFF(struct IdNode, link) == 4);
ABI_ASSERT(sizeof(struct IdManager) == 12);
ABI_ASSERT(OFF(struct IdManager, id_max) == 0);
ABI_ASSERT(OFF(struct IdManager, hoffset) == 2);
ABI_ASSERT(OFF(struct IdManager, id_map) == 4);
ABI_ASSERT(OFF(struct IdManager, htable) == 8);
ABI_ASSERT(sizeof(struct Semaphore) == 32);
ABI_ASSERT(_Alignof(struct Semaphore) == 4);
ABI_ASSERT(OFF(struct Semaphore, id) == 0);
ABI_ASSERT(OFF(struct Semaphore, value) == 12);
ABI_ASSERT(OFF(struct Semaphore, pend_list) == 16);
ABI_ASSERT(OFF(struct Semaphore, link) == 24);
