## Solution
First, find out who's the server:
```bash
$ tshark -Y "tcp && tcp.flags.ack == 1" -T fields -e 'ip.dst' -r syn_attack.pcap  | sort -n | uniq -c | sort -r
  51 128.237.255.81
  15 173.194.74.189
  13 74.125.228.64
  12 74.125.228.86
   8 74.125.228.67
   7 199.59.148.147
```
Then collect the sources:
```bash
$ tshark -Y "tcp && tcp.flags.syn == 1 && tcp.flags.ack == 0 && ip.src != 128.237.255.81" -T fields -e 'ip.src' -r syn_attack.pcap  | tr '\n' ' ';echo
121.168.84.32 75.214.206.60 21.241.212.197 55.53.190.191 71.113.17.64 120.130.138.152 171.128.49.99 104.220.68.36 241.210.41.46 33.24.97.48 115.99.66.210 154.29.81.178 69.232.82.51 234.183.31.38 102.146.88.253 196.132.138.81 63.193.172.89 16.6.74.206 94.148.118.202 160.116.210.243 248.237.9.18 161.147.211.153 207.137.67.221 229.61.253.52 180.70.211.154 132.214.137.24 132.42.241.177 65.248.11.247 49.201.237.5 51.145.58.158
```