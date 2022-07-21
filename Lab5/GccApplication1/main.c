#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/delay.h>
	
long i = 0;
long suma = 0;
long promedio = 0;
long voltage = 0;

int a = 0;
int b = 0;
int c = 0;
int d = 0;

extern void delay_joel ();
extern void numbers ();

unsigned char *pr16 = 0x10;
unsigned char *pr17 = 0x11;

ISR(ADC_vect)
{
	uint16_t duty = ADC;
	OCR1B = duty;

	if (i != 100)
	{
		suma += ADC;
		i++;
	} else {
		promedio = suma / 100;
		voltage = (5000 * promedio) / 1024;
		
		a = voltage % 10000 / 1000;
		b = voltage % 1000 / 100;
		c = voltage % 100 / 10;
		d = voltage % 10 / 1;

		suma = 0;
		i = 0;
	}
}

void ADC_init(void)
{
	ADMUX |= (1<<REFS0) | (0<<MUX0);
	ADCSRA |= (1<<ADEN) | (1<<ADSC)  | (1<<ADATE) | (1<<ADIE) | (1<< ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	sei();
}

int main(void)
{	
	ADC_init();

	while (1)
	{
		*pr16=d;// cargo valor para delay0
		numbers();
		*pr17=0b00010000; //cargo valor para delay1
		delay_joel();
		
		*pr16=c;// cargo valor para delay0
		numbers();
		*pr17=0b00100000; //cargo valor para delay1
		delay_joel();
		
		*pr16=b;// cargo valor para delay0
		numbers();
		*pr17=0b01000000; //cargo valor para delay1
		delay_joel();
		
		*pr16=a;// cargo valor para delay0
		numbers();
		*pr16 &= (0<<0 | 1<<1 | 1<<2 | 1<<3 | 1<<4 | 1<<5| 1<<6 | 1<<7);
		
		*pr17=0b10000000; //cargo valor para delay1
		delay_joel();
	}
}
