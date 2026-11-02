#ifndef CRTOS_M_ISR_H
#define CRTOS_M_ISR_H

#include "xs_base.h"

/*
 * xs_isr.h 的当前配置切片；只省去无关硬件 API/include，不改结构布局。
 * 非 SMP、CONFIG_INTERRUPT_INFO 关闭；k210 plic.h 的 IRQN_MAX 为 66。
 */
#if defined(ARCH_SMP) || defined(CONFIG_INTERRUPT_INFO)
#error "m_isr.h requires the reviewed non-SMP ISR layout"
#endif

typedef void (*IsrHandlerType)(int vector, void *param);

struct IrqDesc {
    IsrHandlerType handler;
    void *param;
};

struct IsrDone {
    x_bool (*isInIsr)();
    int32 (*registerIrq)(uint32 irq_num, IsrHandlerType handler, void *arg);
    int32 (*freeIrq)(uint32 irq_num);
    int32 (*enableIrq)(uint32 irq_num);
    int32 (*disableIrq)(uint32 irq_num);
    void (*handleIrq)(uint32 irq_num);
    uint16 (*getCounter)();
    void (*incCounter)();
    void (*decCounter)();
    uint8 (*getSwitchTrigerFlag)();
    void (*setSwitchTrigerFlag)();
    void (*clearSwitchTrigerFlag)();
};

struct InterruptServiceRoutines {
    volatile uint16 isr_count;
    volatile uint8 isr_switch_trigger_flag;
    struct IrqDesc irq_table[66];
    struct IsrDone *done;
};

extern struct InterruptServiceRoutines isrManager;

x_base DisableLocalInterrupt(void);
void EnableLocalInterrupt(x_base level);

#define DISABLE_INTERRUPT DisableLocalInterrupt
#define ENABLE_INTERRUPT EnableLocalInterrupt

#endif
