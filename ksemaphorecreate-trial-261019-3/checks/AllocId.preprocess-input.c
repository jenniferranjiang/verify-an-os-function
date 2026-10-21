#include <xs_sem.h>
#define DISABLE_INTERRUPT DisableLocalInterrupt
#define ENABLE_INTERRUPT EnableLocalInterrupt
#undef KDEBUG_NOT_IN_INTERRUPT
#define KDEBUG_NOT_IN_INTERRUPT
#line 24 "/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/id.c"
static int AllocId(struct IdManager *manager)
{
    int index = 0;
    int end = 0;
    int id = 0;
    uint8 entry = 0;

    NULL_PARAM_CHECK(manager);

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
