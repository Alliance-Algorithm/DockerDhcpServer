FROM ubuntu:22.04

WORKDIR /root

# Change bash as default shell instead of sh
SHELL ["/bin/bash", "-c"]

# 
RUN apt-get update && apt-get -y install \
    network-manager isc-dhcp-server \
    && rm -rf /var/lib/apt/lists/* && \
    echo "default-lease-time 600; max-lease-time 7200; subnet 192.168.234.0 netmask 255.255.255.0 { range 192.168.234.2 192.168.234.254; option routers 192.168.234.1; }" > /etc/dhcp/dhcpd.conf

# Add tini
RUN wget -O /tini https://github.com/krallin/tini/releases/download/v0.19.0/tini && \
    chmod +x /tini

COPY ./entry_point.sh /root/entry_point.sh

ENTRYPOINT ["/tini", "--", "/root/entry_point.sh"]
