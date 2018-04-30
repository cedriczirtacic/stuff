#!/bin/bash

hists=(
    ".bash_history" 
    ".sh_history" 
    ".zsh_history" 
)

unset HISTFILE
export HISTFILESIZE=0
history -c 

for f in ${hists[*]};do
    if [ -f ~/$f ]; then
        file ~/$f
        gshred -n 1 -u ~/$f
        ln -s /dev/null ~/$f
    fi
done

if [ -e ~/.bash_sessions ];then
    rm -rf ~/.bash_sessions
fi

