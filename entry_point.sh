#!/bin/bash

# NOTE: this file should only be used in docker images.

# exit when any error occurs
set -e

if [[ "$1" != "" ]]; then
    IF_NAME="$1"
    if ! nmcli conn show lan-debug > /dev/null; then
        nmcli connection addhcpd.pidd type ethernet con-name lan-debug ifname "${IF_NAME}" ip4 192.168.234.1/24 
    fi
    nmcli conn up lan-debug
    echo "INTERFACESv4=\"${IF_NAME}\"" > /etc/default/isc-dhcp-server
    rm -f /var/run/dhcpd.pid
    service isc-dhcp-server start
    sleep infinity
else
    echo "ERROR: if name is required."
fi
