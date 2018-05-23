## Solution
ZIP file looks corrupted:
```bash
$ unzip -t recovery.zip
Archive:  recovery.zip
file #1:  bad zipfile offset (local header sig):  0
    testing: Mag7-BW/Chart-15.pdf     OK
    testing: Mag7-BW/                 OK
At least one error was detected in recovery.zip.
$ zipdetails recovery.zip


Unexpecded END at offset 00000000, value 04033F3F
Done
```
Offset 00000000 is at the beginning of the file so the error seems to be at theheader.
After checking the ZIP format specs the header should be 504b0304. We patch that and:
```bash
$ unzip -t recovery.zip
Archive:  recovery.zip
    testing: Mag7-BW/key.txt          OK
    testing: Mag7-BW/Chart-15.pdf     OK
    testing: Mag7-BW/                 OK
No errors detected in compressed data of recovery.zip.
$ unzip -v recovery.zip
Archive:  recovery.zip
 Length   Method    Size  Cmpr    Date    Time   CRC-32   Name
--------  ------  ------- ---- ---------- ----- --------  ----
      27  Stored       27   0% 04-14-2013 13:09 ef2e7df6  Mag7-BW/key.txt
  341644  Defl:N   283364  17% 02-07-2005 21:49 9cc8a61b  Mag7-BW/Chart-15.pdf
       0  Stored        0   0% 04-14-2013 13:13 00000000  Mag7-BW/
--------          -------  ---                            -------
  341671           283391  17%                            3 files
$ unzip recovery.zip Mag7-BW/key.txt
Archive:  recovery.zip
 extracting: Mag7-BW/key.txt
 ```
