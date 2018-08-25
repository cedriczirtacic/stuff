#!/bin/env python
import sys
from base64 import b64decode,b32decode

class RC4:
    def __init__(self, key = None):
            self.state = range(256) # initialisation de la table de permutation
            self.x = self.y = 0 # les index x et y, au lieu de i et j

            if key is not None:
                    self.key = key
                    self.init(key)

    def init(self, key):
            for i in range(256):
                    self.x = (ord(key[i % len(key)]) + self.state[i] + self.x) & 0xFF
                    self.state[i], self.state[self.x] = self.state[self.x], self.state[i]
            self.x = 0

    def binaryDecrypt(self, data):
            output = [None]*len(data)
            for i in xrange(len(data)):
                    self.x = (self.x + 1) & 0xFF
                    self.y = (self.state[self.x] + self.y) & 0xFF
                    self.state[self.x], self.state[self.y] = self.state[self.y], self.state[self.x]
                    output[i] = (data[i] ^ self.state[(self.state[self.x] + self.state[self.y]) & 0xFF])
            return bytearray(output)

def fromBase64URL(msg):
	msg = msg.replace('_','/').replace('-','+')
	if len(msg)%4 == 3:
		return b64decode(msg + '=')
	elif len(msg)%4 == 2:
		return b64decode(msg + '==')
	else:
		return b64decode(msg)

def fromBase32(msg):
	mod = len(msg) % 8
	if mod == 2:
		padding = "======"
	elif mod == 4:
		padding = "===="
	elif mod == 5:
		padding = "==="
	elif mod == 7:
		padding = "="
	else:
		padding = ""

	return b32decode(msg.upper() + padding)

def decode_content(s):
    st = s[0:-(len(tld))]
    n,data = st.split('.',1)
    file_data = data.replace('.','')
    
    rc4Decryptor = RC4(password)
    try:
        print rc4Decryptor.binaryDecrypt(bytearray(fromBase64URL(file_data)))
        return 0
    except TypeError as e:
        print e
        return 1

def decode_init(s):
    name = (s.split('.'))[1]
    try:
        print "data: {}".format(fromBase32(name))
    except TypeError:
        print "data: {}".format(fromBase64URL(name))

    return True

if len(sys.argv) == 1:
    print "usage: {} <domain>".format(sys.argv[0])
    quit(1)

domain = sys.argv[1]
#print "domain: {}".format(domain)

tld = "totallylegit.com"
password = "TryHarder"

if domain.startswith('init.'):
    quit( decode_init(domain) )
else:
    quit( decode_content(domain) )

