	.file	"integral.c"
	.text
	.comm	NTHREADS,4,4
	.comm	a,8,8
	.comm	b,8,8
	.comm	nRetangulos,4,4
	.comm	delta,8,8
	.globl	resultIntegral
	.bss
	.align 8
	.type	resultIntegral, @object
	.size	resultIntegral, 8
resultIntegral:
	.zero	8
	.comm	lock,40,32
	.section	.rodata
	.align 8
.LC0:
	.string	"Digite : %s <Intervalo a> <Intervalo b> <n\302\272 de retangulos> <n\302\272 de thread>\n"
.LC1:
	.string	"\033[31m|-->ERRO: malloc"
	.align 8
.LC3:
	.string	"\033[31m|-->ERRO: pthread_create() <--|\n"
	.align 8
.LC4:
	.string	"\033[31m|-->ERRO: pthread_join()<--| "
.LC5:
	.string	"\nResultado: %lf\n"
.LC6:
	.string	"Tempo de calculo: %lf\n\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movl	%edi, -84(%rbp)
	movq	%rsi, -96(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$3, -84(%rbp)
	jg	.L2
	movq	-96(%rbp), %rax
	movq	(%rax), %rdx
	movq	stderr(%rip), %rax
	leaq	.LC0(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$1, %eax
	jmp	.L3
.L2:
	movq	-96(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atof@PLT
	movq	%xmm0, %rax
	movq	%rax, a(%rip)
	movq	-96(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atof@PLT
	movq	%xmm0, %rax
	movq	%rax, b(%rip)
	movq	-96(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, nRetangulos(%rip)
	movq	-96(%rbp), %rax
	addq	$32, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, NTHREADS(%rip)
	movsd	b(%rip), %xmm0
	movsd	a(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movl	nRetangulos(%rip), %eax
	cvtsi2sdl	%eax, %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, delta(%rip)
	movl	NTHREADS(%rip), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -72(%rbp)
	movl	NTHREADS(%rip), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -64(%rbp)
	cmpq	$0, -64(%rbp)
	je	.L4
	cmpq	$0, -72(%rbp)
	jne	.L5
.L4:
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	movl	$2, %eax
	jmp	.L3
.L5:
	movl	$0, %eax
	call	Menu
	movq	%rax, -56(%rbp)
	movl	$0, %esi
	leaq	lock(%rip), %rdi
	call	pthread_mutex_init@PLT
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime@PLT
	movq	-32(%rbp), %rax
	cvtsi2sdq	%rax, %xmm1
	movq	-24(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC2(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	movl	$0, -80(%rbp)
	jmp	.L6
.L8:
	movl	-80(%rbp), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-72(%rbp), %rax
	addq	%rax, %rdx
	movl	-80(%rbp), %eax
	movl	%eax, (%rdx)
	movl	-80(%rbp), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-72(%rbp), %rax
	addq	%rax, %rdx
	movq	-56(%rbp), %rax
	movq	%rax, 8(%rdx)
	movl	-80(%rbp), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-72(%rbp), %rax
	addq	%rax, %rdx
	movl	-80(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-64(%rbp), %rax
	addq	%rcx, %rax
	movq	%rdx, %rcx
	leaq	somaRiemann(%rip), %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_create@PLT
	testl	%eax, %eax
	je	.L7
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$37, %edx
	movl	$1, %esi
	leaq	.LC3(%rip), %rdi
	call	fwrite@PLT
	movl	$3, %eax
	jmp	.L3
.L7:
	addl	$1, -80(%rbp)
.L6:
	movl	NTHREADS(%rip), %eax
	cmpl	%eax, -80(%rbp)
	jl	.L8
	movl	$0, -76(%rbp)
	jmp	.L9
.L11:
	movl	-76(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join@PLT
	testl	%eax, %eax
	je	.L10
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	movl	$-1, %edi
	call	exit@PLT
.L10:
	addl	$1, -76(%rbp)
.L9:
	movl	NTHREADS(%rip), %eax
	cmpl	%eax, -76(%rbp)
	jl	.L11
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime@PLT
	movq	-32(%rbp), %rax
	cvtsi2sdq	%rax, %xmm1
	movq	-24(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC2(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	movsd	resultIntegral(%rip), %xmm1
	movsd	delta(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	leaq	.LC5(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	movsd	-40(%rbp), %xmm0
	subsd	-48(%rbp), %xmm0
	leaq	.LC6(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	leaq	lock(%rip), %rdi
	call	pthread_mutex_destroy@PLT
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$0, %edi
	call	pthread_exit@PLT
.L3:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L12
	call	__stack_chk_fail@PLT
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.globl	somaRiemann
	.type	somaRiemann, @function
somaRiemann:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -8(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -16(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	addl	$1, %eax
	movl	%eax, -20(%rbp)
	jmp	.L14
.L15:
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	cvtsi2sdl	-20(%rbp), %xmm1
	movsd	delta(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	call	*%rax
	movsd	-16(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movl	NTHREADS(%rip), %eax
	addl	%eax, -20(%rbp)
.L14:
	movl	nRetangulos(%rip), %eax
	cmpl	%eax, -20(%rbp)
	jle	.L15
	leaq	lock(%rip), %rdi
	call	pthread_mutex_lock@PLT
	movsd	resultIntegral(%rip), %xmm0
	addsd	-16(%rbp), %xmm0
	movsd	%xmm0, resultIntegral(%rip)
	leaq	lock(%rip), %rdi
	call	pthread_mutex_unlock@PLT
	movl	$0, %edi
	call	pthread_exit@PLT
	.cfi_endproc
.LFE7:
	.size	somaRiemann, .-somaRiemann
	.section	.rodata
	.align 8
.LC8:
	.string	"Escolha a fun\303\247\303\243o:\n\na- x*2\nb- x^2\nc- (x^3)-6*x\nd- seno(x^2)\n"
	.align 8
.LC9:
	.string	"Digite a letra da fun\303\247\303\243o que deseja executar: "
.LC10:
	.string	"%c"
	.align 8
.LC11:
	.string	"\033[31mOp\303\247\303\243o Invalida.\n\033[0;37m"
	.text
	.globl	Menu
	.type	Menu, @function
Menu:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	.LC8(%rip), %rdi
	call	puts@PLT
	leaq	.LC9(%rip), %rdi
	call	puts@PLT
	leaq	-9(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC10(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	movzbl	-9(%rbp), %eax
	movsbl	%al, %eax
	subl	$65, %eax
	cmpl	$35, %eax
	ja	.L17
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L19(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L19(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L19:
	.long	.L22-.L19
	.long	.L21-.L19
	.long	.L20-.L19
	.long	.L18-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L17-.L19
	.long	.L22-.L19
	.long	.L21-.L19
	.long	.L20-.L19
	.long	.L18-.L19
	.text
.L22:
	leaq	LetraA(%rip), %rax
	jmp	.L24
.L21:
	leaq	LetraB(%rip), %rax
	jmp	.L24
.L20:
	leaq	LetraC(%rip), %rax
	jmp	.L24
.L18:
	leaq	LetraD(%rip), %rax
	jmp	.L24
.L17:
	leaq	.LC11(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$-1, %edi
	call	exit@PLT
.L24:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L25
	call	__stack_chk_fail@PLT
.L25:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	Menu, .-Menu
	.globl	LetraA
	.type	LetraA, @function
LetraA:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movsd	%xmm0, -8(%rbp)
	movsd	-8(%rbp), %xmm0
	addsd	%xmm0, %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	LetraA, .-LetraA
	.globl	LetraB
	.type	LetraB, @function
LetraB:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movsd	%xmm0, -8(%rbp)
	movsd	.LC12(%rip), %xmm0
	movq	-8(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	pow@PLT
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	LetraB, .-LetraB
	.globl	LetraC
	.type	LetraC, @function
LetraC:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movsd	%xmm0, -8(%rbp)
	movsd	.LC13(%rip), %xmm0
	movq	-8(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	pow@PLT
	movsd	-8(%rbp), %xmm2
	movsd	.LC14(%rip), %xmm1
	mulsd	%xmm2, %xmm1
	subsd	%xmm1, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	LetraC, .-LetraC
	.globl	LetraD
	.type	LetraD, @function
LetraD:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movsd	%xmm0, -8(%rbp)
	movsd	.LC12(%rip), %xmm0
	movq	-8(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	pow@PLT
	call	sin@PLT
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	LetraD, .-LetraD
	.section	.rodata
	.align 8
.LC2:
	.long	0
	.long	1104006501
	.align 8
.LC12:
	.long	0
	.long	1073741824
	.align 8
.LC13:
	.long	0
	.long	1074266112
	.align 8
.LC14:
	.long	0
	.long	1075314688
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
