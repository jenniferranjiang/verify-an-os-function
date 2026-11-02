#include "m_ktask.h"
#include "id_module_spec.h"

/* 来源：../crtos 的 kernel/thread/ktask.c:KTaskIdDelete。
 * 当前 xsconfig.h 未启用 KERNEL_CAPABILITY，故不包含 RemoveTaskCaps。
 * 本函数不自行加锁：调用者借出完整 ID manager 资源；这不是 OC 合同，
 * 也不承诺更新 descriptor 注册表、回收任务或释放 descriptor 内存。
 * 直接复用 IdRemoveObj 的 low_level_spec，保留不存在 ID 的正常返回，
 * 成功分支返还脱链 IdNode 的字段资源，不能将它们丢弃。
 * id 的范围保证 int32 -> uint16 转换无截断；范围外行为不在本合同内。
 * 调用点只补充整数转换恒等式，不改变 C 或公开合同。 */
void KTaskIdDelete(int32 id)
/*@ id_delete_local
    With (sm : StableIdmanager) (m : VarIdmanager)
    Require 0 <= id && id < 65536 &&
      store_idmanager(sm, m, &k_task_id_manager)
    Ensure
      (idmanager_query(m, id) == false &&
        store_idmanager(sm, m, &k_task_id_manager))
      ||
      (exists idnode,
        idmanager_query(m, id) == true &&
        idmanager_contains(sm, m, id, idnode) &&
        idnode != 0 && field_addr(idnode, struct IdNode, link) != 0 &&
        store_idmanager(sm, idmanager_remove(sm, m, id), &k_task_id_manager) *
        store(field_addr(idnode, struct IdNode, id), unsigned short, 65535) *
        store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_prev), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link)) *
        store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link)))
 */
{
    /*@ 0 <= id && id < 65536 && emp
        which implies
        0 <= id && id < 65536 && unsigned_last_nbits(id, 16) == id && emp
     */
    IdRemoveObj(&k_task_id_manager, id)
        /*@ where (low_level_spec) sm = sm, m = m */;
}
