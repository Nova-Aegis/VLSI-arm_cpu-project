	.text
	.globl _start
_start:
	bl main
	nop
	mov r10, #TTY_out
	str r0, [r10]
	b _good
	nop
	b _bad


main:
	mov r1, #0
	mov r4, #AdrTab
	mov r5, #AdrTabFin
main_loop:
	ldr r6, [r4], #4
	add r1, r1, r6
	cmp r4, r5
	bne main_loop
	nop

	mov r0, r1
	mov pc, lr
	mov r0, r0
	b _bad
	mov r0, r0
	
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
TTY_out:
	.word 0x00


_bad:
	add r0, r0, r0
_good:
	add r1, r1, r1
