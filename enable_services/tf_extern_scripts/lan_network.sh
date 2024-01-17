#!/usr/bin/env bash
lan_interface=$(ip -o -f inet route | grep -e "^default" | awk '{print $5}')
lan_ip=$(ip -4 addr show $lan_interface | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
lan_subnet=$(ip -o -f inet route list dev $lan_interface | grep -v "default" | grep / | awk '{print $1}')

jq -n \
  --arg ip "$lan_ip" \
  --arg sn "$lan_subnet" \
  '{"ip":$ip, "subnet":$sn}'