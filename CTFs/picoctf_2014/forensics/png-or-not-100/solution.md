## Solution
```bash
$ file image.png 
image.png: PNG image data, 280 x 280, 8-bit/color RGB, non-interlaced
$ binwalk -MB image.png 

Scan Time:     2018-05-23 11:51:14
Target File:   /Users/cedriczirtacic/Development/stuff/CTFs/picoctf_2014/forensics/png-or-not-100/image.png
MD5 Checksum:  729d4be3a7d674b97b61ff69935c4d37
Signatures:    344

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             PNG image, 280 x 280, 8-bit/color RGB, non-interlaced
59            0x3B            Zlib compressed data, default compression
1548          0x60C           7-zip archive data, version 0.3

```
So we have a 7z archive inside the PNG image at offset 0x60c.
```bash
$ tail -c $(( 1686 - 1548 )) image.png > image.7z
$ file image.7z
image.7z: 7-zip archive data, version 0.3
$ 7z e image.7z

7-Zip [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=utf8,Utf16=on,HugeFiles=on,64 bits,4 CPUs x64)

Scanning the drive for archives:
1 file, 138 bytes (1 KiB)

Extracting archive: image.7z
--
Path = image.7z
Type = 7z
Physical Size = 138
Headers Size = 112
Method = LZMA:16
Solid = -
Blocks = 1

Everything is Ok

Size:       20
Compressed: 138
$ cat flag.txt 
EKSi7MktjOpvwesurw0v
```
