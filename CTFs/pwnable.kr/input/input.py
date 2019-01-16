#!/usr/bin/python
from subprocess import *
import os
import socket

argv = []
for i in range(100):
	argv.append("X")
argv[0] = '/home/input2/input'
argv[ord('A')] = "$'\\x00'"
argv[ord('B')] = "$'\\x20\\x0a\\x0d'"
argv[ord('C')] = "9999"
err_r,err_w = os.pipe()
os.write(err_w,b"\x00\x0a\x02\xff")

os.environ["\xde\xad\xbe\xef"] = "\xca\xfe\xba\xbe"

os.unlink("\x0a")
fd = open("\x0a",'wb')
fd.write(b"\x00\x00\x00\x00")

proc = Popen("%s" % " ".join(argv), shell=True, executable='/bin/bash', stdin=PIPE, stderr=err_r)
proc.stdin.write(b"\x00\x0a\x00\xff")

try:
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	sock.connect(("localhost", 9999))
	sock.send(b"\xde\xad\xbe\xef")
except socket.error:
	pass

sock.close()
fd.close()
os.close(err_r)
os.close(err_w)
