# injectTerminal.m
waits until Terminal is focused and execute the specified (on compilation) command

```bash
root# make
gcc -framework Carbon -framework Foundation -o injectTerminal injectTerminal.m
root# ./injectTerminal 
<CFBasicHash 0x7f8b4ac0dd70 [0x7fffadf6a980]>{type = mutable dict, count = 11,
entries =>
	0 : <CFString 0x7f8b4ac0d630 [0x7fffadf6a980]>{contents = "kCGWindowLayer"} = <CFNumber 0x37 [0x7fffadf6a980]>{value = +0, type = kCFNumberSInt64Type}
	1 : <CFString 0x7f8b4ac0d790 [0x7fffadf6a980]>{contents = "kCGWindowAlpha"} = <CFNumber 0x157 [0x7fffadf6a980]>{value = +1.00000000000000000000, type = kCFNumberFloat64Type}
	2 : <CFString 0x7f8b4ac0d7c0 [0x7fffadf6a980]>{contents = "kCGWindowMemoryUsage"} = <CFNumber 0xf2850837 [0x7fffadf6a980]>{value = +15893768, type = kCFNumberSInt64Type}
	3 : <CFString 0x7f8b4ac0d820 [0x7fffadf6a980]>{contents = "kCGWindowIsOnscreen"} = <CFBoolean 0x7fffadf6b278 [0x7fffadf6a980]>{value = true}
	4 : <CFString 0x7f8b4ac0d850 [0x7fffadf6a980]>{contents = "kCGWindowSharingState"} = <CFNumber 0x137 [0x7fffadf6a980]>{value = +1, type = kCFNumberSInt64Type}
	5 : <CFString 0x7f8b4ac0d8b0 [0x7fffadf6a980]>{contents = "kCGWindowOwnerPID"} = <CFNumber 0x14537 [0x7fffadf6a980]>{value = +325, type = kCFNumberSInt64Type}
	7 : <CFString 0x7f8b4ac0d900 [0x7fffadf6a980]>{contents = "kCGWindowNumber"} = <CFNumber 0x2037 [0x7fffadf6a980]>{value = +32, type = kCFNumberSInt64Type}
	8 : <CFString 0x7f8b4ac0d950 [0x7fffadf6a980]>{contents = "kCGWindowOwnerName"} = <CFString 0x7f8b4ac0da80 [0x7fffadf6a980]>{contents = "Terminal"}
	10 : <CFString 0x7f8b4ac0d9a0 [0x7fffadf6a980]>{contents = "kCGWindowStoreType"} = <CFNumber 0x237 [0x7fffadf6a980]>{value = +2, type = kCFNumberSInt64Type}
	11 : <CFString 0x7f8b4ac0d9f0 [0x7fffadf6a980]>{contents = "kCGWindowBounds"} = <CFBasicHash 0x7f8b4ac0dc90 [0x7fffadf6a980]>{type = mutable dict, count = 4,
entries =>
	0 : <CFString 0x7f8b4ac0dc40 [0x7fffadf6a980]>{contents = "X"} = <CFNumber 0x57 [0x7fffadf6a980]>{value = +0.0, type = kCFNumberFloat64Type}
	1 : <CFString 0x7f8b4ac0dba0 [0x7fffadf6a980]>{contents = "Height"} = <CFNumber 0x30857 [0x7fffadf6a980]>{value = +776.00000000000000000000, type = kCFNumberFloat64Type}
	2 : <CFString 0x7f8b4ac0dbf0 [0x7fffadf6a980]>{contents = "Y"} = <CFNumber 0x1857 [0x7fffadf6a980]>{value = +24.00000000000000000000, type = kCFNumberFloat64Type}
	6 : <CFString 0x7f8b4ac0dad0 [0x7fffadf6a980]>{contents = "Width"} = <CFNumber 0x50057 [0x7fffadf6a980]>{value = +1280.00000000000000000000, type = kCFNumberFloat64Type}
}

	12 : <CFString 0x7f8b4ac0d660 [0x7fffadf6a980]>{contents = "kCGWindowName"} = <CFString 0x7f8b4ac0db00 [0x7fffadf6a980]>{contents = "Terminal \u2014 sh \u2014 211\u00d754"}
}
id
root# id
uid=0(root) gid=0(wheel) groups=0(wheel)
```
## todo
fix some keycodes on function char_to_code()
### idea
based on (this code)[https://github.com/CoolerVoid/rootstealer]
