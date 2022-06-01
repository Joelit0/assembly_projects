.ORG 0x0000
	JMP setup_data

.ORG 0x0008
	jmp iBtn

.ORG 0x001C 
	jmp		_tmr0_int

setup_data:
	ldi r19, 0 // Segundos
	ldi r20, 0 // Minutos

setup_display:
	ldi		r16,	0b00000001	
	out		DDRB,	r16
	out		PORTB,	r16	
	ldi		r16,	0b10010000
	out		DDRD,	r16			;configuro PD.4 y PD.7 como salidas
	cbi		PORTD,	7			;PD.7 a 0, es el reloj serial, inicializo a 0
	cbi		PORTD,	4			;PD.4 a 0, es el reloj del latch, inicializo a 0

setup_buttons:
	ldi		r16,	0b00000000	
	out		DDRC,	r16			;3 botones del shield son entradas

	ldi r16, 0b00000010                 
	sts PCICR, r16 ; Hablito del 8 al 14			

	ldi r16, 0b0001110
	sts PCMSK1, r16	; Habilito los botones de los costados

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
	mov r28, r19 // Copio lo que tiene r19 en r15
	call divide

	// Imprimir unidades 
	mov r21, r31
	call numbers
	ldi r17, 0b00010000
	call sacanum

	// Imprimir decenas
	mov r21, r30 // Copio lo que tiene r19 en r11
	call numbers
	ldi r17, 0b00100000
	call sacanum

	mov r28, r20 // Copio lo que tiene r19 en r15
	call divide

	// Imprimir unidades 
	mov r21, r31
	call numbers
	cbr r16, 1
	ldi r17, 0b01000000
	call sacanum

	// Imprimir decenas
	mov r21, r30 // Copio lo que tiene r19 en r11
	call numbers
	ldi r17, 0b10000000
	call sacanum
	rjmp loop

iBtn:
	sbis PINC, 1
	rjmp start_timer

	sbis PINC, 2
	rjmp reset_timer

	sbis PINC, 3
	rjmp stop_timer

	reti

start_timer:
	ldi		r16,	0b00000010	
	sts		TIMSK0,	r16

	reti

reset_timer:
	ldi r19, 0
	ldi r20, 0

	reti

stop_timer:
 	ldi		r16,	0b00000000	
	sts		TIMSK0,	r16

	reti

_tmr0_int:
	dec r24
	brne _tmr0_out
	ldi r24, 125
	inc r19
	call update_min_and_secs

_tmr0_out:
	reti

update_min_and_secs:
	cpi r19, 60
	brne update_min_and_secs_exit
	inc r20 // Incremento minutos
	ldi r19, 0 // Reseteo segundos
update_min_and_secs_exit:
	ret

divide:
	ldi r29, 10 // Numero comparador
	ldi r30, 0 // Decenas
	ldi r31, 0 // Unidades

	mov r31, r28 // Copio lo que tiene r15 en r11. R11 = Unidades
		
	iterate:
		cp r31,r29
		brge decrement_10 ; Branch if r31 ? r29 (signed)
		rjmp divide_out

	decrement_10:			
		sub r31, r29
		inc r30
		rjmp iterate
divide_out:
	ret

numbers:
	number_0:
		cpi  r21, 0
		brne  number_1
		ldi r16,0b00000011
		ret

	number_1:
		cpi  r21, 1
		brne  number_2
		ldi r16,0b10011111
		ret

	number_2:
		cpi  r21, 2
		brne  number_3
		ldi r16,0b00100101
		ret

	number_3:
		cpi  r21, 3
		brne  number_4
		ldi r16,0b00001101
		ret

	number_4:
		cpi  r21, 4
		brne  number_5
		ldi r16,0b10011001
		ret

	number_5:
		cpi  r21, 5
		brne  number_6
		ldi r16,0b01001001
		ret

	number_6:
		cpi  r21, 6
		brne  number_7
		ldi r16,0b01000001
		ret

	number_7:
		cpi  r21, 7
		brne  number_8
		ldi r16,0b00011111
		ret

	number_8:
		cpi  r21, 8
		brne  number_9
		ldi r16,0b00000001
		ret

	number_9:
		ldi r16,0b00011001
		ret

sacanum: 
	call	dato_serie
	mov		r16, r17
	call	dato_serie
	sbi		PORTD, 4		;PD.4 a 1, es LCH el reloj del latch
	cbi		PORTD, 4		;PD.4 a 0, 
	ret
	;Voy a sacar un byte por el 7seg
dato_serie:
	ldi		r18, 0x08 ; lo utilizo para contar 8 (8 bits)
loop_dato1:
	cbi		PORTD, 7		;SCLK = 0 reloj en 0
	lsr		r16				;roto a la derecha r16 y el bit 0 se pone en el C
	brcs	loop_dato2		;salta si C=1
	cbi		PORTB, 0		;SD = 0 escribo un 0 
	rjmp	loop_dato3
loop_dato2:
	sbi		PORTB, 0		;SD = 1 escribo un 1
loop_dato3:
	sbi		PORTD, 7		;SCLK = 1 reloj en 1
	dec		r18
	brne	loop_dato1; cuando r17 llega a 0 corta y vuelve
	ret
