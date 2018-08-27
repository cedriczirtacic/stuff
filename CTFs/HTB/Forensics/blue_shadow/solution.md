## Solution

blue_shadow virus is downloaded from a twitter account (@blue_shad0w_) and then decoded from base 2 to ascii. I coded an small code ([blue_shadow.py](blue_shadow.py)) using tweepy to retrieve this data.

Is a elf32 executable, not stripped, and probably developed in plain asm (expl0it.asm):
```bash
$ file blue_shadow_data
blue_shadow_data: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), statically linked, not stripped
```

Basically, the antidote is the key to de-XOR the final flag (located at 0x8049210). The key used is a reference to Star Wars...
