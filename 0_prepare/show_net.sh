#!/usr/bin/env bash

export lan_interface=$(ip -o -f inet route | grep -e "^default" | awk '{print $5}')
export lan_ip=$(ip -4 addr show $lan_interface | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
export lan_subnet=$(ip -o -f inet route list dev $lan_interface | grep -v "default" | grep / | awk '{print $1}')
export docker_ip=$(ip -4 addr show docker0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
export docker_subnet=$(ip -o -f inet route list dev docker0 | grep -v "default" | awk '{print $1}')

printf "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\n"
printf "┃ LAN interface:   %-15s ┃\n" "$lan_interface"
printf "┃ LAN ip:          %-15s ┃\n" "$lan_ip"
printf "┃ LAN subnet:      %-15s ┃\n" "$lan_subnet"
printf "┠──────────────────────────────────┨\n"
printf "┃ Docker ip:       %-15s ┃\n" "$docker_ip"
printf "┃ Docker subnet:   %-15s ┃\n" "$docker_subnet"
printf "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"

