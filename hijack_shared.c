// gcc -o hijack_shared.o -ldl -Wall -shared hijack_shared.c
#include <stdio.h>
#include <dlfcn.h>
#include <sys/types.h>

uid_t getuid(void) {
    void *handler = dlopen("libc.so.6", RTLD_LAZY);
    if (!handler)
        return (1);

    uid_t (*real_getuid)(void) = dlsym(handler, "getuid");
    dlclose(handler);
    printf("Hijacked getuid();\n");
    return ((*real_getuid)());
}
