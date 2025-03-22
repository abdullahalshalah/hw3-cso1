	.text

############################################################
## CSO1 Spring 2023 - Homework 5 
## 
## Computing ID: ays4be
## 
## You must update your ID above to receive credit.  Note
## that this is an individual assignment and you may NOT
## use a compiler.
############################################################                         

############################################################
##   modulo routine (calculates mod using add/subtract)   ##
############################################################

	.globl	modulo
modulo:

	# TO DO: write this function
	
	# long modulo(long x, long y)
# returns x % y, using repeated subtraction until x < 0, then add y back once.
# If y == 0, return 0

        cmpq $0, %rsi         # check if y == 0
        jne  .Lmod_not_zero
        movq $0, %rax         # if y == 0, result = 0
        retq

.Lmod_not_zero:
        movq %rdi, %rax       # put x into %rax
.Lmod_loop:
        cmpq $0, %rax         # if x < 0 => done
        jl   .Lmod_done
        subq %rsi, %rax       # x -= y
        jmp  .Lmod_loop

.Lmod_done:
        addq %rsi, %rax       # undo last subtraction
        retq


############################################################
##                 end of modulo routine                  ##
############################################################



############################################################
##            gcd routine (gcd using modulo)              ##
############################################################

	.globl	gcd
gcd:

# long gcd(long x, long y)
# if (x == y) return y
# else if (y == 0) return x
# else return gcd(y, modulo(x,y))

        cmpq %rsi, %rdi
        je .Lgcd_return_y

        cmpq $0, %rsi
        je .Lgcd_return_x

        # call modulo(x, y)
        pushq %rdi    # save x
        pushq %rsi    # save y
        call modulo
        popq %rsi     # restore y
        popq %rdi     # restore x

        # gcd(y, result_of_modulo)
        movq %rsi, %rdi   # first arg = y
        movq %rax, %rsi   # second arg = x % y
        call gcd
        retq

.Lgcd_return_y:
        movq %rsi, %rax
        retq

.Lgcd_return_x:
        movq %rdi, %rax
        retq


############################################################
##                 end of gcd routine                     ##
############################################################



############################################################
##           prime routine (prime using gcd)              ##
############################################################

	.globl	prime
# long prime(long x)
# returns 1 if x is prime, 0 otherwise
# for (i=1; i<x; i++)
#     if (gcd(x,i) != 1) return 0
# return 1

prime:
        pushq %rbp
        movq  %rsp, %rbp

        # We'll store x in %r12, i in %rbx
        pushq %rbx
        pushq %r12

        movq %rdi, %r12    # x in %r12
        movq $1, %rbx      # i = 1

.Lprime_loop:
        cmpq %r12, %rbx    # if i >= x => done => prime
        jge  .Lprime_done

        # gcd(x,i)
        movq %r12, %rdi
        movq %rbx, %rsi
        call gcd

        cmpq $1, %rax      # if gcd != 1 => not prime => return 0
        jne  .Lprime_return0

        incq %rbx
        jmp  .Lprime_loop

.Lprime_return0:
        movq $0, %rax
        jmp  .Lprime_exit

.Lprime_done:
        movq $1, %rax

.Lprime_exit:
        popq %r12
        popq %rbx
        leave
        retq


############################################################
##                end of prime routine                    ##
############################################################




############################################################
	.globl	printNum
printNum:
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	subq	$24, %rsp
	movq	%fs:40, %rax
	movq	%rax, 16(%rsp)
	movb	$48, 15(%rsp)
	testq	%rdi, %rdi
	je	.LBB0_9
	movq	%rdi, %r14
	movabsq	$1000000000000000, %rbx
	cmpq	%rbx, %rdi
	jae	.LBB0_5
	movabsq	$-3689348814741910323, %rsi
.LBB0_3:
	movq	%rbx, %rcx
	movq	%rbx, %rax
	mulq	%rsi
	movq	%rdx, %rbx
	shrq	$3, %rbx
	cmpq	%r14, %rbx
	ja	.LBB0_3
	cmpq	$10, %rcx
	jb	.LBB0_7
.LBB0_5:
	movabsq	$-3689348814741910323, %r12
	leaq	15(%rsp), %r15
.LBB0_6:
	xorl	%edx, %edx
	movq	%r14, %rax
	divq	%rbx
	movq	%rax, %rcx
	mulq	%r12
	shrl	$2, %edx
	andl	$-2, %edx
	leal	(%rdx,%rdx,4), %eax
	subl	%eax, %ecx
	orb	$48, %cl
	movb	%cl, 15(%rsp)
	movl	$1, %edi
	movl	$1, %edx
	movq	%r15, %rsi
	callq	write@PLT
	movq	%rbx, %rax
	mulq	%r12
	shrq	$3, %rdx
	cmpq	$9, %rbx
	movq	%rdx, %rbx
	ja	.LBB0_6
	jmp	.LBB0_7
.LBB0_9:
	leaq	15(%rsp), %rsi
	movl	$1, %edi
	movl	$1, %edx
	callq	write@PLT
.LBB0_7:
	leaq	15(%rsp), %rsi
	movb	$10, (%rsi)
	movl	$1, %edi
	movl	$1, %edx
	callq	write@PLT
	movq	%fs:40, %rax
	cmpq	16(%rsp), %rax
	jne	.LBB0_8
	addq	$24, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	retq
.LBB0_8:
	callq	__stack_chk_fail@PLT
############################################################




############################################################
	.globl	main
main:
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	subq	$16, %rsp
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	leaq	.L.str(%rip), %rsi
	movl	$1, %edi
	movl	$9, %edx
	callq	write@PLT
	leaq	7(%rsp), %rbx
	movb	$48, (%rbx)
	movb	$48, %al
	xorl	%r14d, %r14d
.LBB1_1:
	movsbq	%al, %rax
	leaq	(%r14,%r14,4), %rcx
	leaq	(%rax,%rcx,2), %r14
	addq	$-48, %r14
	xorl	%edi, %edi
	movl	$1, %edx
	movq	%rbx, %rsi
	callq	read@PLT
	movb	7(%rsp), %al
	cmpb	$10, %al
	jne	.LBB1_1
	leaq	.L.str.1(%rip), %rsi
	xorl	%ebx, %ebx
	xorl	%edi, %edi
	movl	$9, %edx
	callq	write@PLT
	leaq	7(%rsp), %r15
	movb	$48, (%r15)
	movb	$48, %al
.LBB1_3:
	movsbq	%al, %rax
	leaq	(%rbx,%rbx,4), %rcx
	leaq	(%rax,%rcx,2), %rbx
	addq	$-48, %rbx
	xorl	%edi, %edi
	movl	$1, %edx
	movq	%r15, %rsi
	callq	read@PLT
	movb	7(%rsp), %al
	cmpb	$10, %al
	jne	.LBB1_3
	movq	%r14, %rdi
	movq	%rbx, %rsi
	callq	modulo@PLT
	movq	%rax, %r15
	leaq	.L.str.2(%rip), %rsi
	movl	$1, %edi
	movl	$8, %edx
	callq	write@PLT
	movq	%r15, %rdi
	callq	printNum
	movq	%r14, %rdi
	movq	%rbx, %rsi
	callq	gcd@PLT
	movq	%rax, %r15
	leaq	.L.str.3(%rip), %rsi
	movl	$1, %edi
	movl	$12, %edx
	callq	write@PLT
	movq	%r15, %rdi
	callq	printNum
	movq	%r14, %rdi
	callq	prime@PLT
	movq	%rax, %r15
	leaq	.L.str.4(%rip), %rsi
	movl	$1, %edi
	movl	$10, %edx
	callq	write@PLT
	movq	%r15, %rdi
	callq	printNum
	movq	%rbx, %rdi
	callq	prime@PLT
	movq	%rax, %rbx
	leaq	.L.str.5(%rip), %rsi
	movl	$1, %edi
	movl	$10, %edx
	callq	write@PLT
	movq	%rbx, %rdi
	callq	printNum
	movq	%fs:40, %rax
	cmpq	8(%rsp), %rax
	jne	.LBB1_6
	xorl	%eax, %eax
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
.LBB1_6:
	callq	__stack_chk_fail@PLT
############################################################




############################################################
	.section	.rodata
.L.str:
	.asciz	"Enter x: "
.L.str.1:
	.asciz	"Enter y: "
.L.str.2:
	.asciz	"x % y = "
.L.str.3:
	.asciz	"gcd(x, y) = "
.L.str.4:
	.asciz	"x prime = "
.L.str.5:
	.asciz	"y prime = "
############################################################
