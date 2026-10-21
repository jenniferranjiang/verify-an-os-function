typedef signed char int8;
typedef signed short int16;
typedef signed int int32;
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef signed long long int64;
typedef unsigned long long uint64;
typedef int x_bool;
typedef long x_base;
typedef unsigned long x_ubase;
typedef x_base x_err_t;
typedef uint32 x_time_t;
typedef uint32 x_ticks_t;
typedef x_base x_flag_t;
typedef x_ubase x_size_t;
typedef x_ubase x_dev_t;
typedef x_base x_OffPos;
void KPrintf(const char *fmt, ...);
typedef struct SysDoubleLinklistNode
{
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
typedef struct SingleLinklistNode
{
    struct SingleLinklistNode *node_next;
} SysSingleLinklistType;
void InitDoubleLinkList(DoubleLinklistType *linklist_head);
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node);
void DoubleLinkListInsertNodeBefore(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node);
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node);
int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist);
struct SysDoubleLinklistNode *DoubleLinkListGetHead(const DoubleLinklistType *linklist);
struct SysDoubleLinklistNode *DoubleLinkListGetNext(const DoubleLinklistType *linklist,
        const struct SysDoubleLinklistNode *linklist_node);
unsigned int DoubleLinkListLenGet(const DoubleLinklistType *linklist);
void InitSingleLinkList(SysSingleLinklistType *linklist);
void AppendSingleLinkList(SysSingleLinklistType *linklist, SysSingleLinklistType *linklist_node);
void SingleLinkListNodeInsert(SysSingleLinklistType *linklist, SysSingleLinklistType *linklist_node);
unsigned int SingleLinkListGetLen(const SysSingleLinklistType *linklist);
SysSingleLinklistType *SingleLinkListRmNode(SysSingleLinklistType *linklist, SysSingleLinklistType *linklist_node);
SysSingleLinklistType *SingleLinkListGetFirstNode(SysSingleLinklistType *linklist);
SysSingleLinklistType *SingleLinkListGetTailNode(SysSingleLinklistType *linklist);
SysSingleLinklistType *SingleLinkListGetNextNode(SysSingleLinklistType *linklist_node);
int IsSingleLinkListEmpty(SysSingleLinklistType *linklist);
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
void DoubleLinkListInsertNodeBefore(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
{
    linklist->node_prev->node_next = linklist_node;
    linklist_node->node_prev = linklist->node_prev;
    linklist->node_prev = linklist_node;
    linklist_node->node_next = linklist;
}
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
{
    linklist_node->node_next->node_prev = linklist_node->node_prev;
    linklist_node->node_prev->node_next = linklist_node->node_next;
    linklist_node->node_next = linklist_node;
    linklist_node->node_prev = linklist_node;
}
int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist)
{
    return linklist->node_next == linklist;
}
struct SysDoubleLinklistNode *DoubleLinkListGetHead(const DoubleLinklistType *linklist)
{
    return IsDoubleLinkListEmpty(linklist) ? (0) : linklist->node_next;
}
struct SysDoubleLinklistNode *DoubleLinkListGetNext(const DoubleLinklistType *linklist,
        const struct SysDoubleLinklistNode *linklist_node)
{
    return linklist_node->node_next == linklist ? (0) : linklist_node->node_next;
}
unsigned int DoubleLinkListLenGet(const DoubleLinklistType *linklist)
{
    unsigned int linklist_length = 0;
    const DoubleLinklistType *tmp_node = linklist;
    while (tmp_node->node_next != linklist)
    {
        tmp_node = tmp_node->node_next;
        linklist_length ++;
    }
    return linklist_length;
}
