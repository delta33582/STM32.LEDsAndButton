					
					
					THUMB
START_ADDR			EQU		0x20000100
			 
					AREA	RESET, DATA, READONLY
					THUMB
					   
					DCD		START_ADDR
					DCD		RESET_HANDLER
					DCD     0						   ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved

					; External Interrupts
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved
					DCD     0                          ; Reserved						   
					DCD		TIM2_IRQ_HANDLER


					AREA	|.text|, CODE, READONLY
						   
DEFAULT_HANDLER		PROC
	
					EXPORT	TIM2_IRQ_HANDLER			[WEAK] 
						   						   
TIM2_IRQ_HANDLER					   
					B 		.                     
					ENDP		   	
					   
					ALIGN

					
					AREA	Bolum2, CODE, READONLY   
					ENTRY

RESET_HANDLER					   
					IMPORT	MAIN	
						   
					B		MAIN

					END