.ORG 0x0000
	JMP setup
.ORG 0x0008
	JMP i1

setup:
	ldi r16, 0b00000000	
	out	DDRC, r16			;3 botones del shield son entradas

	ldi r16, 0b00000010                 
	sts PCICR, r16					

	ldi r16, 0b00000100
	sts PCMSK1, r16					

	ldi r16, 0b00011110
	out DDRB, r16

	sei
loop:
	nop
	rjmp loop

i1:
	sbi PINB, 4		;toggle LED
	RETI

	