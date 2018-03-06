# bf2c
brainfuck code to basic C

takes bf code:
```brainfuck
-[----->+<]>>+++++++++++++++++[-<+>>+<]<.-.>>[-<<->>]<<+++.-----.++++++.
```

transform it to basic C code:
```bash
$ ./bf2c dc506
Success: dc506.c
$ cat dc506.c
```
```c
int main() {
	char c[3000];
	char *ptr = c;

        --*ptr;
        while (*ptr) {
            *ptr -= 5;
            --ptr;
            ++*ptr;
            ++ptr;
        }
        ptr -= 2;
        *ptr += 17;
        while (*ptr) {
            --*ptr;
            ++ptr;
            ++*ptr;
            ptr -= 2;
            ++*ptr;
            ++ptr;
        }
        ++ptr;
        putchar(*ptr);
        --*ptr;
        putchar(*ptr);
        ptr -= 2;
        while (*ptr) {
            --*ptr;
            ptr += 2;
            --*ptr;
            ptr -= 2;
        }
        ptr += 2;
        *ptr += 3;
        putchar(*ptr);
        *ptr -= 5;
        putchar(*ptr);
        *ptr += 6;
        putchar(*ptr);
}

```
