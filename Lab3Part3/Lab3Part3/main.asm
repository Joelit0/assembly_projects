.ORG 0x0000
	JMP setup
.ORG 0x0008
	JMP iBtn
.ORG 0x001C 
	jmp	_tmr0_int

setup:
	ldi		r16,	0b00111100

	out		DDRB,	r16 ; Los leds son salida
	out		PORTB,	r16 ; Apago los leds

	ldi r16, 0b00000000	
	out	DDRC, r16 ; Botones de entrada

	// Hablitar el boton para usarse como interrupción

	ldi r16, 0b00000010                 
	sts PCICR, r16 ; Hablito del 8 al 14			

	ldi r16, 0b0001010
	sts PCMSK1, r16	; Habilito los botones de los costados

	// Hablito las interrupciones de timer 0
	ldi		r16, 0b0000010	 
	out		TCCR0A,	r16
	ldi		r16, 0b00000101	
	out		TCCR0B,	r16
	ldi		r16,	125
	out		OCR0A,	r16
	ldi		r16,	0b00000000	
	sts		TIMSK0,	r16

	sei

	ldi		r24,	125
	ldi r30, 0 // Registro que acumula los segundos

loop:
	nop
	rjmp loop

iBtn:
	sbis PINC, 3 // Si se apretó el botón 3
	rjmp start_timer

	sbis PINC, 1 // Si se apretó el botón 1
	rjmp stop_timer

	reti

start_timer:
	ldi		r16,	0b00000010	
	sts		TIMSK0,	r16

	reti

stop_timer:
 	ldi		r16,	0b00000000	
	sts		TIMSK0,	r16
	ldi		r30,	0 ; Reseteo el contador

	reti

_tmr0_int:
		in r17, SREG
		dec r24
		brne _tmr0_out
		sbi		PINB,	2			;toggle LED
		ldi r24, 125
		inc r30

_tmr0_out:
		out SREG, r17
	    reti