/* Board Support Package */

#include "../runtime_environment.h"
#include "bsp.h"

__attribute__((noreturn)) void assert_failed (char const *file, int line) {
    NVIC_SystemReset();
}

void SysTick_Handler(void){
    GPIOF_AHB->DATA_BITS[(LED_GREEN)] ^= LED_GREEN;
}
