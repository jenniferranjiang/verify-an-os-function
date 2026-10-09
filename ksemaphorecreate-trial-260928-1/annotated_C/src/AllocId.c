/* Source: kernel/thread/id.c:24-53. Normalizations: TU-static helper is slice
 * external; active NULL_PARAM_CHECK(manager) is expanded with source line 31.
 * QCP does not parse a variadic prototype, so trusted KPrintf is declared with
 * the exact four argument types used by this expansion; the Cortex-M3 cdecl ABI
 * and the actual call arguments are unchanged. */
typedef unsigned char uint8;
typedef unsigned short uint16;
/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSProtocol */
/*@ Import Coq Import CrtosOS_C_Rules */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphorePure */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreRep */
struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
};
struct IdManager {
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    struct SysDoubleLinklistNode *htable;
};

void KPrintf(const char *fmt, const char *function, int line,
             const char *parameter)
/*@ Require emp Ensure emp */;

/*@ Extern Coq (SemaphoreStable :: *) (SemaphoreState :: *) */
/*@ Extern Coq (semaphore_first_free : SemaphoreStable -> SemaphoreState -> option Z)
               (SemaphoreStableContext : SemaphoreStable -> Prop)
               (semaphore_alloc_index_inv : SemaphoreStable -> SemaphoreState -> Z -> Prop)
               (semaphore_alloc_entry_inv :
                 SemaphoreStable -> SemaphoreState -> Z -> Z -> Z -> Prop)
               (store_semaphore_id_manager :
                 SemaphoreStable -> SemaphoreState -> Assertion)
               (store_sem_manager_id_allocated :
                 SemaphoreStable -> SemaphoreState -> Z -> Assertion)
               (semaphore_manager_addr : SemaphoreStable -> Z)
               (semaphore_id_limit : SemaphoreStable -> Z)
               (semaphore_bucket_count : SemaphoreStable -> Z)
               (semaphore_bitmap_addr : SemaphoreStable -> Z)
               (semaphore_buckets_addr : SemaphoreStable -> Z)
               (store_semaphore_bitmap :
                 SemaphoreStable -> SemaphoreState -> Assertion)
               (semaphore_bitmap_ok :
                 SemaphoreStable -> SemaphoreState -> list Z -> Prop)
               (store_semaphore_buckets :
                 SemaphoreStable -> SemaphoreState -> Assertion)
 */

int AllocId(struct IdManager *manager)
/*@ With (stable : SemaphoreStable) (before : SemaphoreState)
    Require
      manager != 0 && SemaphoreStableContext(stable) &&
      manager == semaphore_manager_addr(stable) &&
      store_semaphore_id_manager(stable, before)
    Ensure
      manager != 0 && SemaphoreStableContext(stable) &&
      ((__return == -1 &&
       semaphore_first_free(stable, before) == None &&
       store_semaphore_id_manager(stable, before))
      ||
      (0 <= __return &&
       semaphore_first_free(stable, before) == Some(__return) &&
       store_sem_manager_id_allocated(stable, before, __return)))
 */
{
    int index = 0;
    int scan_end = 0;
    int id = 0;
    uint8 entry = 0;
    if (manager == 0) {
        KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n",
                "AllocId", 31, "manager");
        while (1)
            ;
    }
    /*@ manager@pre == semaphore_manager_addr(stable) &&
        SemaphoreStableContext(stable) &&
        store_semaphore_id_manager(stable, before)
        which implies
        exists bytes,
          semaphore_bitmap_ok(stable, before, bytes) &&
          store(&(manager@pre->id_max), unsigned short,
            semaphore_id_limit(stable)) *
          store(&(manager@pre->hoffset), unsigned short,
            semaphore_bucket_count(stable)) *
          store(&(manager@pre->id_map), unsigned char *,
            semaphore_bitmap_addr(stable)) *
          store(&(manager@pre->htable), struct SysDoubleLinklistNode *,
            semaphore_buckets_addr(stable)) *
          UCharArray::full(semaphore_bitmap_addr(stable),
            (semaphore_id_limit(stable) + 7) / 8, bytes) *
          store_semaphore_buckets(stable, before)
     */
    /*@ Given bytes */
    scan_end = (manager->id_max + 7) / 8;
    /*@ Inv
          manager == manager@pre && manager != 0 && SemaphoreStableContext(stable) &&
          scan_end == (semaphore_id_limit(stable) + 7) / 8 &&
          0 <= index && index <= scan_end &&
          semaphore_alloc_index_inv(stable, before, index) &&
          semaphore_bitmap_ok(stable, before, bytes) &&
          store(&(manager@pre->id_max), unsigned short,
            semaphore_id_limit(stable)) *
          store(&(manager@pre->hoffset), unsigned short,
            semaphore_bucket_count(stable)) *
          store(&(manager@pre->id_map), unsigned char *,
            semaphore_bitmap_addr(stable)) *
          store(&(manager@pre->htable), struct SysDoubleLinklistNode *,
            semaphore_buckets_addr(stable)) *
          UCharArray::full(semaphore_bitmap_addr(stable),
            (semaphore_id_limit(stable) + 7) / 8, bytes) *
          store_semaphore_buckets(stable, before)
     */
    for (index = 0; index < scan_end; index++)
        if (manager->id_map[index] != 0xff)
            break;
    if (index == scan_end)
        return -1;
    id = index * 8;
    entry = manager->id_map[index];
    /*@ Inv
          manager == manager@pre && manager != 0 && SemaphoreStableContext(stable) &&
          scan_end == (semaphore_id_limit(stable) + 7) / 8 &&
          0 <= index && index < scan_end &&
          semaphore_alloc_index_inv(stable, before, index) &&
          semaphore_alloc_entry_inv(stable, before, index, id, entry) &&
          semaphore_bitmap_ok(stable, before, bytes) &&
          store(&(manager@pre->id_max), unsigned short,
            semaphore_id_limit(stable)) *
          store(&(manager@pre->hoffset), unsigned short,
            semaphore_bucket_count(stable)) *
          store(&(manager@pre->id_map), unsigned char *,
            semaphore_bitmap_addr(stable)) *
          store(&(manager@pre->htable), struct SysDoubleLinklistNode *,
            semaphore_buckets_addr(stable)) *
          UCharArray::full(semaphore_bitmap_addr(stable),
            (semaphore_id_limit(stable) + 7) / 8, bytes) *
          store_semaphore_buckets(stable, before)
     */
    while (entry & 0x1) {
        id++;
        entry >>= 1;
    }
    if (id >= manager->id_max)
        return -1;
    manager->id_map[index] |= (0x1 << (id % 8));
    return id;
}
