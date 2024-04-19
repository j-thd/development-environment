#include <stdint.h>

#include "TM4C123.h"
#include "bsp/bsp.h"

volatile int  a = 0;

int main(void) {
    
    SYSCTL->RCGC2 |= (1U << 5); // Enable clock for GPIOF
    SYSCTL->GPIOHBCTL  |= (1U <<5); // Enable AHB for GPIOF
    GPIOF_AHB->DIR |= ( LED_RED | LED_BLUE | LED_GREEN ); //Set Pin direction on pin 1, 2, 3 as output.
    GPIOF_AHB->DEN |= ( LED_RED | LED_BLUE | LED_GREEN ); // Digital Enable 
    
    // The PRIMASK priority mask is set to 0 by default so, interupts are enabled by default. This might not be true on all compilers or startup code.
    // Whe PRIMASK is set to 1 it prevent activation of all exceptions with configurable priority.
    
    SysTick->VAL = 0U;
    SysTick->LOAD = SYS_CLOCK_HZ/5U - 2U;
    SysTick->CTRL = ( 1U << 2 | 1U << 1 | 1U ); // Set clock source to system clock, interupt enable and clock enable.
    
    
    while(1) {
        ++a;
        GPIOF_AHB->DATA_BITS[(LED_BLUE)] = LED_BLUE;        
        GPIOF_AHB->DATA_BITS[(LED_BLUE)] = 0;
    }
    //return 0;
} 
