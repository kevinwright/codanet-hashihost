#!/usr/bin/env bash


docker_ip=$(ip -4 addr show docker0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
docker_subnet=$(ip -o -f inet route list dev docker0 | grep -v "default" | awk '{print $1}')

jq -n \
  --arg ip "$docker_ip" \
  --arg sn "$docker_subnet" \
  '{"ip":$ip, "subnet":$sn}'