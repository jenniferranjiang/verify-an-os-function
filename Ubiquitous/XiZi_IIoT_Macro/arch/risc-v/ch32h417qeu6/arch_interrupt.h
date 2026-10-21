#ifndef ARCH_INTERRUPT_H__
#define ARCH_INTERRUPT_H__

#include "ch32h417_it.h"
#include "core_riscv.h"

#define ARCH_MAX_IRQ_NUM    256
#define ARCH_IRQ_NUM_OFFSET    0

int ArchEnableHwIrq(uint32_t irq_num);
int ArchDisableHwIrq(uint32_t irq_num);

#endif 