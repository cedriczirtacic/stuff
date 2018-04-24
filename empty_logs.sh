#!/bin/bash
# shreds logs and softlinks them to /dev/null

LOGS=/var/log
[ $(id -un) != "root" ] && exit 1;
find $LOGS -name \*.log -type f -print | while read log;do
    shred -u -n 1 -v $log && \
                ln -s /dev/null $log
done
