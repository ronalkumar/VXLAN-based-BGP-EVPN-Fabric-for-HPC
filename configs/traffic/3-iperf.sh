# iperf3 with 8 parallel tcp streams, each 200 Kbit/s == 1.6Mbit/s
iperf3 -c 10.10.4.103 -t 15 -i 15 -p 5201 -B 10.3.3.23 -P 8 -b 200K -M 1420 &