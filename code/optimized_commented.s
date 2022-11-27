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
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%0.8f"
	.text
	.p2align 4
	.globl	print_double
	.type	print_double, @function
print_double:
	lea	rdx, .LC0[rip]
	mov	esi, 1
	mov	eax, 1
	jmp	__fprintf_chk@PLT
	.size	print_double, .-print_double
	.p2align 4
	.globl	process
	.type	process, @function
process:
	movapd	xmm4, xmm0 						# используем регистры xmm0-xmm6 для сохранения промежуточных вычислений
	xorpd	xmm4, XMMWORD PTR .LC1[rip]     # кстати, удивительно, что этот метод не вызывается вообще 
	movq	xmm5, QWORD PTR .LC3[rip] 		# после компиляции с оптимизирующими функциями...
	pxor	xmm2, xmm2						# (хотя сама программа работает корректно, я компилировал этот ассемблерный файл)
	movsd	xmm6, QWORD PTR .LC4[rip]
	addsd	xmm2, xmm0
	movapd	xmm1, xmm0
	mulsd	xmm4, xmm0
	andpd	xmm0, xmm5
	comisd	xmm6, xmm0
	movsd	QWORD PTR [rdi], xmm2
	mulsd	xmm1, xmm4
	ja	.L5
	mov	eax, 3
	.p2align 4,,10
	.p2align 3
.L7:
	pxor	xmm3, xmm3
	movapd	xmm0, xmm1
	cvtsi2sd	xmm3, eax
	mulsd	xmm1, xmm4
	add	eax, 2
	divsd	xmm0, xmm3
	addsd	xmm2, xmm0
	andpd	xmm0, xmm5
	comisd	xmm6, xmm0
	jbe	.L7
	movsd	QWORD PTR [rdi], xmm2
.L5:
	ret
	.size	process, .-process
	.p2align 4
	.globl	generate
	.type	generate, @function
generate:
	push	rbx
	mov	rbx, rdi
	sub	rsp, 16
	movsd	QWORD PTR 8[rsp], xmm0
	movsd	QWORD PTR [rsp], xmm1
	call	rand@PLT
	movsd	xmm0, QWORD PTR 8[rsp]
	movsd	xmm1, QWORD PTR [rsp]
	pxor	xmm2, xmm2
	cvtsi2sd	xmm2, eax
	divsd	xmm2, QWORD PTR .LC5[rip]
	subsd	xmm1, xmm0
	mulsd	xmm1, xmm2
	addsd	xmm1, xmm0
	movsd	QWORD PTR [rbx], xmm1
	add	rsp, 16
	pop	rbx
	ret
	.size	generate, .-generate
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC6:
	.string	"Command line doesn't fit pattern '{program_name} -d {input_file_name} {output_file_name}' "
	.align 8
.LC7:
	.string	"or\n'{program_name} -g {cycles_count} {output_file_name}\n'Program finished."
	.section	.rodata.str1.1
.LC8:
	.string	"-g"
.LC9:
	.string	"-d"
.LC10:
	.string	"r"
	.section	.rodata.str1.8
	.align 8
.LC11:
	.string	"Couldn't open input file.\nProgram finished."
	.section	.rodata.str1.1
.LC13:
	.string	"w"
	.section	.rodata.str1.8
	.align 8
.LC14:
	.string	"Couldn't open output file.\nProgram finished."
	.section	.rodata.str1.1
.LC15:
	.string	"input data:\n"
.LC16:
	.string	"\n\noutput data:\n"
.LC18:
	.string	"Spent time:%f sec.\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
	push	r13
	push	r12
	push	rbp
	push	rbx
	sub	rsp, 56
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR 40[rsp], rax
	xor	eax, eax
	cmp	edi, 4
	je	.L13
.L16:
	lea	rdi, .LC6[rip]
	call	puts@PLT
	lea	rdi, .LC7[rip]
	call	puts@PLT
.L14:
	mov	rax, QWORD PTR 40[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L33
	add	rsp, 56
	xor	eax, eax
	pop	rbx
	pop	rbp
	pop	r12
	pop	r13
	ret
.L13:
	xor	edi, edi
	mov	rbx, rsi
	lea	r12, .LC9[rip] 					# r12 = "-d"
	call	time@PLT
	mov	edi, eax
	call	srand@PLT
	mov	rbp, QWORD PTR 8[rbx]
	lea	rsi, .LC8[rip]
	mov	rdi, rbp
	call	strcmp@PLT
	test	eax, eax
	je	.L15
	mov	rsi, r12
	mov	rdi, rbp
	call	strcmp@PLT
	test	eax, eax
	jne	.L16
.L15:
	mov	rsi, r12
	mov	rdi, rbp
	mov	DWORD PTR 24[rsp], 0
	call	strcmp@PLT
	test	eax, eax
	jne	.L17
	mov	rdi, QWORD PTR 16[rbx]
	lea	rsi, .LC10[rip]
	mov	rbp, QWORD PTR 24[rbx]
	call	fopen@PLT
	mov	r12, rax 						# r12 = fopen(file_in, "r")
	test	rax, rax
	je	.L34
	lea	r13, 30[rsp] 					# r13 = str
	mov	rdx, rax
	lea	rsi, 24[rsp]
	mov	rdi, r13
	call	read_string
	mov	rdi, r12
	mov	r12d, 1
	call	fclose@PLT
	xor	esi, esi
	mov	rdi, r13
	call	strtod@PLT
	movsd	QWORD PTR [rsp], xmm0
	call	clock@PLT
	movsd	xmm0, QWORD PTR [rsp] 		# xmm0 = atof(str)
	mov	rbx, rax
.L19:
	movapd	xmm6, xmm0 					# xmm6 = atof(str)
	movapd	xmm10, xmm0 				# xmm10 = atof(str)
	pxor	xmm9, xmm9 					# xmm9 = 0
	xor	edx, edx
	xorpd	xmm6, XMMWORD PTR .LC1[rip] # тут что-то странное
	addsd	xmm9, xmm0
	movq	xmm7, QWORD PTR .LC3[rip]
	movapd	xmm8, xmm0
	movsd	xmm5, QWORD PTR .LC4[rip]
	mulsd	xmm6, xmm0
	andpd	xmm8, xmm7
	mulsd	xmm10, xmm6
	.p2align 4,,10
	.p2align 3
.L23:
	comisd	xmm5, xmm8 					# выполняем вычисления функции process (она явно не вызывается)
	movapd	xmm3, xmm9
	ja	.L24
	movapd	xmm2, xmm10
	mov	eax, 3
	.p2align 4,,10
	.p2align 3
.L21:
	pxor	xmm4, xmm4
	movapd	xmm1, xmm2
	cvtsi2sd	xmm4, eax
	mulsd	xmm2, xmm6
	add	eax, 2
	divsd	xmm1, xmm4
	addsd	xmm3, xmm1
	andpd	xmm1, xmm7
	comisd	xmm5, xmm1
	jbe	.L21
.L24:
	add	edx, 1
	cmp	edx, r12d 						# cnt < cycles ?
	jl	.L23
.L20:
	movsd	QWORD PTR 8[rsp], xmm3
	movsd	QWORD PTR [rsp], xmm0
	call	clock@PLT
	mov	rdi, rbp
	lea	rsi, .LC13[rip]
	mov	r12, rax 					# r12 = clock()
	call	fopen@PLT
	movsd	xmm0, QWORD PTR [rsp]
	movsd	xmm3, QWORD PTR 8[rsp]
	test	rax, rax
	mov	rbp, rax
	je	.L35
	mov	rcx, rax
	mov	edx, 12
	mov	esi, 1
	movsd	QWORD PTR 8[rsp], xmm3
	lea	rdi, .LC15[rip]
	movsd	QWORD PTR [rsp], xmm0
	lea	r13, .LC0[rip] 				# r13 = "%0.8f"
	call	fwrite@PLT
	movsd	xmm0, QWORD PTR [rsp]
	mov	rdx, r13
	mov	rdi, rbp
	mov	esi, 1
	mov	eax, 1
	call	__fprintf_chk@PLT
	mov	rcx, rbp
	mov	edx, 15
	mov	esi, 1
	lea	rdi, .LC16[rip]
	call	fwrite@PLT
	mov	rdx, r13
	mov	rdi, rbp
	mov	esi, 1
	movsd	xmm3, QWORD PTR 8[rsp]
	mov	eax, 1
	movapd	xmm0, xmm3
	call	__fprintf_chk@PLT
	pxor	xmm0, xmm0
	pxor	xmm1, xmm1
	lea	rsi, .LC18[rip]
	cvtsi2sd	xmm1, rbx
	mov	edi, 1
	mov	eax, 1
	cvtsi2sd	xmm0, r12
	subsd	xmm0, xmm1
	divsd	xmm0, QWORD PTR .LC17[rip]
	call	__printf_chk@PLT
	mov	rdi, rbp
	call	fclose@PLT
	jmp	.L14
.L17:
	mov	rdi, QWORD PTR 16[rbx]
	xor	esi, esi
	mov	edx, 10
	call	strtol@PLT
	mov	rbp, QWORD PTR 24[rbx]
	mov	r13, rax 				# r13 = atoi(argv[2])
	mov	r12d, eax 				# r12d = atoi(argv[2])
	call	rand@PLT
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, eax
	divsd	xmm0, QWORD PTR .LC5[rip]
	addsd	xmm0, xmm0
	subsd	xmm0, QWORD PTR .LC12[rip]
	movsd	QWORD PTR [rsp], xmm0
	call	clock@PLT
	test	r13d, r13d
	movsd	xmm0, QWORD PTR [rsp]
	pxor	xmm3, xmm3
	mov	rbx, rax
	jg	.L19
	jmp	.L20
.L34:
	lea	rdi, .LC11[rip]
	call	puts@PLT
	jmp	.L14
.L35:
	lea	rdi, .LC14[rip]
	call	puts@PLT
	jmp	.L14
.L33:
	call	__stack_chk_fail@PLT
	.size	main, .-main
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC1:
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
	.section	.rodata.cst8,"aM",@progbits,8
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
.LC17:
	.long	0
	.long	1093567616
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
