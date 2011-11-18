#!/bin/sh
# Author: Christoph Galuschka <christoph.galuschka@chello.at>
#         Athmane Madjoudj <athmanem@gmail.com>

t_Log "Running $0 - TCPdump can capture ICMP from localhost"

#Dumping 4 pings to loopback to file
tcpdump -q -n -p -i lo -w /var/tmp/centos_test.pcap &
# If we don't wait a short time, the first paket will be missed by tcpdump
sleep 1
ping -q -c 4 -i 0.25 127.0.0.1
killall -s SIGINT tcpdump
sleep 1

# reading from file, for each ping we should see two pakets
WORKING=$( tcpdump -r /var/tmp/centos_test.pcap | grep -ci icmp )
if [ $WORKING == 8 ]; then ret_val=0; fi

# Remove file afterwards
 /bin/rm /var/tmp/centos_test.pcap

t_CheckExitStatus $ret_val
