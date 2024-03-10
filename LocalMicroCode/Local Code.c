/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2/2/2023
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <delay.h>
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

// USART Receiver buffer
#define RX_BUFFER_SIZE 32
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index=0,rx_rd_index=0;
#else
unsigned int rx_wr_index=0,rx_rd_index=0;
#endif

#if RX_BUFFER_SIZE < 256
unsigned char rx_counter=0;
#else
unsigned int rx_counter=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0) rx_buffer_overflow=1;
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
void setA(char,int);
void setC(int);
void show(char input[32]);
char words[32],lenl,lenh;
int i, j,m,l;
int len,len1;
int binaryA[8]={0b11111111,0b11000001,0b10000001,0b00110111,0b00110111,0b10000001,0b11000001,0b11111111};
int binaryB[8]={0b11111111,0b00000001,0b00000001,0b01101101,0b00000001,0b10010001,0b10010011,0b11111111};
int binaryC[8]={0b11000111,0b10000011,0b00111001,0b01111101,0b01111101,0b01111101,0b10111011,0b11111111};
int binaryD[8]={0b01111101,0b00000001,0b00000001,0b01111101,0b00111001,0b10000011,0b11000111,0b11111111};
int binaryE[8]={0b01111101,0b00000001,0b00000001,0b01101101,0b01000101,0b01111101,0b00111001,0b11111111};
int binaryF[8]={0b01111101,0b00000001,0b00000001,0b01101101,0b01000111,0b01111111,0b00111111,0b11111111};
int binaryG[8]={0b11000111,0b10000011,0b00111001,0b01111101,0b01110101,0b00110001,0b10110001,0b11111111};
int binaryH[8]={0b11111111,0b00000001,0b00000001,0b11101111,0b11101111,0b00000001,0b00000001,0b11111111};
int binaryI[8]={0b11111111,0b01111101,0b00000001,0b00000001,0b01111101,0b11111111,0b11111111,0b11111111};
int binaryJ[8]={0b11110011,0b11110001,0b11111101,0b01111101,0b00000001,0b00000011,0b01111111,0b11111111};
int binaryK[8]={0b01111101,0b00000001,0b00000001,0b01101101,0b11000111,0b00010001,0b00111001,0b11111111};
int binaryL[8]={0b01111101,0b00000001,0b00000001,0b01111101,0b01111101,0b01111001,0b01110001,0b11111111};
int binaryM[8]={0b00000001,0b00000001,0b10001111,0b11000111,0b10001111,0b00000001,0b00000001,0b11111111};
int binaryN[8]={0b00000001,0b00000001,0b10011111,0b11001111,0b11100111,0b00000001,0b00000001,0b11111111};
int binaryO[8]={0b11111111,0b11000111,0b10000011,0b00111001,0b00111001,0b10000011,0b11000111,0b11111111};
int binaryP[8]={0b01111101,0000000001,0b00000001,0b01101101,0b01101111,0b00001111,0b10011111,0b11111111};
int binaryQ[8]={0b11111111,0b10000111,0b00000011,0b01111011,0b01110001,0b00000001,0b10000101,0b11111111};
int binaryR[8]={0b01111101,0b00000001,0b00000001,0b01101101,0b01100111,0b00000001,0b10011001,0b11111111};
int binaryS[8]={0b10011011,0b00001001,0b01001101,0b01100101,0b00110001,0b10110011,0b11111111,0b11111111};
int binaryT[8]={0b11111111,0b00111111,0b01111111,0b00000001,0b00000001,0b01111101,0b00111111,0b11111111};
int binaryU[8]={0b00000001,0b00000001,0b11111001,0b11111001,0b00000001,0b00000001,0b11111001,0b11111111};
int binaryV[8]={0b11111111,0b00000111,0b00000011,0b11111001,0b11111011,0b00000011,0b00000111,0b11111111};
int binaryW[8]={0b00000001,0b00000001,0b11110011,0b11100111,0b11100111,0b00000001,0b00000001,0b11111111};
int binaryX[8]={0b00111101,0b00011001,0b11000011,0b11100111,0b11000011,0b00011001,0b00111101,0b11111111};
int binaryY[8]={0b11111111,0b00011111,0b00001101,0b11100001,0b11100001,0b00001101,0b00011111,0b11111111};
int binaryZ[8]={0b00011101,0b00111001,0b01110001,0b01100101,0b01001101,0b00011001,0b00110001,0b11111111};
void main(void)
{
DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: Off
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
////sprintf(words,"JAVAD JAHANTAB");
// Global enable interrupts
#asm("sei")
while (1)
      {
          lenl=getchar();
      lenh=getchar();
      len1=(lenh<<8)+lenl;
   for(l=0;l<len1;l++){    
   words[l]=getchar();
}
     show(words);
     sprintf(words,"");
     len1=0;
     delay_ms(500);
      }
}
void setA(char word,int k)
{   switch(word){
    case ' ' :
        PORTA=0XFF; 
        break;
    case 'A' : 
        PORTA=binaryA[k]; 
        break;
    case 'B' : 
        PORTA=binaryB[k];
        break;
    case 'C' : 
        PORTA=binaryC[k];
        break;
    case 'D' : 
        PORTA=binaryD[k];
        break;
    case 'E' : 
        PORTA=binaryE[k];
        break; 
    case 'F' : 
        PORTA=binaryF[k];
        break;  
    case 'G' : 
        PORTA=binaryG[k];
        break;   
    case 'H' : 
        PORTA=binaryH[k]; 
        break;
    case 'I' : 
        PORTA=binaryI[k];
        break;
    case 'J' : 
        PORTA=binaryJ[k];
        break;
    case 'K' : 
        PORTA=binaryK[k];
        break;
    case 'L' : 
        PORTA=binaryL[k];
        break;
    case 'M' : 
        PORTA=binaryM[k];
        break;
    case 'N' : 
        PORTA=binaryN[k];
        break;
    case 'O' : 
        PORTA=binaryO[k];
        break;
    case 'P' : 
        PORTA=binaryP[k];
        break;
    case 'Q' : 
        PORTA=binaryQ[k];
        break;
    case 'R' : 
        PORTA=binaryR[k];
        break;
    case 'S' : 
        PORTA=binaryS[k];
        break;
    case 'T' : 
        PORTA=binaryT[k];
        break;
    case 'U' : 
        PORTA=binaryU[k];
        break;  
    case 'V' : 
        PORTA=binaryV[k];
        break;  
    case 'W' : 
        PORTA=binaryW[k];
        break;
    case 'X' : 
        PORTA=binaryX[k];
        break;
    case 'Y' : 
        PORTA=binaryY[k];
        break;     
    case 'Z' : 
        PORTA=binaryZ[k];
        break;
    default:
       PORTA=0xFF;
       break;
} 
}
void setC(int i)
{   
       PORTC=31-i;
}

void show(char input[32]){
     len= strlen(input);
     if(len>4){ 
        for(j=0;j<(len-4)*8;j++){
        for(m=0;m<20;m++){      
        
            for(i=0;i<32;i++){    
                setC(i);
                setA(input[((i+j)/8)],((i+j)%8));
                
                delay_us(600);
            }
            }
        }
        }
        else 
        {
            for(m=0;m<100;m++){
            for(i=0;i<32;i++){     
                setC(i);
                setA(input[i/8],i%8);
                 
                delay_us(600);
            }  
        }       
   }


}