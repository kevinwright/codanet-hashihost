#!/usr/bin/env bash

other_ip_arr=$(
  avahi-browse -rtpl _hashicorp_consul_server._tcp | \
    grep = | \
    awk '{print $8}' FS=";" | \
    jq  --raw-input . | \
    jq --slurp .
)

echo $other_ip_arr | jq '{"other_ips":.}'
