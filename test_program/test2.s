/*----------------------------------------------------------------
//           Mon premier programme                              //
----------------------------------------------------------------*/
	.text
	.globl	_start 
_start:

	mov r0, #0
	mov r4, #AdrTab
	mov r5, #AdrTabFin
	ldr r6, [r4], #4

	/* 0x00 Reset Interrupt vector address */
	b	_good
	
	/* 0x04 Undefined Instruction Interrupt vector address */
	b	_bad

AdrStack:
	.word 0x80000000
AdrTab:
	.word 0x01
	.word 0x02
	.word 0x03
	.word 0x04
	.word 0x05
	.word 0x06
	.word 0x07
	.word 0x08
	.word 0x09
	.word 0x0a
AdrTabFin:
	.word 0x10

_bad :
	add r0, r0, r0
_good :
	add r1, r1, r1
