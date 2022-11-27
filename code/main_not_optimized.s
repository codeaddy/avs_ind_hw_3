	.file	"main.c"
	.intel_syntax noprefix
	.text
	.globl	read_string
	.type	read_string, @function
read_string:
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	QWORD PTR -8[rbp], rdi
	mov	QWORD PTR -16[rbp], rsi
	mov	QWORD PTR -24[rbp], rdx
	mov	rdx, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, rdx
	mov	edx, 10
	mov	esi, 1
	mov	rdi, rax
	call	fread@PLT
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	mov	DWORD PTR [rax], edx
	nop
	leave
	ret
	.size	read_string, .-read_string
	.section	.rodata
.LC0:
	.string	"%0.8f"
	.text
	.globl	print_double
	.type	print_double, @function
print_double:
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	movsd	QWORD PTR -8[rbp], xmm0
	mov	QWORD PTR -16[rbp], rdi
	mov	rdx, QWORD PTR -8[rbp]
	mov	rax, QWORD PTR -16[rbp]
	movq	xmm0, rdx
	lea	rdx, .LC0[rip]
	mov	rsi, rdx
	mov	rdi, rax
	mov	eax, 1
	call	fprintf@PLT
	nop
	leave
	ret
	.size	print_double, .-print_double
	.globl	process
	.type	process, @function
process:
	endbr64
	push	rbp
	mov	rbp, rsp
	mov	QWORD PTR -40[rbp], rdi
	movsd	QWORD PTR -48[rbp], xmm0
	pxor	xmm0, xmm0
	movsd	QWORD PTR -8[rbp], xmm0
	movsd	xmm0, QWORD PTR -48[rbp]
	movsd	QWORD PTR -16[rbp], xmm0
	mov	rax, QWORD PTR -40[rbp]
	pxor	xmm0, xmm0
	movsd	QWORD PTR [rax], xmm0
	mov	DWORD PTR -20[rbp], 0
.L7:
	mov	eax, DWORD PTR -20[rbp]
	add	eax, eax
	add	eax, 1
	pxor	xmm1, xmm1
	cvtsi2sd	xmm1, eax
	movsd	xmm0, QWORD PTR -16[rbp]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -8[rbp], xmm0
	movsd	xmm0, QWORD PTR -48[rbp]
	movq	xmm1, QWORD PTR .LC2[rip]
	xorpd	xmm0, xmm1
	mulsd	xmm0, QWORD PTR -48[rbp]
	movsd	xmm1, QWORD PTR -16[rbp]
	mulsd	xmm0, xmm1
	movsd	QWORD PTR -16[rbp], xmm0
	mov	rax, QWORD PTR -40[rbp]
	movsd	xmm0, QWORD PTR [rax]
	addsd	xmm0, QWORD PTR -8[rbp]
	mov	rax, QWORD PTR -40[rbp]
	movsd	QWORD PTR [rax], xmm0
	movsd	xmm0, QWORD PTR -8[rbp]
	movq	xmm1, QWORD PTR .LC3[rip]
	andpd	xmm1, xmm0
	movsd	xmm0, QWORD PTR .LC4[rip]
	comisd	xmm0, xmm1
	ja	.L8
	add	DWORD PTR -20[rbp], 1
	jmp	.L7
.L8:
	nop
	nop
	pop	rbp
	ret
	.size	process, .-process
	.globl	generate
	.type	generate, @function
generate:
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	QWORD PTR -8[rbp], rdi
	movsd	QWORD PTR -16[rbp], xmm0
	movsd	QWORD PTR -24[rbp], xmm1
	call	rand@PLT
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, eax
	movsd	xmm2, QWORD PTR .LC5[rip]
	movapd	xmm1, xmm0
	divsd	xmm1, xmm2
	movsd	xmm0, QWORD PTR -24[rbp]
	subsd	xmm0, QWORD PTR -16[rbp]
	mulsd	xmm0, xmm1
	addsd	xmm0, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	movsd	QWORD PTR [rax], xmm0
	nop
	leave
	ret
	.size	generate, .-generate
	.section	.rodata
	.align 8
.LC6:
	.string	"Command line doesn't fit pattern '{program_name} -d {input_file_name} {output_file_name}' "
	.align 8
.LC7:
	.string	"or\n'{program_name} -g {cycles_count} {output_file_name}\n'Program finished."
.LC8:
	.string	"-g"
.LC9:
	.string	"-d"
.LC10:
	.string	"r"
	.align 8
.LC11:
	.string	"Couldn't open input file.\nProgram finished."
.LC14:
	.string	"w"
	.align 8
.LC15:
	.string	"Couldn't open output file.\nProgram finished."
.LC16:
	.string	"input data:\n"
.LC17:
	.string	"\n\noutput data:\n"
.LC19:
	.string	"Spent time:%f sec.\n"
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	push	rbp
	mov	rbp, rsp
	add	rsp, -128
	mov	DWORD PTR -116[rbp], edi
	mov	QWORD PTR -128[rbp], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	cmp	DWORD PTR -116[rbp], 4
	je	.L11
	lea	rax, .LC6[rip]
	mov	rdi, rax
	call	puts@PLT
	lea	rax, .LC7[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 0
	jmp	.L20
.L11:
	mov	edi, 0
	call	time@PLT
	mov	edi, eax
	call	srand@PLT
	mov	rax, QWORD PTR -128[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	lea	rdx, .LC8[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	strcmp@PLT
	test	eax, eax
	je	.L13
	mov	rax, QWORD PTR -72[rbp]
	lea	rdx, .LC9[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	strcmp@PLT
	test	eax, eax
	je	.L13
	lea	rax, .LC6[rip]
	mov	rdi, rax
	call	puts@PLT
	lea	rax, .LC7[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 0
	jmp	.L20
.L13:
	mov	DWORD PTR -108[rbp], 0
	mov	DWORD PTR -104[rbp], 1
	pxor	xmm0, xmm0
	movsd	QWORD PTR -96[rbp], xmm0
	mov	rax, QWORD PTR -72[rbp]
	lea	rdx, .LC9[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	strcmp@PLT
	test	eax, eax
	jne	.L14
	mov	rax, QWORD PTR -128[rbp]
	mov	rax, QWORD PTR 16[rax]
	mov	QWORD PTR -64[rbp], rax
	mov	rax, QWORD PTR -128[rbp]
	mov	rax, QWORD PTR 24[rax]
	mov	QWORD PTR -80[rbp], rax
	mov	rax, QWORD PTR -64[rbp]
	lea	rdx, .LC10[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -56[rbp], rax
	cmp	QWORD PTR -56[rbp], 0
	jne	.L15
	lea	rax, .LC11[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 0
	jmp	.L20
.L15:
	mov	rdx, QWORD PTR -56[rbp]
	lea	rcx, -108[rbp]
	lea	rax, -18[rbp]
	mov	rsi, rcx
	mov	rdi, rax
	call	read_string
	mov	rax, QWORD PTR -56[rbp]
	mov	rdi, rax
	call	fclose@PLT
	lea	rax, -18[rbp]
	mov	rdi, rax
	call	atof@PLT
	movq	rax, xmm0
	mov	QWORD PTR -96[rbp], rax
	jmp	.L16
.L14:
	mov	rax, QWORD PTR -128[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rdi, rax
	call	atoi@PLT
	mov	DWORD PTR -104[rbp], eax
	mov	rax, QWORD PTR -128[rbp]
	mov	rax, QWORD PTR 24[rax]
	mov	QWORD PTR -80[rbp], rax
	movsd	xmm0, QWORD PTR .LC12[rip]
	mov	rdx, QWORD PTR .LC13[rip]
	lea	rax, -96[rbp]
	movapd	xmm1, xmm0
	movq	xmm0, rdx
	mov	rdi, rax
	call	generate
.L16:
	pxor	xmm0, xmm0
	movsd	QWORD PTR -88[rbp], xmm0
	call	clock@PLT
	mov	QWORD PTR -48[rbp], rax
	mov	DWORD PTR -100[rbp], 0
	jmp	.L17
.L18:
	mov	rdx, QWORD PTR -96[rbp]
	lea	rax, -88[rbp]
	movq	xmm0, rdx
	mov	rdi, rax
	call	process
	add	DWORD PTR -100[rbp], 1
.L17:
	mov	eax, DWORD PTR -100[rbp]
	cmp	eax, DWORD PTR -104[rbp]
	jl	.L18
	call	clock@PLT
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -80[rbp]
	lea	rdx, .LC14[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 0
	jne	.L19
	lea	rax, .LC15[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 0
	jmp	.L20
.L19:
	mov	rax, QWORD PTR -32[rbp]
	mov	rcx, rax
	mov	edx, 12
	mov	esi, 1
	lea	rax, .LC16[rip]
	mov	rdi, rax
	call	fwrite@PLT
	mov	rax, QWORD PTR -96[rbp]
	mov	rdx, QWORD PTR -32[rbp]
	mov	rdi, rdx
	movq	xmm0, rax
	call	print_double
	mov	rax, QWORD PTR -32[rbp]
	mov	rcx, rax
	mov	edx, 15
	mov	esi, 1
	lea	rax, .LC17[rip]
	mov	rdi, rax
	call	fwrite@PLT
	mov	rax, QWORD PTR -88[rbp]
	mov	rdx, QWORD PTR -32[rbp]
	mov	rdi, rdx
	movq	xmm0, rax
	call	print_double
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, QWORD PTR -40[rbp]
	pxor	xmm1, xmm1
	cvtsi2sd	xmm1, QWORD PTR -48[rbp]
	subsd	xmm0, xmm1
	movsd	xmm1, QWORD PTR .LC18[rip]
	divsd	xmm0, xmm1
	movq	rax, xmm0
	movq	xmm0, rax
	lea	rax, .LC19[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT
	mov	rax, QWORD PTR -32[rbp]
	mov	rdi, rax
	call	fclose@PLT
	mov	eax, 0
.L20:
	mov	rdx, QWORD PTR -8[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L21
	call	__stack_chk_fail@PLT
.L21:
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 16
.LC2:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align 16
.LC3:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
	.align 8
.LC4:
	.long	-755914244
	.long	1061184077
	.align 8
.LC5:
	.long	-4194304
	.long	1105199103
	.align 8
.LC12:
	.long	0
	.long	1072693248
	.align 8
.LC13:
	.long	0
	.long	-1074790400
	.align 8
.LC18:
	.long	0
	.long	1093567616
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
