//.include "./m328Pdef.inc"

.global numbers;
.section .text

numbers:
	number_0:
		cpi  r16, 0
		brne  number_1
		ldi r16,0b00000011
		ret

	number_1:
		cpi  r16, 1
		brne  number_2
		ldi r16,0b10011111
		ret

	number_2:
		cpi  r16, 2
		brne  number_3
		ldi r16,0b00100101
		ret

	number_3:
		cpi  r16, 3
		brne  number_4
		ldi r16,0b00001101
		ret

	number_4:
		cpi  16, 4
		brne  number_5
		ldi r16,0b10011001
		ret

	number_5:
		cpi  r16, 5
		brne  number_6
		ldi r16,0b01001001
		ret

	number_6:
		cpi  r16, 6
		brne  number_7
		ldi r16,0b01000001
		ret

	number_7:
		cpi  r16, 7
		brne  number_8
		ldi r16,0b00011111
		ret

	number_8:
		cpi  r16, 8
		brne  number_9
		ldi r16,0b00000001
		ret

	number_9:
		ldi r16,0b00011001
		ret