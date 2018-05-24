## Solution
Checked DOS filesystem.
```bash
$ sfdisk -V disk.img
disk.img:
Remaining 10239 unallocated 512-byte sectors.
```
And fixed it using `testdisk` and `dosfsck`:
```bash
$ dosfsck -a -t -v disk.img
fsck.fat 4.1 (2017-01-24)
Checking we can access the last sector of the filesystem
Boot sector contents:
System ID "MSWIN4.1"
Media byte 0xf0 (5.25" or 3.5" HD floppy)
       512 bytes per logical sector
      2048 bytes per cluster
         1 reserved sector
First FAT starts at byte 512 (sector 1)
         2 FATs, 12 bit entries
      4096 bytes per FAT (= 8 sectors)
Root directory starts at byte 8704 (sector 17)
       512 root directory entries
Data area starts at byte 25088 (sector 49)
      2547 data clusters (5216256 bytes)
63 sectors/track, 255 heads
         0 hidden sectors
     10240 sectors total
Checking for bad clusters.
Reclaiming unconnected clusters.
disk.img: 5 files, 180/2547 clusters
$ sudo mount disk.img mount/
$ ls mount/pictures/
billy.jpg  fuzzy.jpg  pew.jpg  precious.jpg
```
And the flag is there.

