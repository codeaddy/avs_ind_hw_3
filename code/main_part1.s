	.file	"main.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	read_string
	.type	read_string, @function
read_string:
	push	rbx
	mov	rcx, rdx
	mov	rbx, rsi
	mov	edx, 10
	mov	esi, 1
	call	fread@PLT
	mov	DWORD PTR [rbx], eax
	pop	rbx
	ret
	.size	read_string, .-read_string
