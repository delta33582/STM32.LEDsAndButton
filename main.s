; Variables
GPIOA_CRL			EQU		0x40010800
GPIOA_IDR			EQU		0x40010808
GPIOA_ODR			EQU		0x4001080C
GPIOB_CRL			EQU		0x40010C00
GPIOB_IDR			EQU		0x40010C08
GPIOB_ODR			EQU		0x40010C0C
RCC_APB2ENR			EQU		0x40021000
RCC_APB1ENR			EQU		0x40021000
TIM2_ARR			EQU		0x40000000
TIM2_PSC			EQU		0x40000028
TIM2_DIER			EQU		0x40000000
TIM2_CR1			EQU		0x40000000
TIM2_SR				EQU		0x40000000
RCC_CR				EQU		0x40021000
RCC_CFGR			EQU		0x40021004
FLASH_ACR			EQU		0x40022000

					
					AREA	MAIN_PROC, CODE, READONLY	                 
					THUMB
					EXTERN	TIM2_IRQ_HANDLER
					EXPORT	MAIN

MAIN
					;GPIO A/B CLOCK ON
					LDR		r2,=0x20000260 
					MOV		r0,#0x0C
					LDR 	r1,=RCC_APB2ENR  
					STR 	r0,[r1,#0x18]

					;PA0-PA7 as output
					LDR 	R0,=GPIOA_CRL
					LDR 	R1,=0x33333333
					STR 	R1,[R0,#0x00]
					
					; Init PA low
					LDR		r0,=GPIOA_ODR  
					MOV		R1, #0x0FF
					STR		R1, [R0]
					
					;PB0 as input
					LDR 	R0,=GPIOB_CRL
					LDR 	R1, [R0]
					BIC		R1, R1, #0x0F
					ORR		R1, R1, #0x08
					STR 	R1,[R0,#0x00]
					
					; Init PB0
					LDR		r0,=GPIOB_ODR  
					MOV		R1, #0x01
					STR		R1, [R0]
					
					; Init LED MODE
					MOV		R4, #0x00
					
				   
					LDR		R0, =FLASH_ACR
					LDR		R1, [R0]
					ORR		R1, R1, #0x10
					BIC		R1, R1, #0x03
					ORR		R1, R1, #0x02
					STR 	R1, [R0]
					
					LDR		R0, =RCC_CR
					LDR		R1, [R0]
					LDR		R2, =0x101000
					ORR		R1, R2;				HSEON, PLLON
					STR 	R1, [R0]
					
					LDR		R0, =RCC_CFGR
					LDR		R1, [R0]
					ORR		R1, R1, #0x400;		APB1 / 2
					BIC		R1, R1, #0x3F0000
					ORR		R1, R1, #0x1C0000;	PLLMUL = 9
					ORR		R1, R1, #0x02;		PLL selected
					ORR		R1, R1, #0x10000;	HSE selected
					STR		R1, [R0]
					
;*****************************************************************************TIMER CONFIGURATION 	
    ;        __disable_irq(); 
                   CPSID    I 
    ;         RCC->APB1ENR =0x1;// timer2 aktif 
                   MOV      r0,#0x1
                   LDR      r1,=RCC_APB1ENR  
                   STR      r0,[r1,#0x1C]
    ;        TIM2->ARR = 0xffff;  
                   MOV      r0,#19999
                   LDR      r1,=TIM2_ARR
                   STR      r0,[r1,#0x2C]
    ;         TIM2->PSC = 54;             10HZ BLINK
                   MOV      r0,#179
                   STR      r0,[r1,#0x28]
    ;        TIM2->DIER = 0x1; 
                   MOV      r0,#0x1
                   STR      r0,[r1,#0x0C]
    ;         TIM2->CR1 = 0x1;  
                   MOV      r0,#0x1
				   STR      r0,[r1,#0x00]
;*****************************************************************************TIMER CONFIGURATION 				   
    ;        NVIC_EnableIRQ(TIM2_IRQn); //TIMx_CR1.CEN 
;*****************************************************************************INTERRUPT CONFIGURATION                    
                   MOV      r0,#0x1C
  ;   if ((int32_t)(IRQn) >= 0) 
  ;   { 		   
                   CMP      r0,#0x00
                   BLT      SKIP ;
                   AND      r2,r0,#0x1F
                   MOV      r1,#0x01
                   LSLS     r1,r1,r2
                   LSRS     r2,r0,#5
                   LSLS     r2,r2,#2
                   ADD      r2,r2,#0xE000E000
                   STR      r1,[r2,#0x100] 				   				   
SKIP 	           NOP                   
    ;         __enable_irq();

				   CPSIE    I
;*****************************************************************************INTERRUPT CONFIGURATION	
					
LOOP
					LDR		R0, =GPIOB_IDR
					LDR		R1, [R0]
					AND		R1, #0x01
					CMP		R1, #0x00
					BNE		LOOP
					BL		PRESSED_HANDLER
					
					B 		LOOP
					
PRESSED_HANDLER
					LDR		R0, =TIM2_CR1
					MOV		R1, #0x00
					STR		R1, [R0];				Pause timer 
					
					LDR		R0, =GPIOB_IDR
					LDR		R1, [R0]
					AND		R1, #0x01
					CMP		R1, #0x01
					BNE		PRESSED_HANDLER;		Debouncing
					
					ADD		R4, R4, #0x01;			Increase
					CMP		R4, #0x05;				Constraint
					BNE		CONTINUE
					MOV		R4, #0x00

CONTINUE					
					CMP		R4, #0x02
					BNE		NOT_MODE_2_INIT
					
MODE_2_INIT			LDR		R0,=GPIOA_ODR  
					MOV		R1, #0x055
					STR		R1, [R0]
					B		END_PRESSED_HANDLER

NOT_MODE_2_INIT
					LDR		R0,=GPIOA_ODR  
					MOV		R1, #0x0FF
					STR		R1, [R0]

END_PRESSED_HANDLER
					LDR		R0, =TIM2_CR1
					MOV		R1, #0x01
					STR		R1, [R0];				Resume timer
					
					BX LR
					
					ALIGN
					END
	
	