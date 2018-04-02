/* FS sandbox method used by chromium
 * only uid > 0 will allow chrooting on /proc
 * https://chromium.googlesource.com/chromium/src/+/lkgr/sandbox/linux/services/credentials.cc#69
 */
#include <stdio.h>
#include <unistd.h>
#include <sched.h>
#include <linux/sched.h>

static int ls()
{
        char *argv[] = {"/etc", NULL};
        char *env[] = {NULL};
        execve("/bin/ls", argv, env);
        return (0);
}

int main() {
        pid_t pid = -1;
        char stack[1024*1024];
        void *stack_ptr = (stack + sizeof(stack));
        /* 
        chroot("/proc/self/fdinfo");
        chdir("/");
        if ((pid = clone(ls, stack_ptr, CLONE_FS, 0)) == -1)
                perror("");
        return (0);
}
