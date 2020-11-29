#!/bin/bash

echo "$1 $2 has transitioned to the $3 state with a priority of $4" > /var/run/keepalived_status
if [ "$3" = "MASTER" ]
then
  ip route del default via 10.0.20.6 dev ens19
  cp /etc/keepalived/10-keepalived-ens18.network /run/systemd/network/ && chmod 644 /run/systemd/network/10-keepalived-ens18.network
  networkctl reload
  iptables -t nat -A POSTROUTING -o ens18 -j MASQUERADE
else
  iptables -t nat -D POSTROUTING -o ens18 -j MASQUARADE
  rm /run/systemd/network/10-keepalived-ens18.network
  networkctl reload
  ip link set ens18 down
  ip route add default via 10.0.20.6 dev ens19
fi
