typedef long x_base;

#define NONE ((void *)0)

/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreInv */
/*@ Import Coq Local Open Scope sac */

x_base DisableLocalInterrupt(void)
/*@ Require emp Ensure emp */
;

void EnableLocalInterrupt(x_base lock)
/*@ Require emp Ensure emp */
;

void FreeInvalidPointerDebug(void *pointer)
/*@ Require emp Ensure emp */
;

int AllocatorPointerLegal(void *pointer)
/*@ With n
    Require pointer != 0 && 0 <= n && CharArray::undef_full(pointer, n)
    Ensure __return == 1 && CharArray::undef_full(pointer, n)
 */
;

int AllocatorBlockIsStatic(void *pointer)
/*@ With n
    Require pointer != 0 && 0 <= n && CharArray::undef_full(pointer, n)
    Ensure (__return == 0 || __return == 1) &&
      CharArray::undef_full(pointer, n)
 */
;

void StaticMemoryRelease(void *pointer)
/*@ With n
    Require pointer != 0 && 0 <= n && CharArray::undef_full(pointer, n)
    Ensure emp
 */
;

void DynamicBuddyRelease(void *pointer)
/*@ With n
    Require pointer != 0 && 0 <= n && CharArray::undef_full(pointer, n)
    Ensure emp
 */
;

void x_free(void *pointer)
/*@ With n
    Require pointer != 0 && 0 <= n && CharArray::undef_full(pointer, n)
    Ensure emp
 */
{
    x_base lock;

    if (pointer == NONE) {
        return;
    }

    lock = DisableLocalInterrupt();
    if (!AllocatorPointerLegal(pointer)
          /*@ where n = n */) {
        EnableLocalInterrupt(lock);
        FreeInvalidPointerDebug(pointer);
        return;
    }

    if (AllocatorBlockIsStatic(pointer)
          /*@ where n = n */) {
        StaticMemoryRelease(pointer)
          /*@ where n = n */;
    } else {
        DynamicBuddyRelease(pointer)
          /*@ where n = n */;
    }

    EnableLocalInterrupt(lock);
}
