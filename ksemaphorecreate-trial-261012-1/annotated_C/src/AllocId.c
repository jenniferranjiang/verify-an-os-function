#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

/*@ Extern Coq
    (IdNodeAbs :: *)
*/
/*@ Extern Coq
    (idmax : StableIdmanager -> Z)
    (hoffset : StableIdmanager -> Z)
    (id_map : StableIdmanager -> Z)
    (htable : StableIdmanager -> Z)
    (idlist : VarIdmanager -> list Z)
    (idbuckets : VarIdmanager -> list (list IdNodeAbs))
    (id_map_bytes_ok : Z -> list Z -> list Z -> Prop)
    (idbuckets_ok : Z -> Z -> list Z -> list (list IdNodeAbs) -> Prop)
    (store_idbuckets : Z -> Z -> list (list IdNodeAbs) -> Task_C_Rules::expr)
    (allocid_index_scan_inv : list Z -> Z -> Prop)
    (allocid_entry_scan_inv : list Z -> Z -> Z -> Z -> Prop)
*/

/* Candidate contracts use the compiled OSHeap transport; bodies await verification. */
void KPrintf(const char *fmt, const char *function, int line, const char *parameter)
/*@ Require emp
    Ensure emp
*/;

int AllocId(struct IdManager *manager)
/*@ With (sm : StableIdmanager) (before : VarIdmanager)
    Require manager != 0 && OSHeap(store_idmanager(sm, before, manager))
    Ensure
      (__return == -1 && idmanager_full(sm, before) &&
        OSHeap(store_idmanager(sm, before, manager))) ||
      (idmanager_min_free_id(sm, before, __return) &&
        OSHeap(store_idmanager_allocated_unlinked(sm, before, manager, __return)))
*/
{
    int index = 0;
    int end = 0;
    int id = 0;
    uint8 entry = 0;

    do {
        if (manager == NONE) {
            KPrintf("PARAM CHECK FAILED ...%s %d %s is NULL.\n", "AllocId", 31, "manager");
            /*@ Inv Assert 0 == 1 && emp */
            while (1)
                ;
        }
    } /*@ Inv Assert manager == manager@pre && manager != 0 &&
        index == 0 && end == 0 && id == 0 && entry == 0 &&
        OSHeap(store_idmanager(sm, before, manager)) */ while (0);

    /*@ Assert exists (bytes : list Z),
        manager == manager@pre && manager != 0 &&
        index == 0 && end == 0 && id == 0 && entry == 0 &&
        id_map_bytes_ok(idmax(sm), idlist(before), bytes) &&
        idbuckets_ok(idmax(sm), hoffset(sm), idlist(before), idbuckets(before)) &&
        data_at(&(manager->id_max), unsigned short, idmax(sm)) *
        data_at(&(manager->hoffset), unsigned short, hoffset(sm)) *
        data_at(&(manager->id_map), void *, id_map(sm)) *
        UCharArray::full(id_map(sm), (idmax(sm) + 7) / 8, bytes) *
        data_at(&(manager->htable), void *, htable(sm)) *
        OSHeap(store_idbuckets(htable(sm), hoffset(sm), idbuckets(before))) */
    /*@ Given bytes */
    end = (manager->id_max + 7) / 8;

    /*@ Inv Assert manager == manager@pre && manager != 0 &&
        end == (idmax(sm) + 7) / 8 && 0 <= index && index <= end && id == 0 && entry == 0 &&
        allocid_index_scan_inv(bytes, index) &&
        id_map_bytes_ok(idmax(sm), idlist(before), bytes) &&
        idbuckets_ok(idmax(sm), hoffset(sm), idlist(before), idbuckets(before)) &&
        data_at(&(manager->id_max), unsigned short, idmax(sm)) *
        data_at(&(manager->hoffset), unsigned short, hoffset(sm)) *
        data_at(&(manager->id_map), void *, id_map(sm)) *
        UCharArray::full(id_map(sm), (idmax(sm) + 7) / 8, bytes) *
        data_at(&(manager->htable), void *, htable(sm)) *
        OSHeap(store_idbuckets(htable(sm), hoffset(sm), idbuckets(before))) */
    for (index = 0; index < end; index++)
        if (manager->id_map[index] != 0xff)
            break;
    if (index == end)
        return -1;

    id = index * 8;
    entry = manager->id_map[index];
    /*@ Inv Assert manager == manager@pre && manager != 0 &&
        end == (idmax(sm) + 7) / 8 && 0 <= index && index < end &&
        Znth(index, bytes, 0) != 255 &&
        allocid_index_scan_inv(bytes, index) &&
        allocid_entry_scan_inv(bytes, index, id, entry) &&
        id_map_bytes_ok(idmax(sm), idlist(before), bytes) &&
        idbuckets_ok(idmax(sm), hoffset(sm), idlist(before), idbuckets(before)) &&
        data_at(&(manager->id_max), unsigned short, idmax(sm)) *
        data_at(&(manager->hoffset), unsigned short, hoffset(sm)) *
        data_at(&(manager->id_map), void *, id_map(sm)) *
        UCharArray::full(id_map(sm), (idmax(sm) + 7) / 8, bytes) *
        data_at(&(manager->htable), void *, htable(sm)) *
        OSHeap(store_idbuckets(htable(sm), hoffset(sm), idbuckets(before))) */
    while (entry & 0x1) {
        id++;
        entry >>= 1;
    }
    if (id >= manager->id_max)
        return -1;

    manager->id_map[index] |= (0x1 << (id % 8));

    return id;
}
