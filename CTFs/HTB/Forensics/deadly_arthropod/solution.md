## Solution
Is a usb pcap capture and the device is a keyboard:
```
0000  1c 00 10 10 4b 60 04 a5 ff ff 00 00 00 00 08 00   ....K`..........
0010  01 01 00 0c 00 80 02 3e 00 00 00 01 3e 03 52 00   .......>....>.R.
0020  61 00 7a 00 65 00 72 00 20 00 42 00 6c 00 61 00   a.z.e.r. .B.l.a.
0030  63 00 6b 00 57 00 69 00 64 00 6f 00 77 00 20 00   c.k.W.i.d.o.w. .
0040  55 00 6c 00 74 00 69 00 6d 00 61 00 74 00 65 00   U.l.t.i.m.a.t.e.
0050  20 00 32 00 30 00 31 00 33 00                      .2.0.1.3.
```

The last bulk of packets are data transfers. Lets dump that:
```bash
$ tshark -Q -r deadly_arthropod.pcap -Tfields -e usb.capdata -Y 'usb.capdata'|perl -ne 'foreach(split/:/){print chr(hex($_))}' > data.bin
```

Then start parsing the content:
````bash
$ gcc -o keys keys.c
$ ./keys data.bin
eks@hackthebox.eu
Th1sC0uldB3MyR3alP@ssw0rd
QK<-_->.<-<-<-<-H->5<-<-{_<-I->->ck->'->->b0<-<-<-<-<-<-<-<-<-I<-<-<-<-T->->f->->->->->->_->->->->->->}<-.<-.<-<-<-<-3<-<-<-<-<-<-<-<-u<-<-t_->->a<-<-<-<-<-<-<-<-<-<-B->->->->->->->->->->->->->->t->5<-<-<-I->->->_->->->->->a<-<-<-<-<-<-a->->->->->->d<-<-<-<-y->->->r
```

Because of lazyness and to don't spend 3 days with this thing, I parsed the last line (tried the others but no success) being the *<-* and *->* left and right keyboard arrows respectively.
```bash
$ HTB{If_It_Quack5_It'5_a_K3yb0ard...}
```
