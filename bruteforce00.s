	.file	"bruteforce00.c"
	.text
	.globl	decrypt
	.type	decrypt, @function
decrypt:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movl	%edx, -52(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$0, -16(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L2
.L3:
	salq	-40(%rbp)
	movl	-20(%rbp), %eax
	sall	$3, %eax
	movl	$254, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	cltq
	andq	-40(%rbp), %rax
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -16(%rbp)
	addl	$1, -20(%rbp)
.L2:
	cmpl	$7, -20(%rbp)
	jle	.L3
	leaq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	des_setparity@PLT
	movq	-48(%rbp), %rsi
	leaq	-16(%rbp), %rax
	movl	$1, %ecx
	movl	$16, %edx
	movq	%rax, %rdi
	call	ecb_crypt@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L4
	call	__stack_chk_fail@PLT
.L4:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	decrypt, .-decrypt
	.globl	_encrypt
	.type	_encrypt, @function
_encrypt:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movl	%edx, -52(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$0, -16(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L6
.L7:
	salq	-40(%rbp)
	movl	-20(%rbp), %eax
	sall	$3, %eax
	movl	$254, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	cltq
	andq	-40(%rbp), %rax
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -16(%rbp)
	addl	$1, -20(%rbp)
.L6:
	cmpl	$7, -20(%rbp)
	jle	.L7
	leaq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	des_setparity@PLT
	movq	-48(%rbp), %rsi
	leaq	-16(%rbp), %rax
	movl	$0, %ecx
	movl	$16, %edx
	movq	%rax, %rdi
	call	ecb_crypt@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	_encrypt, .-_encrypt
	.globl	search
	.data
	.align 8
	.type	search, @object
	.size	search, 9
search:
	.string	" lectus "
	.text
	.globl	tryKey
	.type	tryKey, @function
tryKey:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$72, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -68(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	%rsp, %rax
	movq	%rax, %rbx
	movl	-68(%rbp), %eax
	addl	$1, %eax
	movslq	%eax, %rdx
	subq	$1, %rdx
	movq	%rdx, -40(%rbp)
	movslq	%eax, %rdx
	movq	%rdx, %r10
	movl	$0, %r11d
	movslq	%eax, %rdx
	movq	%rdx, %r8
	movl	$0, %r9d
	cltq
	movl	$16, %edx
	subq	$1, %rdx
	addq	%rdx, %rax
	movl	$16, %esi
	movl	$0, %edx
	divq	%rsi
	imulq	$16, %rax, %rax
	movq	%rax, %rcx
	andq	$-4096, %rcx
	movq	%rsp, %rdx
	subq	%rcx, %rdx
.L10:
	cmpq	%rdx, %rsp
	je	.L11
	subq	$4096, %rsp
	orq	$0, 4088(%rsp)
	jmp	.L10
.L11:
	movq	%rax, %rdx
	andl	$4095, %edx
	subq	%rdx, %rsp
	movq	%rax, %rdx
	andl	$4095, %edx
	testq	%rdx, %rdx
	je	.L12
	andl	$4095, %eax
	subq	$8, %rax
	addq	%rsp, %rax
	orq	$0, (%rax)
.L12:
	movq	%rsp, %rax
	addq	$0, %rax
	movq	%rax, -32(%rbp)
	movl	-68(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy@PLT
	movq	-32(%rbp), %rdx
	movl	-68(%rbp), %eax
	cltq
	movb	$0, (%rdx,%rax)
	movl	-68(%rbp), %edx
	movq	-32(%rbp), %rcx
	movq	-56(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	decrypt
	movq	-32(%rbp), %rax
	leaq	search(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strstr@PLT
	testq	%rax, %rax
	setne	%al
	movzbl	%al, %eax
	movq	%rbx, %rsp
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L14
	call	__stack_chk_fail@PLT
.L14:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	tryKey, .-tryKey
	.section	.rodata
.LC0:
	.string	"r"
.LC1:
	.string	"message.txt"
	.align 8
.LC2:
	.string	"Key encountered:\n%li,\nText:\n%s\n"
.LC3:
	.string	"Elapsed time is %f seconds\n"
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
	subq	$176, %rsp
	movl	%edi, -164(%rbp)
	movq	%rsi, -176(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movabsq	$72057594037927936, %rax
	movq	%rax, -104(%rbp)
	movl	$1024, %edi
	call	malloc@PLT
	movq	%rax, -96(%rbp)
	movl	$1024, %edi
	call	malloc@PLT
	movq	%rax, -88(%rbp)
	leaq	.LC0(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -80(%rbp)
	cmpq	$0, -80(%rbp)
	jne	.L16
	movl	$-1, %eax
	jmp	.L17
.L16:
	movl	$0, -148(%rbp)
	jmp	.L18
.L20:
	movl	-148(%rbp), %eax
	movslq	%eax, %rdx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movl	-148(%rbp), %edx
	movslq	%edx, %rcx
	movq	-88(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -148(%rbp)
	cmpl	$1023, -148(%rbp)
	jg	.L31
.L18:
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	fgetc@PLT
	movl	%eax, %edx
	movl	-148(%rbp), %eax
	movslq	%eax, %rcx
	movq	-96(%rbp), %rax
	addq	%rcx, %rax
	movb	%dl, (%rax)
	movzbl	(%rax), %eax
	cmpb	$-1, %al
	jne	.L20
	jmp	.L19
.L31:
	nop
.L19:
	movl	-148(%rbp), %eax
	movslq	%eax, %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, -140(%rbp)
	movl	-140(%rbp), %edx
	movq	-88(%rbp), %rax
	movq	%rax, %rsi
	movl	$2310089, %edi
	call	_encrypt
	leaq	ompi_mpi_comm_world(%rip), %rax
	movq	%rax, -72(%rbp)
	movl	$0, %esi
	movl	$0, %edi
	call	MPI_Init@PLT
	call	MPI_Wtime@PLT
	movq	%xmm0, %rax
	movq	%rax, -64(%rbp)
	leaq	-160(%rbp), %rdx
	movq	-72(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	MPI_Comm_size@PLT
	leaq	-156(%rbp), %rdx
	movq	-72(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	MPI_Comm_rank@PLT
	movl	-160(%rbp), %eax
	movslq	%eax, %rsi
	movq	-104(%rbp), %rax
	cqto
	idivq	%rsi
	movq	%rax, -56(%rbp)
	movl	-156(%rbp), %eax
	cltq
	movq	-56(%rbp), %rdx
	imulq	%rdx, %rax
	movq	%rax, -48(%rbp)
	movl	-156(%rbp), %eax
	addl	$1, %eax
	cltq
	imulq	-56(%rbp), %rax
	subq	$1, %rax
	movq	%rax, -120(%rbp)
	movl	-160(%rbp), %eax
	leal	-1(%rax), %edx
	movl	-156(%rbp), %eax
	cmpl	%eax, %edx
	jne	.L21
	movq	-104(%rbp), %rax
	movq	%rax, -120(%rbp)
.L21:
	movq	$0, -128(%rbp)
	movl	$0, -152(%rbp)
	movq	-72(%rbp), %rcx
	leaq	-128(%rbp), %rax
	subq	$8, %rsp
	leaq	-136(%rbp), %rdx
	pushq	%rdx
	movq	%rcx, %r9
	movl	$-1, %r8d
	movl	$-1, %ecx
	leaq	ompi_mpi_long(%rip), %rdx
	movl	$1, %esi
	movq	%rax, %rdi
	call	MPI_Irecv@PLT
	addq	$16, %rsp
	movq	-48(%rbp), %rax
	movq	%rax, -112(%rbp)
	jmp	.L22
.L28:
	leaq	-152(%rbp), %rcx
	leaq	-136(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	MPI_Test@PLT
	movl	-152(%rbp), %eax
	testl	%eax, %eax
	jne	.L32
	movl	-140(%rbp), %edx
	movq	-88(%rbp), %rcx
	movq	-112(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tryKey
	testl	%eax, %eax
	je	.L25
	movq	-112(%rbp), %rax
	movq	%rax, -128(%rbp)
	movl	$0, -144(%rbp)
	jmp	.L26
.L27:
	movl	-144(%rbp), %edx
	leaq	-128(%rbp), %rax
	leaq	ompi_mpi_comm_world(%rip), %r9
	movl	$0, %r8d
	movl	%edx, %ecx
	leaq	ompi_mpi_long(%rip), %rdx
	movl	$1, %esi
	movq	%rax, %rdi
	call	MPI_Send@PLT
	addl	$1, -144(%rbp)
.L26:
	movl	-160(%rbp), %eax
	cmpl	%eax, -144(%rbp)
	jl	.L27
	jmp	.L24
.L25:
	addq	$1, -112(%rbp)
.L22:
	movq	-112(%rbp), %rax
	cmpq	-120(%rbp), %rax
	jl	.L28
	jmp	.L24
.L32:
	nop
.L24:
	movl	-156(%rbp), %eax
	testl	%eax, %eax
	jne	.L29
	leaq	-32(%rbp), %rdx
	leaq	-136(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	MPI_Wait@PLT
	movq	-128(%rbp), %rax
	movl	-140(%rbp), %edx
	movq	-88(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	decrypt
	call	MPI_Wtime@PLT
	movq	%xmm0, %rax
	movq	%rax, -40(%rbp)
	movq	-128(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	%rax, %rsi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movsd	-40(%rbp), %xmm0
	subsd	-64(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
.L29:
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	call	MPI_Finalize@PLT
	movl	$0, %eax
.L17:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L30
	call	__stack_chk_fail@PLT
.L30:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
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
