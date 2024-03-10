
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _lenl=R6
	.DEF _lenh=R9
	.DEF _i=R10
	.DEF _i_msb=R11
	.DEF _j=R12
	.DEF _j_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0

_0xA:
	.DB  0xFF,0x0,0xC1,0x0,0x81,0x0,0x37,0x0
	.DB  0x37,0x0,0x81,0x0,0xC1,0x0,0xFF
_0xB:
	.DB  0xFF,0x0,0x1,0x0,0x1,0x0,0x6D,0x0
	.DB  0x1,0x0,0x91,0x0,0x93,0x0,0xFF
_0xC:
	.DB  0xC7,0x0,0x83,0x0,0x39,0x0,0x7D,0x0
	.DB  0x7D,0x0,0x7D,0x0,0xBB,0x0,0xFF
_0xD:
	.DB  0x7D,0x0,0x1,0x0,0x1,0x0,0x7D,0x0
	.DB  0x39,0x0,0x83,0x0,0xC7,0x0,0xFF
_0xE:
	.DB  0x7D,0x0,0x1,0x0,0x1,0x0,0x6D,0x0
	.DB  0x45,0x0,0x7D,0x0,0x39,0x0,0xFF
_0xF:
	.DB  0x7D,0x0,0x1,0x0,0x1,0x0,0x6D,0x0
	.DB  0x47,0x0,0x7F,0x0,0x3F,0x0,0xFF
_0x10:
	.DB  0xC7,0x0,0x83,0x0,0x39,0x0,0x7D,0x0
	.DB  0x75,0x0,0x31,0x0,0xB1,0x0,0xFF
_0x11:
	.DB  0xFF,0x0,0x1,0x0,0x1,0x0,0xEF,0x0
	.DB  0xEF,0x0,0x1,0x0,0x1,0x0,0xFF
_0x12:
	.DB  0xFF,0x0,0x7D,0x0,0x1,0x0,0x1,0x0
	.DB  0x7D,0x0,0xFF,0x0,0xFF,0x0,0xFF
_0x13:
	.DB  0xF3,0x0,0xF1,0x0,0xFD,0x0,0x7D,0x0
	.DB  0x1,0x0,0x3,0x0,0x7F,0x0,0xFF
_0x14:
	.DB  0x7D,0x0,0x1,0x0,0x1,0x0,0x6D,0x0
	.DB  0xC7,0x0,0x11,0x0,0x39,0x0,0xFF
_0x15:
	.DB  0x7D,0x0,0x1,0x0,0x1,0x0,0x7D,0x0
	.DB  0x7D,0x0,0x79,0x0,0x71,0x0,0xFF
_0x16:
	.DB  0x1,0x0,0x1,0x0,0x8F,0x0,0xC7,0x0
	.DB  0x8F,0x0,0x1,0x0,0x1,0x0,0xFF
_0x17:
	.DB  0x1,0x0,0x1,0x0,0x9F,0x0,0xCF,0x0
	.DB  0xE7,0x0,0x1,0x0,0x1,0x0,0xFF
_0x18:
	.DB  0xFF,0x0,0xC7,0x0,0x83,0x0,0x39,0x0
	.DB  0x39,0x0,0x83,0x0,0xC7,0x0,0xFF
_0x19:
	.DB  0x7D,0x0,0x1,0x0,0x1,0x0,0x6D,0x0
	.DB  0x6F,0x0,0xF,0x0,0x9F,0x0,0xFF
_0x1A:
	.DB  0xFF,0x0,0x87,0x0,0x3,0x0,0x7B,0x0
	.DB  0x71,0x0,0x1,0x0,0x85,0x0,0xFF
_0x1B:
	.DB  0x7D,0x0,0x1,0x0,0x1,0x0,0x6D,0x0
	.DB  0x67,0x0,0x1,0x0,0x99,0x0,0xFF
_0x1C:
	.DB  0x9B,0x0,0x9,0x0,0x4D,0x0,0x65,0x0
	.DB  0x31,0x0,0xB3,0x0,0xFF,0x0,0xFF
_0x1D:
	.DB  0xFF,0x0,0x3F,0x0,0x7F,0x0,0x1,0x0
	.DB  0x1,0x0,0x7D,0x0,0x3F,0x0,0xFF
_0x1E:
	.DB  0x1,0x0,0x1,0x0,0xF9,0x0,0xF9,0x0
	.DB  0x1,0x0,0x1,0x0,0xF9,0x0,0xFF
_0x1F:
	.DB  0xFF,0x0,0x7,0x0,0x3,0x0,0xF9,0x0
	.DB  0xFB,0x0,0x3,0x0,0x7,0x0,0xFF
_0x20:
	.DB  0x1,0x0,0x1,0x0,0xF3,0x0,0xE7,0x0
	.DB  0xE7,0x0,0x1,0x0,0x1,0x0,0xFF
_0x21:
	.DB  0x3D,0x0,0x19,0x0,0xC3,0x0,0xE7,0x0
	.DB  0xC3,0x0,0x19,0x0,0x3D,0x0,0xFF
_0x22:
	.DB  0xFF,0x0,0x1F,0x0,0xD,0x0,0xE1,0x0
	.DB  0xE1,0x0,0xD,0x0,0x1F,0x0,0xFF
_0x23:
	.DB  0x1D,0x0,0x39,0x0,0x71,0x0,0x65,0x0
	.DB  0x4D,0x0,0x19,0x0,0x31,0x0,0xFF
_0x0:
	.DB  0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0F
	.DW  _binaryA
	.DW  _0xA*2

	.DW  0x0F
	.DW  _binaryB
	.DW  _0xB*2

	.DW  0x0F
	.DW  _binaryC
	.DW  _0xC*2

	.DW  0x0F
	.DW  _binaryD
	.DW  _0xD*2

	.DW  0x0F
	.DW  _binaryE
	.DW  _0xE*2

	.DW  0x0F
	.DW  _binaryF
	.DW  _0xF*2

	.DW  0x0F
	.DW  _binaryG
	.DW  _0x10*2

	.DW  0x0F
	.DW  _binaryH
	.DW  _0x11*2

	.DW  0x0F
	.DW  _binaryI
	.DW  _0x12*2

	.DW  0x0F
	.DW  _binaryJ
	.DW  _0x13*2

	.DW  0x0F
	.DW  _binaryK
	.DW  _0x14*2

	.DW  0x0F
	.DW  _binaryL
	.DW  _0x15*2

	.DW  0x0F
	.DW  _binaryM
	.DW  _0x16*2

	.DW  0x0F
	.DW  _binaryN
	.DW  _0x17*2

	.DW  0x0F
	.DW  _binaryO
	.DW  _0x18*2

	.DW  0x0F
	.DW  _binaryP
	.DW  _0x19*2

	.DW  0x0F
	.DW  _binaryQ
	.DW  _0x1A*2

	.DW  0x0F
	.DW  _binaryR
	.DW  _0x1B*2

	.DW  0x0F
	.DW  _binaryS
	.DW  _0x1C*2

	.DW  0x0F
	.DW  _binaryT
	.DW  _0x1D*2

	.DW  0x0F
	.DW  _binaryU
	.DW  _0x1E*2

	.DW  0x0F
	.DW  _binaryV
	.DW  _0x1F*2

	.DW  0x0F
	.DW  _binaryW
	.DW  _0x20*2

	.DW  0x0F
	.DW  _binaryX
	.DW  _0x21*2

	.DW  0x0F
	.DW  _binaryY
	.DW  _0x22*2

	.DW  0x0F
	.DW  _binaryZ
	.DW  _0x23*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2/2/2023
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 32
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0035 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0036 char status,data;
; 0000 0037 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0038 data=UDR;
	IN   R16,12
; 0000 0039 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 003A    {
; 0000 003B    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 003C #if RX_BUFFER_SIZE == 256
; 0000 003D    // special case for receiver buffer size=256
; 0000 003E    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 003F #else
; 0000 0040    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(32)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 0041    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(32)
	CP   R30,R7
	BRNE _0x5
; 0000 0042       {
; 0000 0043       rx_counter=0;
	CLR  R7
; 0000 0044       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0045       }
; 0000 0046 #endif
; 0000 0047    }
_0x5:
; 0000 0048 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 004F {
_getchar:
; .FSTART _getchar
; 0000 0050 char data;
; 0000 0051 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
; 0000 0052 data=rx_buffer[rx_rd_index++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 0053 #if RX_BUFFER_SIZE != 256
; 0000 0054 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(32)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 0055 #endif
; 0000 0056 #asm("cli")
_0x9:
	cli
; 0000 0057 --rx_counter;
	DEC  R7
; 0000 0058 #asm("sei")
	sei
; 0000 0059 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 005A }
; .FEND
;#pragma used-
;#endif
;#include <string.h>
;#include <stdlib.h>
;#include <stdio.h>
;void setA(char,int);
;void setC(int);
;void show(char input[32]);
;char words[32],lenl,lenh;
;int i, j,m,l;
;int len,len1;
;int binaryA[8]={0b11111111,0b11000001,0b10000001,0b00110111,0b00110111,0b10000001,0b11000001,0b11111111};

	.DSEG
;int binaryB[8]={0b11111111,0b00000001,0b00000001,0b01101101,0b00000001,0b10010001,0b10010011,0b11111111};
;int binaryC[8]={0b11000111,0b10000011,0b00111001,0b01111101,0b01111101,0b01111101,0b10111011,0b11111111};
;int binaryD[8]={0b01111101,0b00000001,0b00000001,0b01111101,0b00111001,0b10000011,0b11000111,0b11111111};
;int binaryE[8]={0b01111101,0b00000001,0b00000001,0b01101101,0b01000101,0b01111101,0b00111001,0b11111111};
;int binaryF[8]={0b01111101,0b00000001,0b00000001,0b01101101,0b01000111,0b01111111,0b00111111,0b11111111};
;int binaryG[8]={0b11000111,0b10000011,0b00111001,0b01111101,0b01110101,0b00110001,0b10110001,0b11111111};
;int binaryH[8]={0b11111111,0b00000001,0b00000001,0b11101111,0b11101111,0b00000001,0b00000001,0b11111111};
;int binaryI[8]={0b11111111,0b01111101,0b00000001,0b00000001,0b01111101,0b11111111,0b11111111,0b11111111};
;int binaryJ[8]={0b11110011,0b11110001,0b11111101,0b01111101,0b00000001,0b00000011,0b01111111,0b11111111};
;int binaryK[8]={0b01111101,0b00000001,0b00000001,0b01101101,0b11000111,0b00010001,0b00111001,0b11111111};
;int binaryL[8]={0b01111101,0b00000001,0b00000001,0b01111101,0b01111101,0b01111001,0b01110001,0b11111111};
;int binaryM[8]={0b00000001,0b00000001,0b10001111,0b11000111,0b10001111,0b00000001,0b00000001,0b11111111};
;int binaryN[8]={0b00000001,0b00000001,0b10011111,0b11001111,0b11100111,0b00000001,0b00000001,0b11111111};
;int binaryO[8]={0b11111111,0b11000111,0b10000011,0b00111001,0b00111001,0b10000011,0b11000111,0b11111111};
;int binaryP[8]={0b01111101,0000000001,0b00000001,0b01101101,0b01101111,0b00001111,0b10011111,0b11111111};
;int binaryQ[8]={0b11111111,0b10000111,0b00000011,0b01111011,0b01110001,0b00000001,0b10000101,0b11111111};
;int binaryR[8]={0b01111101,0b00000001,0b00000001,0b01101101,0b01100111,0b00000001,0b10011001,0b11111111};
;int binaryS[8]={0b10011011,0b00001001,0b01001101,0b01100101,0b00110001,0b10110011,0b11111111,0b11111111};
;int binaryT[8]={0b11111111,0b00111111,0b01111111,0b00000001,0b00000001,0b01111101,0b00111111,0b11111111};
;int binaryU[8]={0b00000001,0b00000001,0b11111001,0b11111001,0b00000001,0b00000001,0b11111001,0b11111111};
;int binaryV[8]={0b11111111,0b00000111,0b00000011,0b11111001,0b11111011,0b00000011,0b00000111,0b11111111};
;int binaryW[8]={0b00000001,0b00000001,0b11110011,0b11100111,0b11100111,0b00000001,0b00000001,0b11111111};
;int binaryX[8]={0b00111101,0b00011001,0b11000011,0b11100111,0b11000011,0b00011001,0b00111101,0b11111111};
;int binaryY[8]={0b11111111,0b00011111,0b00001101,0b11100001,0b11100001,0b00001101,0b00011111,0b11111111};
;int binaryZ[8]={0b00011101,0b00111001,0b01110001,0b01100101,0b01001101,0b00011001,0b00110001,0b11111111};
;void main(void)
; 0000 0081 {

	.CSEG
_main:
; .FSTART _main
; 0000 0082 DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0083 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0084 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0085 
; 0000 0086 // Port B initialization
; 0000 0087 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0088 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0089 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 008A PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 008B 
; 0000 008C // Port C initialization
; 0000 008D // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 008E DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 008F // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0090 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0091 
; 0000 0092 // Port D initialization
; 0000 0093 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0094 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0095 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0096 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0097 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0098 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0099 
; 0000 009A // USART initialization
; 0000 009B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 009C // USART Receiver: On
; 0000 009D // USART Transmitter: Off
; 0000 009E // USART Mode: Asynchronous
; 0000 009F // USART Baud Rate: 9600
; 0000 00A0 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 00A1 UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(144)
	OUT  0xA,R30
; 0000 00A2 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00A3 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00A4 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 00A5 
; 0000 00A6 // Analog Comparator initialization
; 0000 00A7 // Analog Comparator: Off
; 0000 00A8 // The Analog Comparator's positive input is
; 0000 00A9 // connected to the AIN0 pin
; 0000 00AA // The Analog Comparator's negative input is
; 0000 00AB // connected to the AIN1 pin
; 0000 00AC ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00AD SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00AE 
; 0000 00AF // ADC initialization
; 0000 00B0 // ADC disabled
; 0000 00B1 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00B2 
; 0000 00B3 // SPI initialization
; 0000 00B4 // SPI disabled
; 0000 00B5 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00B6 
; 0000 00B7 // TWI initialization
; 0000 00B8 // TWI disabled
; 0000 00B9 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00BA ////sprintf(words,"JAVAD JAHANTAB");
; 0000 00BB // Global enable interrupts
; 0000 00BC #asm("sei")
	sei
; 0000 00BD while (1)
_0x24:
; 0000 00BE       {
; 0000 00BF           lenl=getchar();
	RCALL _getchar
	MOV  R6,R30
; 0000 00C0       lenh=getchar();
	RCALL _getchar
	MOV  R9,R30
; 0000 00C1       len1=(lenh<<8)+lenl;
	MOV  R31,R9
	LDI  R30,LOW(0)
	MOVW R26,R30
	MOV  R30,R6
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _len1,R30
	STS  _len1+1,R31
; 0000 00C2    for(l=0;l<len1;l++){
	LDI  R30,LOW(0)
	STS  _l,R30
	STS  _l+1,R30
_0x28:
	LDS  R30,_len1
	LDS  R31,_len1+1
	LDS  R26,_l
	LDS  R27,_l+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x29
; 0000 00C3    words[l]=getchar();
	LDS  R30,_l
	LDS  R31,_l+1
	SUBI R30,LOW(-_words)
	SBCI R31,HIGH(-_words)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00C4 }
	LDI  R26,LOW(_l)
	LDI  R27,HIGH(_l)
	CALL SUBOPT_0x0
	RJMP _0x28
_0x29:
; 0000 00C5      show(words);
	LDI  R26,LOW(_words)
	LDI  R27,HIGH(_words)
	RCALL _show
; 0000 00C6      sprintf(words,"");
	LDI  R30,LOW(_words)
	LDI  R31,HIGH(_words)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0000 00C7      len1=0;
	LDI  R30,LOW(0)
	STS  _len1,R30
	STS  _len1+1,R30
; 0000 00C8      delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 00C9       }
	RJMP _0x24
; 0000 00CA }
_0x2A:
	RJMP _0x2A
; .FEND
;void setA(char word,int k)
; 0000 00CC {   switch(word){
_setA:
; .FSTART _setA
	ST   -Y,R27
	ST   -Y,R26
;	word -> Y+2
;	k -> Y+0
	LDD  R30,Y+2
	LDI  R31,0
; 0000 00CD     case ' ' :
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x2E
; 0000 00CE         PORTA=0XFF;
	RJMP _0x5B
; 0000 00CF         break;
; 0000 00D0     case 'A' :
_0x2E:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0x2F
; 0000 00D1         PORTA=binaryA[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryA)
	LDI  R27,HIGH(_binaryA)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00D2         break;
; 0000 00D3     case 'B' :
_0x2F:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0x30
; 0000 00D4         PORTA=binaryB[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryB)
	LDI  R27,HIGH(_binaryB)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00D5         break;
; 0000 00D6     case 'C' :
_0x30:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x31
; 0000 00D7         PORTA=binaryC[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryC)
	LDI  R27,HIGH(_binaryC)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00D8         break;
; 0000 00D9     case 'D' :
_0x31:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0x32
; 0000 00DA         PORTA=binaryD[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryD)
	LDI  R27,HIGH(_binaryD)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00DB         break;
; 0000 00DC     case 'E' :
_0x32:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BRNE _0x33
; 0000 00DD         PORTA=binaryE[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryE)
	LDI  R27,HIGH(_binaryE)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00DE         break;
; 0000 00DF     case 'F' :
_0x33:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0x34
; 0000 00E0         PORTA=binaryF[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryF)
	LDI  R27,HIGH(_binaryF)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00E1         break;
; 0000 00E2     case 'G' :
_0x34:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BRNE _0x35
; 0000 00E3         PORTA=binaryG[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryG)
	LDI  R27,HIGH(_binaryG)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00E4         break;
; 0000 00E5     case 'H' :
_0x35:
	CPI  R30,LOW(0x48)
	LDI  R26,HIGH(0x48)
	CPC  R31,R26
	BRNE _0x36
; 0000 00E6         PORTA=binaryH[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryH)
	LDI  R27,HIGH(_binaryH)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00E7         break;
; 0000 00E8     case 'I' :
_0x36:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BRNE _0x37
; 0000 00E9         PORTA=binaryI[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryI)
	LDI  R27,HIGH(_binaryI)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00EA         break;
; 0000 00EB     case 'J' :
_0x37:
	CPI  R30,LOW(0x4A)
	LDI  R26,HIGH(0x4A)
	CPC  R31,R26
	BRNE _0x38
; 0000 00EC         PORTA=binaryJ[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryJ)
	LDI  R27,HIGH(_binaryJ)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00ED         break;
; 0000 00EE     case 'K' :
_0x38:
	CPI  R30,LOW(0x4B)
	LDI  R26,HIGH(0x4B)
	CPC  R31,R26
	BRNE _0x39
; 0000 00EF         PORTA=binaryK[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryK)
	LDI  R27,HIGH(_binaryK)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00F0         break;
; 0000 00F1     case 'L' :
_0x39:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0x3A
; 0000 00F2         PORTA=binaryL[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryL)
	LDI  R27,HIGH(_binaryL)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00F3         break;
; 0000 00F4     case 'M' :
_0x3A:
	CPI  R30,LOW(0x4D)
	LDI  R26,HIGH(0x4D)
	CPC  R31,R26
	BRNE _0x3B
; 0000 00F5         PORTA=binaryM[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryM)
	LDI  R27,HIGH(_binaryM)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00F6         break;
; 0000 00F7     case 'N' :
_0x3B:
	CPI  R30,LOW(0x4E)
	LDI  R26,HIGH(0x4E)
	CPC  R31,R26
	BRNE _0x3C
; 0000 00F8         PORTA=binaryN[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryN)
	LDI  R27,HIGH(_binaryN)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00F9         break;
; 0000 00FA     case 'O' :
_0x3C:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0x3D
; 0000 00FB         PORTA=binaryO[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryO)
	LDI  R27,HIGH(_binaryO)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00FC         break;
; 0000 00FD     case 'P' :
_0x3D:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0x3E
; 0000 00FE         PORTA=binaryP[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryP)
	LDI  R27,HIGH(_binaryP)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 00FF         break;
; 0000 0100     case 'Q' :
_0x3E:
	CPI  R30,LOW(0x51)
	LDI  R26,HIGH(0x51)
	CPC  R31,R26
	BRNE _0x3F
; 0000 0101         PORTA=binaryQ[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryQ)
	LDI  R27,HIGH(_binaryQ)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 0102         break;
; 0000 0103     case 'R' :
_0x3F:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0x40
; 0000 0104         PORTA=binaryR[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryR)
	LDI  R27,HIGH(_binaryR)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 0105         break;
; 0000 0106     case 'S' :
_0x40:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x41
; 0000 0107         PORTA=binaryS[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryS)
	LDI  R27,HIGH(_binaryS)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 0108         break;
; 0000 0109     case 'T' :
_0x41:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x42
; 0000 010A         PORTA=binaryT[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryT)
	LDI  R27,HIGH(_binaryT)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 010B         break;
; 0000 010C     case 'U' :
_0x42:
	CPI  R30,LOW(0x55)
	LDI  R26,HIGH(0x55)
	CPC  R31,R26
	BRNE _0x43
; 0000 010D         PORTA=binaryU[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryU)
	LDI  R27,HIGH(_binaryU)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 010E         break;
; 0000 010F     case 'V' :
_0x43:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BRNE _0x44
; 0000 0110         PORTA=binaryV[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryV)
	LDI  R27,HIGH(_binaryV)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 0111         break;
; 0000 0112     case 'W' :
_0x44:
	CPI  R30,LOW(0x57)
	LDI  R26,HIGH(0x57)
	CPC  R31,R26
	BRNE _0x45
; 0000 0113         PORTA=binaryW[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryW)
	LDI  R27,HIGH(_binaryW)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 0114         break;
; 0000 0115     case 'X' :
_0x45:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x46
; 0000 0116         PORTA=binaryX[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryX)
	LDI  R27,HIGH(_binaryX)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 0117         break;
; 0000 0118     case 'Y' :
_0x46:
	CPI  R30,LOW(0x59)
	LDI  R26,HIGH(0x59)
	CPC  R31,R26
	BRNE _0x47
; 0000 0119         PORTA=binaryY[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryY)
	LDI  R27,HIGH(_binaryY)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 011A         break;
; 0000 011B     case 'Z' :
_0x47:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BRNE _0x49
; 0000 011C         PORTA=binaryZ[k];
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_binaryZ)
	LDI  R27,HIGH(_binaryZ)
	CALL SUBOPT_0x1
	RJMP _0x5C
; 0000 011D         break;
; 0000 011E     default:
_0x49:
; 0000 011F        PORTA=0xFF;
_0x5B:
	LDI  R30,LOW(255)
_0x5C:
	OUT  0x1B,R30
; 0000 0120        break;
; 0000 0121 }
; 0000 0122 }
	ADIW R28,3
	RET
; .FEND
;void setC(int i)
; 0000 0124 {
_setC:
; .FSTART _setC
; 0000 0125        PORTC=31-i;
	ST   -Y,R27
	ST   -Y,R26
;	i -> Y+0
	LD   R26,Y
	LDI  R30,LOW(31)
	SUB  R30,R26
	OUT  0x15,R30
; 0000 0126 }
	RJMP _0x20A0002
; .FEND
;
;void show(char input[32]){
; 0000 0128 void show(char input[32]){
_show:
; .FSTART _show
; 0000 0129      len= strlen(input);
	ST   -Y,R27
	ST   -Y,R26
;	input -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CALL _strlen
	STS  _len,R30
	STS  _len+1,R31
; 0000 012A      if(len>4){
	LDS  R26,_len
	LDS  R27,_len+1
	SBIW R26,5
	BRLT _0x4A
; 0000 012B         for(j=0;j<(len-4)*8;j++){
	CLR  R12
	CLR  R13
_0x4C:
	LDS  R30,_len
	LDS  R31,_len+1
	SBIW R30,4
	CALL __LSLW3
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x4D
; 0000 012C         for(m=0;m<20;m++){
	LDI  R30,LOW(0)
	STS  _m,R30
	STS  _m+1,R30
_0x4F:
	LDS  R26,_m
	LDS  R27,_m+1
	SBIW R26,20
	BRGE _0x50
; 0000 012D 
; 0000 012E             for(i=0;i<32;i++){
	CLR  R10
	CLR  R11
_0x52:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x53
; 0000 012F                 setC(i);
	MOVW R26,R10
	RCALL _setC
; 0000 0130                 setA(input[((i+j)/8)],((i+j)%8));
	MOVW R26,R12
	ADD  R26,R10
	ADC  R27,R11
	CALL SUBOPT_0x2
	MOVW R30,R12
	ADD  R30,R10
	ADC  R31,R11
	CALL SUBOPT_0x3
; 0000 0131 
; 0000 0132                 delay_us(600);
; 0000 0133             }
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x52
_0x53:
; 0000 0134             }
	LDI  R26,LOW(_m)
	LDI  R27,HIGH(_m)
	CALL SUBOPT_0x0
	RJMP _0x4F
_0x50:
; 0000 0135         }
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	SBIW R30,1
	RJMP _0x4C
_0x4D:
; 0000 0136         }
; 0000 0137         else
	RJMP _0x54
_0x4A:
; 0000 0138         {
; 0000 0139             for(m=0;m<100;m++){
	LDI  R30,LOW(0)
	STS  _m,R30
	STS  _m+1,R30
_0x56:
	LDS  R26,_m
	LDS  R27,_m+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0x57
; 0000 013A             for(i=0;i<32;i++){
	CLR  R10
	CLR  R11
_0x59:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x5A
; 0000 013B                 setC(i);
	MOVW R26,R10
	RCALL _setC
; 0000 013C                 setA(input[i/8],i%8);
	MOVW R26,R10
	CALL SUBOPT_0x2
	MOVW R30,R10
	CALL SUBOPT_0x3
; 0000 013D 
; 0000 013E                 delay_us(600);
; 0000 013F             }
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x59
_0x5A:
; 0000 0140         }
	LDI  R26,LOW(_m)
	LDI  R27,HIGH(_m)
	CALL SUBOPT_0x0
	RJMP _0x56
_0x57:
; 0000 0141    }
_0x54:
; 0000 0142 
; 0000 0143 
; 0000 0144 }
_0x20A0002:
	ADIW R28,2
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
; .FSTART _put_buff_G102
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x0
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	CALL SUBOPT_0x0
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0x4
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	CALL SUBOPT_0x4
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	CALL SUBOPT_0x5
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x6
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	CALL SUBOPT_0x5
	CALL SUBOPT_0x8
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x8
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	CALL SUBOPT_0x4
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	CALL SUBOPT_0x4
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x6
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	CALL SUBOPT_0x4
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x6
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x9
	SBIW R30,0
	BRNE _0x2040072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x2040072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x9
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x20
_words:
	.BYTE 0x20
_m:
	.BYTE 0x2
_l:
	.BYTE 0x2
_len:
	.BYTE 0x2
_len1:
	.BYTE 0x2
_binaryA:
	.BYTE 0x10
_binaryB:
	.BYTE 0x10
_binaryC:
	.BYTE 0x10
_binaryD:
	.BYTE 0x10
_binaryE:
	.BYTE 0x10
_binaryF:
	.BYTE 0x10
_binaryG:
	.BYTE 0x10
_binaryH:
	.BYTE 0x10
_binaryI:
	.BYTE 0x10
_binaryJ:
	.BYTE 0x10
_binaryK:
	.BYTE 0x10
_binaryL:
	.BYTE 0x10
_binaryM:
	.BYTE 0x10
_binaryN:
	.BYTE 0x10
_binaryO:
	.BYTE 0x10
_binaryP:
	.BYTE 0x10
_binaryQ:
	.BYTE 0x10
_binaryR:
	.BYTE 0x10
_binaryS:
	.BYTE 0x10
_binaryT:
	.BYTE 0x10
_binaryU:
	.BYTE 0x10
_binaryV:
	.BYTE 0x10
_binaryW:
	.BYTE 0x10
_binaryX:
	.BYTE 0x10
_binaryY:
	.BYTE 0x10
_binaryZ:
	.BYTE 0x10
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:72 WORDS
SUBOPT_0x1:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MANDW12
	MOVW R26,R30
	CALL _setA
	__DELAY_USW 1200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
