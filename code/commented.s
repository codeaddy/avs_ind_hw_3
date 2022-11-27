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
	mov	QWORD PTR -8[rbp], rdi 					# сохранили ссылку на str
	mov	QWORD PTR -16[rbp], rsi 				# сохранили ссылку на n
	mov	QWORD PTR -24[rbp], rdx 				# сохранили ссылку на ptr
	mov	rdx, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, rdx 								# передаем ptr
	mov	edx, 10
	mov	esi, 1
	mov	rdi, rax 								# передаем str
	call	fread@PLT
	mov	edx, eax 	
	mov	rax, QWORD PTR -16[rbp]
	mov	DWORD PTR [rax], edx 					# *n = fread(...)
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
	mov	QWORD PTR -16[rbp], rdi 				# сохранили ссылку на result
	mov	rdx, QWORD PTR -8[rbp] 					# передаем ссылку на res
	mov	rax, QWORD PTR -16[rbp] 
	movq	xmm0, rdx
	lea	rdx, .LC0[rip] 							# передаем ссылку на res
	mov	rsi, rdx 								# передаем строку форматирования
	mov	rdi, rax 								# передаем ссылку на ptr
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
	mov	QWORD PTR -40[rbp], rdi 				# сохранили result
	movsd	QWORD PTR -48[rbp], xmm0 			# сохранили x
	pxor	xmm0, xmm0
	movsd	QWORD PTR -8[rbp], xmm0 			# current = 0
	movsd	xmm0, QWORD PTR -48[rbp]
	movsd	QWORD PTR -16[rbp], xmm0			# x_pow = x
	mov	rax, QWORD PTR -40[rbp]
	pxor	xmm0, xmm0
	movsd	QWORD PTR [rax], xmm0 				# result = 0
	mov	DWORD PTR -20[rbp], 0 					# i = 0
.L7:
	mov	eax, DWORD PTR -20[rbp]
	add	eax, eax
	add	eax, 1 									# eax = 2 * i + 1
	pxor	xmm1, xmm1
	cvtsi2sd	xmm1, eax
	movsd	xmm0, QWORD PTR -16[rbp]
	divsd	xmm0, xmm1 							# xmm0 = x_pow / (2 * i + 1)
	movsd	QWORD PTR -8[rbp], xmm0 			# сохранили результат операции выше
	movsd	xmm0, QWORD PTR -48[rbp]
	movq	xmm1, QWORD PTR .LC2[rip]
	xorpd	xmm0, xmm1
	mulsd	xmm0, QWORD PTR -48[rbp]
	movsd	xmm1, QWORD PTR -16[rbp]
	mulsd	xmm0, xmm1 							# xmm0 = -1 * x * x
	movsd	QWORD PTR -16[rbp], xmm0 			# x_pow *= -1 * x * x
	mov	rax, QWORD PTR -40[rbp]
	movsd	xmm0, QWORD PTR [rax]
	addsd	xmm0, QWORD PTR -8[rbp] 			# xmm0 = result + current
	mov	rax, QWORD PTR -40[rbp]
	movsd	QWORD PTR [rax], xmm0 				# resukt = result + current
	movsd	xmm0, QWORD PTR -8[rbp]
	movq	xmm1, QWORD PTR .LC3[rip]
	andpd	xmm1, xmm0
	movsd	xmm0, QWORD PTR .LC4[rip]
	comisd	xmm0, xmm1 							# fabs(current) < 0.0005 ?
	ja	.L8
	add	DWORD PTR -20[rbp], 1 					# i++
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
	mov	QWORD PTR -8[rbp], rdi 				# сохранили указатель на x
	movsd	QWORD PTR -16[rbp], xmm0
	movsd	QWORD PTR -24[rbp], xmm1
	call	rand@PLT
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, eax 					# xmm0 = rand()
	movsd	xmm2, QWORD PTR .LC5[rip] 		# xmm2 = RAND_MAX
	movapd	xmm1, xmm0 						# xmm1 = rand() * 1.0
	divsd	xmm1, xmm2 						# xmm1 = rand() * 1.0 / RAND_MAX
	movsd	xmm0, QWORD PTR -24[rbp] 		# xmm0 = r_gr
	subsd	xmm0, QWORD PTR -16[rbp] 		# xmm0 = l_gr - r_gr
	mulsd	xmm0, xmm1 						# xmm0 = (rand() * 1.0 / RAND_MAX * (r_gr - l_gr))
	addsd	xmm0, QWORD PTR -16[rbp] 		# xmm0 = l_gr + ...
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
	mov	DWORD PTR -116[rbp], edi				# сохранили argc
	mov	QWORD PTR -128[rbp], rsi 				# сохранили argv
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	cmp	DWORD PTR -116[rbp], 4 					# argc != 4 ?
	je	.L11
	lea	rax, .LC6[rip]
	mov	rdi, rax 								# передаем сообщение о некорректном вводе
	call	puts@PLT
	lea	rax, .LC7[rip]
	mov	rdi, rax								# передаем сообщение о некорректном вводе
	call	puts@PLT
	mov	eax, 0
	jmp	.L20
.L11:
	mov	edi, 0 									# time(NULL)
	call	time@PLT
	mov	edi, eax 								# srand(time(NULL))
	call	srand@PLT
	mov	rax, QWORD PTR -128[rbp]
	mov	rax, QWORD PTR 8[rax]					# type = argv[1]
	mov	QWORD PTR -72[rbp], rax 				# сохранили type
	mov	rax, QWORD PTR -72[rbp]
	lea	rdx, .LC8[rip]
	mov	rsi, rdx 					 			# передаем строку "-g"
	mov	rdi, rax 								# передаем строку type
	call	strcmp@PLT
	test	eax, eax 							# strcmp(type, "-g") != 0 ?
	je	.L13
	mov	rax, QWORD PTR -72[rbp]
	lea	rdx, .LC9[rip]
	mov	rsi, rdx 								# передаем строку "-d"
	mov	rdi, rax								# передаем type
	call	strcmp@PLT
	test	eax, eax
	je	.L13
	lea	rax, .LC6[rip]
	mov	rdi, rax 								# передаем сообщение о некорректном вводе
	call	puts@PLT
	lea	rax, .LC7[rip]
	mov	rdi, rax 								# передаем сообщение о некорректном вводе
	call	puts@PLT
	mov	eax, 0
	jmp	.L20
.L13:
	mov	DWORD PTR -108[rbp], 0 					# n = 0
	mov	DWORD PTR -104[rbp], 1 					# cycles = 1
	pxor	xmm0, xmm0 							# x = 0
	movsd	QWORD PTR -96[rbp], xmm0 			# сохранили x
	mov	rax, QWORD PTR -72[rbp]
	lea	rdx, .LC9[rip]
	mov	rsi, rdx 								# передаем строку "-d"
	mov	rdi, rax								# передаем строку type
	call	strcmp@PLT
	test	eax, eax
	jne	.L14
	mov	rax, QWORD PTR -128[rbp]
	mov	rax, QWORD PTR 16[rax]
	mov	QWORD PTR -64[rbp], rax 				# file_in = argv[2]
	mov	rax, QWORD PTR -128[rbp]
	mov	rax, QWORD PTR 24[rax]
	mov	QWORD PTR -80[rbp], rax 				# file_out = argv[3]
	mov	rax, QWORD PTR -64[rbp]
	lea	rdx, .LC10[rip] 						# строка "r"
	mov	rsi, rdx 								# передаем строку "r"
	mov	rdi, rax 								# передаем строку file_in
	call	fopen@PLT
	mov	QWORD PTR -56[rbp], rax 				# сохранили ссылку на входной файл
	cmp	QWORD PTR -56[rbp], 0 					# fin_ptr == NULL ?
	jne	.L15
	lea	rax, .LC11[rip]
	mov	rdi, rax 								# передаем сообщение о неудаче при открытии файла
	call	puts@PLT
	mov	eax, 0
	jmp	.L20
.L15:
	mov	rdx, QWORD PTR -56[rbp] 				# передаем fin_ptr
	lea	rcx, -108[rbp]
	lea	rax, -18[rbp]
	mov	rsi, rcx 								# передаем указатель на n
	mov	rdi, rax 								# передаем str
	call	read_string
	mov	rax, QWORD PTR -56[rbp]
	mov	rdi, rax 								# передаем fin_ptr
	call	fclose@PLT
	lea	rax, -18[rbp]
	mov	rdi, rax 								# передаем str
	call	atof@PLT
	movq	rax, xmm0
	mov	QWORD PTR -96[rbp], rax 				# x = atof(str)
	jmp	.L16
.L14:
	mov	rax, QWORD PTR -128[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rdi, rax 								# передаем argv[2]
	call	atoi@PLT
	mov	DWORD PTR -104[rbp], eax 				# cycles = atoi(argv[2])
	mov	rax, QWORD PTR -128[rbp]
	mov	rax, QWORD PTR 24[rax]
	mov	QWORD PTR -80[rbp], rax 				# file_out = argv[3]
	movsd	xmm0, QWORD PTR .LC12[rip]
	mov	rdx, QWORD PTR .LC13[rip]
	lea	rax, -96[rbp]
	movapd	xmm1, xmm0
	movq	xmm0, rdx
	mov	rdi, rax 								# передаем указатель на x
	call	generate
.L16:
	pxor	xmm0, xmm0
	movsd	QWORD PTR -88[rbp], xmm0  			# result = 0
	call	clock@PLT
	mov	QWORD PTR -48[rbp], rax 				# t_start = clock()
	mov	DWORD PTR -100[rbp], 0 					# cnt = 0
	jmp	.L17
.L18:
	mov	rdx, QWORD PTR -96[rbp] 				# передаем x
	lea	rax, -88[rbp]
	movq	xmm0, rdx
	mov	rdi, rax 								# передаем указатель на result
	call	process
	add	DWORD PTR -100[rbp], 1 					# cnt++
.L17:
	mov	eax, DWORD PTR -100[rbp]
	cmp	eax, DWORD PTR -104[rbp] 				# cnt < cycles ?
	jl	.L18
	call	clock@PLT
	mov	QWORD PTR -40[rbp], rax 				# t_stop = clock()
	mov	rax, QWORD PTR -80[rbp]
	lea	rdx, .LC14[rip]
	mov	rsi, rdx 								# передаем "w"
	mov	rdi, rax 								# передаем file_out
	call	fopen@PLT
	mov	QWORD PTR -32[rbp], rax 				# сохранили ссылку на выходной файл
	cmp	QWORD PTR -32[rbp], 0  					# fout_ptr == NULL ?
	jne	.L19
	lea	rax, .LC15[rip]
	mov	rdi, rax 								# передаем сообщение о неудаче при открытии выходного файла
	call	puts@PLT
	mov	eax, 0
	jmp	.L20
.L19:
	mov	rax, QWORD PTR -32[rbp]
	mov	rcx, rax
	mov	edx, 12 								# какие-то магические константы для фукнции fwrite
	mov	esi, 1
	lea	rax, .LC16[rip]
	mov	rdi, rax 								# передаем строку "input data:"
	call	fwrite@PLT
	mov	rax, QWORD PTR -96[rbp]
	mov	rdx, QWORD PTR -32[rbp]
	mov	rdi, rdx
	movq	xmm0, rax
	call	print_double
	mov	rax, QWORD PTR -32[rbp]
	mov	rcx, rax
	mov	edx, 15 								# какие-то магические константы для фукнции fwrite
	mov	esi, 1
	lea	rax, .LC17[rip]
	mov	rdi, rax 								# передаем строку "output:"
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
	movq	xmm0, rax 							# передаем время выполнения программы
	lea	rax, .LC19[rip]
	mov	rdi, rax 								# передаем строку "Spent time..."
	mov	eax, 1
	call	printf@PLT
	mov	rax, QWORD PTR -32[rbp]
	mov	rdi, rax 								# передаем ссылка на выходной файл
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
