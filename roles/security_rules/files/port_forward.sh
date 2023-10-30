#!/usr/bin/env bash
# This script is used to forward ports from the host to the guest VM.
# This is useful for accessing services running on the guest VM via the host.
# For example, if you want to access the guest VM's web server from the host,

# Arguments:
# $1 - The port on the host to forward to the guest.
# $2 - The port on the guest to forward to.
# $3 - The ip address of the guest.
# $4 - Protocol to use (tcp or udp).

# Example usage:
# ./port_forward.sh 8080 80 192.168.0.2 tcp

# Check if the correct number of arguments were passed in.
if [ $# -ne 4 ]; then
    echo "Usage: ./port_forward.sh <host_port> <guest_port> <guest_ip> <protocol>"
    exit 1
fi

# Check if the port numbers are valid.
if ! [[ $1 =~ ^[0-9]+$ ]] || ! [[ $2 =~ ^[0-9]+$ ]]; then
    echo "Error: Invalid port number."
    exit 1
fi

# Check if the ip address is valid.
if ! [[ $3 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid ip address."
    exit 1
fi

# Check if the port is already in use.
if [ "$(sudo lsof -i:$1)" ]; then
    echo "Error: Port $1 is already in use."
    exit 1
fi

# Check if the protocol is valid.
if [ "$4" != "tcp" ] && [ "$4" != "udp" ]; then
    echo "Error: Invalid protocol."
    exit 1
fi

iptables -t nat -I PREROUTING -p $4 --dport $1 -j DNAT --to-destination $3:$2
