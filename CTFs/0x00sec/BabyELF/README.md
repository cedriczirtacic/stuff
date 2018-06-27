## Info
This was a small CrackMe from 0x00sec.org by (calchemist)[https://0x00sec.org/u/calchemist].

LIEF needed in order to parse the ELF64.

```bash
cedric@shell:/tmp$ ./babyelf
kek
kek
Try harder!
cedric@shell:/tmp$ python bebelf.py
[+] Lookiyyng for strcmp@glibc on .dynstr table
[+] Found puts@glibc at .dynstr offset: 0xb
[+] Found strcmp@glibc at .dynstr offset: 0x26
[+] Finding file offset for patching .dynsym...
[+] Creating a patched file as ./bebelf
[+] Now execute ./bebelf and write 'kek' as answer!
cedric@shell:/tmp$ ./bebelf
kek
Congrats!
```
