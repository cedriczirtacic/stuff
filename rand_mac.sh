#!/bin/bash
# randomize iface MAC address (on MacOS X)
# modified from: https://youtu.be/J1q4Ir2J8P8?t=17m48s

function prev_ether() {
    local f=$1
    local mac=$( ifconfig $f | grep ether | cut -d" " -f2 )
    echo "Previous MAC = $mac" 1>&2
}

IFACE=$1
/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z
RAND_MAC=$( openssl rand -hex 5 | perl -ne '(@a)=$_=~m/(..)/g; print "00:",join(":", @a)' )

prev_ether $IFACE
echo "New MAC = $RAND_MAC" 1>&2
ifconfig $IFACE ether $RAND_MAC
