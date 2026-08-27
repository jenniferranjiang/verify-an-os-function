typedef unsigned int uint32;
typedef long x_base;
typedef unsigned long x_size_t;

#define NONE ((void *)0)
#define SIZEOF_32B 32
#define SIZEOF_64B 64
#define DYNAMIC_BLOCK_NO_EXTMEM_MASK 0x40000000U

/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreInv */
/*@ Import Coq Local Open Scope sac */
/*@ Extern Coq
      (aligned_8 : Z -> Prop)
      (semaphore_layout_ok : Z -> Prop)
 */

x_base DisableLocalInterrupt(void)
/*@ Require emp Ensure emp */
;

void EnableLocalInterrupt(x_base lock)
/*@ Require emp Ensure emp */
;

x_size_t AlignMemorySize(x_size_t size)
/*@ Require 0 < size && size <= 64
    Ensure size <= __return && __return <= 64 && __return % 8 == 0
 */
;

int AllocatorHasCapacity(x_size_t size)
/*@ Require 0 < size && size <= 64
    Ensure __return == 0 || __return == 1
 */
;

void MemoryAllocParameterError(x_size_t size)
/*@ Require emp Ensure emp */
;

int ShowTask(void)
/*@ Require emp Ensure emp */
;

void DebugCheck(int condition)
/*@ Require condition != 0 && emp Ensure emp */
;

void *StaticMemoryMalloc(int size)
/*@ With requested
    Require 0 < requested && requested <= size && size <= 64
    Ensure (__return == 0) ||
      (0 < __return && aligned_8(__return) && semaphore_layout_ok(__return) &&
       CharArray::undef_full(__return, requested))
 */
;

void *DynamicBuddyMalloc(x_size_t size, uint32 extsram_mask)
/*@ With requested
    Require extsram_mask == DYNAMIC_BLOCK_NO_EXTMEM_MASK &&
      0 < requested && requested <= size && size <= 64
    Ensure (__return == 0) ||
      (0 < __return && aligned_8(__return) && semaphore_layout_ok(__return) &&
       CharArray::undef_full(__return, requested))
 */
;

int DynamicBuddyJudgeLegal(void *payload)
/*@ Require payload != 0 && emp Ensure __return != 0 && emp */
;

void *x_malloc(x_size_t size)
/*@ Require 0 < size && size <= 64
    Ensure (__return == 0) ||
      (0 < __return && aligned_8(__return) && semaphore_layout_ok(__return) &&
       CharArray::undef_full(__return, size))
 */
{
    void *ret = NONE;
    x_base lock = DisableLocalInterrupt();

    size = AlignMemorySize(size);
    if (AllocatorHasCapacity(size) == 0) {
        EnableLocalInterrupt(lock);
        MemoryAllocParameterError(size);
        ShowTask();
        return NONE;
    }

    if (size <= SIZEOF_32B) {
        ret = StaticMemoryMalloc(SIZEOF_32B)
          /*@ where requested = size@pre */;
    } else if (size <= SIZEOF_64B) {
        ret = StaticMemoryMalloc(SIZEOF_64B)
          /*@ where requested = size@pre */;
    }

    if (ret == NONE) {
        ret = DynamicBuddyMalloc(size, DYNAMIC_BLOCK_NO_EXTMEM_MASK)
          /*@ where requested = size@pre */;
        if (ret != NONE) {
            DebugCheck(DynamicBuddyJudgeLegal(ret));
        }
    }

    EnableLocalInterrupt(lock);
    return ret;
}
