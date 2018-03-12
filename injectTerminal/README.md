# injectTerminal.m
waits until Terminal is focused and execute the specified command via *INJ* environment variable.
```bash
$ make
gcc -framework Carbon -framework Foundation -o injectTerminal injectTerminal.m
$ INJ="date" ./injectTerminal
```
Unfocus, wait until other user focus on Terminal:
```bash
date
$ date
Sun Mar 11 22:38:03 CST 2018
```
## todo
fix some keycodes on function char_to_code()
### idea
based on (this code)[https://github.com/CoolerVoid/rootstealer]
