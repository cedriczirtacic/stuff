#!/bin/env python
# automated solution for https://0x00sec.org/t/crackme-babyelf/7268
import lief
import os
import ctypes
bebe = lief.parse('./babyelf')
dynstr = bebe.get_section('.dynstr')
stroff = 0
strval = ""
# func offsets
putsoff = 0x0
strcmpoff = 0x0
print "[+] Lookiyyng for strcmp@glibc on .dynstr table"
for c in dynstr.content:
    if stroff == len(dynstr.content):
        break
    if c == 0:
        if strval == "strcmp":
            strcmpoff = stroff - len(strval)
            print "[+] Found strcmp@glibc at .dynstr offset: 0x%x" % (strcmpoff)
        if strval == "puts":
            putsoff = stroff - len(strval)
            print "[+] Found puts@glibc at .dynstr offset: 0x%x" % (putsoff)
        strval = ""
        stroff += 1
        continue
    stroff += 1
    strval += chr(c)
if strcmpoff == 0:
    print "[-] strcmp@glibc not found..."
    exit(1)
dynsym = bebe.get_section('.dynsym')
dynsym_size = dynsym.size
dynsym_off = 0
print "[+] Finding file offset for patching .dynsym..."
f_offset = 0
while True:
    if dynsym_off == dynsym_size:
        break
    name = 0 # Elf64_Word st_name
    for i in range(0,3):
        name += dynsym.content[dynsym_off+i]
    if name == putsoff:
        f_offset = dynsym.file_offset + dynsym_off
        #print "foffset: %x dynsymoffset: %x" % (dynsym.file_offset, dynsym_off)
    dynsym_off += 24 # skip size of sym table entry
print "[+] Creating a patched file as ./bebelf"
os.system('cp babyelf bebelf; chmod +x bebelf')
f = open('bebelf', 'r+b')
f.seek(f_offset);
f.write(bytearray([strcmpoff]))
f.close()

print "[+] Now execute ./bebelf and write 'kek' as answer!"
exit(0)

