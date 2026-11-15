#include "../annotated_C/src/dataqueue_logic.h"
#define OFF(t,f,n) _Static_assert(__builtin_offsetof(t,f)==n,#t "." #f)
_Static_assert(sizeof(void*)==4,"ILP32 pointer");
_Static_assert(sizeof(x_size_t)==4,"ILP32 x_size_t");
_Static_assert(sizeof(DataQueueType)==20,"DataQueueType");
_Static_assert(sizeof(DataElemType)==8,"DataElemType");
OFF(DataQueueType,front,0);
OFF(DataQueueType,rear,2);
OFF(DataQueueType,max_len,4);
OFF(DataQueueType,base,8);
OFF(DataQueueType,sem_blank,12);
OFF(DataQueueType,sem_data,16);
OFF(DataElemType,data,0);
OFF(DataElemType,length,4);
