#!/bin/sh

: ${int:=$1}
: ${int:="lo0"}
##### Change lo0 to interface
/usr/sbin/tcpdump -n -e -tttt -XX -i $int 'tcp src port 443 and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4] = 0x18) and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4 + 1] = 0x03) and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4 + 2] < 0x04) and ((ip[2:2] - 4 * (ip[0] & 0x0F)  - 4 * ((tcp[12] & 0xF0) >> 4) > 69))'

#### IPv4 and 6
#tcp src port 443  and (((ip and tcp[((tcp[12] & 0xF0) >> 4 ) * 4] = 0x18) and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4 + 1] = 0x03) and (tcp[((tcp[12] & 0xF0) >> 4 ) * 4 + 2] < 0x04) and ((ip[2:2] - 4 * (ip[0] & 0x0F)  - 4 * ((tcp[12] & 0xF0) >> 4) > 69)) )  or ( (ip6 and ip6[6]=6 and (ip6[40 + ((ip6[40+12] & 0xF0) >> 4) * 4 + 0] = 0x18) and (ip6[40 + ((ip6[40+12] & 0xF0) >> 4) * 4 + 1] = 0x03) and (ip6[40 + ((ip6[40+12] & 0xF0) >> 4) * 4 + 2] < 0x04) and ((ip6[4:2] - 4*( (ip6[40+12] & 0xF0) >> 4) ) > 69))))
