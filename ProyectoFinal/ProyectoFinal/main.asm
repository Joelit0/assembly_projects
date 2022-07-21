.ORG 0x0000
	JMP setup_data

.ORG 0x0008
	jmp iBtn

.ORG 0x001C 
	jmp		_tmr0_int

setup_data:
	ldi r30, 100

	setup_buttons:
		ldi		r16,	0b00000000	
		out		DDRC,	r16

		ldi r16, 0b00000010                 
		sts PCICR, r16		

		ldi r16, 0b0001110
		sts PCMSK1, r16

	setup_timer0:
		ldi		r16,	0b00000010	 
		out		TCCR0A,	r16
		ldi		r16,	0b00000101	
		out		TCCR0B,	r16
		ldi		r16,	125
		out		OCR0A,	r16	
		ldi		r16,	0b00000010	
		sts		TIMSK0,	r16
		ldi		r24,	125

	sei

loop:
	rjmp loop

modulo:
	ldi r16, 255 // Numero comparador
	ldi r18, 0 // Resto

	mov r18, r30

	iterate:
		cp r18,r16
		breq decrement_255
		rjmp modulo_out

	decrement_255:			
		sub r18, r16
		rjmp iterate
modulo_out:
	mov r30, r18
	ret

_tmr0_int:
	dec r30
	brne _tmr0_out
	ldi r30, 100

_tmr0_out:
	reti

iBtn:
	ldi r25, 2
	ldi r26, 255
	ldi r27, 255

	// Constantes
	ldi r28, 50 // Aditiva
	ldi r29, 2 // Multiplicativa

	ldi r17, 1

	gen_numeros:
		mul r30, r29 // Multiplico r30 x 2
		mov r30, r0 // Guardo en r30 el valor de del low value de la multiplicacion		add r30, r28 // Le sumo a eso la constante aditiva
	
		call modulo

		part_1:
			cpi r17, 2
			breq part_2
			cpi r17, 3
			breq part_3

			dec r26
			breq part_2
			rjmp gen_numeros

		part_2:
			cpi r17, 3
			breq part_3cccccvvvvvvvvvvvvvvvvvccccccccc
			ldi r17, 2
			dec r27
			breq part_3zzzzzzzzzzz
			rjmp gen_numeros

		
		part_3:
			ldi r17, 3
			dec r25
			breq i_btn_out
			rjmp gen_numeros
		
	i_btn_out:
		reti
		ccccccccc