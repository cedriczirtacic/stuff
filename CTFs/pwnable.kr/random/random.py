#!/usr/bin/python
rand_val = 0x6b8b4567
result = 0x00000000
bits = 32

bits -= 8
for x in range(0x00,0xff):
	v = ((rand_val & 0xff000000)>>bits)
	if v ^ x == 0xde:
		result += (x << bits)
bits -= 8
for x in range(0x00,0xff):
	v = ((rand_val & 0x00ff0000)>>bits)
	if v ^ x == 0xad:
		result += (x << bits)
bits -= 8
for x in range(0x00,0xff):
	v = ((rand_val & 0x0000ff00)>>bits)
	if v ^ x == 0xbe:
		result += (x << bits)
bits -= 8
for x in range(0x00,0xff):
	v = ((rand_val & 0x000000ff)>>bits)
	if v ^ x == 0xef:
		result += (x << bits)
print "%d" % result
