.include "./m328Pdef.inc"
.ORG 0

START:
    // Configurar entrada y salida

    LDI R16, 0b00111100
    LDI R17, 0b00111100
    LDI R20, 0

    OUT PORTB, R17
    OUT DDRB, R16

	// Configuración de variables

    LDI R22, 0b11111011
    LDI R23, 0b11110011
    LDI R24, 0b11100011
    LDI R25, 0b11000011

LOOP:
    OUT PORTB, R22
    CALL DELAY

    OUT PORTB, R23
    CALL DELAY

    OUT PORTB, R24
    CALL DELAY

    OUT PORTB, R25
    CALL DELAY
 
    OUT PORTB, R17
    CALL DELAY
	 
    RJMP LOOP // Volver al loop

DELAY:
    LDI R31, 255

    DELAY1:
        LDI R30, 255

        DELAY2:
            LDI R29, 255

            DELAY3:
                DEC R29
                BRNE DELAY3

                DEC R30
                BRNE DELAY2

                DEC R31
                BRNE DELAY1
    RET