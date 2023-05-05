GPIOA_ODR			EQU 	0x4001080C
					
					AREA 	tim2_IRQHandler, READONLY, CODE
					THUMB
					EXPORT	TIM2_IRQ_HANDLER
					EXTERN	MAIN

TIM2_IRQ_HANDLER	PROC
					; TIM2->SR =0x0;//interrupt FLAG ON
					MOVS	R0,#0x00
					MOV		R1,#0x40000000 
					STR		R0,[R1,#0x10]
					
					CMP 	R4, #0x00
					BEQ		END_TIM2_IRQ_HANDLER
					
					; GPIOA->ODR ^=0x0008;//toggle pa low
					LDR		R0,=GPIOA_ODR  
					LDR		R1,[R0]
					
					CMP 	R4, #0x01
					BEQ		LED_MODE_1
					CMP 	R4, #0x02
					BEQ		LED_MODE_2					
					CMP 	R4, #0x03
					BEQ		LED_MODE_3
					CMP 	R4, #0x04
					BEQ		LED_MODE_4
					B		NEXT

LED_MODE_1			; nhap nhay dong thoi
					EOR		R1, R1, #0x0FF
					B NEXT

LED_MODE_2			; nhap nhay xen ke
					MVN		R1, R1
					B NEXT
					
LED_MODE_3			; chuoi
					LSL		R1, R1, #0x01
					LDR		R2, =0x3FF
					AND		R2, R1, R2
					CMP		R2, #0x200
					BNE		NEXT
					MOV		R1, #0x0FF
					B NEXT

					
					
LED_MODE_4
					MVN		R1, R1
					ADD		R1, R1, #0x01
					MVN		R1, R1
					B NEXT
NEXT	
					LDR		R0,=GPIOA_ODR  
					STR		R1,[R0] 	

END_TIM2_IRQ_HANDLER
					BX		LR	
					ENDP
					ALIGN
					END