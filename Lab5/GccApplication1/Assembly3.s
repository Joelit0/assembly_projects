//.include "./m328Pdef.inc"

.set DDRD, 0X0A
.set PORTD, 0x0B
.set DDRB, 0x04
.set PORTB, 0x05

.global delay_joel;
.section .text

delay_joel:
	setup_display:
		ldi		r19,	0b00000001
		out		DDRB,	r19
		out		PORTB,	r19
		ldi		r19,	0b10010000
		out		DDRD,	r19			;configuro PD.4 y PD.7 como salidas
		cbi		PORTD,	7			;PD.7 a 0, es el reloj serial, inicializo a 0
		cbi		PORTD,	4			;PD.4 a 0, es el reloj del latch, inicializo a 0
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