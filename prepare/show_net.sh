#!/usr/bin/env bash

lan_interface=$(ip -o -f inet route | grep -e "^default" | awk '{print $5}')
lan_ip=$(ip -4 addr show $lan_interface | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
lan_subnet=$(ip -o -f inet route list dev $lan_interface | grep -v "default" | grep / | awk '{print $1}')
docker_ip=$(ip -4 addr show docker0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
docker_subnet=$(ip -o -f inet route list dev docker0 | grep -v "default" | awk '{print $1}')

printf "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\n"
printf "┃ LAN interface:   %20s┃\n" "$lan_interface"
printf "┃ LAN ip:          %20s┃\n" "$lan_ip"
printf "┃ LAN subnet:      %20s┃\n" "$lan_subnet"
printf "┠───────────────────────────────────────────────┨\n"
printf "┃ Docker ip:       %20s┃\n" "$docker_ip"
printf "┃ Docker subnet:   %20s┃\n" "$docker_subnet"
printf "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"

