#!/usr/bin/env bash
case $(uname) in 
  Darwin)
    export lan_interface=en0
    export lan_ip=$(ipconfig getifaddr en0)
    netmask=$(ipconfig getoption en0 subnet_mask)
    export lan_cidr=$(ipcalc $lan_ip $netmask | grep Network | awk '{print $2}')
    export docker_ip="n/a"
    export docker_subnet="n/a"
    ;;
  Linux)
    export lan_interface=$(ip -o -f inet route | grep -e "^default" | awk '{print $5}')
    export lan_ip=$(ip -4 addr show $lan_interface | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
    export lan_cidr=$(ip -o -f inet route list dev $lan_interface | grep -v "default" | grep / | awk '{print $1}')
    export docker_ip=$(ip -4 addr show docker0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
    export docker_cidr=$(ip -o -f inet route list dev docker0 | grep -v "default" | awk '{print $1}')
    ;;
esac

printf "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\n"
printf "┃ LAN i/f:  %-20s │                                   ┃\n" "$lan_interface"
printf "┃ LAN ip:   %-20s │ Docker ip:   %-20s ┃\n"                "$lan_ip" "$docker_ip"
printf "┃ LAN cidr: %-20s │ Docker cidr: %-20s ┃\n"                "$lan_cidr" "$docker_cidr"
printf "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"

