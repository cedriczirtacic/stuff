## Solution
We look for the GET requests in order to see the MAC address of the client:
```bash
 $ tshark -O http -Q -r traffic.pcap -Y "http.request.method == GET"
 ...
 Frame 58: 165 bytes on wire (1320 bits), 165 bytes captured (1320 bits)
Ethernet II, Src: PcsCompu_2b:f7:02 (08:00:27:2b:f7:02), Dst: PcsCompu_a3:7c:ac (08:00:27:a3:7c:ac)
Internet Protocol Version 4, Src: 192.168.50.4, Dst: 192.168.50.10
Transmission Control Protocol, Src Port: 51064, Dst Port: 80, Seq: 1, Ack: 1, Len: 99
Hypertext Transfer Protocol
    GET /secretfile.txt HTTP/1.1\r\n
        [Expert Info (Chat/Sequence): GET /secretfile.txt HTTP/1.1\r\n]
            [GET /secretfile.txt HTTP/1.1\r\n]
            [Severity level: Chat]
            [Group: Sequence]
        Request Method: GET
        Request URI: /secretfile.txt
        Request Version: HTTP/1.1
    User-Agent: curl/7.26.0\r\n
    Host: vpn.daedauluscorp.com\r\n
    Accept: */*\r\n
    \r\n
    [Full request URI: http://vpn.daedauluscorp.com/secretfile.txt]
    [HTTP request 1/1]

```
So, the client is 08:00:27:2b:f7:02 and we should use that MAC address to see if there's any previous traffic.
```bash
$ tshark -O http -Q -r traffic.pcap -Y "eth.src == 08:00:27:2b:f7:02"
....
Frame 21: 165 bytes on wire (1320 bits), 165 bytes captured (1320 bits)
Ethernet II, Src: PcsCompu_2b:f7:02 (08:00:27:2b:f7:02), Dst: PcsCompu_a3:7c:ac (08:00:27:a3:7c:ac)
Internet Protocol Version 4, Src: 192.168.50.3, Dst: 192.168.50.10
Transmission Control Protocol, Src Port: 37291, Dst Port: 80, Seq: 1, Ack: 1, Len: 99
Hypertext Transfer Protocol
    GET /john.johnson HTTP/1.1\r\n
        [Expert Info (Chat/Sequence): GET /john.johnson HTTP/1.1\r\n]
            [GET /john.johnson HTTP/1.1\r\n]
            [Severity level: Chat]
            [Group: Sequence]
        Request Method: GET
        Request URI: /john.johnson
        Request Version: HTTP/1.1
    User-Agent: curl/7.26.0\r\n
    Host: socialsocialnetwork.com\r\n
    Accept: */*\r\n
    \r\n
    [Full request URI: http://socialsocialnetwork.com/john.johnson]
    [HTTP request 1/1]

$ tshark -O http -Q -r traffic.pcap -Y "eth.src == 08:00:27:2b:f7:02" -T fields -e 'ip.src' | grep -vE '^$' | uniq
192.168.50.3
192.168.50.4
```

Actor is johnson,192.168.50.3,192.168.50.4

