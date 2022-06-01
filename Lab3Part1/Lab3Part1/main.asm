; Empiezo con los vectores de interrupción
.ORG 0x0000
	jmp		start		;dirección de comienzo (vector de reset)  
.ORG 0x001C 
	jmp		_tmr0_int	;salto atención a rutina de comparación A del timer 0

; ---------------------------------------------------------------------------------------
start:
;configuro los puertos:
    ldi		r16,	0b00111101	;PB2 PB3 PB4 PB5 - son los LEDs del shield

	out		DDRB,	r16			;4 LEDs del shield son salidas
	out		PORTB,	r16			;apago los LEDs

	ldi		r16,	0b00000000	
	out		DDRC,	r16			;3 botones del shield son entradas
;-------------------------------------------------------------------------------------

;Configuro el TMR0 y su interrupcion.
	ldi		r16,	0b00000010	 
	out		TCCR0A,	r16			;configuro para que cuente hasta OCR0A y vuelve a cero (reset on compare), ahí dispara la interrupción. 
								;En este registro especial le especificas si vas a usar por overflow o por comparacion
	ldi		r16,	0b00000101	
	out		TCCR0B,	r16			;prescaler = 1024. Sirve para modificar la frecuencia de la placa
	ldi		r16,	125
	out		OCR0A,	r16			;comparo con 125. Este registro es el que se va a comparar cuando el timer count llegue a ese numero
	ldi		r16,	0b00000010	
	sts		TIMSK0,	r16			;habilito la interrupción (falta habilitar global)

;-------------------------------------------------------------------------------------
;Inicializo algunos registros que voy a usar como variables.
	ldi		r24,	125		;inicializo r24 para un contador genérico
	ldi		r30,	30		;
;-------------------------------------------------------------------------------------


;Programa principal ... acá puedo hacer lo que quiero

comienzo:
	sei							;habilito las interrupciones globales(set interrupt flag)

loop:
	nop
	rjmp loop

;RUTINAS
;-------------------------------------------------------------------------------------

; ------------------------------------------------
; Rutina de atención a la interrupción del Timer0.
; ------------------------------------------------
; recordar que el timer 0 fue configurado para interrumpir cada 125 ciclos (5^3), y tiene un prescaler 1024 = 2^10.
; El reloj de I/O está configurado @ Fclk = 16.000.000 Hz = 2^10*5^6; entonces voy a interrumpir 125 veces por segundo
; esto sale de dividir Fclk por el prescaler y el valor de OCR0A.
; 
; Esta rutina por ahora no hace casi nada, Ud puede ir agregando funcionalidades.
; Por ahora solo: cambia el valor de un LED en la placa, e incrementa un contador en r24.

_tmr0_int:
		push r17 // Paso el valor de r17 al stack
		in r17, SREG		// Guardamos el status register en el r17
		dec		r24					;cuento cuántas veces entré en la rutina.
		brne _tmr0_out
		ldi r24, 125
		dec r30
		brne _tmr0_out
		ldi r30, 30
		sbi		PINB,	2			;toggle LED

_tmr0_out:
		out SREG, r17 // En el status register asignamos lo que tenemos en el r17(El status)
		pop r17  // El valor que está encima del stack(Lo que guardamos previamente) lo asignamos al r17
	    reti						;retorno de la rutina de interrupción del Timer0
