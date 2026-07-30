#!/bin/bash
set -e

echo "== Интерфейсы на gateway =="
ip a

# ВАЖНО: порядок интерфейсов может отличаться. Проверь через `ip a` после
# первого запуска, какой интерфейс смотрит в lan-net (10.10.10.2), а какой
# в wan-net, и поправь имена ниже если нужно (обычно eth0=первая сеть в
# compose = wan-net, eth1=lan-net, но не гарантировано).

LAN_IF="eth1"
WAN_IF="eth0"

iptables -t nat -A POSTROUTING -o $WAN_IF -j MASQUERADE
iptables -A FORWARD -i $LAN_IF -o $WAN_IF -j ACCEPT
iptables -A FORWARD -i $WAN_IF -o $LAN_IF -m state --state ESTABLISHED,RELATED -j ACCEPT

# DNS для внутренней сети
cat <<EOF > /etc/dnsmasq.conf
listen-address=10.10.10.2
no-resolv
server=8.8.8.8
address=/compute.lab/10.10.10.11
address=/storage.lab/10.10.10.12
EOF
dnsmasq

echo "Gateway готов. iptables:"
iptables -t nat -L -v
iptables -L -v

tail -f /dev/null