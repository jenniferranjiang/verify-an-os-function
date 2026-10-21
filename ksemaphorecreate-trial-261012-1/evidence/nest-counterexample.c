#ifndef CRTOS_SEMAPHORE_LAYOUT_H
#define CRTOS_SEMAPHORE_LAYOUT_H
/* Current Cortex-M3 ILP32 declarations, derived from xs_base.h, xs_klist.h,
 * xs_id.h and xs_sem.h. No executable code or module contracts here. */
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef signed int int32;
typedef long x_base;
/* unsigned long and unsigned int have the same 32-bit size, alignment and
 * Cortex-M3 calling convention; approved x_size_t parser normalization. */
typedef unsigned int x_size_t;
typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
struct IdNode {
    uint16 id;
    DoubleLinklistType link;
};
struct IdManager {
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    DoubleLinklistType *htable;
};
struct Semaphore {
    struct IdNode id;
    uint16 value;
    DoubleLinklistType pend_list;
    DoubleLinklistType link;
};
#define NONE 0
#define ENOMEMORY 5
#endif





int32 _SemaphoreCreate(uint16 val)
;

int32 KSemaphoreCreate(uint16 val)

{

    return _SemaphoreCreate(val) ;
}




extern struct IdManager k_sem_id_manager;
extern DoubleLinklistType k_sem_list;



void *x_malloc(x_size_t size)
;

void *memset(void *dest, int value, x_size_t size)
;
x_base CriticalAreaLock(void)
;
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
;

void x_free(void *ptr)
;
void CriticalAreaUnLock(x_base lock)
;
void InitDoubleLinkList(DoubleLinklistType *linklist_head)
;
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
;

int32 _SemaphoreCreate(uint16 val)

{
    int32 id = 0;
    x_base lock = 0;
    struct Semaphore *sem = NONE;

    sem = (struct Semaphore *)x_malloc(sizeof(struct Semaphore));
    if (sem == NONE)
        return -ENOMEMORY;

    memset(sem, 0, sizeof(struct Semaphore));
    lock = CriticalAreaLock() ;
    
    id = IdInsertObj(&k_sem_id_manager, &sem->id)
      ;
    if (id < 0) {
        x_free(sem);
        CriticalAreaUnLock(lock)
          ;
        return -ENOMEMORY;
    }

    sem->value = val;
    InitDoubleLinkList(&sem->pend_list) ;

    
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link)
      ;
    CriticalAreaUnLock(lock)
      ;


    return id;
}





int AllocId(struct IdManager *manager)
;
void InsertObj(struct IdManager *manager, struct IdNode *idnode)
;
void KPrintf(const char *fmt, const char *function, int line, const char *parameter)
;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)

{
    int id = 0;

    do {
        if (manager == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "IdInsertObj", 110, "manager");
            while (1)
                ;
        }
    } while (0);
    do {
        if (idnode == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "IdInsertObj", 111, "idnode");
            while (1)
                ;
        }
    } while (0);

    id = AllocId(manager) ;
    if (id < 0)
        return -1;

    idnode->id = id;
    InsertObj(manager, idnode) ;

    return id;
}





void KPrintf(const char *fmt, const char *function, int line, const char *parameter)
;

int AllocId(struct IdManager *manager)

{
    int index = 0;
    int end = 0;
    int id = 0;
    uint8 entry = 0;

    do {
        if (manager == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "AllocId", 31, "manager");
            while (1)
                ;
        }
    } while (0);

    end = (manager->id_max + 7) / 8;

    for (index = 0; index < end; index++)
        if (manager->id_map[index] != 0xff)
            break;
    if (index == end)
        return -1;

    id = index * 8;
    entry = manager->id_map[index];
    while (entry & 0x1) {
        id++;
        entry >>= 1;
    }
    if (id >= manager->id_max)
        return -1;

    manager->id_map[index] |= (0x1 << (id % 8));

    return id;
}





void InitDoubleLinkList(DoubleLinklistType *linklist_head)
;
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
;
void KPrintf(const char *fmt, const char *function, int line, const char *parameter)
;

void InsertObj(struct IdManager *manager, struct IdNode *idnode)

{
    do {
        if (manager == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "InsertObj", 64, "manager");
            while (1)
                ;
        }
    } while (0);
    do {
        if (idnode == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "InsertObj", 65, "idnode");
            while (1)
                ;
        }
    } while (0);

    DoubleLinklistType *head = &manager->htable[idnode->id % manager->hoffset];

    if (head->node_prev == NONE)
        InitDoubleLinkList(head) ;

    DoubleLinkListInsertNodeAfter(head, &idnode->link)
      ;
}







void InitDoubleLinkList(DoubleLinklistType *linklist_head)

{
    linklist_head->node_next = linklist_head;
    linklist_head->node_prev = linklist_head;
}







void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)

{
    linklist->node_next->node_prev = linklist_node;
    linklist_node->node_next = linklist->node_next;

    linklist->node_next = linklist_node;
    linklist_node->node_prev = linklist;
}





extern uint16 KTaskOsAssignLockNest;


x_base DisableLocalInterrupt(void)
;

x_base CriticalAreaLock(void)

{
    x_base lock;

    lock = DisableLocalInterrupt() ;
    

    KTaskOsAssignLockNest ++;

    return lock;
}





extern uint16 KTaskOsAssignLockNest;


void EnableLocalInterrupt(x_base level)
;

void CriticalAreaUnLock(x_base lock)

{
    if (KTaskOsAssignLockNest >= 1) {
        KTaskOsAssignLockNest --;
    }

    EnableLocalInterrupt(lock) ;
}


_Static_assert(sizeof(void *) == 4 && sizeof(long) == 4, "ILP32");
_Static_assert(sizeof(struct Semaphore) == 32, "Semaphore ABI");
uint16 KTaskOsAssignLockNest;
static uint8 id_bitmap[16];
static DoubleLinklistType id_buckets[16];
struct IdManager k_sem_id_manager = {128, 16, id_bitmap, id_buckets};
DoubleLinklistType k_sem_list = {&k_sem_list, &k_sem_list};
static struct Semaphore arena_object;
static int allocated;
static x_base primask;
void *x_malloc(x_size_t size) {
    if (size != 32 || allocated) return 0;
    allocated = 1; return &arena_object;
}
void *memset(void *dest, int value, x_size_t size) {
    unsigned char *p = dest;
    for (x_size_t i = 0; i < size; ++i) p[i] = (unsigned char)value;
    return dest;
}
void x_free(void *ptr) { if (ptr == &arena_object) allocated = 0; }
x_base DisableLocalInterrupt(void) {
    x_base handler = primask; primask = 1; return handler;
}
void EnableLocalInterrupt(x_base handler) { primask = handler; }
void KPrintf(const char *fmt, const char *function, int line, const char *parameter) {
    (void)fmt; (void)function; (void)line; (void)parameter;
}
static void write_text(const char *text, unsigned size) {
    __asm__ volatile("int $0x80" : : "a"(4), "b"(1), "c"(text), "d"(size) : "memory");
}
void _start(void) {
    x_base outer_handler = CriticalAreaLock();
    for (unsigned i = 1; i < 65535; ++i) (void)CriticalAreaLock();
    unsigned before = KTaskOsAssignLockNest;
    int id = KSemaphoreCreate(3);
    unsigned after = KTaskOsAssignLockNest;
    int reproduced = before == 65535 && after == 0 && id == 0 &&
      arena_object.value == 3 && primask == 1 && outer_handler == 0;
    /* Finish the matching unlock sequence: no unmatched caller locks remain. */
    for (unsigned i = 1; i < 65535; ++i) CriticalAreaUnLock(1);
    CriticalAreaUnLock(outer_handler);
    reproduced = reproduced && KTaskOsAssignLockNest == 0 && primask == 0;
    const char result[] = "REPRODUCED: before=65535 after=0 id=0 value=3 primask=1\n";
    if (reproduced) write_text(result, sizeof(result) - 1);
    __asm__ volatile("int $0x80" : : "a"(1), "b"(reproduced ? 0 : 1) : "memory");
    __builtin_unreachable();
}
