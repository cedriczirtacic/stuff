// for linux x86-64
// recognizes ELFs inside dir
// ./get_elfs <path>
.set BUF_SIZE, 4096

.set SYS_write,         1
.set SYS_open,          2
.set SYS_close,         3
.set SYS_getdents,      78
.set SYS_chdir,         80

.set O_RDONLY, 0
.set O_DIRECTORY, 00200000

.section .rodata
dir:
        .asciz "."
.section .data
file_fd:
        .int 0
dir_fd:
        .int 0

// struct linux_dirent
d_ino:
        .quad 0
d_off:
        .quad 0
d_reclen:
        .byte 0x00, 0x00
d_name:
        .quad 0
newline:
        .byte 10

.section .text
.global _start

.macro println
        movq $SYS_write, %rax
        movq $1, %rdi
        leaq (newline), %rsi
        movq $1, %rdx
        syscall
.endm

_exit:
        // exit(0)
        movq $60, %rax
        xorq %rdi, %rdi
        syscall

_start:
        pushq %rbp
        movq %rsp, %rbp

        // exit if args < 2
        cmp $2, 0x8(%rbp)
        jge .Lstart
        call _exit

.Lstart:
        movq 0x10(%rbp), %r9
        .L02:
                cmpb $0, (%r9)
                je .L02_end
                incb %r9b
                jmp .L02
        .L02_end:
        incb %r9b

        // chdir(%r9)
        movq $SYS_chdir, %rax
        leaq (%r9), %rdi
        syscall

        //open(%rdi, 0, 0)
        movq $SYS_open, %rax
        movq $O_RDONLY, %rsi
        orq $O_DIRECTORY, %rsi
        xorq %rdx, %rdx
        syscall
        movq %rax, (dir_fd)

.L00:
        subq $BUF_SIZE, %rbp
        // getdents(dir_fd, &rbp, BUF_SIZE);
        movq $SYS_getdents, %rax
        movq (dir_fd), %rdi
        leaq (%rbp), %rsi
        movq $BUF_SIZE, %rdx
        syscall
        testl %eax, %eax
        jz .L00_end

        leaq (%rbp), %rdi
        movq %rax, %rsi
        call identify

        jmp .L00
.L00_end:

        // close(dir_fd)
        movq $SYS_close, %rax
        movq (dir_fd), %rdi
        syscall

        popq %rbp
        call _exit

// int identify(struct linux_dirent *rdi, int rsi)
identify:
        push %rbp
        movq %rsp, %rbp

        movq %rdi, -0x8(%rbp)
        movq %rsi, -0x10(%rbp)

        // read struct
.L01:
        movq -0x8(%rbp), %rbx
        movq -0x10(%rbp), %rcx

        movq (%rbx), %r9
        movq %r9, d_ino
        addq $8, %rbx
        movq (%rbx), %r9
        movq %r9, d_off
        addq $8, %rbx
        movb (%rbx), %r9b
        movb %r9b, d_reclen
        movb 1(%rbx), %r9b
        movb %r9b, d_reclen+1
        addq $2, %rbx
        movq %rbx, d_name

        // prepare next struct
        xorq %r9, %r9
        movw d_reclen, %r9w
        addq %r9, -0x8(%rbp)
        subw d_reclen, %cx
        movq %rcx, -0x10(%rbp)

        // check type of dirent
        movq -0x8(%rbp), %r9
        decb %r9b
        cmpb $8, (%r9)
        jne .Lno_print

        // open(%rbx, 0, 0)
        movq $SYS_open, %rax
        leaq (%rbx), %rdi
        xorq %rsi, %rsi
        xorq %rdx, %rdx
        syscall
        movl %eax, file_fd
.endm
        // read(file_fd, &%rsi, 4)
        xorq %rax, %rax
        movl file_fd, %edi
        leaq -0x16(%rbp), %rsi
        movq $4, %rdx
        syscall
        cmpl $0x464c457f, (%rsi)
        jne .Lno_print
        // close(file_fd)
        movq $SYS_close, %rax
        movl file_fd, %edi
        syscall
        movq %rbx, %rsi
        // while(*rsi != '\0') { write(1,*rsi,1); }
        movq $1, %rdi
        .Lprint:
                cmpb $0, (%rsi)
                jz .Lprint_end
                xorq %rax, %rax
                movq $SYS_write, %rax
                movq $1, %rdx
                syscall
                addb $1, %sil
                jmp .Lprint
        .Lprint_end:
        println
        .Lno_print:
        cmp $0, -0x10(%rbp)
        jne .L01
.L01_end:
        popq %rbp
        retq

