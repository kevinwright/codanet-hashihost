#!/usr/bin/env bash


avahi-browse -rtpl _hashicorp_consul_server._tcp | \
  grep = | \
  awk '
    BEGIN { ORS=""; print "{\"other_ips\":\"[" }
          { print p"\\\""$8"\\\""; p=", "}
    END   { print "]\"}\n" }
  ' FS=";" 

