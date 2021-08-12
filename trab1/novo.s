	.file	"novo.c"
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
	.text
	.globl	somaRiemannLetraA
	.type	somaRiemannLetraA, @function
somaRiemannLetraA:
.LFB6:
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
	movsd	%xmm0, -24(%rbp)
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -16(%rbp)
	jmp	.L2
.L3:
	movq	-16(%rbp), %rax
	addq	%rax, %rax
	cvtsi2sdq	%rax, %xmm1
	movsd	delta(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movl	NTHREADS(%rip), %eax
	cltq
	addq	%rax, -16(%rbp)
.L2:
	movl	nRetangulos(%rip), %eax
	cltq
	cmpq	%rax, -16(%rbp)
	jle	.L3
	leaq	lock(%rip), %rdi
	call	pthread_mutex_lock@PLT
	movsd	resultIntegral(%rip), %xmm0
	addsd	-24(%rbp), %xmm0
	movsd	%xmm0, resultIntegral(%rip)
	leaq	lock(%rip), %rdi
	call	pthread_mutex_unlock@PLT
	movl	$0, %edi
	call	pthread_exit@PLT
	.cfi_endproc
.LFE6:
	.size	somaRiemannLetraA, .-somaRiemannLetraA
	.globl	somaRiemannLetraB
	.type	somaRiemannLetraB, @function
somaRiemannLetraB:
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
	movsd	%xmm0, -24(%rbp)
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -16(%rbp)
	jmp	.L5
.L6:
	cvtsi2sdq	-16(%rbp), %xmm1
	movsd	delta(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC1(%rip), %xmm1
	call	pow@PLT
	movsd	-24(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movl	NTHREADS(%rip), %eax
	cltq
	addq	%rax, -16(%rbp)
.L5:
	movl	nRetangulos(%rip), %eax
	cltq
	cmpq	%rax, -16(%rbp)
	jle	.L6
	leaq	lock(%rip), %rdi
	call	pthread_mutex_lock@PLT
	movsd	resultIntegral(%rip), %xmm0
	addsd	-24(%rbp), %xmm0
	movsd	%xmm0, resultIntegral(%rip)
	leaq	lock(%rip), %rdi
	call	pthread_mutex_unlock@PLT
	movl	$0, %edi
	call	pthread_exit@PLT
	.cfi_endproc
.LFE7:
	.size	somaRiemannLetraB, .-somaRiemannLetraB
	.globl	somaRiemannLetraC
	.type	somaRiemannLetraC, @function
somaRiemannLetraC:
.LFB8:
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
	movsd	%xmm0, -24(%rbp)
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -16(%rbp)
	jmp	.L8
.L9:
	cvtsi2sdq	-16(%rbp), %xmm1
	movsd	delta(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC2(%rip), %xmm1
	call	pow@PLT
	movq	-16(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	cvtsi2sdq	%rax, %xmm2
	movsd	delta(%rip), %xmm1
	mulsd	%xmm2, %xmm1
	subsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movl	NTHREADS(%rip), %eax
	cltq
	addq	%rax, -16(%rbp)
.L8:
	movl	nRetangulos(%rip), %eax
	cltq
	cmpq	%rax, -16(%rbp)
	jle	.L9
	leaq	lock(%rip), %rdi
	call	pthread_mutex_lock@PLT
	movsd	resultIntegral(%rip), %xmm0
	addsd	-24(%rbp), %xmm0
	movsd	%xmm0, resultIntegral(%rip)
	leaq	lock(%rip), %rdi
	call	pthread_mutex_unlock@PLT
	movl	$0, %edi
	call	pthread_exit@PLT
	.cfi_endproc
.LFE8:
	.size	somaRiemannLetraC, .-somaRiemannLetraC
	.globl	somaRiemannLetraD
	.type	somaRiemannLetraD, @function
somaRiemannLetraD:
.LFB9:
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
	movsd	%xmm0, -24(%rbp)
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -16(%rbp)
	jmp	.L11
.L12:
	cvtsi2sdq	-16(%rbp), %xmm1
	movsd	delta(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC1(%rip), %xmm1
	call	pow@PLT
	call	sin@PLT
	movsd	-24(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movl	NTHREADS(%rip), %eax
	cltq
	addq	%rax, -16(%rbp)
.L11:
	movl	nRetangulos(%rip), %eax
	cltq
	cmpq	%rax, -16(%rbp)
	jle	.L12
	leaq	lock(%rip), %rdi
	call	pthread_mutex_lock@PLT
	movsd	resultIntegral(%rip), %xmm0
	addsd	-24(%rbp), %xmm0
	movsd	%xmm0, resultIntegral(%rip)
	leaq	lock(%rip), %rdi
	call	pthread_mutex_unlock@PLT
	movl	$0, %edi
	call	pthread_exit@PLT
	.cfi_endproc
.LFE9:
	.size	somaRiemannLetraD, .-somaRiemannLetraD
	.section	.rodata
	.align 8
.LC3:
	.string	"Escolha a fun\303\247\303\243o:\n\na- x*2\nb- x^2\nc- (x^3)-6*x\nd- seno(x^2)\n"
	.align 8
.LC4:
	.string	"Digite a letra da fun\303\247\303\243o que deseja executar: "
.LC5:
	.string	"%c"
.LC6:
	.string	"\033[31m|-->ERRO: malloc"
	.align 8
.LC8:
	.string	"\033[31m|-->ERRO: pthread_create() <--|\n"
	.align 8
.LC9:
	.string	"\033[31mOp\303\247\303\243o Invalida.\n\033[0;37m"
	.align 8
.LC10:
	.string	"\033[31m|-->ERRO: pthread_join()<--| "
.LC11:
	.string	"\nResultado: %lf\n"
.LC12:
	.string	"Tempo de calculo: %lf\n\n"
	.text
	.type	preThread, @function
preThread:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, %esi
	leaq	lock(%rip), %rdi
	call	pthread_mutex_init@PLT
	movl	NTHREADS(%rip), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -56(%rbp)
	leaq	.LC3(%rip), %rdi
	call	puts@PLT
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	leaq	-93(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC5(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	cmpq	$0, -56(%rbp)
	jne	.L14
	leaq	.LC6(%rip), %rdi
	call	puts@PLT
	movl	$2, %edi
	call	exit@PLT
.L14:
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime@PLT
	movq	-32(%rbp), %rax
	cvtsi2sdq	%rax, %xmm1
	movq	-24(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC7(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	movzbl	-93(%rbp), %eax
	movsbl	%al, %eax
	subl	$65, %eax
	cmpl	$35, %eax
	ja	.L15
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L17(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L17(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L17:
	.long	.L20-.L17
	.long	.L19-.L17
	.long	.L18-.L17
	.long	.L16-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L15-.L17
	.long	.L20-.L17
	.long	.L19-.L17
	.long	.L18-.L17
	.long	.L16-.L17
	.text
.L20:
	movq	$0, -88(%rbp)
	jmp	.L21
.L23:
	movq	-88(%rbp), %rax
	movq	-88(%rbp), %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-56(%rbp), %rdx
	leaq	(%rcx,%rdx), %rdi
	movq	%rax, %rcx
	leaq	somaRiemannLetraA(%rip), %rdx
	movl	$0, %esi
	call	pthread_create@PLT
	testl	%eax, %eax
	je	.L22
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$37, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rdi
	call	fwrite@PLT
	movl	$3, %edi
	call	exit@PLT
.L22:
	addq	$1, -88(%rbp)
.L21:
	movl	NTHREADS(%rip), %eax
	cltq
	cmpq	%rax, -88(%rbp)
	jl	.L23
	jmp	.L24
.L19:
	movq	$0, -80(%rbp)
	jmp	.L25
.L27:
	movq	-80(%rbp), %rax
	movq	-80(%rbp), %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-56(%rbp), %rdx
	leaq	(%rcx,%rdx), %rdi
	movq	%rax, %rcx
	leaq	somaRiemannLetraB(%rip), %rdx
	movl	$0, %esi
	call	pthread_create@PLT
	testl	%eax, %eax
	je	.L26
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$37, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rdi
	call	fwrite@PLT
	movl	$3, %edi
	call	exit@PLT
.L26:
	addq	$1, -80(%rbp)
.L25:
	movl	NTHREADS(%rip), %eax
	cltq
	cmpq	%rax, -80(%rbp)
	jl	.L27
	jmp	.L24
.L18:
	movq	$0, -72(%rbp)
	jmp	.L28
.L30:
	movq	-72(%rbp), %rax
	movq	-72(%rbp), %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-56(%rbp), %rdx
	leaq	(%rcx,%rdx), %rdi
	movq	%rax, %rcx
	leaq	somaRiemannLetraC(%rip), %rdx
	movl	$0, %esi
	call	pthread_create@PLT
	testl	%eax, %eax
	je	.L29
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$37, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rdi
	call	fwrite@PLT
	movl	$3, %edi
	call	exit@PLT
.L29:
	addq	$1, -72(%rbp)
.L28:
	movl	NTHREADS(%rip), %eax
	cltq
	cmpq	%rax, -72(%rbp)
	jl	.L30
	jmp	.L24
.L16:
	movq	$0, -64(%rbp)
	jmp	.L31
.L33:
	movq	-64(%rbp), %rax
	movq	-64(%rbp), %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-56(%rbp), %rdx
	leaq	(%rcx,%rdx), %rdi
	movq	%rax, %rcx
	leaq	somaRiemannLetraD(%rip), %rdx
	movl	$0, %esi
	call	pthread_create@PLT
	testl	%eax, %eax
	je	.L32
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$37, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rdi
	call	fwrite@PLT
	movl	$3, %edi
	call	exit@PLT
.L32:
	addq	$1, -64(%rbp)
.L31:
	movl	NTHREADS(%rip), %eax
	cltq
	cmpq	%rax, -64(%rbp)
	jl	.L33
	jmp	.L24
.L15:
	leaq	.LC9(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$-1, %edi
	call	exit@PLT
.L24:
	movl	$0, -92(%rbp)
	jmp	.L34
.L36:
	movl	-92(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join@PLT
	testl	%eax, %eax
	je	.L35
	leaq	.LC10(%rip), %rdi
	call	puts@PLT
	movl	$-1, %edi
	call	exit@PLT
.L35:
	addl	$1, -92(%rbp)
.L34:
	movl	NTHREADS(%rip), %eax
	cmpl	%eax, -92(%rbp)
	jl	.L36
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime@PLT
	movq	-32(%rbp), %rax
	cvtsi2sdq	%rax, %xmm1
	movq	-24(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC7(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	movsd	resultIntegral(%rip), %xmm1
	movsd	delta(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	leaq	.LC11(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	movsd	-40(%rbp), %xmm0
	subsd	-48(%rbp), %xmm0
	leaq	.LC12(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	leaq	lock(%rip), %rdi
	call	pthread_mutex_destroy@PLT
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$0, %edi
	call	pthread_exit@PLT
	.cfi_endproc
.LFE10:
	.size	preThread, .-preThread
	.section	.rodata
	.align 8
.LC13:
	.string	"Digite : %s <Intervalo a> <Intervalo b> <n\302\272 de retangulos> <n\302\272 de thread>\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	cmpl	$3, -4(%rbp)
	jg	.L39
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movq	stderr(%rip), %rax
	leaq	.LC13(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$1, %edi
	call	exit@PLT
.L39:
	movq	-16(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atof@PLT
	movq	%xmm0, %rax
	movq	%rax, a(%rip)
	movq	-16(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atof@PLT
	movq	%xmm0, %rax
	movq	%rax, b(%rip)
	movq	-16(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, nRetangulos(%rip)
	movq	-16(%rbp), %rax
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
	movl	$0, %eax
	call	preThread
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC1:
	.long	0
	.long	1073741824
	.align 8
.LC2:
	.long	0
	.long	1074266112
	.align 8
.LC7:
	.long	0
	.long	1104006501
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
