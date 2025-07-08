#!/bin/bash
#
#Author: Ronal Kumar [ron@lbl.gov]
#            \
#             \
#              ^__^
#              (oo)\_______
#              (__)        )\
#                 ||----- |
#                 ||     ||

set -eu

echo "Accepted commands: start, stop"
echo "Accepted arguments: compute-1, compute-2, compute-3, compute-4, compute-5, compute-6, all"

startTraffic-compute-1() {
    echo "starting traffic between und streaming host 1 and primary compute 1"
    sudo docker exec und-streaming-host-1 bash /config/1-iperf.sh
}

startTraffic-compute-2() {
    echo "starting traffic between und streaming host 1 and primary compute 2"
    sudo docker exec und-streaming-host-2 bash /config/2-iperf.sh
}

startTraffic-compute-3() {
    echo "starting traffic between und streaming host 3 and primary compute 3"
    sudo docker exec und-streaming-host-3 bash /config/3-iperf.sh
}

startTraffic-compute-4() {
    echo "starting traffic between und streaming host 4 and primary compute 4"
    sudo docker exec und-streaming-host-4 bash /config/4-iperf.sh
}

startTraffic-compute-5() {
    echo "starting traffic between und streaming host 5 and backup site compute 5"
    sudo docker exec und-streaming-host-5 bash /config/5-iperf.sh
}

startTraffic-compute-6() {
    echo "starting traffic between und streaming host 6 and backup site compute 6"
    sudo docker exec und-streaming-host-6 bash /config/6-iperf.sh
}

startAll() {
    echo "starting streaming traffic to all compute hosts"
    sudo docker exec und-streaming-host-1 bash /config/1-iperf.sh
    sudo docker exec und-streaming-host-2 bash /config/2-iperf.sh
    sudo docker exec und-streaming-host-3 bash /config/3-iperf.sh
    sudo docker exec und-streaming-host-4 bash /config/4-iperf.sh
    sudo docker exec und-streaming-host-5 bash /config/5-iperf.sh
    sudo docker exec und-streaming-host-6 bash /config/6-iperf.sh
}

stopAll() {
    echo "stopping all traffic"
    sudo docker exec und-streaming-host-1 pkill iperf3
    sudo docker exec und-streaming-host-2 pkill iperf3
    sudo docker exec und-streaming-host-3 pkill iperf3
    sudo docker exec und-streaming-host-4 pkill iperf3
    sudo docker exec und-streaming-host-5 pkill iperf3
    sudo docker exec und-streaming-host-6 pkill iperf3
}

# start traffic
if [ $1 == "start" ]; then
    if [ $2 == "compute-1" ]; then
        startTraffic-compute-1
    fi
    if [ $2 == "compute-2" ]; then
        startTraffic-compute-2
    fi
    if [ $2 == "compute-3" ]; then
        startTraffic-compute-3
    fi
    if [ $2 == "compute-4" ]; then
        startTraffic-compute-4
    fi
    if [ $2 == "compute-5" ]; then
        startTraffic-compute-5
    fi
    if [ $2 == "compute-6" ]; then
        startTraffic-compute-6
    fi
    if [ $2 == "all" ]; then
        startAll
    fi
fi

if [ $1 == "stop" ]; then
    if [ $2 == "all" ]; then
        stopAll
    fi
fi
